import QuartzCore
import UIKit

final class AppleTvPlayerViewController: UIViewController {
    private let player: MpvPlayerWrapper
    var onExit: (() -> Void)?
    var onNext: (() -> Void)?
    var onPrevious: (() -> Void)?
    var onSelectAudio: ((Int) -> Void)?
    var onSelectSubtitle: ((Int) -> Void)?
    private var didAttachSurface = false
    private var updateTimer: Timer?
    private var lastShowAt: TimeInterval = 0

    private var skipForwardMs = 30000
    private var skipBackMs = 10000
    private var hasNext = false
    private var hasPrevious = false
    private var audioTracks: [(index: Int, label: String, subtitle: String, selected: Bool)] = []
    private var subtitleTracks: [(index: Int, label: String, subtitle: String, selected: Bool)] = []

    private var scrubTargetMs: Int?
    private var scrubCommitTimer: Timer?

    private enum Zone { case scrubber, buttons }
    private enum ControlId { case prev, skipBack, playPause, skipForward, next, audio, subtitles, chapters }
    private var focusedZone: Zone = .buttons
    private var focusedControlIndex = 0
    private var controls: [ControlId] = []
    private var controlViews: [ControlId: UIView] = [:]
    private var controlIcons: [ControlId: UIImageView] = [:]

    private let osdContainer = UIView()
    private let gradientLayer = CAGradientLayer()
    private let scrubber = UIProgressView(progressViewStyle: .default)
    private let currentTimeLabel = UILabel()
    private let durationLabel = UILabel()
    private let chapterOverlay = UIView()
    private let controlRow = UIStackView()

    private let topContainer = UIView()
    private let topGradientLayer = CAGradientLayer()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private var chapters: [(title: String, startMs: Int)] = []

    init(player: MpvPlayerWrapper) {
        self.player = player
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        player.attachVideoView(view)
        didAttachSurface = true
        setupOsd()
        rebuildControls()
    }

    private func setupOsd() {
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        topContainer.alpha = 0
        view.addSubview(topContainer)
        NSLayoutConstraint.activate([
            topContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topContainer.topAnchor.constraint(equalTo: view.topAnchor),
            topContainer.heightAnchor.constraint(equalToConstant: 220),
        ])

        topGradientLayer.colors = [
            UIColor(white: 0, alpha: 0.85).cgColor,
            UIColor.clear.cgColor,
        ]
        topContainer.layer.addSublayer(topGradientLayer)

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = .systemFont(ofSize: 26, weight: .semibold)
        subtitleLabel.textColor = UIColor(white: 1, alpha: 0.7)
        topContainer.addSubview(subtitleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 40, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        topContainer.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(
                equalTo: topContainer.leadingAnchor, constant: 90),
            subtitleLabel.trailingAnchor.constraint(
                equalTo: topContainer.trailingAnchor, constant: -90),
            subtitleLabel.topAnchor.constraint(
                equalTo: topContainer.safeAreaLayoutGuide.topAnchor, constant: 40),

            titleLabel.leadingAnchor.constraint(equalTo: subtitleLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: subtitleLabel.trailingAnchor),
            titleLabel.topAnchor.constraint(
                equalTo: subtitleLabel.bottomAnchor, constant: 6),
        ])

