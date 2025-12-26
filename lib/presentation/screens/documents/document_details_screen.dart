import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
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
        final document = documentProvider.documents.firstWhere(
          (doc) => doc.id == documentId,
          orElse: () => documentProvider.currentDocument!,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Document Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.download),
                onPressed: () {
                  _downloadDocument(context, document);
                },
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [Icon(Icons.edit, size: 20), SizedBox(width: 12), Text('Edit')],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Row(
                      children: [
                        Icon(Icons.copy, size: 20),
                        SizedBox(width: 12),
                        Text('Duplicate'),
                      ],
                    ),
                  ),
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
                        Text('Generated Content', style: AppTypography.h3),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.neutral100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.neutral300),
                          ),
                          child: Text(document.generatedContent!, style: AppTypography.bodyMedium),
                        ),
                      ],
                      const SizedBox(height: 24),

                      // Preview Section
                      Text('Document Preview', style: AppTypography.h3),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        height: 400,
                        decoration: BoxDecoration(
                          color: AppColors.neutral100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.neutral300),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getFileIcon(document.fileType ?? 'pdf'),
                                size: 80,
                                color: AppColors.neutral400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '${(document.fileType ?? 'PDF').toUpperCase()} Preview',
                                style: AppTypography.h4.copyWith(color: AppColors.neutral600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to view full document',
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.neutral500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _showFullContentDialog(context, document);
                              },
                              icon: const Icon(Icons.visibility),
                              label: const Text('View Full'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                _shareDocument(context, document);
                              },
                              icon: const Icon(Icons.share),
                              label: const Text('Share'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Edit document
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Document'),
                          style: OutlinedButton.styleFrom(
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

  void _showFullContentDialog(BuildContext context, document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(document.title),
        content: SingleChildScrollView(
          child: Text(
            document.generatedContent ?? 'No content available',
            style: AppTypography.bodyMedium,
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
      ),
    );
  }

  void _shareDocument(BuildContext context, document) async {
    String shareText = 'Document: ${document.title}\nType: ${document.documentType}';

    if (document.generatedContent != null && document.generatedContent!.isNotEmpty) {
      shareText += '\n\nContent:\n${document.generatedContent}';
    }

    if (document.fileUrl != null && document.fileUrl!.isNotEmpty) {
      shareText += '\n\nDownload Link: ${document.fileUrl}';
    }

    try {
      await Share.share(shareText, subject: 'Shared Document: ${document.title}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing document: $e'), duration: const Duration(seconds: 2)),
      );
    }
  }

  void _downloadDocument(BuildContext context, document) async {
    if (document.fileUrl != null && document.fileUrl!.isNotEmpty) {
      final Uri url = Uri.parse(document.fileUrl!);
      try {
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Opening document...'), duration: Duration(seconds: 2)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open document URL'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening document: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else if (document.generatedContent != null && document.generatedContent!.isNotEmpty) {
      // For generated content without a file URL, share the content
      _shareDocument(context, document);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Document shared. Use share options to save or send.'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No downloadable content available'),
          duration: Duration(seconds: 2),
        ),
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
