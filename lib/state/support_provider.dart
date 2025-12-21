import 'package:flutter/foundation.dart';
import '../data/models/api_response.dart';
import '../data/models/support_models.dart';
import '../repo/support_repository.dart';

enum SupportState { idle, loading, success, error }

class SupportProvider extends ChangeNotifier {
  final SupportRepository _supportRepository = SupportRepository();

  SupportState _state = SupportState.idle;
  List<FaqItem> _faqItems = [];
  List<String> _faqCategories = [];
  List<SupportTicket> _tickets = [];
  SupportTicket? _currentTicket;
  String? _errorMessage;

  // Getters
  SupportState get state => _state;
  List<FaqItem> get faqItems => _faqItems;
  List<String> get faqCategories => _faqCategories;
  List<SupportTicket> get tickets => _tickets;
  SupportTicket? get currentTicket => _currentTicket;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == SupportState.loading;
  bool get hasError => _state == SupportState.error;
  bool get hasFaq => _faqItems.isNotEmpty;
  bool get hasTickets => _tickets.isNotEmpty;

  // Computed getters
  List<SupportTicket> get openTickets =>
      _tickets.where((t) => t.status == 'OPEN' || t.status == 'IN_PROGRESS').toList();
  List<SupportTicket> get closedTickets =>
      _tickets.where((t) => t.status == 'CLOSED' || t.status == 'RESOLVED').toList();

  // Get FAQ
  Future<bool> getFaq() async {
    _setState(SupportState.loading);
    _errorMessage = null;

    try {
      final response = await _supportRepository.getFaq();

      if (response.success && response.data != null) {
        _faqItems = response.data!.faqs;
        _faqCategories = response.data!.categories;
        _setState(SupportState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to fetch FAQ';
        _setState(SupportState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(SupportState.error);
      return false;
    }
  }

  // Create Support Ticket
  Future<SupportTicket?> createTicket(CreateTicketRequest request) async {
    _setState(SupportState.loading);
    _errorMessage = null;

    try {
      final response = await _supportRepository.createTicket(request);

      if (response.success && response.data != null) {
        final newTicket = response.data!.ticket;
        _tickets.insert(0, newTicket);
        _currentTicket = newTicket;
        _setState(SupportState.success);
        return newTicket;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to create ticket';
        _setState(SupportState.error);
        return null;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(SupportState.error);
      return null;
    }
  }

  // Get User Tickets
  Future<bool> getUserTickets({int page = 1, int limit = 20, String? status}) async {
    _setState(SupportState.loading);
    _errorMessage = null;

    try {
      final response = await _supportRepository.getUserTickets(
        page: page,
        limit: limit,
        status: status,
      );

      if (response.success && response.data != null) {
        if (page == 1) {
          _tickets = response.data!.tickets;
        } else {
          _tickets.addAll(response.data!.tickets);
        }
        _setState(SupportState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to fetch tickets';
        _setState(SupportState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(SupportState.error);
      return false;
    }
  }

  // Get Ticket by ID
  Future<bool> getTicketById(String ticketId) async {
    _setState(SupportState.loading);
    _errorMessage = null;

    try {
      final response = await _supportRepository.getTicketById(ticketId);

      if (response.success && response.data != null) {
        _currentTicket = response.data!.ticket;

        // Update in list if exists
        final index = _tickets.indexWhere((t) => t.id == ticketId);
        if (index != -1) {
          _tickets[index] = _currentTicket!;
        }

        _setState(SupportState.success);
        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to fetch ticket';
        _setState(SupportState.error);
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(SupportState.error);
      return false;
    }
  }

  // Add Message to Ticket
  Future<bool> addTicketMessage({required String ticketId, required String message}) async {
    _errorMessage = null;

    try {
      final response = await _supportRepository.addTicketMessage(
        ticketId: ticketId,
        request: AddTicketMessageRequest(message: message),
      );

      if (response.success && response.data != null) {
        final newMessage = response.data!.message;

        // Add message to current ticket
        if (_currentTicket?.id == ticketId) {
          _currentTicket = SupportTicket(
            id: _currentTicket!.id,
            subject: _currentTicket!.subject,
            category: _currentTicket!.category,
            priority: _currentTicket!.priority,
            status: _currentTicket!.status,
            description: _currentTicket!.description,
            createdAt: _currentTicket!.createdAt,
            updatedAt: DateTime.now(),
            messages: [...?_currentTicket!.messages, newMessage],
          );
        }

        // Refresh the ticket to get updated data
        await getTicketById(ticketId);

        return true;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to add message';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }

  // Contact Us (public form)
  Future<String?> contactUs(ContactUsRequest request) async {
    _setState(SupportState.loading);
    _errorMessage = null;

    try {
      final response = await _supportRepository.contactUs(request);

      if (response.success && response.data != null) {
        _setState(SupportState.success);
        return response.data!.ticketId;
      } else {
        _errorMessage = response.error?.message ?? 'Failed to send message';
        _setState(SupportState.error);
        return null;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _setState(SupportState.error);
      return null;
    }
  }

  // Get FAQ by category
  List<FaqItem> getFaqByCategory(String category) {
    return _faqItems.where((f) => f.category == category).toList();
  }

  // Search FAQ
  List<FaqItem> searchFaq(String query) {
    final lowerQuery = query.toLowerCase();
    return _faqItems
        .where(
          (f) =>
              f.question.toLowerCase().contains(lowerQuery) ||
              f.answer.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  // Get tickets by status
  List<SupportTicket> getTicketsByStatus(String status) {
    return _tickets.where((t) => t.status == status).toList();
  }

  // Refresh FAQ (silent)
  Future<void> refreshFaq() async {
    try {
      final response = await _supportRepository.getFaq();
      if (response.success && response.data != null) {
        _faqItems = response.data!.faqs;
        _faqCategories = response.data!.categories;
        notifyListeners();
      }
    } catch (e) {
      // Silent failure
    }
  }

  // Refresh tickets (silent)
  Future<void> refreshTickets() async {
    try {
      final response = await _supportRepository.getUserTickets();
      if (response.success && response.data != null) {
        _tickets = response.data!.tickets;
        notifyListeners();
      }
    } catch (e) {
      // Silent failure
    }
  }

  // Clear data
  void clear() {
    _faqItems = [];
    _faqCategories = [];
    _tickets = [];
    _currentTicket = null;
    _errorMessage = null;
    _setState(SupportState.idle);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    if (_state == SupportState.error) {
      _setState(SupportState.idle);
    }
  }

  // Private helper to set state and notify
  void _setState(SupportState newState) {
    _state = newState;
    notifyListeners();
  }
}
