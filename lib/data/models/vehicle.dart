class Vehicle {
  const Vehicle({
    required this.id,
    required this.ownerId,
    required this.make,
    required this.model,
    required this.yearAd,
    required this.plateRoman,
    required this.plateDevanagari,
    this.province,
    this.fuel = 'Petrol',
    this.transmission = 'Manual',
    this.color,
    this.chassisMasked,
    this.engineMasked,
    this.initialOdometer = 0,
    this.photoAsset,
    required this.createdAt,
    this.isSeed = false,
  });

  final String id;
  final String ownerId;
  final String make;
  final String model;
  final int yearAd;
  final String plateRoman;
  final String plateDevanagari;
  final String? province;
  final String fuel;
  final String transmission;
  final String? color;
  final String? chassisMasked;
  final String? engineMasked;
  final int initialOdometer;
  final String? photoAsset;
  final DateTime createdAt;
  final bool isSeed;

  String get displayName => '$make $model';

  Map<String, Object?> toMap() => {
    'id': id,
    'owner_id': ownerId,
    'make': make,
    'model': model,
    'year_ad': yearAd,
    'plate_roman': plateRoman,
    'plate_devanagari': plateDevanagari,
    'province': province,
    'fuel': fuel,
    'transmission': transmission,
    'color': color,
    'chassis_masked': chassisMasked,
    'engine_masked': engineMasked,
    'initial_odometer': initialOdometer,
    'photo_asset': photoAsset,
    'created_at': createdAt.toIso8601String(),
    'is_seed': isSeed ? 1 : 0,
  };

  factory Vehicle.fromMap(Map<String, Object?> map) => Vehicle(
    id: map['id'] as String,
    ownerId: map['owner_id'] as String,
    make: map['make'] as String,
    model: map['model'] as String,
    yearAd: map['year_ad'] as int,
    plateRoman: map['plate_roman'] as String,
    plateDevanagari: map['plate_devanagari'] as String,
    province: map['province'] as String?,
    fuel: map['fuel'] as String? ?? 'Petrol',
    transmission: map['transmission'] as String? ?? 'Manual',
    color: map['color'] as String?,
    chassisMasked: map['chassis_masked'] as String?,
    engineMasked: map['engine_masked'] as String?,
    initialOdometer: map['initial_odometer'] as int? ?? 0,
    photoAsset: map['photo_asset'] as String?,
    createdAt: DateTime.parse(map['created_at'] as String),
    isSeed: (map['is_seed'] as int? ?? 0) == 1,
  );

  Vehicle copyWith({
    String? make,
    String? model,
    int? yearAd,
    String? plateRoman,
    String? plateDevanagari,
    String? province,
    String? fuel,
    String? transmission,
    String? color,
    String? chassisMasked,
    String? engineMasked,
    int? initialOdometer,
    String? photoAsset,
  }) => Vehicle(
    id: id,
    ownerId: ownerId,
    make: make ?? this.make,
    model: model ?? this.model,
    yearAd: yearAd ?? this.yearAd,
    plateRoman: plateRoman ?? this.plateRoman,
    plateDevanagari: plateDevanagari ?? this.plateDevanagari,
    province: province ?? this.province,
    fuel: fuel ?? this.fuel,
    transmission: transmission ?? this.transmission,
    color: color ?? this.color,
    chassisMasked: chassisMasked ?? this.chassisMasked,
    engineMasked: engineMasked ?? this.engineMasked,
    initialOdometer: initialOdometer ?? this.initialOdometer,
    photoAsset: photoAsset ?? this.photoAsset,
    createdAt: createdAt,
    isSeed: isSeed,
  );
}
