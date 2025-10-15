// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Mi Aplicación';

  @override
  String get welcome => 'Bienvenido';

  @override
  String hello(String name) {
    return 'Hola, $name';
  }

  @override
  String counter(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString elementos',
      one: '1 elemento',
      zero: 'Sin elementos',
    );
    return '$_temp0';
  }

  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get signUp => 'Registrarse';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get settings => 'Configuración';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get lightMode => 'Modo Claro';

  @override
  String get systemMode => 'Modo del Sistema';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get notificationSent => 'Notificación enviada';

  @override
  String get enableNotifications => 'Activar Notificaciones';

  @override
  String get receiveNotifications => 'Recibir notificaciones push';

  @override
  String get sendTestNotification => 'Enviar Notificación de Prueba';

  @override
  String get deviceToken => 'Token del Dispositivo';

  @override
  String get loading => 'Cargando...';

  @override
  String get notAvailable => 'No disponible';
}
