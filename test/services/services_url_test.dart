import 'package:flutter_test/flutter_test.dart';
import 'package:pro_services/models/solicitud_abierta.dart';
import 'package:pro_services/models/pago.dart';
import 'package:pro_services/models/hito_servicio.dart';
import 'package:pro_services/models/foto_proyecto.dart';
import 'package:pro_services/models/busqueda_resultado.dart';
import 'package:pro_services/models/servicio_recurrente.dart';
import 'package:pro_services/models/slot_disponible.dart';
import 'package:pro_services/models/portfolio_item.dart';
import 'package:pro_services/models/perfil_cliente_publico.dart';
import 'package:pro_services/models/estadistica_precio.dart';

/// Estos tests verifican que cada modelo parsea correctamente el payload
/// que la API realmente devolveria segun la URL documentada en cada service.
///
/// Service URLs verificadas manualmente (todas con _base = 'http://localhost:5099'):
///
/// | Service                    | Endpoints                                                |
/// |----------------------------|----------------------------------------------------------|
/// | SolicitudAbiertaService    | /solicitudes-abiertas, /solicitudes-abiertas/mis,        |
/// |                            | /solicitudes-abiertas/disponibles,                       |
/// |                            | /solicitudes-abiertas/{id}/cerrar                        |
/// | PagoService                | /pagos/iniciar, /pagos/{id}/liberar,                     |
/// |                            | /pagos/{id}/reembolsar, /pagos/mis, /pagos/mis-cobros    |
/// | HitoService                | /proyectos/{id}/hitos                                    |
/// | FotoProyectoService        | /proyectos/{id}/fotos, /proyectos/{id}/fotos?tipo=X      |
/// | BusquedaService            | /profesionales/buscar?query=X&...                        |
/// | ServicioRecurrenteService  | /servicios-recurrentes/mis, /servicios-recurrentes/       |
/// |                            | mis-asignados, /servicios-recurrentes/{id}/pausar,       |
/// |                            | /servicios-recurrentes/{id}/cancelar                     |
/// | DisponibilidadService      | /api/HorarioProfesional/{id}/disponibilidad?mes=YYYY-MM  |
/// | PortfolioService           | /profesionales/{id}/portfolio                            |
/// | PerfilClienteService       | /clientes/{id}/perfil-publico                            |
/// | EstadisticasService        | /estadisticas/precio-promedio?tipoProfesionId=X          |

