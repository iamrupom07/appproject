import 'package:flutter/material.dart';

/// Distinguishes between a standard image slide and the special
/// "Search Smarter" slide that renders a live mock search UI.
enum OnboardingPageType {
  /// Standard layout: large hero image card + optional trust badge.
  image,

  /// Special layout: search bar + category chips + machine list cards.
  searchPreview,
}

/// Data model for a single onboarding slide.
class OnboardingPageModel {
  const OnboardingPageModel({
    required this.heading,
    required this.body,
    this.pageType = OnboardingPageType.image,
    this.imageUrl,
    this.showTrustBadge = false,
    this.trustBadgeTitle,
    this.trustBadgeSubtitle,
    this.isLastPage = false,
  });

  final OnboardingPageType pageType;
  final String? imageUrl;
  final String heading;
  final String body;
  final bool showTrustBadge;
  final String? trustBadgeTitle;
  final String? trustBadgeSubtitle;
  final bool isLastPage;
}

/// The full list of onboarding slides.
final List<OnboardingPageModel> onboardingPages = [
  const OnboardingPageModel(
    pageType: OnboardingPageType.image,
    imageUrl:
        'https://images.unsplash.com/photo-1581093804475-577d72e35330?w=800&q=80',
    heading: 'Explore Premium\nMachinery',
    body: 'Find trusted heavy equipment with a\nseamless modern experience.',
    showTrustBadge: true,
    trustBadgeTitle: 'Trusted Sellers',
    trustBadgeSubtitle: 'Verified machinery\nfrom trusted dealers.',
  ),
  const OnboardingPageModel(
    pageType: OnboardingPageType.searchPreview,
    heading: 'Search Smarter',
    body: 'Filter machinery by category,\nprice, and availability instantly.',
    isLastPage: true,
  ),
];
