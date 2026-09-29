import 'package:tumbas_servis/core/domain/model/garage/motor_model.dart';

String motorBrandLabel(MotorBrand brand) => switch (brand) {
  MotorBrand.honda => 'Honda',
  MotorBrand.yamaha => 'Yamaha',
  MotorBrand.suzuki => 'Suzuki',
  MotorBrand.kawasaki => 'Kawasaki',
  MotorBrand.unknown => 'Lainnya',
};

String motorCategoryLabel(MotorCategory category) => switch (category) {
  MotorCategory.matic => 'Matic',
  MotorCategory.bebek => 'Bebek',
  MotorCategory.sport => 'Sport',
  MotorCategory.unknown => 'Motor',
};

String modelDisplayName(MotorModel model) =>
    '${motorBrandLabel(model.brand)} ${model.name}';

const pickerBrands = [MotorBrand.honda, MotorBrand.yamaha, MotorBrand.suzuki];