void main() {
  // ─────────────────────────────────────────────────────────────────────────
  // Smoke test: cada modelo parsea un payload realista de su endpoint
  // ─────────────────────────────────────────────────────────────────────────
  group('Smoke: modelo parsea payload realista del endpoint', () {
    test('SolicitudAbierta <- /solicitudes-abiertas/disponibles', () {
      // Respuesta tipica: lista con un item
      final apiItem = <String, dynamic>{
        'id': 1,
        'idUsuario': 10,
        'idTipoProfesion': 2,
        'titulo': 'Pintar fachada',
        'descripcion': 'Pintura exterior de casa de 2 pisos',
        'presupuestoMax': 800.0,
        'ubicacion': 'Surco, Lima',
        'fechaLimite': '2025-07-01T00:00:00',
        'esUrgente': false,
        'estadoSolicitud': 'Abierta',
        'fecha': '2025-06-01T10:00:00',
        'nombreUsuario': 'Pedro Suarez',
        'nombreTipoProfesion': 'Pintor',
      };

      final modelo = SolicitudAbierta.fromJson(apiItem);

      expect(modelo.id, 1);
      expect(modelo.titulo, isNotEmpty);
      expect(modelo.estadoSolicitud, 'abierta');
      expect(modelo.fechaLimite, isNotNull);
    });

    test('Pago <- /pagos/mis (lista de pagos del cliente)', () {
      final apiItem = <String, dynamic>{
        'id': 50,
        'idUsuario': 10,
        'idProfesional': 20,
        'monto': 350.00,
        'moneda': 'PEN',
        'estadoPago': 'Capturado',
        'metodoPago': 'Culqi',
        'fechaCaptura': '2025-06-01T14:00:00',
        'fechaLiberacion': null,
        'fechaCreacion': '2025-06-01T13:55:00',
      };

      final modelo = Pago.fromJson(apiItem);

      expect(modelo.monto, 350.00);
      expect(modelo.estadoPago, 'capturado');
      expect(modelo.fechaLiberacion, isNull);
      expect(modelo.fecha, isNotEmpty);
    });

    test('HitoServicio <- /proyectos/{id}/hitos', () {
      final apiItem = <String, dynamic>{
        'id': 5,
        'idProyecto': 30,
        'hito': 'Material entregado',
        'descripcion': 'Se entrego todo el material de pintura',
        'fechaHito': '2025-06-05T09:30:00',
      };

      final modelo = HitoServicio.fromJson(apiItem);

      expect(modelo.hito, 'Material entregado');
      expect(modelo.descripcion, isNotNull);
      expect(modelo.fechaHito, contains('/'));
    });

    test('FotoProyecto <- /proyectos/{id}/fotos', () {
      final apiItem = <String, dynamic>{
        'id': 12,
        'url': 'https://storage.example.com/proyecto30/foto1.jpg',
        'fechaCreacion': '2025-06-05',
        'tipoFoto': 'antes',
        'descripcion': 'Estado inicial de la fachada',
      };

      final modelo = FotoProyecto.fromJson(apiItem);

      expect(modelo.url, contains('foto1.jpg'));
      expect(modelo.tipoFoto, 'antes');
      expect(modelo.fecha, '2025-06-05');
    });

    test('BusquedaResultado <- /profesionales/buscar', () {
      final apiItem = <String, dynamic>{
        'id': 25,
        'nombre': 'Luis Mendoza',
        'especialidad': 'Plomero',
        'calificacion': 4.5,
        'precioPorHora': 50.0,
        'disponibleAhora': true,
        'ubicacion': 'La Molina, Lima',
        'distanciaKm': 4.1,
        'nivelVerificacion': 2,
        'esVerificado': true,
      };

      final modelo = BusquedaResultado.fromJson(apiItem);

      expect(modelo.disponibleAhora, true);
      expect(modelo.esVerificado, true);
      expect(modelo.distanciaKm, isNotNull);
      expect(modelo.distanciaKm, greaterThan(0));
    });

    test('ServicioRecurrente <- /servicios-recurrentes/mis', () {
      final apiItem = <String, dynamic>{
        'id': 8,
        'idUsuario': 10,
        'idProfesional': 15,
        'idTipoServicio': 3,
        'descripcion': 'Limpieza quincenal de jardin',
        'frecuencia': 'quincenal',
        'diaSemana': 6,
        'horaInicio': '08:00',
        'fechaInicio': '2025-03-01',
        'fechaFin': null,
        'estadoRecurrente': 'activo',
        'proximaEjecucion': '2025-06-14',
      };

      final modelo = ServicioRecurrente.fromJson(apiItem);

      expect(modelo.frecuencia, 'quincenal');
      expect(modelo.estadoRecurrente, 'activo');
      expect(modelo.fechaFin, isNull);
      expect(modelo.proximaEjecucion, isNotNull);
    });

    test(
        'SlotDisponible <- /api/HorarioProfesional/{id}/disponibilidad',
        () {
      final apiItem = <String, dynamic>{
        'fecha': '2025-06-16',
        'diaSemana': 1,
        'horaInicio': '09:00',
        'horaFin': '10:00',
        'disponible': true,
      };

      final modelo = SlotDisponible.fromJson(apiItem);

      expect(modelo.disponible, true);
      expect(modelo.horaInicio, '09:00');
      expect(modelo.horaFin, '10:00');
    });

    test('PortfolioItem <- /profesionales/{id}/portfolio', () {
      final apiItem = <String, dynamic>{
        'idProyecto': 45,
        'nombreProyecto': 'Instalacion electrica completa',
        'fechaCompletado': '2025-04-15',
        'fotoUrls': [
          'https://storage.example.com/p45/1.jpg',
          'https://storage.example.com/p45/2.jpg',
        ],
      };

      final modelo = PortfolioItem.fromJson(apiItem);

      expect(modelo.nombreProyecto, contains('electrica'));
      expect(modelo.fotoUrls, hasLength(2));
      expect(modelo.fotoUrls.every((url) => url.startsWith('https://')), true);
    });

    test('PerfilClientePublico <- /clientes/{id}/perfil-publico', () {
      final apiItem = <String, dynamic>{
        'id': 10,
        'nombre': 'Maria Elena Gutierrez',
        'proyectosCompletados': 7,
        'calificacionPromedio': 4.8,
        'totalResenasRecibidas': 5,
        'miembroDesde': '2024-06-20T00:00:00',
      };

      final modelo = PerfilClientePublico.fromJson(apiItem);

      expect(modelo.nombre, contains('Gutierrez'));
      expect(modelo.proyectosCompletados, greaterThan(0));
      expect(modelo.calificacionPromedio, greaterThanOrEqualTo(0));
      expect(modelo.calificacionPromedio, lessThanOrEqualTo(5));
    });

    test('EstadisticaPrecio <- /estadisticas/precio-promedio', () {
      final apiItem = <String, dynamic>{
        'min': 20.0,
        'max': 180.0,
        'promedio': 72.3,
        'cantidadMuestras': 35,
      };

      final modelo = EstadisticaPrecio.fromJson(apiItem);

      expect(modelo.min, lessThan(modelo.max));
      expect(modelo.promedio, greaterThanOrEqualTo(modelo.min));
      expect(modelo.promedio, lessThanOrEqualTo(modelo.max));
      expect(modelo.cantidadMuestras, greaterThan(0));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Edge cases: la API devuelve un body vacio o parcial
  // ─────────────────────────────────────────────────────────────────────────
  group('Edge: API devuelve payload parcial o vacio', () {
    test('SolicitudAbierta con solo id sobrevive', () {
      final modelo = SolicitudAbierta.fromJson(<String, dynamic>{'id': 1});
      expect(modelo.titulo, '');
      expect(modelo.estadoSolicitud, 'abierta');
    });

    test('Pago con solo id sobrevive', () {
      final modelo = Pago.fromJson(<String, dynamic>{'id': 1});
      expect(modelo.moneda, 'PEN');
      expect(modelo.monto, 0.0);
    });

    test('HitoServicio con json vacio sobrevive', () {
      final modelo = HitoServicio.fromJson(<String, dynamic>{});
      expect(modelo.id, 0);
      expect(modelo.fechaHito, '');
    });

    test('FotoProyecto con json vacio sobrevive', () {
      final modelo = FotoProyecto.fromJson(<String, dynamic>{});
      expect(modelo.tipoFoto, 'durante');
    });

    test('BusquedaResultado con solo id sobrevive', () {
      final modelo = BusquedaResultado.fromJson(<String, dynamic>{'id': 1});
      expect(modelo.calificacion, 0.0);
      expect(modelo.disponibleAhora, false);
    });

    test('ServicioRecurrente con json vacio sobrevive', () {
      final modelo = ServicioRecurrente.fromJson(<String, dynamic>{});
      expect(modelo.estadoRecurrente, 'activo');
    });

    test('SlotDisponible con json vacio sobrevive', () {
      final modelo = SlotDisponible.fromJson(<String, dynamic>{});
      expect(modelo.disponible, false);
    });

    test('PortfolioItem con json vacio sobrevive', () {
      final modelo = PortfolioItem.fromJson(<String, dynamic>{});
      expect(modelo.fotoUrls, isEmpty);
    });

    test('PerfilClientePublico con json vacio sobrevive', () {
      final modelo = PerfilClientePublico.fromJson(<String, dynamic>{});
      expect(modelo.calificacionPromedio, 0.0);
    });

    test('EstadisticaPrecio con json vacio sobrevive', () {
      final modelo = EstadisticaPrecio.fromJson(<String, dynamic>{});
      expect(modelo.cantidadMuestras, 0);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Consistencia: listas de modelos se parsean desde array JSON
  // ─────────────────────────────────────────────────────────────────────────
  group('Consistencia: parseo de listas (como haria un service)', () {
    test('Lista de SolicitudAbierta', () {
      final apiResponse = [
        {'id': 1, 'titulo': 'Solicitud A'},
        {'id': 2, 'titulo': 'Solicitud B'},
        {'id': 3, 'titulo': 'Solicitud C'},
      ];

      final lista = apiResponse
          .map((e) => SolicitudAbierta.fromJson(e as Map<String, dynamic>))
          .toList();

      expect(lista, hasLength(3));
      expect(lista[0].id, 1);
      expect(lista[1].titulo, 'Solicitud B');
      expect(lista[2].id, 3);
    });

    test('Lista de Pago', () {
      final apiResponse = [
        {'id': 10, 'monto': 100.0, 'moneda': 'PEN'},
        {'id': 11, 'monto': 200.0, 'moneda': 'USD'},
      ];

      final lista = apiResponse
          .map((e) => Pago.fromJson(e as Map<String, dynamic>))
          .toList();

      expect(lista, hasLength(2));
      expect(lista[0].monto, 100.0);
      expect(lista[1].moneda, 'USD');
    });

    test('Lista vacia devuelve lista vacia', () {
      final apiResponse = <Map<String, dynamic>>[];

      final lista = apiResponse
          .map((e) => SlotDisponible.fromJson(e))
          .toList();

      expect(lista, isEmpty);
    });
  });
}
