enum Maps {
  west0,
  west1,
  west2;

  factory Maps.fromName(String name) {
    return Maps.values.firstWhere(
      (e) => e.name == name,
      orElse: () => Maps.west0,
    );
  }
}
