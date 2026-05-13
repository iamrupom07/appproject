import 'package:flutter/material.dart';

/// Data model for a single onboarding slide.
///
/// All fields are optional so individual slides can opt in/out of
/// the trust badge, the "Get Started" button, etc.
class OnboardingPageModel {
  const OnboardingPageModel({
    required this.imageUrl,
    required this.heading,
    required this.body,
    this.showTrustBadge = false,
    this.trustBadgeTitle,
    this.trustBadgeSubtitle,
    this.isLastPage = false,
  });

  /// Network URL or asset path for the hero image.
  final String imageUrl;

  /// Large heading text.
  final String heading;

  /// Supporting body text.
  final String body;

  /// Whether to show the floating trust-badge card.
  final bool showTrustBadge;
  final String? trustBadgeTitle;
  final String? trustBadgeSubtitle;

  /// Last page gets a "Get Started" button instead of just the arrow.
  final bool isLastPage;
}

/// The full list of onboarding slides.
/// Add, remove, or reorder entries here — the UI adapts automatically.
final List<OnboardingPageModel> onboardingPages = [
  const OnboardingPageModel(
    imageUrl:
        'https://images.unsplash.com/photo-1581093804475-577d72e35330?w=800&q=80',
    heading: 'Explore Premium\nMachinery',
    body: 'Find trusted heavy equipment with a\nseamless modern experience.',
    showTrustBadge: true,
    trustBadgeTitle: 'Trusted Sellers',
    trustBadgeSubtitle: 'Verified machinery\nfrom trusted dealers.',
  ),
  const OnboardingPageModel(
    imageUrl:
        'https://images.unsplash.com/photo-1581093804475-577d72e35330?w=800&q=80',
    heading: 'Search Smarter',
    body: 'Filter machinery by category,\nprice, and availability instantly.',
    isLastPage: true,
  ),
];
