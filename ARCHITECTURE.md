# ARCHITECTURE.md

## Arquitectura de Software

Este proyecto sigue los principios de Clean Architecture para garantizar la escalabilidad, la testabilidad y la separación de responsabilidades. La aplicación se divide en tres capas concéntricas:

* **Presentation Layer**: Responsable de la UI y el manejo de estado.
    * Patrón: MVI (Model-View-Intent) implementado con BLoC.
    * Decisión: Se eligió BLoC sobre otros gestores de estado por su estricta separación entre eventos (Inputs) y estados (Outputs), lo cual facilita el testing y previene "side effects" no controlados en la UI.
* **Domain Layer**: El núcleo de la aplicación. Contiene las Reglas de Negocio.
    * Componentes: Entidades (Report, Evidence), Interfaces de Repositorios y Casos de Uso (UseCases).
    * Pureza: Esta capa no tiene dependencias de librerías externas (como Flutter, SQL o HTTP), siendo puro código Dart.
* **Data Layer**: Responsable de la implementación de la persistencia y comunicación.
    * Componentes: Modelos (mappers), Data Sources (Local/Remoto) y la implementación de los Repositorios.

## Estrategia "Offline-First" y Sincronización

La aplicación trata a la base de datos local (SQLite) como la "Single Source of Truth" (Fuente única de verdad). La UI nunca lee directamente de la API, sino que observa la base de datos local.

### Manejo de Concurrencia (Race Conditions)

**Escenario**: Un usuario edita un reporte o evidencia mientras el sistema está intentando sincronizarlo.

Solución Implementada:
1. **Estados de Sincronización**: Cada evidencia tiene un estado explícito (pending, syncing, synced).
2. **Inmutabilidad de IDs**: Los IDs se generan localmente (UUID v4) y son la llave primaria inmutable. Esto permite que el registro local y el remoto se reconcilien sin conflictos de llaves.
3. **Prioridad Local**: Si el usuario edita un reporte, el estado de sincronización se resetea a pending. Si el Worker estaba subiendo una versión anterior, esa subida completará (o fallará), pero el registro local mantendrá el estado pending hasta que el Worker vuelva a ejecutarse y tome la nueva versión editada.

## Manejo de Errores y Resiliencia

Dado que la operación crítica es la subida de archivos binarios (Imágenes) a un servidor S3 (MinIO), se implementaron las siguientes estrategias:

* **Worker en Segundo Plano**: Se utiliza WorkManager para desacoplar la subida de archivos del ciclo de vida de la UI. Esto garantiza que las subidas continúen incluso si el usuario cierra la app.

* **Backoff Exponencial**: Si la subida a MinIO falla (ej. error 500 o pérdida de conexión al 99%), el Worker retorna Result.retry(). El sistema operativo (Android/iOS) reprogramará la tarea con un tiempo de espera exponencial, evitando saturar la red o la batería.

* **Timeouts Extendidos**: Se configuró Dio con timeouts de 60 segundos para tolerar conexiones lentas al subir archivos pesados (>5MB).

* **Manejo Funcional de Errores**: Se utiliza el tipo Either<Failure, Success> (paquete dartz) en el Dominio. Esto obliga al desarrollador a gestionar explícitamente los errores en la capa de presentación, evitando excepciones no capturadas en tiempo de ejecución.

## Algoritmo de Priorización de Subida

Para optimizar la experiencia de usuario y el uso de ancho de banda, se implementó un algoritmo de ordenamiento personalizado (UploadQueueOptimizer) que cumple con:

1. **Prioridad de Negocio**: Las imágenes (evidencia visual) tienen prioridad HIGH sobre otros tipos de adjuntos.

2. **Estrategia "Quick Wins"**: A igual prioridad, se suben primero los archivos más ligeros. Esto libera rápidamente la cola de tareas pendientes y da una sensación de progreso más veloz al usuario.

Este algoritmo es agnóstico al framework y cuenta con sus propios Tests Unitarios.

## Inyección de Dependencias (DI)

Se utiliza GetIt como Service Locator y Injectable para la generación de código.

Árbol de Dependencias:

1. **Singleton**: Dio (Cliente HTTP), DatabaseHelper (Conexión SQL).

2. **LazySingleton**: Repositorios y DataSources (se crean solo cuando se necesitan).

3. **Factory**: BLoCs (se crea una instancia nueva cada vez que una pantalla lo requiere, y se desecha al cerrarla).

Facilidad para Testing: Esta estructura permite reemplazar fácilmente el MinioRemoteDataSourceImpl por un MockRemoteDataSource durante los tests de integración, permitiendo probar la lógica de la app sin necesidad de un servidor real o conexión a internet.

## Stack Tecnológico

* **Lenguaje**: Dart 3.x

* **Framework**: Flutter 3.x

* **State Management**: flutter_bloc

* **Local DB**: sqflite (Relacional)

* **Networking**: Dio + PrettyDioLogger

* **Background Tasks**: workmanager

* **Routing**: go_router

* **Infrastructure**: Docker + MinIO (S3 Compatible)