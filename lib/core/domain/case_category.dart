enum CaseCategory { criminal, civil, family, property }

extension CaseCategoryX on CaseCategory {
  String get label => switch (this) {
    CaseCategory.criminal => 'Criminal',
    CaseCategory.civil => 'Civil',
    CaseCategory.family => 'Family',
    CaseCategory.property => 'Property',
  };
}
