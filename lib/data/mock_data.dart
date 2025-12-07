import 'models/models.dart';

class MockData {
  // Mock User
  static final User mockUser = User(
    id: '1',
    email: 'fahadqasim3310@gmail.com',
    name: 'Fahad Qasim',
    phone: '+923021826959',
    role: 'client',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    isEmailVerified: true,
    isPhoneVerified: true,
    subscriptionPlan: 'pro',
    subscriptionExpiryDate: DateTime.now().add(const Duration(days: 335)),
  );

  // Mock Risk Assessment
  static final RiskAssessment mockAssessment = RiskAssessment(
    id: '1',
    userId: '1',
    riskScore: 75,
    riskCategory: 'URGENT',
    assessmentDate: DateTime.now().subtract(const Duration(days: 5)),
    auctionDate: DateTime.now().add(const Duration(days: 45)),
    daysToAuction: 45,
    amountOwed: 285000.00,
    propertyValue: 350000.00,
    missedPayments: 4,
    lenderName: 'First National Bank',
    lenderPhone: '+1 (555) 987-6543',
    propertyAddress: '1234 Main Street',
    propertyCity: 'Springfield',
    propertyState: 'IL',
    propertyZip: '62701',
    monthlyIncome: 4500.00,
    monthlyExpenses: 5200.00,
    hasOtherDebts: true,
    otherDebtsAmount: 45000.00,
    legalStatus: 'foreclosure_filed',
    hasLegalRepresentation: false,
    hasReceivedNotices: true,
    occupancyStatus: 'owner_occupied',
    wantsToKeepHome: true,
    notes: 'Lost job 6 months ago, recently found new employment',
    riskSummary:
        r'''Your foreclosure risk is URGENT. Based on your financial situation and the active foreclosure filing, immediate action is required to protect your home.

Key Risk Factors:
• 4 missed mortgage payments totaling $8,500
• Foreclosure already filed with court
• Monthly expenses exceed income by $700
• Auction scheduled in 45 days
• No legal representation currently

Positive Factors:
• Recently employed with stable income
• Home equity of approximately $65,000
• Strong desire to keep the home
• Owner-occupied property''',
    actionPlan30Day: r'''IMMEDIATE ACTIONS (Next 7 Days):

1. Contact Your Lender - PRIORITY
   • Call First National Bank at (555) 987-6543
   • Request loss mitigation department
   • Ask about forbearance or loan modification options
   • Get contact info for your case manager

2. Gather Required Documents
   • Last 2 months of pay stubs
   • Bank statements (last 3 months)
   • Tax returns (last 2 years)
   • Hardship letter explaining job loss
   • Proof of new employment

3. Seek Legal Assistance
   • Contact local legal aid in Springfield, IL
   • HUD-approved housing counselor consultation
   • Free consultation with foreclosure attorney

WEEK 2-3 ACTIONS:

4. Apply for Loan Modification
   • Submit complete application package
   • Follow up every 3 days
   • Document all communications

5. Review Budget and Reduce Expenses
   • Cut non-essential expenses by $700/month
   • Consider temporary second income
   • Apply for utility assistance programs

6. Explore All Options
   • Forbearance agreement
   • Repayment plan
   • Short sale (if modification denied)
   • Deed in lieu of foreclosure

WEEK 4 ACTIONS:

7. Follow Up on All Applications
8. Prepare for Court Hearing if Necessary
9. Document Everything''',
    actionPlan60Day: r'''DAYS 30-45:

1. Loan Modification Follow-Up
   • Check status weekly
   • Provide any additional documentation requested
   • Request written updates

2. Strengthen Your Case
   • Make partial payments if possible
   • Show good faith effort to resolve
   • Keep detailed records

3. Prepare Alternative Plans
   • Research refinancing options
   • Contact family for potential assistance
   • Investigate state/federal assistance programs

DAYS 45-60:

4. Court Preparation (if needed)
   • Attend all court dates
   • Bring all documentation
   • Present your case professionally

5. Final Option Review
   • If modification approved: celebrate and comply strictly
   • If denied: appeal or pursue alternatives
   • Consider selling if equity can be preserved

6. Long-Term Financial Planning
   • Credit counseling
   • Emergency fund building
   • Debt management plan''',
  );

