import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_typography.dart';
import '/state/document_provider.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({super.key});

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  String? _selectedDocumentType;
  String? _selectedFilePath;
  String? _selectedFileName;
  final _titleController = TextEditingController();

  final Map<String, Map<String, dynamic>> _documentTypes = {
    'legal': {
      'title': 'Legal Notice',
      'description': 'Foreclosure notices, court documents',
      'icon': Icons.gavel,
      'color': AppColors.red,
    },
    'financial': {
      'title': 'Financial Document',
      'description': 'Bank statements, pay stubs',
      'icon': Icons.account_balance,
      'color': AppColors.secondary,
    },
    'correspondence': {
      'title': 'Correspondence',
      'description': 'Letters, emails with lender',
      'icon': Icons.mail,
      'color': AppColors.blue,
    },
    'other': {
      'title': 'Other',
      'description': 'Any other relevant document',
      'icon': Icons.description,
      'color': AppColors.neutral600,
    },
  };

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'docx', 'doc'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFilePath = result.files.single.path;
        _selectedFileName = result.files.single.name;
        if (_titleController.text.isEmpty) {
          _titleController.text = result.files.single.name.split('.').first;
        }
      });
    }
  }

  Future<void> _uploadDocument() async {
    if (_selectedDocumentType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a document type')));
      return;
    }

    if (_selectedFilePath == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a file')));
      return;
    }

    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a title')));
      return;
    }

    final documentProvider = Provider.of<DocumentProvider>(context, listen: false);

    final document = await documentProvider.uploadDocument(
      filePath: _selectedFilePath!,
      title: _titleController.text,
      documentType: _selectedDocumentType!,
    );

    if (mounted) {
      if (document != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Document uploaded successfully')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(documentProvider.errorMessage ?? 'Failed to upload document')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentProvider>(
      builder: (context, documentProvider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Upload Document')),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Document Type', style: AppTypography.h2),
                const SizedBox(height: 16),
                ..._documentTypes.entries.map(
                  (entry) => _buildDocumentTypeCard(
                    entry.key,
                    entry.value['title'],
                    entry.value['description'],
                    entry.value['icon'],
                    entry.value['color'],
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Document Title',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: documentProvider.isLoading ? null : _pickFile,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedFilePath != null ? AppColors.green : AppColors.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: _selectedFilePath != null ? AppColors.green.withOpacity(0.1) : null,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _selectedFilePath != null ? Icons.check_circle : Icons.cloud_upload,
                          size: 60,
                          color: _selectedFilePath != null ? AppColors.green : AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedFileName ?? 'Drop files here or click to browse',
                          style: AppTypography.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Supported formats: PDF, JPG, PNG, DOCX',
                          style: AppTypography.bodySmall.copyWith(color: AppColors.neutral600),
                        ),
                        if (documentProvider.isLoading && documentProvider.uploadProgress > 0) ...[
                          const SizedBox(height: 16),
                          LinearProgressIndicator(value: documentProvider.uploadProgress),
                          const SizedBox(height: 8),
                          Text(
                            '${(documentProvider.uploadProgress * 100).toInt()}%',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: documentProvider.isLoading ? null : _uploadDocument,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: documentProvider.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Upload Document'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDocumentTypeCard(
    String type,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedDocumentType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDocumentType = type;
        });
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        color: isSelected ? color.withOpacity(0.1) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? color : AppColors.neutral300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          title: Text(
            title,
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Text(subtitle),
          trailing: isSelected
              ? Icon(Icons.check_circle, color: color)
              : Icon(Icons.circle_outlined, color: AppColors.neutral400),
        ),
      ),
    );
  }
}
