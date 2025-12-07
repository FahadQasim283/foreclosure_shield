import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../data/mock_data.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final documents = MockData.mockDocuments;

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
      body: documents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open, size: 80, color: AppColors.neutral300),
                  const SizedBox(height: 16),
                  Text(
                    'No documents yet',
                    style: AppTypography.h4.copyWith(color: AppColors.neutral500),
                  ),
                ],
              ),
            )
          : ListView.builder(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(RouteNames.generateLetter);
        },
        child: const Icon(Icons.add),
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
