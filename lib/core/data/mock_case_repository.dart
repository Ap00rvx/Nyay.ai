import 'package:nyay/core/domain/case_category.dart';
import 'package:nyay/core/domain/entities.dart';

class MockCaseRepository {
  List<ClientCase> fetchCases() {
    return [
      ClientCase(
        id: 'C-1001',
        description:
            'Boundary dispute over inherited land near Connaught Place.',
        budget: 2000,
        location: 'Delhi',
        predictedCategory: CaseCategory.property,
        assignedLawyerId: 'L3',
        updates: [
          CaseUpdate(
            DateTime.now().subtract(const Duration(days: 5)),
            'Case created and documents uploaded.',
          ),
          CaseUpdate(
            DateTime.now().subtract(const Duration(days: 3)),
            'Initial consultation scheduled.',
          ),
          CaseUpdate(
            DateTime.now().subtract(const Duration(days: 1)),
            'Notice drafted for the opposite party.',
          ),
        ],
      ),
      ClientCase(
        id: 'C-1002',
        description: 'Mutual consent divorce consultation and paperwork.',
        budget: 1500,
        location: 'Bengaluru',
        predictedCategory: CaseCategory.family,
        assignedLawyerId: 'L5',
        updates: [
          CaseUpdate(
            DateTime.now().subtract(const Duration(days: 10)),
            'Case created.',
          ),
          CaseUpdate(
            DateTime.now().subtract(const Duration(days: 7)),
            'Mediation session booked.',
          ),
        ],
      ),
      ClientCase(
        id: 'C-1003',
        description: 'Cheque bounce criminal complaint under Section 138.',
        budget: 1200,
        location: 'Mumbai',
        predictedCategory: CaseCategory.criminal,
        assignedLawyerId: 'L2',
        updates: [
          CaseUpdate(
            DateTime.now().subtract(const Duration(days: 14)),
            'FIR copy collected.',
          ),
        ],
      ),
    ];
  }
}
