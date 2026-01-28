import '/data/models/api_response.dart';

// ===============================
// FAQ ITEM MODEL
// ===============================
class FaqItem {
  final String id;
  final String question;
  final String answer;
  final String category;
  final int order;

  FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    required this.order,
  });

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      category: json['category'] as String,
      order: json['order'] as int,
    );
  }
}

// ===============================
// SUPPORT TICKET MODEL
// ===============================
class SupportTicket {
  final String id;
  final String subject;
  final String category;
  final String priority;
  final String status;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TicketMessage>? messages;

  SupportTicket({
    required this.id,
    required this.subject,
    required this.category,
    required this.priority,
    required this.status,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    this.messages,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'] as String,
      subject: json['subject'] as String,
      category: json['category'] as String,
      priority: json['priority'] as String,
      status: json['status'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      messages: json['messages'] != null
          ? (json['messages'] as List)
                .map((e) => TicketMessage.fromJson(e as Map<String, dynamic>))
                .toList()
          : null,
    );
  }
}

// ===============================
// TICKET MESSAGE MODEL
// ===============================
class TicketMessage {
  final String id;
  final String message;
  final String senderType;
  final String? senderName;
  final DateTime createdAt;

  TicketMessage({
    required this.id,
    required this.message,
    required this.senderType,
    this.senderName,
    required this.createdAt,
  });

  factory TicketMessage.fromJson(Map<String, dynamic> json) {
    return TicketMessage(
      id: json['id'] as String,
      message: json['message'] as String,
      senderType: json['senderType'] as String,
      senderName: json['senderName'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

// ===============================
// REQUEST MODELS
// ===============================

class CreateTicketRequest {
  final String subject;
  final String category;
  final String priority;
  final String description;

  CreateTicketRequest({
    required this.subject,
    required this.category,
    required this.priority,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'category': category,
      'priority': priority,
      'description': description,
    };
  }
}

class AddTicketMessageRequest {
  final String message;

  AddTicketMessageRequest({required this.message});

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}

class ContactUsRequest {
  final String name;
  final String email;
  final String subject;
  final String message;

  ContactUsRequest({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'subject': subject, 'message': message};
  }
}

// ===============================
// RESPONSE MODELS
// ===============================

class FaqListResponse {
  final List<FaqItem> faqs;
  final List<String> categories;

  FaqListResponse({required this.faqs, required this.categories});

  factory FaqListResponse.fromJson(Map<String, dynamic> json) {
    return FaqListResponse(
      faqs: (json['faqs'] as List).map((e) => FaqItem.fromJson(e as Map<String, dynamic>)).toList(),
      categories: (json['categories'] as List).map((e) => e as String).toList(),
    );
  }
}

class TicketResponse {
  final SupportTicket ticket;

  TicketResponse({required this.ticket});

  factory TicketResponse.fromJson(Map<String, dynamic> json) {
    return TicketResponse(ticket: SupportTicket.fromJson(json));
  }
}

class TicketsListResponse {
  final List<SupportTicket> tickets;
  final Pagination pagination;

  TicketsListResponse({required this.tickets, required this.pagination});

  factory TicketsListResponse.fromJson(Map<String, dynamic> json) {
    return TicketsListResponse(
      tickets: (json['tickets'] as List)
          .map((e) => SupportTicket.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class TicketMessageResponse {
  final TicketMessage message;

  TicketMessageResponse({required this.message});

  factory TicketMessageResponse.fromJson(Map<String, dynamic> json) {
    return TicketMessageResponse(message: TicketMessage.fromJson(json));
  }
}

class ContactUsResponse {
  final String ticketId;
  final String status;

  ContactUsResponse({required this.ticketId, required this.status});

  factory ContactUsResponse.fromJson(Map<String, dynamic> json) {
    return ContactUsResponse(
      ticketId: json['ticketId'] as String,
      status: json['status'] as String,
    );
  }
}
