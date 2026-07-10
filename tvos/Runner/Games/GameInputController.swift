import Foundation
import GameController

// Maps connected GCControllers to per-port RetroPad bitmasks read lock-free by the
// core's input_state callback (emulation thread). Button events are mirrored to
// Dart so the existing overlay navigation (RetroPad-indexed) works.
//
// Menu button: games need RetroPad Start, but the overlay needs a dedicated way in,
// so short-press Menu = Start tap, long-press (0.7 s) = overlay. Options = Select.
final class GameInputController {
    // RetroPad ids (RETRO_DEVICE_ID_JOYPAD_*)
    private enum Pad {
        static let b: UInt16 = 1 << 0
        static let y: UInt16 = 1 << 1
        static let select: UInt16 = 1 << 2
        static let start: UInt16 = 1 << 3
        static let up: UInt16 = 1 << 4
        static let down: UInt16 = 1 << 5
        static let left: UInt16 = 1 << 6
        static let right: UInt16 = 1 << 7
        static let a: UInt16 = 1 << 8
        static let x: UInt16 = 1 << 9
        static let l: UInt16 = 1 << 10
        static let r: UInt16 = 1 << 11
        static let l2: UInt16 = 1 << 12
        static let r2: UInt16 = 1 << 13
        static let l3: UInt16 = 1 << 14
        static let r3: UInt16 = 1 << 15
    }

    private static let menuHoldSeconds: TimeInterval = 0.7
    private static let startTapSeconds: TimeInterval = 0.15

    // Written on the main queue (GC handlers), read on the emulation thread.
    // UInt16 stores cannot tear on arm64.
    nonisolated(unsafe) private var portMasks = [UInt16](repeating: 0, count: 4)

    var onMenuPressed: (() -> Void)?
    var onButton: ((Int, Bool) -> Void)?
    var onControllersChanged: ((Int) -> Void)?

    private var observers: [NSObjectProtocol] = []
    private var menuHoldTimers: [Int: Timer] = [:]
    private var menuHoldFired: Set<Int> = []

    var controllerCount: Int {
        GCController.controllers().filter { $0.extendedGamepad != nil }.count
    }

    func start() {
        let center = NotificationCenter.default
        observers.append(
            center.addObserver(
                forName: .GCControllerDidConnect, object: nil, queue: .main
            ) { [weak self] _ in
                self?.attachAll()
                self?.notifyChanged()
            })
        observers.append(
            center.addObserver(
                forName: .GCControllerDidDisconnect, object: nil, queue: .main
            ) { [weak self] _ in
                self?.attachAll()
                self?.notifyChanged()
            })
        attachAll()
        GCController.startWirelessControllerDiscovery()
    }

    func stop() {
        GCController.stopWirelessControllerDiscovery()
        observers.forEach { NotificationCenter.default.removeObserver($0) }
        observers.removeAll()
        menuHoldTimers.values.forEach { $0.invalidate() }
        menuHoldTimers.removeAll()
        for c in GCController.controllers() {
            c.extendedGamepad?.valueChangedHandler = nil
            c.extendedGamepad?.buttonMenu.pressedChangedHandler = nil
        }
        portMasks = [0, 0, 0, 0]
    }

    nonisolated func mask(forPort port: Int) -> UInt16 {
        guard port >= 0, port < portMasks.count else { return 0 }
        return portMasks[port]
    }

    private func notifyChanged() {
        onControllersChanged?(controllerCount)
    }

    private func attachAll() {
        let pads = GCController.controllers().filter { $0.extendedGamepad != nil }
        for (port, controller) in pads.enumerated() where port < portMasks.count {
            controller.playerIndex = GCControllerPlayerIndex(rawValue: port) ?? .indexUnset
            let gamepad = controller.extendedGamepad!
            gamepad.valueChangedHandler = { [weak self] pad, _ in
                self?.refresh(pad: pad, port: port)
            }
            gamepad.buttonMenu.pressedChangedHandler = { [weak self] _, _, pressed in
                self?.handleMenu(port: port, pressed: pressed)
            }
        }
        for port in pads.count..<portMasks.count {
            portMasks[port] = 0
        }
    }

    private func handleMenu(port: Int, pressed: Bool) {
        if pressed {
            menuHoldFired.remove(port)
            menuHoldTimers[port]?.invalidate()
            menuHoldTimers[port] = Timer.scheduledTimer(
                withTimeInterval: Self.menuHoldSeconds, repeats: false
            ) { [weak self] _ in
                guard let self else { return }
                self.menuHoldFired.insert(port)
                self.onMenuPressed?()
            }
        } else {
            menuHoldTimers[port]?.invalidate()
            menuHoldTimers[port] = nil
            if !menuHoldFired.contains(port) {
                tapStart(port: port)
            }
            menuHoldFired.remove(port)
        }
    }

    // Short Menu press: synthesize a brief RetroPad Start press.
    private func tapStart(port: Int) {
        setBits(Pad.start, on: true, port: port)
        DispatchQueue.main.asyncAfter(deadline: .now() + Self.startTapSeconds) { [weak self] in
            self?.setBits(Pad.start, on: false, port: port)
        }
    }

    private func setBits(_ bits: UInt16, on: Bool, port: Int) {
        guard port >= 0, port < portMasks.count else { return }
        let old = portMasks[port]
        let mask = on ? old | bits : old & ~bits
        portMasks[port] = mask
        emitDiffs(old: old, new: mask, port: port)
    }

    private func refresh(pad: GCExtendedGamepad, port: Int) {
        var mask: UInt16 = portMasks[port] & Pad.start  // Start is synthetic; preserve it
        if pad.buttonA.isPressed { mask |= Pad.b }      // GC A (bottom) = RetroPad B
        if pad.buttonB.isPressed { mask |= Pad.a }      // GC B (right)  = RetroPad A
        if pad.buttonX.isPressed { mask |= Pad.y }      // GC X (left)   = RetroPad Y
        if pad.buttonY.isPressed { mask |= Pad.x }      // GC Y (top)    = RetroPad X
        if pad.dpad.up.isPressed || pad.leftThumbstick.up.isPressed { mask |= Pad.up }
        if pad.dpad.down.isPressed || pad.leftThumbstick.down.isPressed { mask |= Pad.down }
        if pad.dpad.left.isPressed || pad.leftThumbstick.left.isPressed { mask |= Pad.left }
        if pad.dpad.right.isPressed || pad.leftThumbstick.right.isPressed { mask |= Pad.right }
        if pad.leftShoulder.isPressed { mask |= Pad.l }
        if pad.rightShoulder.isPressed { mask |= Pad.r }
        if pad.leftTrigger.isPressed { mask |= Pad.l2 }
        if pad.rightTrigger.isPressed { mask |= Pad.r2 }
        if pad.leftThumbstickButton?.isPressed == true { mask |= Pad.l3 }
        if pad.rightThumbstickButton?.isPressed == true { mask |= Pad.r3 }
        if pad.buttonOptions?.isPressed == true { mask |= Pad.select }

        let old = portMasks[port]
        portMasks[port] = mask
        emitDiffs(old: old, new: mask, port: port)
    }

    private func emitDiffs(old: UInt16, new: UInt16, port: Int) {
        guard port == 0, old != new, let onButton else { return }
        for bit in 0..<16 where (old ^ new) & (1 << bit) != 0 {
            onButton(bit, new & (1 << bit) != 0)
        }
    }
}