  // Mock Action Tasks
  static final List<ActionTask> mockTasks = [
    ActionTask(
      id: '1',
      assessmentId: '1',
      title: 'Call Lender Immediately',
      description:
          'Contact First National Bank loss mitigation department. Ask for forbearance or modification options.',
      category: 'immediate',
      priority: 'high',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      isCompleted: false,
      sortOrder: 1,
    ),
    ActionTask(
      id: '2',
      assessmentId: '1',
      title: 'Gather Financial Documents',
      description:
          'Collect pay stubs (2 months), bank statements (3 months), tax returns (2 years).',
      category: 'immediate',
      priority: 'high',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      isCompleted: true,
      completedDate: DateTime.now().subtract(const Duration(days: 1)),
      sortOrder: 2,
    ),
    ActionTask(
      id: '3',
      assessmentId: '1',
      title: 'Contact HUD Housing Counselor',
      description: 'Schedule free consultation with HUD-approved counselor in your area.',
      category: 'urgent',
      priority: 'high',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      isCompleted: false,
      sortOrder: 3,
    ),
    ActionTask(
      id: '4',
      assessmentId: '1',
      title: 'Submit Loan Modification Application',
      description: 'Complete and submit full application package to lender.',
      category: 'urgent',
      priority: 'high',
      dueDate: DateTime.now().add(const Duration(days: 10)),
      isCompleted: false,
      sortOrder: 4,
    ),
    ActionTask(
      id: '5',
      assessmentId: '1',
      title: 'Consult with Attorney',
      description: 'Free consultation with foreclosure defense attorney.',
      category: 'important',
      priority: 'medium',
      dueDate: DateTime.now().add(const Duration(days: 7)),
      isCompleted: false,
      sortOrder: 5,
    ),
    ActionTask(
      id: '6',
      assessmentId: '1',
      title: 'Review and Cut Monthly Expenses',
      description: 'Analyze budget and identify \$700 in monthly savings.',
      category: 'important',
      priority: 'medium',
      dueDate: DateTime.now().add(const Duration(days: 14)),
      isCompleted: false,
      sortOrder: 6,
    ),
  ];

  // Mock Documents
  static final List<Document> mockDocuments = [
    Document(
      id: '1',
      userId: '1',
      assessmentId: '1',
      title: 'Hardship Letter - Draft',
      documentType: 'generated',
      fileType: 'docx',
      fileSizeBytes: 15360,
      uploadedDate: DateTime.now().subtract(const Duration(days: 2)),
      letterType: 'hardship',
      generatedContent: 'Dear Loan Servicer...',
    ),
    Document(
      id: '2',
      userId: '1',
      assessmentId: '1',
      title: 'Loan Modification Request Letter',
      documentType: 'generated',
      fileType: 'docx',
      fileSizeBytes: 18432,
      uploadedDate: DateTime.now().subtract(const Duration(days: 1)),
      letterType: 'loan_modification',
      generatedContent: 'To Whom It May Concern...',
    ),
    Document(
      id: '3',
      userId: '1',
      title: 'Foreclosure Notice',
      documentType: 'uploaded',
      fileType: 'pdf',
      fileSizeBytes: 524288,
      uploadedDate: DateTime.now().subtract(const Duration(days: 30)),
      fileUrl: 'https://example.com/foreclosure-notice.pdf',
    ),
    Document(
      id: '4',
      userId: '1',
      title: 'Pay Stub - November 2025',
      documentType: 'uploaded',
      fileType: 'pdf',
      fileSizeBytes: 102400,
      uploadedDate: DateTime.now().subtract(const Duration(days: 5)),
      fileUrl: 'https://example.com/paystub-nov.pdf',
    ),
  ];

  // Mock Notifications
  static final List<Notification> mockNotifications = [
    Notification(
      id: '1',
      userId: '1',
      title: 'Auction Alert: 45 Days Remaining',
      message:
          'Your property auction is scheduled in 45 days. Take immediate action to protect your home.',
      type: 'alert',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      relatedAssessmentId: '1',
    ),
    Notification(
      id: '2',
      userId: '1',
      title: 'Task Reminder: Call Lender',
      message:
          'High priority task due tomorrow: Contact First National Bank loss mitigation department.',
      type: 'reminder',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      isRead: false,
      relatedAssessmentId: '1',
    ),
    Notification(
      id: '3',
      userId: '1',
      title: 'Action Plan Generated',
      message: 'Your 30-day and 60-day action plans are ready to view.',
      type: 'success',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
      readAt: DateTime.now().subtract(const Duration(days: 4)),
      relatedAssessmentId: '1',
    ),
    Notification(
      id: '4',
      userId: '1',
      title: 'Document Ready: Hardship Letter',
      message: 'Your AI-generated hardship letter is ready for review and download.',
      type: 'info',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      readAt: DateTime.now().subtract(const Duration(days: 2)),
      relatedAssessmentId: '1',
    ),
  ];

  // Helper method to get uncompleted tasks count
  static int getUncompletedTasksCount() {
    return mockTasks.where((task) => !task.isCompleted).length;
  }

  // Helper method to get unread notifications count
  static int getUnreadNotificationsCount() {
    return mockNotifications.where((notif) => !notif.isRead).length;
  }

  // Helper to get tasks by category
  static List<ActionTask> getTasksByCategory(String category) {
    return mockTasks.where((task) => task.category == category && !task.isCompleted).toList();
  }
}
