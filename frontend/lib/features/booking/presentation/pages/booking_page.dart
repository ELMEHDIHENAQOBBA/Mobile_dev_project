import 'package:flutter/material.dart';
import 'package:guideme/features/booking/providers/booking_notifier.dart';
import 'package:guideme/features/booking/providers/booking_providers.dart';
import 'package:guideme/features/guides/domain/entities/guide_entity.dart';
import 'package:guideme/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BookingPage extends ConsumerStatefulWidget {
  final GuideEntity guide;
  const BookingPage({super.key, required this.guide});

  @override
  ConsumerState<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends ConsumerState<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime _visitDate = DateTime.now().add(const Duration(days: 1));
  int _duration = 3;
  int _people = 1;
  final _specialRequestCtrl = TextEditingController();

  double get _totalPrice => widget.guide.priceMin * _duration * _people;

  @override
  void dispose() {
    _specialRequestCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _visitDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _visitDate = picked);
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(bookingNotifierProvider.notifier).createBooking(
            guideId: widget.guide.id,
            visitDate:
                '${_visitDate.year}-${_visitDate.month.toString().padLeft(2, '0')}-${_visitDate.day.toString().padLeft(2, '0')}',
            durationHours: _duration,
            numberOfPeople: _people,
            specialRequest:
                _specialRequestCtrl.text.isEmpty ? null : _specialRequestCtrl.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<BookingState>(bookingNotifierProvider, (prev, next) {
      if (prev?.newBooking == null && next.newBooking != null) {
        ref.read(bookingNotifierProvider.notifier).clearNewBooking();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking created! Waiting for guide confirmation.'),
            backgroundColor: Colors.green,
          ),
        );
        context.go(Routes.myBookings);
      } else if (next.error != null && prev?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
    });

    final loading = ref.watch(bookingNotifierProvider).isLoading;
    final theme = Theme.of(context);
    final color = const Color(0xFF2E86C1);

    return Scaffold(
      appBar: AppBar(title: const Text('Book Guide'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Guide card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Row(children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: widget.guide.profileImage.isNotEmpty
                        ? NetworkImage(widget.guide.profileImage) : null,
                    onBackgroundImageError: widget.guide.profileImage.isNotEmpty
                        ? (_, __) {} : null,
                    child: widget.guide.profileImage.isEmpty
                        ? const Icon(Icons.person, size: 32) : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(widget.guide.name,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(widget.guide.city, style: const TextStyle(color: Colors.grey)),
                    Text('From ${widget.guide.priceMin.round()} MAD/h',
                        style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                  ])),
                ]),
              ),
              const SizedBox(height: 24),

              // Date
              const Text('Visit Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: Row(children: [
                    Icon(Icons.calendar_today_rounded, color: color),
                    const SizedBox(width: 12),
                    Text('${_visitDate.day}/${_visitDate.month}/${_visitDate.year}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ]),
                ),
              ),
              const SizedBox(height: 24),

              // Duration
              const Text('Duration (hours)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(children: [
                IconButton(
                  onPressed: () {
                    if (_duration > 1) setState(() => _duration--);
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                  color: color,
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text('$_duration h',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                )),
                IconButton(
                  onPressed: () {
                    if (_duration < 12) setState(() => _duration++);
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  color: color,
                ),
              ]),
              const SizedBox(height: 24),

              // People
              const Text('Number of people', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(children: [
                IconButton(
                  onPressed: () {
                    if (_people > 1) setState(() => _people--);
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                  color: color,
                ),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text('$_people person${_people > 1 ? 's' : ''}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                )),
                IconButton(
                  onPressed: () {
                    if (_people < 20) setState(() => _people++);
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  color: color,
                ),
              ]),
              const SizedBox(height: 24),

              // Special request
              const Text('Special Request (optional)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _specialRequestCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Any special requirements or preferences...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 32),

              // Total price
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Estimated Total', style: TextStyle(fontSize: 16)),
                  Text('${_totalPrice.round()} MAD',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
                ]),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Confirm Booking',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
