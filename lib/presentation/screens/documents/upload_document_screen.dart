import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import '/core/theme/app_typography.dart';

class UploadDocumentScreen extends StatelessWidget {
  const UploadDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Document')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Document Type', style: AppTypography.h2),
            const SizedBox(height: 16),
            _buildDocumentTypeCard(
              'Legal Notice',
              'Foreclosure notices, court documents',
              Icons.gavel,
              AppColors.red,
            ),
            _buildDocumentTypeCard(
              'Financial Document',
              'Bank statements, pay stubs',
              Icons.account_balance,
              AppColors.secondary,
            ),
            _buildDocumentTypeCard(
              'Correspondence',
              'Letters, emails with lender',
              Icons.mail,
              AppColors.blue,
            ),
            _buildDocumentTypeCard(
              'Other',
              'Any other relevant document',
              Icons.description,
              AppColors.neutral600,
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 2, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(Icons.cloud_upload, size: 60, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text('Drop files here or click to browse', style: AppTypography.bodyLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Supported formats: PDF, JPG, PNG, DOCX',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.neutral600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Upload document
                },
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Upload Document'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentTypeCard(String title, String subtitle, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
        title: Text(title, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: Radio(value: false, groupValue: true, onChanged: (value) {}),
      ),
    );
  }
}
