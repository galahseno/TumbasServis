/// Raw `bookings` box rows for tracking data tests.
Map<String, dynamic> rawUnit(
  String code,
  String status, {
  String? mechanicId,
  String motorId = 'motor_001',
}) => {
  'unit_code': code,
  'motor_id': motorId,
  'motor_snapshot': {
    'id': motorId,
    'owner_id': 'user_001',
    'nickname': 'Vario 125',
    'plate_number': 'AB 1234 XY',
    'year': 2022,
    'model_id': 'model_vario125',
  },
  'service_ids': ['svc_berkala'],
  'part_ids': <String>[],
  'status': status,
  'status_history': [
    {'status': status, 'timestamp': DateTime(2026, 9, 20, 9).toIso8601String()},
  ],
  'mechanic_id': ?mechanicId,
  'subtotal': 85000,
  'duration_min': 30,
};

Map<String, dynamic> rawBooking(
  String id,
  List<Map<String, dynamic>> units, {
  String status = 'terjadwal',
}) => {
  'id': id,
  'code': 'TS-260929-0001',
  'user_id': 'user_001',
  'workshop_id': 'ws_001',
  'units': units,
  'schedule_mode': 'shared',
  'shared_slot': {
    'date': DateTime(2026, 9, 29).toIso8601String(),
    'hour': 9,
    'capacity': 5,
    'booked': 1,
  },
  'status': status,
  'subtotal': 85000,
  'discount': 0,
  'total': 85000,
  'created_at': DateTime(2026, 9, 20, 9).toIso8601String(),
  'completed_at': null,
};
