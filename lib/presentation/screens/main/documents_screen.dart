import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../state/document_provider.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDocuments();
    });
  }

  Future<void> _loadDocuments() async {
    // Documents are loaded and managed by DocumentProvider automatically
    // The documents getter returns the current list
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentProvider>(
      builder: (context, documentProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Documents'),
            actions: [
              IconButton(
                icon: const Icon(Icons.upload_file),
                onPressed: () {
                  context.push(RouteNames.uploadDocument);
                },
              ),
            ],
          ),
          body: _buildBody(documentProvider),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.push(RouteNames.generateLetter);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildBody(DocumentProvider provider) {
    if (provider.isLoading && !provider.hasDocuments) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.red),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? 'Failed to load documents',
              style: AppTypography.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _loadDocuments, child: const Text('Retry')),
          ],
        ),
      );
    }

    final documents = provider.documents;

    if (documents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 80, color: AppColors.neutral300),
            const SizedBox(height: 16),
            Text('No documents yet', style: AppTypography.h4.copyWith(color: AppColors.neutral500)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDocuments,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: documents.length,
        itemBuilder: (context, index) {
          final doc = documents[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getDocTypeColor(doc.documentType).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getDocTypeIcon(doc.documentType),
                  color: _getDocTypeColor(doc.documentType),
                ),
              ),
              title: Text(
                doc.title,
                style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                '${doc.fileType?.toUpperCase() ?? 'Unknown'} • ${doc.fileSizeFormatted}',
                style: AppTypography.caption,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                context.push('${RouteNames.documentDetails}/${doc.id}');
              },
            ),
          );
        },
      ),
    );
  }

  Color _getDocTypeColor(String type) {
    switch (type) {
      case 'generated':
        return AppColors.blue;
      case 'uploaded':
        return AppColors.green;
      case 'letter':
        return AppColors.secondary;
      default:
        return AppColors.neutral500;
    }
  }

  IconData _getDocTypeIcon(String type) {
    switch (type) {
      case 'generated':
        return Icons.auto_awesome;
      case 'uploaded':
        return Icons.upload_file;
      case 'letter':
        return Icons.mail;
      default:
        return Icons.description;
    }
  }
}
