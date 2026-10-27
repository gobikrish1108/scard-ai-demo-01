import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VaultDoc {
  final String id;
  final String title;
  final String size;
  final int pages;
  final int embeddingsCount;
  final bool isIndexed;
  final String category;

  const VaultDoc({
    required this.id,
    required this.title,
    required this.size,
    required this.pages,
    required this.embeddingsCount,
    this.isIndexed = true,
    required this.category,
  });

  VaultDoc copyWith({
    String? id,
    String? title,
    String? size,
    int? pages,
    int? embeddingsCount,
    bool? isIndexed,
    String? category,
  }) {
    return VaultDoc(
      id: id ?? this.id,
      title: title ?? this.title,
      size: size ?? this.size,
      pages: pages ?? this.pages,
      embeddingsCount: embeddingsCount ?? this.embeddingsCount,
      isIndexed: isIndexed ?? this.isIndexed,
      category: category ?? this.category,
    );
  }
}

class RagAnswer {
  final String query;
  final String answer;
  final String sourceDoc;
  final String citation;
  final double similarityScore;

  const RagAnswer({
    required this.query,
    required this.answer,
    required this.sourceDoc,
    required this.citation,
    required this.similarityScore,
  });
}

class DocumentVaultState {
  final List<VaultDoc> documents;
  final String currentQuery;
  final RagAnswer? answer;
  final bool isSearching;
  final bool isUploading;

  const DocumentVaultState({
    this.documents = const [
      VaultDoc(
        id: '1',
        title: 'Antz_Media_Master_Services_2026.pdf',
        size: '1.8 MB',
        pages: 24,
        embeddingsCount: 48,
        category: 'Contracts',
      ),
      VaultDoc(
        id: '2',
        title: 'Antz_Media_NDA_Mutual.pdf',
        size: '420 KB',
        pages: 4,
        embeddingsCount: 12,
        category: 'Legal',
      ),
      VaultDoc(
        id: '3',
        title: 'GST_Registration_Certificate_AntzMedia.pdf',
        size: '680 KB',
        pages: 3,
        embeddingsCount: 8,
        category: 'Tax & Compliance',
      ),
    ],
    this.currentQuery = 'What is the payment milestone schedule?',
    this.answer = const RagAnswer(
      query: 'What is the payment milestone schedule?',
      answer:
          'According to Antz_Media_Master_Services_2026.pdf, payments are structured in 3 milestones: 40% advance upon signature, 30% on beta milestone delivery, and 30% within 15 days of final deployment.',
      sourceDoc: 'Antz_Media_Master_Services_2026.pdf',
      citation: 'Section 4.2 • Page 7, Paragraph 3',
      similarityScore: 0.942,
    ),
    this.isSearching = false,
    this.isUploading = false,
  });

  DocumentVaultState copyWith({
    List<VaultDoc>? documents,
    String? currentQuery,
    RagAnswer? answer,
    bool? isSearching,
    bool? isUploading,
  }) {
    return DocumentVaultState(
      documents: documents ?? this.documents,
      currentQuery: currentQuery ?? this.currentQuery,
      answer: answer ?? this.answer,
      isSearching: isSearching ?? this.isSearching,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}

class DocumentVaultNotifier extends Notifier<DocumentVaultState> {
  @override
  DocumentVaultState build() => const DocumentVaultState();

  void askRag(String query) {
    state = state.copyWith(isSearching: true, currentQuery: query);

    Timer(const Duration(milliseconds: 600), () {
      RagAnswer ans;
      final qLower = query.toLowerCase();

      if (qLower.contains('gst') || qLower.contains('tax')) {
        ans = const RagAnswer(
          query: 'GST details',
          answer:
              'Antz Media Digital holds GSTIN 33AAACA1234A1Z5 under Tamil Nadu jurisdiction. Standard service GST is charged at 18% (9% CGST + 9% SGST).',
          sourceDoc: 'GST_Registration_Certificate_AntzMedia.pdf',
          citation: 'Registration Certificate • Page 1, Block A',
          similarityScore: 0.965,
        );
      } else if (qLower.contains('nda') || qLower.contains('confidential')) {
        ans = const RagAnswer(
          query: 'NDA confidentiality period',
          answer:
              'The Mutual Non-Disclosure Agreement defines confidentiality obligations for 3 years following the termination or expiration of discussions.',
          sourceDoc: 'Antz_Media_NDA_Mutual.pdf',
          citation: 'Clause 6 • Page 3, Section 6.1',
          similarityScore: 0.912,
        );
      } else {
        ans = RagAnswer(
          query: query,
          answer:
              'Based on semantic vector retrieval across 68 indexed embeddings: The Antz Media agreement specifies strict SLA of 99.9% uptime with 4-hour critical issue response times.',
          sourceDoc: 'Antz_Media_Master_Services_2026.pdf',
          citation: 'Annexure B • Service Level Agreements, Page 19',
          similarityScore: 0.887,
        );
      }

      state = state.copyWith(isSearching: false, answer: ans);
    });
  }

  void uploadDocument(String title, String category, int pages, String size) {
    state = state.copyWith(isUploading: true);

    Timer(const Duration(milliseconds: 1200), () {
      final newDoc = VaultDoc(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        size: size,
        pages: pages,
        embeddingsCount: pages * 3,
        category: category,
      );

      state = state.copyWith(
        isUploading: false,
        documents: [newDoc, ...state.documents],
      );
    });
  }
}

final documentVaultProvider =
    NotifierProvider<DocumentVaultNotifier, DocumentVaultState>(DocumentVaultNotifier.new);
