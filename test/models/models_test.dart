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

void main() {
  // ─────────────────────────────────────────────────────────────────────────
  // SolicitudAbierta
  // ─────────────────────────────────────────────────────────────────────────
  group('SolicitudAbierta', () {
    test('fromJson con datos completos', () {
      final json = <String, dynamic>{
        'id': 10,
        'idUsuario': 3,
        'idTipoProfesion': 5,
        'titulo': 'Necesito plomero urgente',
        'descripcion': 'Se rompio la caneria del bano',
        'presupuestoMax': 250.0,
        'ubicacion': 'Lima, Peru',
        'fechaLimite': '2025-06-15T00:00:00',
        'esUrgente': true,
        'estadoSolicitud': 'Abierta',
        'fecha': '2025-06-01T10:30:00',
        'nombreUsuario': 'Carlos Lopez',
        'nombreTipoProfesion': 'Plomeria',
      };

      final modelo = SolicitudAbierta.fromJson(json);

      expect(modelo.id, 10);
      expect(modelo.idUsuario, 3);
      expect(modelo.idTipoProfesion, 5);
      expect(modelo.titulo, 'Necesito plomero urgente');
      expect(modelo.descripcion, 'Se rompio la caneria del bano');
      expect(modelo.presupuestoMax, 250.0);
      expect(modelo.ubicacion, 'Lima, Peru');
      expect(modelo.fechaLimite, '15/06/2025');
      expect(modelo.esUrgente, true);
      expect(modelo.estadoSolicitud, 'abierta');
      expect(modelo.fecha, '01/06/2025');
      expect(modelo.nombreUsuario, 'Carlos Lopez');
      expect(modelo.nombreTipoProfesion, 'Plomeria');
    });

    test('fromJson con nulls usa defaults', () {
      final json = <String, dynamic>{'id': 1};

      final modelo = SolicitudAbierta.fromJson(json);

      expect(modelo.id, 1);
      expect(modelo.idUsuario, 0);
      expect(modelo.idTipoProfesion, 0);
      expect(modelo.titulo, '');
      expect(modelo.descripcion, '');
      expect(modelo.presupuestoMax, isNull);
      expect(modelo.ubicacion, isNull);
      expect(modelo.fechaLimite, isNull);
      expect(modelo.esUrgente, false);
      expect(modelo.estadoSolicitud, 'abierta');
      expect(modelo.fecha, '');
      expect(modelo.nombreUsuario, isNull);
      expect(modelo.nombreTipoProfesion, isNull);
    });

    test('fromJson convierte estadoSolicitud a lowercase', () {
      final json = <String, dynamic>{
        'id': 2,
        'estadoSolicitud': 'EN_REVISION',
      };

      final modelo = SolicitudAbierta.fromJson(json);

      expect(modelo.estadoSolicitud, 'en_revision');
    });

    test('fromJson parsea fechas ISO a formato dd/MM/yyyy', () {
      final json = <String, dynamic>{
        'id': 3,
        'fecha': '2025-01-07T14:30:00',
        'fechaLimite': '2025-12-25T00:00:00',
      };

      final modelo = SolicitudAbierta.fromJson(json);

      expect(modelo.fecha, '07/01/2025');
      expect(modelo.fechaLimite, '25/12/2025');
    });

    test('fromJson con fecha no parseable devuelve el string original', () {
      final json = <String, dynamic>{
        'id': 4,
        'fecha': 'no-es-fecha',
        'fechaLimite': 'tampoco',
      };

      final modelo = SolicitudAbierta.fromJson(json);

      expect(modelo.fecha, 'no-es-fecha');
      expect(modelo.fechaLimite, 'tampoco');
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Pago
  // ─────────────────────────────────────────────────────────────────────────
  group('Pago', () {
    test('fromJson con datos completos', () {
      final json = <String, dynamic>{
        'id': 100,
        'idUsuario': 5,
        'idProfesional': 8,
        'monto': 350.50,
        'moneda': 'USD',
        'estadoPago': 'Completado',
        'metodoPago': 'Culqi',
        'fechaCaptura': '2025-03-10T09:00:00',
        'fechaLiberacion': '2025-03-15T12:00:00',
        'fechaCreacion': '2025-03-10T08:55:00',
      };

      final modelo = Pago.fromJson(json);

      expect(modelo.id, 100);
      expect(modelo.idUsuario, 5);
      expect(modelo.idProfesional, 8);
      expect(modelo.monto, 350.50);
      expect(modelo.moneda, 'USD');
      expect(modelo.estadoPago, 'completado');
      expect(modelo.metodoPago, 'Culqi');
      expect(modelo.fechaCaptura, '10/03/2025');
      expect(modelo.fechaLiberacion, '15/03/2025');
      expect(modelo.fecha, '10/03/2025');
    });

    test('fromJson con nulls usa defaults', () {
      final json = <String, dynamic>{'id': 1};

      final modelo = Pago.fromJson(json);

      expect(modelo.id, 1);
      expect(modelo.idUsuario, 0);
      expect(modelo.idProfesional, 0);
      expect(modelo.monto, 0.0);
      expect(modelo.moneda, 'PEN');
      expect(modelo.estadoPago, 'pendiente');
      expect(modelo.metodoPago, isNull);
      expect(modelo.fechaCaptura, isNull);
      expect(modelo.fechaLiberacion, isNull);
      expect(modelo.fecha, '');
    });

    test('fromJson convierte estadoPago a lowercase', () {
      final json = <String, dynamic>{
        'id': 2,
        'estadoPago': 'PENDIENTE',
      };

      final modelo = Pago.fromJson(json);

      expect(modelo.estadoPago, 'pendiente');
    });

    test('fromJson monto acepta int y lo convierte a double', () {
      final json = <String, dynamic>{
        'id': 3,
        'monto': 100,
      };

      final modelo = Pago.fromJson(json);

      expect(modelo.monto, 100.0);
      expect(modelo.monto, isA<double>());
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // HitoServicio
  // ─────────────────────────────────────────────────────────────────────────
  group('HitoServicio', () {
    test('fromJson con datos completos', () {
      final json = <String, dynamic>{
        'id': 7,
        'idProyecto': 15,
        'hito': 'Trabajo iniciado',
        'descripcion': 'Se comenzo la demolicion',
        'fechaHito': '2025-04-20T14:30:00',
      };

      final modelo = HitoServicio.fromJson(json);

      expect(modelo.id, 7);
      expect(modelo.idProyecto, 15);
      expect(modelo.hito, 'Trabajo iniciado');
      expect(modelo.descripcion, 'Se comenzo la demolicion');
      // fechaHito incluye hora: dd/MM/yyyy HH:mm
      expect(modelo.fechaHito, contains('20/04/2025'));
      expect(modelo.fechaHito, contains(':'));
    });

    test('fromJson con nulls usa defaults', () {
      final json = <String, dynamic>{};

      final modelo = HitoServicio.fromJson(json);

      expect(modelo.id, 0);
      expect(modelo.idProyecto, 0);
      expect(modelo.hito, '');
      expect(modelo.descripcion, isNull);
      expect(modelo.fechaHito, '');
    });

    test('fromJson con fechaHito null devuelve string vacio', () {
      final json = <String, dynamic>{
        'id': 1,
        'fechaHito': null,
      };

      final modelo = HitoServicio.fromJson(json);

      expect(modelo.fechaHito, '');
    });

    test('fromJson con fechaHito no parseable devuelve string original', () {
      final json = <String, dynamic>{
        'id': 2,
        'fechaHito': 'fecha-invalida',
      };

      final modelo = HitoServicio.fromJson(json);

      expect(modelo.fechaHito, 'fecha-invalida');
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // FotoProyecto
  // ─────────────────────────────────────────────────────────────────────────
  group('FotoProyecto', () {
    test('fromJson con datos completos', () {
      final json = <String, dynamic>{
        'id': 42,
        'url': 'https://cdn.example.com/foto1.jpg',
        'fechaCreacion': '2025-05-01',
        'tipoFoto': 'antes',
        'descripcion': 'Foto antes de iniciar',
      };

      final modelo = FotoProyecto.fromJson(json);

      expect(modelo.id, 42);
      expect(modelo.url, 'https://cdn.example.com/foto1.jpg');
      expect(modelo.fecha, '2025-05-01');
      expect(modelo.tipoFoto, 'antes');
      expect(modelo.descripcion, 'Foto antes de iniciar');
    });

    test('fromJson con nulls usa defaults', () {
      final json = <String, dynamic>{};

      final modelo = FotoProyecto.fromJson(json);

      expect(modelo.id, 0);
      expect(modelo.url, '');
      expect(modelo.fecha, '');
      expect(modelo.tipoFoto, 'durante');
      expect(modelo.descripcion, isNull);
    });

    test('fromJson usa fechaCreacion con prioridad sobre fecha', () {
      final json = <String, dynamic>{
        'id': 1,
        'fechaCreacion': '2025-01-01',
        'fecha': '2025-12-31',
      };

      final modelo = FotoProyecto.fromJson(json);

      expect(modelo.fecha, '2025-01-01');
    });

    test('fromJson usa fecha como fallback si fechaCreacion es null', () {
      final json = <String, dynamic>{
        'id': 2,
        'fecha': '2025-06-15',
      };

      final modelo = FotoProyecto.fromJson(json);

      expect(modelo.fecha, '2025-06-15');
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // BusquedaResultado
  // ─────────────────────────────────────────────────────────────────────────
  group('BusquedaResultado', () {
    test('fromJson con datos completos', () {
      final json = <String, dynamic>{
        'id': 20,
        'nombre': 'Maria Garcia',
        'especialidad': 'Electricista',
        'calificacion': 4.8,
        'precioPorHora': 75.0,
        'disponibleAhora': true,
        'ubicacion': 'Miraflores, Lima',
        'distanciaKm': 3.5,
        'nivelVerificacion': 2,
        'esVerificado': true,
      };

      final modelo = BusquedaResultado.fromJson(json);

      expect(modelo.id, 20);
      expect(modelo.nombre, 'Maria Garcia');
      expect(modelo.especialidad, 'Electricista');
      expect(modelo.calificacion, 4.8);
      expect(modelo.precioPorHora, 75.0);
      expect(modelo.disponibleAhora, true);
      expect(modelo.ubicacion, 'Miraflores, Lima');
      expect(modelo.distanciaKm, 3.5);
      expect(modelo.nivelVerificacion, 2);
      expect(modelo.esVerificado, true);
    });

    test('fromJson con nulls usa defaults', () {
      final json = <String, dynamic>{'id': 1};

      final modelo = BusquedaResultado.fromJson(json);

      expect(modelo.id, 1);
      expect(modelo.nombre, '');
      expect(modelo.especialidad, '');
      expect(modelo.calificacion, 0.0);
      expect(modelo.precioPorHora, 0.0);
      expect(modelo.disponibleAhora, false);
      expect(modelo.ubicacion, isNull);
      expect(modelo.distanciaKm, isNull);
      expect(modelo.nivelVerificacion, 0);
      expect(modelo.esVerificado, false);
    });

    test('fromJson calificacion acepta int y lo convierte a double', () {
      final json = <String, dynamic>{
        'id': 2,
        'calificacion': 5,
        'precioPorHora': 100,
      };

      final modelo = BusquedaResultado.fromJson(json);

      expect(modelo.calificacion, 5.0);
      expect(modelo.calificacion, isA<double>());
      expect(modelo.precioPorHora, 100.0);
      expect(modelo.precioPorHora, isA<double>());
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // ServicioRecurrente
  // ─────────────────────────────────────────────────────────────────────────
  group('ServicioRecurrente', () {
    test('fromJson con datos completos', () {
      final json = <String, dynamic>{
        'id': 30,
        'idUsuario': 4,
        'idProfesional': 12,
        'idTipoServicio': 6,
        'descripcion': 'Limpieza semanal de oficina',
        'frecuencia': 'semanal',
        'diaSemana': 1,
        'horaInicio': '08:00',
        'fechaInicio': '2025-01-15',
        'fechaFin': '2025-12-31',
        'estadoRecurrente': 'activo',
        'proximaEjecucion': '2025-06-16',
      };

      final modelo = ServicioRecurrente.fromJson(json);

      expect(modelo.id, 30);
      expect(modelo.idUsuario, 4);
      expect(modelo.idProfesional, 12);
      expect(modelo.idTipoServicio, 6);
      expect(modelo.descripcion, 'Limpieza semanal de oficina');
      expect(modelo.frecuencia, 'semanal');
      expect(modelo.diaSemana, 1);
      expect(modelo.horaInicio, '08:00');
      expect(modelo.fechaInicio, '2025-01-15');
      expect(modelo.fechaFin, '2025-12-31');
      expect(modelo.estadoRecurrente, 'activo');
      expect(modelo.proximaEjecucion, '2025-06-16');
    });

    test('fromJson con nulls usa defaults', () {
      final json = <String, dynamic>{};

      final modelo = ServicioRecurrente.fromJson(json);

      expect(modelo.id, 0);
      expect(modelo.idUsuario, 0);
      expect(modelo.idProfesional, 0);
      expect(modelo.idTipoServicio, isNull);
      expect(modelo.descripcion, '');
      expect(modelo.frecuencia, '');
      expect(modelo.diaSemana, isNull);
      expect(modelo.horaInicio, isNull);
      expect(modelo.fechaInicio, '');
      expect(modelo.fechaFin, isNull);
      expect(modelo.estadoRecurrente, 'activo');
      expect(modelo.proximaEjecucion, isNull);
    });

    test('toJson omite campos opcionales nulos', () {
      final modelo = ServicioRecurrente(
        id: 1,
        idUsuario: 2,
        idProfesional: 3,
        descripcion: 'Test',
        frecuencia: 'mensual',
        fechaInicio: '2025-01-01',
        estadoRecurrente: 'activo',
      );

      final json = modelo.toJson();

      expect(json.containsKey('idTipoServicio'), false);
      expect(json.containsKey('diaSemana'), false);
      expect(json.containsKey('horaInicio'), false);
      expect(json.containsKey('fechaFin'), false);
      expect(json.containsKey('proximaEjecucion'), false);
      expect(json['id'], 1);
      expect(json['frecuencia'], 'mensual');
    });

    test('toJson incluye campos opcionales cuando no son nulos', () {
      final modelo = ServicioRecurrente(
        id: 1,
        idUsuario: 2,
        idProfesional: 3,
        idTipoServicio: 5,
        descripcion: 'Test',
        frecuencia: 'quincenal',
        diaSemana: 3,
        horaInicio: '10:00',
        fechaInicio: '2025-01-01',
        fechaFin: '2025-06-30',
        estadoRecurrente: 'pausado',
        proximaEjecucion: '2025-02-01',
      );

      final json = modelo.toJson();

      expect(json['idTipoServicio'], 5);
      expect(json['diaSemana'], 3);
      expect(json['horaInicio'], '10:00');
      expect(json['fechaFin'], '2025-06-30');
      expect(json['proximaEjecucion'], '2025-02-01');
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // SlotDisponible
  // ─────────────────────────────────────────────────────────────────────────
  group('SlotDisponible', () {
    test('fromJson con datos completos', () {
      final json = <String, dynamic>{
        'fecha': '2025-06-16',
        'diaSemana': 1,
        'horaInicio': '09:00',
        'horaFin': '10:00',
        'disponible': true,
      };

      final modelo = SlotDisponible.fromJson(json);

      expect(modelo.fecha, '2025-06-16');
      expect(modelo.diaSemana, 1);
      expect(modelo.horaInicio, '09:00');
      expect(modelo.horaFin, '10:00');
      expect(modelo.disponible, true);
    });

    test('fromJson con nulls usa defaults', () {
      final json = <String, dynamic>{};

      final modelo = SlotDisponible.fromJson(json);

      expect(modelo.fecha, '');
      expect(modelo.diaSemana, 0);
      expect(modelo.horaInicio, '');
      expect(modelo.horaFin, '');
      expect(modelo.disponible, false);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // PortfolioItem
  // ─────────────────────────────────────────────────────────────────────────
  group('PortfolioItem', () {
    test('fromJson con datos completos', () {
      final json = <String, dynamic>{
        'idProyecto': 55,
        'nombreProyecto': 'Renovacion cocina completa',
        'fechaCompletado': '2025-05-20',
        'fotoUrls': [
          'https://cdn.example.com/p1.jpg',
          'https://cdn.example.com/p2.jpg',
        ],
      };

      final modelo = PortfolioItem.fromJson(json);

      expect(modelo.idProyecto, 55);
      expect(modelo.nombreProyecto, 'Renovacion cocina completa');
      expect(modelo.fechaCompletado, '2025-05-20');
      expect(modelo.fotoUrls, hasLength(2));
      expect(modelo.fotoUrls[0], 'https://cdn.example.com/p1.jpg');
      expect(modelo.fotoUrls[1], 'https://cdn.example.com/p2.jpg');
    });

    test('fromJson con nulls usa defaults', () {
      final json = <String, dynamic>{};

      final modelo = PortfolioItem.fromJson(json);

      expect(modelo.idProyecto, 0);
      expect(modelo.nombreProyecto, '');
      expect(modelo.fechaCompletado, '');
      expect(modelo.fotoUrls, isEmpty);
    });

    test('fromJson con fotoUrls null devuelve lista vacia', () {
      final json = <String, dynamic>{
        'idProyecto': 1,
        'fotoUrls': null,
      };

      final modelo = PortfolioItem.fromJson(json);

      expect(modelo.fotoUrls, isEmpty);
      expect(modelo.fotoUrls, isA<List<String>>());
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // PerfilClientePublico
  // ─────────────────────────────────────────────────────────────────────────
  group('PerfilClientePublico', () {
    test('fromJson con datos completos', () {
      final json = <String, dynamic>{
        'id': 5,
        'nombre': 'Juan Perez',
        'proyectosCompletados': 3,
        'calificacionPromedio': 4.2,
        'totalResenasRecibidas': 2,
        'miembroDesde': '2025-01-15T10:30:00',
      };

      final modelo = PerfilClientePublico.fromJson(json);

      expect(modelo.id, 5);
      expect(modelo.nombre, 'Juan Perez');
      expect(modelo.proyectosCompletados, 3);
      expect(modelo.calificacionPromedio, 4.2);
      expect(modelo.totalResenasRecibidas, 2);
      expect(modelo.miembroDesde, '2025-01-15T10:30:00');
    });

    test('fromJson con nulls usa defaults', () {
      final json = <String, dynamic>{};

      final modelo = PerfilClientePublico.fromJson(json);

      expect(modelo.id, 0);
      expect(modelo.nombre, '');
      expect(modelo.proyectosCompletados, 0);
      expect(modelo.calificacionPromedio, 0.0);
      expect(modelo.totalResenasRecibidas, 0);
      expect(modelo.miembroDesde, '');
    });

    test('fromJson calificacionPromedio acepta int y lo convierte a double',
        () {
      final json = <String, dynamic>{
        'id': 1,
        'calificacionPromedio': 4,
      };

      final modelo = PerfilClientePublico.fromJson(json);

      expect(modelo.calificacionPromedio, 4.0);
      expect(modelo.calificacionPromedio, isA<double>());
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // EstadisticaPrecio
  // ─────────────────────────────────────────────────────────────────────────
  group('EstadisticaPrecio', () {
    test('fromJson con datos completos', () {
      final json = <String, dynamic>{
        'min': 25.0,
        'max': 150.0,
        'promedio': 87.5,
        'cantidadMuestras': 42,
      };

      final modelo = EstadisticaPrecio.fromJson(json);

      expect(modelo.min, 25.0);
      expect(modelo.max, 150.0);
      expect(modelo.promedio, 87.5);
      expect(modelo.cantidadMuestras, 42);
    });

    test('fromJson con nulls usa defaults', () {
      final json = <String, dynamic>{};

      final modelo = EstadisticaPrecio.fromJson(json);

      expect(modelo.min, 0.0);
      expect(modelo.max, 0.0);
      expect(modelo.promedio, 0.0);
      expect(modelo.cantidadMuestras, 0);
    });

    test('fromJson acepta int y lo convierte a double', () {
      final json = <String, dynamic>{
        'min': 10,
        'max': 200,
        'promedio': 105,
        'cantidadMuestras': 5,
      };

      final modelo = EstadisticaPrecio.fromJson(json);

      expect(modelo.min, 10.0);
      expect(modelo.min, isA<double>());
      expect(modelo.max, 200.0);
      expect(modelo.max, isA<double>());
      expect(modelo.promedio, 105.0);
      expect(modelo.promedio, isA<double>());
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Integration: modelos parsean lo que la API devolveria
  // ─────────────────────────────────────────────────────────────────────────
  group('Integration: modelo parsea respuesta tipica de la API', () {
    test('PerfilClientePublico parsea /clientes/{id}/perfil-publico', () {
      final apiResponse = <String, dynamic>{
        'id': 5,
        'nombre': 'Juan Perez',
        'proyectosCompletados': 3,
        'calificacionPromedio': 4.2,
        'totalResenasRecibidas': 2,
        'miembroDesde': '2025-01-15T10:30:00',
      };

      final perfil = PerfilClientePublico.fromJson(apiResponse);

      expect(perfil.nombre, 'Juan Perez');
      expect(perfil.calificacionPromedio, 4.2);
      expect(perfil.proyectosCompletados, 3);
    });

    test('SolicitudAbierta parsea /solicitudes-abiertas/disponibles', () {
      final apiResponse = <String, dynamic>{
        'id': 10,
        'idUsuario': 3,
        'idTipoProfesion': 5,
        'titulo': 'Necesito electricista certificado',
        'descripcion': 'Instalacion electrica completa para local comercial',
        'presupuestoMax': 5000.0,
        'ubicacion': 'San Isidro, Lima',
        'fechaLimite': '2025-07-01T00:00:00',
        'esUrgente': false,
        'estadoSolicitud': 'Abierta',
        'fecha': '2025-06-01T10:30:00',
        'nombreUsuario': 'Ana Rodriguez',
        'nombreTipoProfesion': 'Electricista',
      };

      final solicitud = SolicitudAbierta.fromJson(apiResponse);

      expect(solicitud.titulo, 'Necesito electricista certificado');
      expect(solicitud.presupuestoMax, 5000.0);
      expect(solicitud.estadoSolicitud, 'abierta');
      expect(solicitud.fechaLimite, '01/07/2025');
    });

    test('Pago parsea /pagos/mis', () {
      final apiResponse = <String, dynamic>{
        'id': 200,
        'idUsuario': 10,
        'idProfesional': 25,
        'monto': 450.00,
        'moneda': 'PEN',
        'estadoPago': 'Completado',
        'metodoPago': 'Culqi',
        'fechaCaptura': '2025-05-10T15:30:00',
        'fechaLiberacion': '2025-05-15T09:00:00',
        'fechaCreacion': '2025-05-10T15:25:00',
      };

      final pago = Pago.fromJson(apiResponse);

      expect(pago.monto, 450.00);
      expect(pago.estadoPago, 'completado');
      expect(pago.fechaCaptura, '10/05/2025');
      expect(pago.fechaLiberacion, '15/05/2025');
    });

    test('BusquedaResultado parsea /profesionales/buscar', () {
      final apiResponse = <String, dynamic>{
        'id': 15,
        'nombre': 'Roberto Diaz',
        'especialidad': 'Pintor',
        'calificacion': 4.6,
        'precioPorHora': 55.0,
        'disponibleAhora': true,
        'ubicacion': 'Barranco, Lima',
        'distanciaKm': 2.3,
        'nivelVerificacion': 3,
        'esVerificado': true,
      };

      final resultado = BusquedaResultado.fromJson(apiResponse);

      expect(resultado.nombre, 'Roberto Diaz');
      expect(resultado.disponibleAhora, true);
      expect(resultado.distanciaKm, 2.3);
      expect(resultado.esVerificado, true);
    });

    test('EstadisticaPrecio parsea /estadisticas/precio-promedio', () {
      final apiResponse = <String, dynamic>{
        'min': 30.0,
        'max': 120.0,
        'promedio': 65.5,
        'cantidadMuestras': 18,
      };

      final stats = EstadisticaPrecio.fromJson(apiResponse);

      expect(stats.promedio, 65.5);
      expect(stats.cantidadMuestras, 18);
      expect(stats.min, lessThan(stats.max));
    });

    test('PortfolioItem parsea /profesionales/{id}/portfolio', () {
      final apiResponse = <String, dynamic>{
        'idProyecto': 88,
        'nombreProyecto': 'Remodelacion total bano master',
        'fechaCompletado': '2025-04-01',
        'fotoUrls': [
          'https://storage.ejemplo.com/img1.jpg',
          'https://storage.ejemplo.com/img2.jpg',
          'https://storage.ejemplo.com/img3.jpg',
        ],
      };

      final item = PortfolioItem.fromJson(apiResponse);

      expect(item.nombreProyecto, contains('bano'));
      expect(item.fotoUrls, hasLength(3));
    });

    test('SlotDisponible parsea /api/HorarioProfesional/{id}/disponibilidad',
        () {
      final apiResponse = <String, dynamic>{
        'fecha': '2025-06-16',
        'diaSemana': 1,
        'horaInicio': '09:00',
        'horaFin': '10:00',
        'disponible': true,
      };

      final slot = SlotDisponible.fromJson(apiResponse);

      expect(slot.fecha, '2025-06-16');
      expect(slot.disponible, true);
      expect(slot.horaInicio, '09:00');
    });
  });
}
