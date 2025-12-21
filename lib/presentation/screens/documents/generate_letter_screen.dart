import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme.dart';
import '../../../state/document_provider.dart';
import '../../../data/models/document_models.dart';

class GenerateLetterScreen extends StatefulWidget {
  const GenerateLetterScreen({super.key});

  @override
  State<GenerateLetterScreen> createState() => _GenerateLetterScreenState();
}

class _GenerateLetterScreenState extends State<GenerateLetterScreen> {
  String? _selectedLetterType;

  final List<Map<String, dynamic>> _letterTypes = [
    {
      'type': 'hardship',
      'title': 'Hardship Letter',
      'description': 'Explain your financial hardship to your lender',
      'icon': Icons.description,
      'color': AppColors.blue,
    },
    {
      'type': 'loan_modification',
      'title': 'Loan Modification Request',
      'description': 'Request to modify your loan terms',
      'icon': Icons.edit_document,
      'color': AppColors.green,
    },
    {
      'type': 'reinstatement',
      'title': 'Reinstatement Letter',
      'description': 'Request to reinstate your loan',
      'icon': Icons.refresh,
      'color': AppColors.orange,
    },
    {
      'type': 'cease_desist',
      'title': 'Cease and Desist',
      'description': 'Stop harassment from debt collectors',
      'icon': Icons.block,
      'color': AppColors.red,
    },
  ];

  Future<void> _generateLetter() async {
    if (_selectedLetterType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a letter type')));
      return;
    }

    final documentProvider = Provider.of<DocumentProvider>(context, listen: false);

    final request = GenerateLetterRequest(
      letterType: _selectedLetterType!,
      recipientName: 'Lender Name',
      recipientAddress: 'Lender Address',
    );

    final document = await documentProvider.generateLetter(request);

    if (mounted) {
      if (document != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Letter Generated', style: AppTypography.h3),
            content: Text(
              'Your letter has been generated successfully!',
              style: AppTypography.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.pop();
                },
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to document details
                  context.pop();
                },
                child: const Text('View Letter'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(documentProvider.errorMessage ?? 'Failed to generate letter')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DocumentProvider>(
      builder: (context, documentProvider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text('Generate Letter')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.goldGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.auto_awesome, size: 48, color: AppColors.white),
                      const SizedBox(height: 12),
                      Text(
                        'AI-Powered Letter Generation',
                        style: AppTypography.h3.copyWith(color: AppColors.white),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Professional letters tailored to your situation',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Letter Types
                Text('Select Letter Type', style: AppTypography.h3),
                const SizedBox(height: 16),

                ..._letterTypes.map((letterType) => _buildLetterTypeCard(letterType)),

                const SizedBox(height: 32),

                // Generate Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: documentProvider.isLoading ? null : _generateLetter,
                    child: documentProvider.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.auto_awesome),
                              const SizedBox(width: 8),
                              Text('Generate with AI', style: AppTypography.buttonLarge),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLetterTypeCard(Map<String, dynamic> letterType) {
    final isSelected = _selectedLetterType == letterType['type'];
    final color = letterType['color'] as Color;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedLetterType = letterType['type']);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : AppColors.neutral300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(letterType['icon'] as IconData, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    letterType['title'],
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? color : AppColors.neutral800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    letterType['description'],
                    style: AppTypography.bodySmall.copyWith(color: AppColors.neutral600),
                  ),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: color),
          ],
        ),
      ),
    );
  }
}
