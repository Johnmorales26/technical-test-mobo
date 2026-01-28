# README.md

## Mobo Field Reporter

Aplicación móvil "Offline-First" desarrollada en Flutter para la gestión de reportes de campo con evidencia multimedia. La aplicación permite operar sin conexión a internet y sincroniza los datos automáticamente con un servidor MinIO (S3 Compatible) cuando la conectividad se restablece.

### 🛠️ Stack Tecnológico

* **Arquitectura**: Clean Architecture + MVI
* **Estado**: flutter_bloc
* **Base de Datos Local**: sqflite (Relacional con Transacciones)
* **Sincronización**: WorkManager (Background Workers)
* **Infraestructura**: Docker + MinIO

### 🚀 Guía de Instalación y Ejecución

#### 1. Prerrequisitos

* Flutter SDK (3.x o superior)
* Docker Desktop (o Docker Engine) corriendo
* Dispositivo Android (Emulador o Físico)

#### 2. Configuración de Infraestructura (MinIO)

La aplicación requiere un servidor local de almacenamiento. Se incluye un archivo `docker-compose.yml` para levantar este entorno.

1. Abrir una terminal en la raíz del proyecto
2. Ejecutar:
```bash
docker-compose up -d
```

3. **Importante**: Una vez levantado el contenedor, entra a la consola de administración y crea el bucket necesario:

   * **URL**: http://localhost:9001
   * **User**: moboadmin
   * **Password**: mobopassword
   * **Acción**: Crear un bucket llamado `evidence-bucket` y establecer su política de acceso como Public (para facilitar la visualización)

#### 3. Credenciales de MinIO

Estas son las credenciales configuradas en el entorno local:

| Parámetro | Valor | Notas |
|-----------|-------|-------|
| Console URL | `http://localhost:9001` | Para ver los archivos desde el navegador |
| API URL | `http://localhost:9000` | Puerto usado por la App para subir archivos |
| Username | `moboadmin` | |
| Password | `mobopassword` | |
| Region | `us-east-1` | Default |
| Bucket | `evidence-bucket` | Debe existir antes de subir fotos |

**Nota para Emuladores**: Si usas exclusivamente el emulador de Android, puedes usar `http://10.0.2.2:9000`. Sin embargo, para dispositivos físicos (APK instalado), es obligatorio usar la IP de la red WiFi y esto se puede ajustar en el archivo `lib/core/network/network_module.dart`.

#### 4. Ejecutar la Aplicación

1. Obtener dependencias:
```bash
flutter pub get
```

2. Generar código (Injectable/JSON):
```bash
dart run build_runner build --delete-conflicting-outputs
```

3. Correr la app:
```bash
flutter run
```

### 🧪 Cómo Probar el Modo Offline (Testing Scenario)

Sigue estos pasos para verificar la resiliencia y la sincronización en segundo plano:

1. **Modo Avión**: Desactiva el Wifi/Datos de tu dispositivo o emulador
2. **Crear Reporte**: Abre la app, pulsa "Nuevo Reporte", llena los datos y adjunta una fotografía
3. **Verificación Local**: Guarda el reporte. Verás que en la lista aparece con un icono de "Nube Tachada" (☁️🚫), indicando que está pendiente de sincronización. La imagen se ha guardado solo en el dispositivo
4. **Restablecer Conexión**: Activa nuevamente el Wifi/Datos
5. **Sincronización**:
   * **Opción A (Paciente)**: Espera aprox. 15 minutos (restricción de Android WorkManager)
   * **Opción B (Rápida - Recomendada para evaluar)**: Ejecuta el siguiente comando en tu terminal para forzar la tarea en background inmediatamente:
```
   # Comando para forzar la sincronización inmediata en Android
   JOB_ID=$(adb shell dumpsys jobscheduler | grep "JOB #" | grep "com.example.mobo_field_reporter" | head -n 1 | awk -F '[/:]' '{print $2}' | tr -d ' ') && adb shell cmd jobscheduler run -f com.example.mobo_field_reporter $JOB_ID
```

6. **Resultado Final**:
   * En MinIO: Podrás ver la fotografía subida en el bucket `evidence-bucket` a través de http://localhost:9001

### 📂 Documentación de Arquitectura

Para detalles profundos sobre las decisiones técnicas, manejo de errores y estrategia de sincronización, consultar el archivo: 📄 [ARCHITECTURE.md](ARCHITECTURE.md)