enum Maps {
  west0,
  west1,
  west2,
  west3,
  center0,
  center2;

  factory Maps.fromName(String name) {
    return Maps.values.firstWhere(
      (e) => e.name == name,
      orElse: () => Maps.west0,
    );
  }
}
