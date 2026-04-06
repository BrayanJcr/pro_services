import 'package:flutter_test/flutter_test.dart';
import 'package:pro_services/models/profesional.dart';
import 'package:pro_services/models/proyecto.dart';

void main() {
  // ─────────────────────────────────────────────────────────────────────────
  // Profesional — campos nuevos: distanciaKm, latitud, longitud,
  //               nivelVerificacion, esVerificado, aniosExperiencia
  // ─────────────────────────────────────────────────────────────────────────
  group('Profesional', () {
    test('fromJson con datos completos', () {
      final json = <String, dynamic>{
        'id': 1,
        'nombre': 'Ana Torres',
        'especialidad': 'Electricista',
        'calificacion': 4.7,
        'trabajosRealizados': 85,
        'ubicacion': 'Miraflores, Lima',
        'precioPorHora': 65.0,
        'horarioDisponibilidad': 'Lun-Vie 8:00-18:00',
        'habilidades': 'instalaciones,mantenimiento,reparaciones',
        'disponibleAhora': true,
        'telefono': '+51987654321',
        'correo': 'ana@example.com',
        'sitioWeb': 'https://ana-electricista.com',
        'sobreMi': 'Electricista certificada con 10 anios de experiencia',
        'avatarUrl': 'https://cdn.example.com/avatar.jpg',
        'esVerificado': true,
        'nivelVerificacion': 3,
        'latitud': -12.1197,
        'longitud': -77.0318,
        'distanciaKm': 5.2,
        'aniosExperiencia': 10,
      };

      final modelo = Profesional.fromJson(json);

      expect(modelo.id, 1);
      expect(modelo.nombre, 'Ana Torres');
      expect(modelo.especialidad, 'Electricista');
      expect(modelo.calificacion, 4.7);
      expect(modelo.trabajosRealizados, 85);
      expect(modelo.ubicacion, 'Miraflores, Lima');
      expect(modelo.precioPorHora, 65.0);
      expect(modelo.horarioDisponibilidad, 'Lun-Vie 8:00-18:00');
      expect(modelo.habilidades, ['instalaciones', 'mantenimiento', 'reparaciones']);
      expect(modelo.disponibleAhora, true);
      expect(modelo.telefono, '+51987654321');
      expect(modelo.correo, 'ana@example.com');
      expect(modelo.sitioWeb, 'https://ana-electricista.com');
      expect(modelo.sobreMi, 'Electricista certificada con 10 anios de experiencia');
      expect(modelo.avatarUrl, 'https://cdn.example.com/avatar.jpg');
      expect(modelo.esVerificado, true);
      expect(modelo.nivelVerificacion, 3);
      expect(modelo.latitud, -12.1197);
      expect(modelo.longitud, -77.0318);
      expect(modelo.distanciaKm, 5.2);
      expect(modelo.aniosExperiencia, 10);
    });

    test('fromJson con nulls usa defaults', () {
      final json = <String, dynamic>{'id': 1};

      final modelo = Profesional.fromJson(json);

      expect(modelo.id, 1);
      expect(modelo.nombre, '');
      expect(modelo.especialidad, '');
      expect(modelo.calificacion, 0.0);
      expect(modelo.trabajosRealizados, 0);
      expect(modelo.ubicacion, '');
      expect(modelo.precioPorHora, 0.0);
      expect(modelo.horarioDisponibilidad, '');
      expect(modelo.habilidades, isEmpty);
      expect(modelo.disponibleAhora, false);
      expect(modelo.telefono, '');
      expect(modelo.correo, '');
      expect(modelo.sitioWeb, isNull);
      expect(modelo.sobreMi, '');
      expect(modelo.avatarUrl, isNull);
      expect(modelo.esVerificado, false);
      expect(modelo.nivelVerificacion, 0);
      expect(modelo.latitud, isNull);
      expect(modelo.longitud, isNull);
      expect(modelo.distanciaKm, isNull);
      expect(modelo.aniosExperiencia, 0);
    });

    test('distanciaKm, latitud y longitud se parsean correctamente', () {
      final json = <String, dynamic>{
        'id': 2,
        'latitud': -12.0464,
        'longitud': -77.0428,
        'distanciaKm': 1.8,
      };

      final modelo = Profesional.fromJson(json);

      expect(modelo.latitud, -12.0464);
      expect(modelo.longitud, -77.0428);
      expect(modelo.distanciaKm, 1.8);
      expect(modelo.latitud, isA<double>());
      expect(modelo.longitud, isA<double>());
      expect(modelo.distanciaKm, isA<double>());
    });

    test('latitud y longitud aceptan int y lo convierten a double', () {
      final json = <String, dynamic>{
        'id': 3,
        'latitud': -12,
        'longitud': -77,
        'distanciaKm': 3,
      };

      final modelo = Profesional.fromJson(json);

      expect(modelo.latitud, -12.0);
      expect(modelo.latitud, isA<double>());
      expect(modelo.longitud, -77.0);
      expect(modelo.longitud, isA<double>());
      expect(modelo.distanciaKm, 3.0);
      expect(modelo.distanciaKm, isA<double>());
    });

    test('habilidades parsea string con comas correctamente', () {
      final json = <String, dynamic>{
        'id': 4,
        'habilidades': 'pintura, plomeria, electricidad',
      };

      final modelo = Profesional.fromJson(json);

      expect(modelo.habilidades, hasLength(3));
      expect(modelo.habilidades[0], 'pintura');
      expect(modelo.habilidades[1], 'plomeria');
      expect(modelo.habilidades[2], 'electricidad');
    });

    test('habilidades parsea List<dynamic> correctamente', () {
      final json = <String, dynamic>{
        'id': 5,
        'habilidades': ['cocina', 'reposteria'],
      };

      final modelo = Profesional.fromJson(json);

      expect(modelo.habilidades, hasLength(2));
      expect(modelo.habilidades[0], 'cocina');
      expect(modelo.habilidades[1], 'reposteria');
    });

    test('habilidades con null devuelve lista vacia', () {
      final json = <String, dynamic>{
        'id': 6,
        'habilidades': null,
      };

      final modelo = Profesional.fromJson(json);

      expect(modelo.habilidades, isEmpty);
    });

    test('habilidades ignora strings vacios tras split', () {
      final json = <String, dynamic>{
        'id': 7,
        'habilidades': 'uno,,dos, ,tres',
      };

      final modelo = Profesional.fromJson(json);

      expect(modelo.habilidades, ['uno', 'dos', 'tres']);
    });

    test('esVerificado y nivelVerificacion se parsean correctamente', () {
      final json = <String, dynamic>{
        'id': 8,
        'esVerificado': true,
        'nivelVerificacion': 2,
      };

      final modelo = Profesional.fromJson(json);

      expect(modelo.esVerificado, true);
      expect(modelo.nivelVerificacion, 2);
    });

    test('nivelVerificacion default es 0 cuando no esta en json', () {
      final json = <String, dynamic>{'id': 9};

      final modelo = Profesional.fromJson(json);

      expect(modelo.nivelVerificacion, 0);
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Proyecto — verificar campos existentes y parseo de fechas
  // ─────────────────────────────────────────────────────────────────────────
  group('Proyecto', () {
    test('fromJson con datos completos', () {
      final json = <String, dynamic>{
        'id': 50,
        'idUsuario': 10,
        'cliente': 'Empresa ABC',
        'telefono': '+51912345678',
        'correo': 'contacto@abc.com',
        'servicio': 'Remodelacion oficina',
        'descripcion': 'Remodelacion completa del piso 3',
        'ubicacion': 'San Borja, Lima',
        'fecha': '2025-05-01T00:00:00',
        'fechaInicio': '2025-05-10T00:00:00',
        'fechaFin': '2025-06-10T00:00:00',
        'presupuesto': 12500.0,
        'estado': 'En Progreso',
        'progreso': 0.65,
      };

      final modelo = Proyecto.fromJson(json);

      expect(modelo.id, 50);
      expect(modelo.idUsuario, 10);
      expect(modelo.cliente, 'Empresa ABC');
      expect(modelo.telefono, '+51912345678');
      expect(modelo.correo, 'contacto@abc.com');
      expect(modelo.servicio, 'Remodelacion oficina');
      expect(modelo.descripcion, 'Remodelacion completa del piso 3');
      expect(modelo.ubicacion, 'San Borja, Lima');
      expect(modelo.fecha, '01/05/2025');
      expect(modelo.fechaInicio, '10/05/2025');
      expect(modelo.fechaFin, '10/06/2025');
      expect(modelo.presupuesto, 12500.0);
      expect(modelo.estado, 'en progreso');
      expect(modelo.progreso, 0.65);
    });

    test('fromJson con nulls usa defaults', () {
      final json = <String, dynamic>{};

      final modelo = Proyecto.fromJson(json);

      expect(modelo.id, 0);
      expect(modelo.idUsuario, 0);
      expect(modelo.cliente, '');
      expect(modelo.telefono, '');
      expect(modelo.correo, '');
      expect(modelo.servicio, '');
      expect(modelo.descripcion, '');
      expect(modelo.ubicacion, '');
      expect(modelo.fecha, '');
      expect(modelo.fechaInicio, '');
      expect(modelo.fechaFin, '');
      expect(modelo.presupuesto, 0.0);
      expect(modelo.estado, '');
      expect(modelo.progreso, 0.0);
    });

    test('fromJson convierte estado a lowercase', () {
      final json = <String, dynamic>{
        'estado': 'COMPLETADO',
      };

      final modelo = Proyecto.fromJson(json);

      expect(modelo.estado, 'completado');
    });

    test('fromJson parsea fechas ISO a formato dd/MM/yyyy', () {
      final json = <String, dynamic>{
        'fecha': '2025-12-25T00:00:00',
        'fechaInicio': '2025-01-07T10:00:00',
        'fechaFin': '2025-03-15T18:00:00',
      };

      final modelo = Proyecto.fromJson(json);

      expect(modelo.fecha, '25/12/2025');
      expect(modelo.fechaInicio, '07/01/2025');
      expect(modelo.fechaFin, '15/03/2025');
    });

    test('fromJson con fecha no parseable devuelve string original', () {
      final json = <String, dynamic>{
        'fecha': 'no-es-fecha',
        'fechaInicio': 'tampoco',
        'fechaFin': 'nope',
      };

      final modelo = Proyecto.fromJson(json);

      expect(modelo.fecha, 'no-es-fecha');
      expect(modelo.fechaInicio, 'tampoco');
      expect(modelo.fechaFin, 'nope');
    });

    test('fromJson con fecha null devuelve string vacio', () {
      final json = <String, dynamic>{
        'fecha': null,
        'fechaInicio': null,
        'fechaFin': null,
      };

      final modelo = Proyecto.fromJson(json);

      expect(modelo.fecha, '');
      expect(modelo.fechaInicio, '');
      expect(modelo.fechaFin, '');
    });

    test('fromJson presupuesto acepta int y lo convierte a double', () {
      final json = <String, dynamic>{
        'presupuesto': 5000,
        'progreso': 1,
      };

      final modelo = Proyecto.fromJson(json);

      expect(modelo.presupuesto, 5000.0);
      expect(modelo.presupuesto, isA<double>());
      expect(modelo.progreso, 1.0);
      expect(modelo.progreso, isA<double>());
    });
  });
}
