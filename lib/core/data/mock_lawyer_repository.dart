import 'dart:math';

import '../domain/case_category.dart';
import '../domain/entities.dart';

class MockLawyerRepository {
  final _rng = Random(42);

  List<Lawyer> getAll() {
    return [
      Lawyer(
        id: 'L1',
        name: 'Adv. Ananya Sharma',
        expertise: const [CaseCategory.family, CaseCategory.civil],
        years: 7,
        fee: 1500,
        rating: 4.6,
        location: 'Delhi',
        about:
            'Specializes in family disputes and civil litigation with a mediation-first approach.',
      ),
      Lawyer(
        id: 'L2',
        name: 'Adv. Rohan Mehta',
        expertise: const [CaseCategory.criminal],
        years: 11,
        fee: 2500,
        rating: 4.2,
        location: 'Mumbai',
        about:
            'Experienced in criminal defense with a strong track record in trial courts.',
      ),
      Lawyer(
        id: 'L3',
        name: 'Adv. Priya Nair',
        expertise: const [CaseCategory.property, CaseCategory.civil],
        years: 9,
        fee: 1800,
        rating: 4.5,
        location: 'Bengaluru',
        about:
            'Property disputes and civil contracts; known for clear documentation and strategy.',
      ),
      Lawyer(
        id: 'L4',
        name: 'Adv. Arjun Singh',
        expertise: const [CaseCategory.criminal, CaseCategory.property],
        years: 5,
        fee: 1200,
        rating: 4.0,
        location: 'Delhi',
        about:
            'Criminal and property matters; pragmatic and budget-conscious solutions.',
      ),
      Lawyer(
        id: 'L5',
        name: 'Adv. Kavya Rao',
        expertise: const [CaseCategory.family],
        years: 6,
        fee: 1000,
        rating: 4.7,
        location: 'Hyderabad',
        about:
            'Family law with empathetic counseling and efficient settlements.',
      ),
    ];
  }

  /// Simple scoring based on expertise match, budget fit proximity, location, rating, and experience.
  List<(Lawyer, double)> match(ClientCase c) {
    final lawyers = getAll();
    return lawyers.map((l) => (l, _score(l, c))).toList()
      ..sort((a, b) => b.$2.compareTo(a.$2));
  }

  double _score(Lawyer l, ClientCase c) {
    double s = 0;
    // Expertise match
    if (c.predictedCategory != null &&
        l.expertise.contains(c.predictedCategory)) {
      s += 50;
    }
    // Budget proximity: closer fee to budget is better
    final diff = (c.budget - l.fee).abs();
    s += (25 * (1 / (1 + diff / (c.budget == 0 ? 1 : c.budget))));
    // Location match
    if (l.location.toLowerCase() == c.location.toLowerCase()) s += 10;
    // Rating and experience
    s += l.rating * 2; // up to +10
    s += (l.years.clamp(0, 15)) * 0.5; // up to +7.5
    // small random jitter for demo variety
    s += _rng.nextDouble() * 3;
    return s;
  }
}
