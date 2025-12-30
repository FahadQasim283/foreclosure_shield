import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_typography.dart';
import '/state/document_provider.dart';

class DocumentDetailsScreen extends StatelessWidget {
  final String documentId;

  const DocumentDetailsScreen({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentProvider>(
      builder: (context, documentProvider, child) {
        // Find document by ID from provider
        final document = documentProvider.documents.isNotEmpty
            ? documentProvider.documents.firstWhere(
                (doc) => doc.id == documentId,
                orElse: () => documentProvider.currentDocument!,
              )
            : documentProvider.currentDocument;

        // Show error if document not found
        if (document == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Document Details')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.neutral400),
                  const SizedBox(height: 16),
                  Text(
                    'Document not found',
                    style: AppTypography.h3.copyWith(color: AppColors.neutral600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The document you\'re looking for doesn\'t exist.',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.neutral500),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(onPressed: () => context.pop(), child: const Text('Go Back')),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Document Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  _shareDocument(context, document);
                },
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'delete') {
                    _showDeleteDialog(context);
                  }
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Document Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getCategoryColor(document.documentType),
                        _getCategoryColor(document.documentType).withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          document.documentType.toUpperCase(),
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(document.title, style: AppTypography.h1.copyWith(color: Colors.white)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _formatDate(document.uploadedDate),
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.description, size: 16, color: Colors.white.withOpacity(0.9)),
                          const SizedBox(width: 6),
                          Text(
                            (document.fileType ?? 'PDF').toUpperCase(),
                            style: AppTypography.bodySmall.copyWith(
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Document Info
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Document Information', style: AppTypography.h3),
                      const SizedBox(height: 16),
                      _buildInfoRow('Type', document.documentType),
                      _buildInfoRow('File Type', (document.fileType ?? 'PDF').toUpperCase()),
                      _buildInfoRow('Uploaded', _formatDate(document.uploadedDate)),
                      if (document.fileUrl != null)
                        _buildInfoRow('File Location', document.fileUrl!),
                      if (document.generatedContent != null) ...[
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Letter Preview', style: AppTypography.h3),
                            if (document.letterType != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                                ),
                                child: Text(
                                  _formatLetterType(document.letterType!),
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.neutral300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: MarkdownBody(
                            data: document.generatedContent!,
                            styleSheet: MarkdownStyleSheet(
                              h1: AppTypography.h2.copyWith(
                                color: AppColors.neutral900,
                                fontWeight: FontWeight.bold,
                              ),
                              h2: AppTypography.h3.copyWith(
                                color: AppColors.neutral800,
                                fontWeight: FontWeight.w600,
                                height: 2.0,
                              ),
                              h3: AppTypography.h4.copyWith(
                                color: AppColors.neutral700,
                                fontWeight: FontWeight.w600,
                              ),
                              p: AppTypography.bodyMedium.copyWith(
                                color: AppColors.neutral800,
                                height: 1.6,
                              ),
                              listBullet: AppTypography.bodyMedium.copyWith(
                                color: AppColors.primary,
                              ),
                              strong: AppTypography.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.neutral900,
                              ),
                              blockSpacing: 16.0,
                              listIndent: 24.0,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Action Buttons
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _shareDocument(context, document);
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Share Letter'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, [Color? valueColor]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.neutral600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyMedium.copyWith(
                color: valueColor ?? AppColors.neutral800,
                fontWeight: valueColor != null ? FontWeight.w600 : FontWeight.normal,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String documentType) {
    switch (documentType.toLowerCase()) {
      case 'letter':
        return AppColors.primary;
      case 'notice':
        return AppColors.red;
      case 'generated':
        return AppColors.secondary;
      case 'uploaded':
        return AppColors.blue;
      default:
        return AppColors.neutral600;
    }
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  String _formatLetterType(String letterType) {
    return letterType.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }

  void _shareDocument(BuildContext context, document) async {
    String shareText = 'Document: ${document.title}\nType: ${document.documentType}';

    if (document.letterType != null) {
      shareText += '\nLetter Type: ${_formatLetterType(document.letterType!)}';
    }

    if (document.generatedContent != null && document.generatedContent!.isNotEmpty) {
      shareText += '\n\n${document.generatedContent}';
    }

    try {
      await Share.share(shareText, subject: document.title);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing document: $e'), duration: const Duration(seconds: 2)),
      );
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: const Text(
          'Are you sure you want to delete this document? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop(); // Go back to documents list
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
