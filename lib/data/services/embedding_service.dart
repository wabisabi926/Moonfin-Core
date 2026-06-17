import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class EmbeddingService {
  static const int embeddingDimension = 384;
  static const String defaultModelFileName = 'all-MiniLM-L6-v2.onnx';

  Future<void>? _initializeFuture;
  File? _modelFile;

  bool get isInitialized => _initializeFuture != null;

  bool get hasModelFile => _modelFile?.existsSync() == true;

  String? get modelPath => _modelFile?.path;

  Future<void> initialize() {
    final existing = _initializeFuture;
    if (existing != null) return existing;

    final future = _initializeInternal();
    _initializeFuture = future;
    return future;
  }

  Future<File> resolveModelFile() async {
    await initialize();
    return _modelFile!;
  }

  Future<Float32List?> embedText(String text) async {
    final normalized = text.trim();
    if (normalized.isEmpty) return null;

    await initialize();

    // V2 bootstrap: deterministic local embeddings that require no cloud
    // service and keep the semantic ranking flow active across all platforms.
    return _hashEmbedding(normalized);
  }

  Uint8List toBytes(Float32List vector) {
    final data = Uint8List(vector.length * Float32List.bytesPerElement);
    final byteData = ByteData.sublistView(data);
    for (var i = 0; i < vector.length; i++) {
      byteData.setFloat32(
        i * Float32List.bytesPerElement,
        vector[i],
        Endian.little,
      );
    }
    return data;
  }

  Float32List fromBytes(Uint8List bytes) {
    final count = bytes.lengthInBytes ~/ Float32List.bytesPerElement;
    final output = Float32List(count);
    final byteData = ByteData.sublistView(bytes);
    for (var i = 0; i < count; i++) {
      output[i] = byteData.getFloat32(
        i * Float32List.bytesPerElement,
        Endian.little,
      );
    }
    return output;
  }

  double cosineSimilarity(Float32List a, Float32List b) {
    final length = min(a.length, b.length);
    if (length == 0) return 0;

    var dot = 0.0;
    var normA = 0.0;
    var normB = 0.0;

    for (var i = 0; i < length; i++) {
      final av = a[i];
      final bv = b[i];
      dot += av * bv;
      normA += av * av;
      normB += bv * bv;
    }

    if (normA <= 0 || normB <= 0) return 0;
    return dot / (sqrt(normA) * sqrt(normB));
  }

  Future<void> _initializeInternal() async {
    final support = await getApplicationSupportDirectory();
    final modelDir = Directory('${support.path}/Moonfin/models');
    if (!await modelDir.exists()) {
      await modelDir.create(recursive: true);
    }

    _modelFile = File('${modelDir.path}/$defaultModelFileName');
  }

  Float32List _hashEmbedding(String text) {
    final vector = Float32List(embeddingDimension);

    final normalized = text.toLowerCase();
    final tokens = RegExp(r'[a-z0-9]+')
        .allMatches(normalized)
        .map((match) => match.group(0)!)
        .where((token) => token.length >= 2)
        .toList();

    if (tokens.isEmpty) {
      return vector;
    }

    for (final token in tokens) {
      final bytes = utf8.encode(token);
      final hashA = _fnv1a32(bytes, seed: 2166136261);
      final hashB = _fnv1a32(bytes, seed: 16777619);

      final indexA = hashA % embeddingDimension;
      final indexB = hashB % embeddingDimension;

      final weight = 1.0 + (token.length / 12.0);
      vector[indexA] += weight;
      vector[indexB] -= weight * 0.5;

      if (token.length >= 4) {
        for (var i = 0; i <= token.length - 3; i++) {
          final trigram = token.substring(i, i + 3);
          final trigramHash = _fnv1a32(utf8.encode(trigram), seed: hashA);
          final trigramIndex = trigramHash % embeddingDimension;
          vector[trigramIndex] += 0.35;
        }
      }
    }

    var norm = 0.0;
    for (final value in vector) {
      norm += value * value;
    }
    if (norm <= 0) {
      return vector;
    }

    final invNorm = 1.0 / sqrt(norm);
    for (var i = 0; i < vector.length; i++) {
      vector[i] = vector[i] * invNorm;
    }

    return vector;
  }

  int _fnv1a32(List<int> bytes, {required int seed}) {
    var hash = seed & 0xFFFFFFFF;
    for (final byte in bytes) {
      hash ^= byte;
      hash = (hash * 16777619) & 0xFFFFFFFF;
    }
    return hash & 0x7FFFFFFF;
  }
}