        osdContainer.translatesAutoresizingMaskIntoConstraints = false
        osdContainer.alpha = 0
        view.addSubview(osdContainer)
        NSLayoutConstraint.activate([
            osdContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            osdContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            osdContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            osdContainer.heightAnchor.constraint(equalToConstant: 320),
        ])

        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor(white: 0, alpha: 0.9).cgColor,
        ]
        osdContainer.layer.addSublayer(gradientLayer)

        scrubber.translatesAutoresizingMaskIntoConstraints = false
        scrubber.progressTintColor = UIColor(red: 0.9, green: 0.1, blue: 0.55, alpha: 1)
        scrubber.trackTintColor = UIColor(white: 1, alpha: 0.25)
        scrubber.layer.cornerRadius = 3
        scrubber.clipsToBounds = true
        osdContainer.addSubview(scrubber)

        chapterOverlay.translatesAutoresizingMaskIntoConstraints = false
        chapterOverlay.isUserInteractionEnabled = false
        osdContainer.addSubview(chapterOverlay)

        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentTimeLabel.font = .monospacedDigitSystemFont(ofSize: 28, weight: .medium)
        currentTimeLabel.textColor = .white
        osdContainer.addSubview(currentTimeLabel)

        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.font = .monospacedDigitSystemFont(ofSize: 28, weight: .medium)
        durationLabel.textColor = UIColor(white: 1, alpha: 0.7)
        durationLabel.textAlignment = .right
        osdContainer.addSubview(durationLabel)

        controlRow.translatesAutoresizingMaskIntoConstraints = false
        controlRow.axis = .horizontal
        controlRow.alignment = .center
        controlRow.distribution = .equalSpacing
        controlRow.spacing = 28
        osdContainer.addSubview(controlRow)

        NSLayoutConstraint.activate([
            scrubber.leadingAnchor.constraint(
                equalTo: osdContainer.leadingAnchor, constant: 90),
            scrubber.trailingAnchor.constraint(
                equalTo: osdContainer.trailingAnchor, constant: -90),
            scrubber.heightAnchor.constraint(equalToConstant: 6),

            chapterOverlay.leadingAnchor.constraint(equalTo: scrubber.leadingAnchor),
            chapterOverlay.trailingAnchor.constraint(equalTo: scrubber.trailingAnchor),
            chapterOverlay.centerYAnchor.constraint(equalTo: scrubber.centerYAnchor),
            chapterOverlay.heightAnchor.constraint(equalToConstant: 16),

            currentTimeLabel.leadingAnchor.constraint(equalTo: scrubber.leadingAnchor),
            currentTimeLabel.bottomAnchor.constraint(
                equalTo: scrubber.topAnchor, constant: -14),

            durationLabel.trailingAnchor.constraint(equalTo: scrubber.trailingAnchor),
            durationLabel.bottomAnchor.constraint(
                equalTo: scrubber.topAnchor, constant: -14),

            controlRow.centerXAnchor.constraint(equalTo: osdContainer.centerXAnchor),
            controlRow.topAnchor.constraint(equalTo: scrubber.bottomAnchor, constant: 34),
        ])
    }

    private func icon(for id: ControlId) -> String {
        switch id {
        case .prev: return "backward.end.fill"
        case .skipBack: return "gobackward"
        case .playPause: return isPaused() ? "play.fill" : "pause.fill"
        case .skipForward: return "goforward"
        case .next: return "forward.end.fill"
        case .audio: return "waveform"
        case .subtitles: return "captions.bubble"
        case .chapters: return "list.bullet"
        }
    }

    private func rebuildControls() {
        controlRow.arrangedSubviews.forEach {
            controlRow.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        controlViews.removeAll()
        controlIcons.removeAll()

        var ids: [ControlId] = []
        if hasPrevious { ids.append(.prev) }
        ids.append(.skipBack)
        ids.append(.playPause)
        ids.append(.skipForward)
        if hasNext { ids.append(.next) }
        if !audioTracks.isEmpty { ids.append(.audio) }
        ids.append(.subtitles)
        if chapters.count > 1 { ids.append(.chapters) }
        controls = ids

        for id in ids {
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            container.layer.cornerRadius = 32
            let iconView = UIImageView()
            iconView.translatesAutoresizingMaskIntoConstraints = false
            iconView.contentMode = .scaleAspectFit
            iconView.tintColor = .white
            iconView.image = UIImage(
                systemName: icon(for: id),
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold))
            container.addSubview(iconView)
            NSLayoutConstraint.activate([
                container.widthAnchor.constraint(equalToConstant: 64),
                container.heightAnchor.constraint(equalToConstant: 64),
                iconView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                iconView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            ])
            controlRow.addArrangedSubview(container)
            controlViews[id] = container
            controlIcons[id] = iconView
        }

        if !controls.indices.contains(focusedControlIndex) {
            focusedControlIndex = controls.firstIndex(of: .playPause) ?? 0
        }
        updateFocusHighlight()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if didAttachSurface {
            player.notifySurfaceReady()
        }
        gradientLayer.frame = osdContainer.bounds
        topGradientLayer.frame = topContainer.bounds
        layoutChapters()
    }

    func applyUiMetadata(_ args: [String: Any]) {
        let title = (args["topTitle"] as? String) ?? ""
        let subtitle = (args["topSubtitle"] as? String) ?? ""
        titleLabel.text = title
        subtitleLabel.text = subtitle
        subtitleLabel.isHidden = subtitle.isEmpty
        titleLabel.isHidden = title.isEmpty

        hasNext = (args["hasNext"] as? Bool) ?? false
        hasPrevious = (args["hasPrevious"] as? Bool) ?? false
        skipForwardMs = (args["skipForwardMs"] as? NSNumber)?.intValue ?? 30000
        skipBackMs = (args["skipBackMs"] as? NSNumber)?.intValue ?? 10000
        audioTracks = parseTracks(args["audioTracks"])
        subtitleTracks = parseTracks(args["subtitleTracks"])

        chapters = ((args["chapters"] as? [[String: Any]]) ?? []).compactMap {
            entry in
            guard let startMs = (entry["startMs"] as? NSNumber)?.intValue else {
                return nil
            }
            let title = (entry["title"] as? String) ?? ""
            return (title: title, startMs: startMs)
        }
        if isViewLoaded {
            rebuildControls()
            view.setNeedsLayout()
        }
    }

    private func parseTracks(_ raw: Any?)
        -> [(index: Int, label: String, subtitle: String, selected: Bool)]
    {
        guard let arr = raw as? [[String: Any]] else { return [] }
        return arr.compactMap { entry in
            guard let index = (entry["index"] as? NSNumber)?.intValue else {
                return nil
            }
            let label = (entry["label"] as? String) ?? "Track"
            let subtitle = (entry["subtitle"] as? String) ?? ""
            let selected = (entry["selected"] as? Bool) ?? false
            return (index: index, label: label, subtitle: subtitle, selected: selected)
        }
    }

    private func layoutChapters() {
        chapterOverlay.subviews.forEach { $0.removeFromSuperview() }
        let width = chapterOverlay.bounds.width
        let durationMs = player.duration * 1000
        guard width > 0, durationMs > 0, chapters.count > 1 else { return }
        for chapter in chapters {
            let fraction = min(1, max(0, Double(chapter.startMs) / durationMs))
            if fraction <= 0 { continue }
            let tick = UIView()
            tick.backgroundColor = UIColor(white: 1, alpha: 0.9)
            tick.frame = CGRect(
                x: CGFloat(fraction) * width - 1,
                y: 0,
                width: 2,
                height: chapterOverlay.bounds.height)
            chapterOverlay.addSubview(tick)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player.notifySurfaceReady()
        focusedZone = .buttons
        focusedControlIndex = controls.firstIndex(of: .playPause) ?? 0
        updateFocusHighlight()
        showOsd()
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) {
            [weak self] _ in
            Task { @MainActor in self?.updateOsd() }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        updateTimer?.invalidate()
        updateTimer = nil
        scrubCommitTimer?.invalidate()
        scrubCommitTimer = nil
        player.stop()
        onExit?()
    }

    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        for press in presses {
            switch press.type {
            case .menu:
                if scrubTargetMs != nil {
                    cancelScrub()
                    showOsd()
                    return
                }
            case .upArrow:
                focusedZone = .scrubber
                updateFocusHighlight()
                showOsd()
                return
            case .downArrow:
                focusedZone = .buttons
                updateFocusHighlight()
                showOsd()
                return
            case .playPause:
                togglePlayPause()
                showOsd()
                return
            case .select:
                handleSelect()
                showOsd()
                return
            case .leftArrow:
                handleHorizontal(forward: false)
                showOsd()
                return
            case .rightArrow:
                handleHorizontal(forward: true)
                showOsd()
                return
            default:
                break
            }
        }
        super.pressesBegan(presses, with: event)
    }

    private func handleSelect() {
        switch focusedZone {
        case .scrubber:
            if scrubTargetMs != nil {
                commitScrub()
            } else {
                togglePlayPause()
            }
        case .buttons:
            guard controls.indices.contains(focusedControlIndex) else { return }
            activate(controls[focusedControlIndex])
        }
    }

    private func handleHorizontal(forward: Bool) {
        switch focusedZone {
        case .scrubber:
            adjustScrub(byMs: forward ? skipForwardMs : -skipBackMs)
        case .buttons:
            let next = focusedControlIndex + (forward ? 1 : -1)
            focusedControlIndex = min(controls.count - 1, max(0, next))
            updateFocusHighlight()
        }
    }

    private func activate(_ id: ControlId) {
        switch id {
        case .prev:
            onPrevious?()
        case .skipBack:
            adjustScrub(byMs: -skipBackMs)
        case .playPause:
            togglePlayPause()
        case .skipForward:
            adjustScrub(byMs: skipForwardMs)
        case .next:
            onNext?()
        case .audio:
            presentAudioMenu()
        case .subtitles:
            presentSubtitleMenu()
        case .chapters:
            presentChapterMenu()
        }
    }

    private func updateFocusHighlight() {
        for (id, container) in controlViews {
            let isFocused =
                focusedZone == .buttons && controls.indices.contains(focusedControlIndex)
                && controls[focusedControlIndex] == id
            container.backgroundColor =
                isFocused ? .white : UIColor(white: 1, alpha: 0)
            controlIcons[id]?.tintColor = isFocused ? .black : UIColor(white: 1, alpha: 0.85)
            container.transform =
                isFocused ? CGAffineTransform(scaleX: 1.12, y: 1.12) : .identity
        }
        let scrubFocused = focusedZone == .scrubber
        scrubber.transform =
            scrubFocused ? CGAffineTransform(scaleX: 1, y: 2.0) : .identity
        scrubber.trackTintColor =
            scrubFocused ? UIColor(white: 1, alpha: 0.45) : UIColor(white: 1, alpha: 0.25)
    }

    private func togglePlayPause() {
        switch player.state {
        case .playing, .buffering, .opening:
            player.pause()
        default:
            player.resume()
        }
    }

    private func isPaused() -> Bool {
        player.state == .paused
    }

    private func adjustScrub(byMs deltaMs: Int) {
        let durationMs = Int(player.duration * 1000)
        guard durationMs > 0 else { return }
        let base = scrubTargetMs ?? Int(player.currentTime * 1000)
        scrubTargetMs = min(durationMs, max(0, base + deltaMs))
        renderProgress()
        scrubCommitTimer?.invalidate()
        scrubCommitTimer = Timer.scheduledTimer(
            withTimeInterval: 0.6, repeats: false
        ) { [weak self] _ in
            Task { @MainActor in self?.commitScrub() }
        }
    }

    private func commitScrub() {
        scrubCommitTimer?.invalidate()
        scrubCommitTimer = nil
        guard let target = scrubTargetMs else { return }
        scrubTargetMs = nil
        player.seek(to: Double(target) / 1000.0)
    }

    private func cancelScrub() {
        scrubCommitTimer?.invalidate()
        scrubCommitTimer = nil
        scrubTargetMs = nil
        renderProgress()
    }

    private func hideOsd() {
        UIView.animate(withDuration: 0.3) {
            self.osdContainer.alpha = 0
            self.topContainer.alpha = 0
        }
    }

    private func trackActionTitle(
        _ track: (index: Int, label: String, subtitle: String, selected: Bool)
    ) -> String {
        let prefix = track.selected ? "\u{2713} " : ""
        if track.subtitle.isEmpty {
            return "\(prefix)\(track.label)"
        }
        return "\(prefix)\(track.label) · \(track.subtitle)"
    }

    private func presentAudioMenu() {
        let sheet = UIAlertController(
            title: "Audio", message: nil, preferredStyle: .actionSheet)
        for track in audioTracks {
            sheet.addAction(
                UIAlertAction(title: trackActionTitle(track), style: .default) {
                    [weak self] _ in
                    self?.onSelectAudio?(track.index)
                })
        }
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sheet, animated: true)
    }

    private func presentSubtitleMenu() {
        let sheet = UIAlertController(
            title: "Subtitles", message: nil, preferredStyle: .actionSheet)
        let anySelected = subtitleTracks.contains { $0.selected }
        let offTitle = (anySelected ? "" : "\u{2713} ") + "Off"
        sheet.addAction(
            UIAlertAction(title: offTitle, style: .default) { [weak self] _ in
                self?.onSelectSubtitle?(-1)
            })
        for track in subtitleTracks {
            sheet.addAction(
                UIAlertAction(title: trackActionTitle(track), style: .default) {
                    [weak self] _ in
                    self?.onSelectSubtitle?(track.index)
                })
        }
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sheet, animated: true)
    }

    private func presentChapterMenu() {
        let sheet = UIAlertController(
            title: "Chapters", message: nil, preferredStyle: .actionSheet)
        for chapter in chapters {
            let stamp = formatTime(Double(chapter.startMs) / 1000.0)
            sheet.addAction(
                UIAlertAction(title: "\(chapter.title) · \(stamp)", style: .default) {
                    [weak self] _ in
                    self?.player.seek(to: Double(chapter.startMs) / 1000.0)
                    self?.showOsd()
                })
        }
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sheet, animated: true)
    }

    private func showOsd() {
        lastShowAt = CACurrentMediaTime()
        if osdContainer.alpha < 1 {
            UIView.animate(withDuration: 0.2) {
                self.osdContainer.alpha = 1
                self.topContainer.alpha = 1
            }
        }
    }

    private func renderProgress() {
        let duration = player.duration
        let current = scrubTargetMs.map { Double($0) / 1000.0 } ?? player.currentTime
        scrubber.progress = duration > 0 ? Float(min(1, max(0, current / duration))) : 0
        currentTimeLabel.text = formatTime(current)
        durationLabel.text = formatTime(duration)
    }

    private func updateOsd() {
        renderProgress()
        controlIcons[.playPause]?.image = UIImage(
            systemName: isPaused() ? "play.fill" : "pause.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .semibold))

        let shouldShow =
            isPaused() || scrubTargetMs != nil
            || (CACurrentMediaTime() - lastShowAt < 4.0)
        let visible = osdContainer.alpha > 0.5
        if shouldShow && !visible {
            UIView.animate(withDuration: 0.2) {
                self.osdContainer.alpha = 1
                self.topContainer.alpha = 1
            }
        } else if !shouldShow && visible {
            UIView.animate(withDuration: 0.3) {
                self.osdContainer.alpha = 0
                self.topContainer.alpha = 0
            }
        }
    }

    private func formatTime(_ t: TimeInterval) -> String {
        guard t.isFinite, t >= 0 else { return "0:00" }
        let total = Int(t.rounded())
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        return h > 0
            ? String(format: "%d:%02d:%02d", h, m, s)
            : String(format: "%d:%02d", m, s)
    }
}
