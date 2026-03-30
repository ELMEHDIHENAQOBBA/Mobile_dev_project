import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/features/booking/domain/entities/booking_entity.dart';
import 'package:flutter_clean_architecture/features/auth/providers/auth_providers.dart';
import 'package:flutter_clean_architecture/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReviewPage extends ConsumerStatefulWidget {
  final BookingEntity booking;
  const ReviewPage({super.key, required this.booking});

  @override
  ConsumerState<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<ReviewPage> {
  int _rating = 5;
  final _commentCtrl = TextEditingController();
  bool _loading = false;
  bool _submitted = false;

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      final ds = ref.read(reviewDataSourceProvider);
      await ds.createReview(
        bookingId: widget.booking.id,
        guideId: widget.booking.guideId,
        rating: _rating,
        comment: _commentCtrl.text.isEmpty ? null : _commentCtrl.text,
      );
      setState(() { _loading = false; _submitted = true; });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF2E86C1);
    return Scaffold(
      appBar: AppBar(title: const Text('Leave a Review'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _submitted ? _buildSuccess() : _buildForm(color),
      ),
    );
  }

  Widget _buildForm(Color color) {
    return Column(children: [
      // Guide info
      CircleAvatar(radius: 48, backgroundImage: widget.booking.guideProfileImage.isNotEmpty
          ? NetworkImage(widget.booking.guideProfileImage) : null,
        child: widget.booking.guideProfileImage.isEmpty ? const Icon(Icons.person, size: 48) : null),
      const SizedBox(height: 12),
      Text(widget.booking.guideName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      Text(widget.booking.guideCity, style: const TextStyle(color: Colors.grey)),
      const SizedBox(height: 32),

      const Text('How was your experience?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 16),

      // Stars
      Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(5, (i) {
        final n = i + 1;
        return GestureDetector(
          onTap: () => setState(() => _rating = n),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              n <= _rating ? Icons.star_rounded : Icons.star_border_rounded,
              color: Colors.amber, size: 48,
            ),
          ),
        );
      })),
      const SizedBox(height: 8),
      Text(_ratingLabel(), style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w600)),
      const SizedBox(height: 32),

      TextFormField(
        controller: _commentCtrl,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: 'Share your experience with this guide...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          labelText: 'Your review (optional)',
        ),
      ),
      const SizedBox(height: 32),

      SizedBox(
        width: double.infinity, height: 56,
        child: ElevatedButton(
          onPressed: _loading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: color, foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: _loading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Submit Review', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    ]);
  }

  Widget _buildSuccess() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(height: 60),
      Container(
        width: 100, height: 100,
        decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
        child: const Icon(Icons.star_rounded, color: Colors.white, size: 60),
      ),
      const SizedBox(height: 24),
      const Text('Review Submitted!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Text('You gave $_rating/5 stars to ${widget.booking.guideName}',
          textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 16)),
      const SizedBox(height: 40),
      SizedBox(
        width: double.infinity, height: 56,
        child: ElevatedButton(
          onPressed: () => context.go(Routes.myBookings),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E86C1), foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text('Back to My Bookings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    ]);
  }

  String _ratingLabel() => switch (_rating) {
    1 => 'Poor', 2 => 'Fair', 3 => 'Good', 4 => 'Very Good', 5 => 'Excellent!', _ => '',
  };
}
