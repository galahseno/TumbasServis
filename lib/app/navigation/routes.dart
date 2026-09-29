abstract final class Routes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const otp = '/otp';

  static const home = '/home';
  static const notifications = '/notifications';

  static const garage = '/garage';
  static const garageAdd = '/garage/add';
  static const garageDetailTemplate = '/garage/:id';
  static String garageDetail(String id) => '/garage/$id';

  static const bookingVehicles = '/booking/vehicles';
  static const bookingConfigure = '/booking/configure';
  static const bookingConfigureParts = '/booking/configure/parts';
  static const catalog = '/catalog';
  static const bookingWorkshop = '/booking/workshop';
  static const bookingWorkshopDetailTemplate = '/booking/workshop/:id';
  static String bookingWorkshopDetail(String id) => '/booking/workshop/$id';
  static const workshopDetailTemplate = '/workshops/:id';
  static String workshopDetail(String id) => '/workshops/$id';
  static const bookingSchedule = '/booking/schedule';
  static const bookingSummary = '/booking/summary';
  static const bookingSummaryVoucher = '/booking/summary/voucher';
  static const bookingSuccessTemplate = '/booking/success/:bookingId';
  static String bookingSuccess(String bookingId) =>
      '/booking/success/$bookingId';

  static const bookings = '/bookings';
  static const bookingDetailTemplate = '/bookings/:id';
  static String bookingDetail(String id) => '/bookings/$id';
  static const bookingUnitDetailTemplate = '/bookings/:id/unit/:unitCode';
  static String bookingUnitDetail(String id, String unitCode) =>
      '/bookings/$id/unit/$unitCode';

  static const invoiceTemplate = '/invoice/:bookingId';
  static String invoice(String bookingId) => '/invoice/$bookingId';
  static const reviewTemplate = '/review/:bookingId';
  static String review(String bookingId) => '/review/$bookingId';

  static const profile = '/profile';
  static const profileDemoMode = '/profile/demo-mode';
}
