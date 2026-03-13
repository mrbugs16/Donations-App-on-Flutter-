# 📱 Donativos App – Proyecto Final

### Ingeniería en Tecnologías de Cómputo y Telecomunicaciones
### Aplicaciones Móviles – Otoño 2025

**Autores:**  
- **Fernando Flores López**  
- **Santiago Tapia Reducindo**

**Institución:** Universidad Iberoamericana

---

## 📖 Descripción General

Donativos App es una aplicación móvil desarrollada en **Flutter**, diseñada para que voluntarios registren donativos de manera rápida y organizada.

### Características principales:

- **Inicio de sesión seguro** con Firebase Authentication
- **Registro manual de donativos**
- **Escaneo de códigos QR** para registrar donativos automáticamente
- **Consulta de actividad reciente**
- **Estadísticas por voluntario** (donativos totales y del mes)
- **Arquitectura limpia** tipo MVVM con separación en capas
- **Persistencia en la nube** mediante Firebase Firestore

La aplicación está pensada para mostrar un flujo completo de captura, consulta y seguimiento.

---

## 🧱 Arquitectura del Proyecto

El proyecto sigue una estructura **MVVM + Clean Architecture**, organizada así:
```
lib/
├─ core/                    # Rutas, utilidades
├─ data/                    # Firebase implementations
│  ├─ models/
│  ├─ repositories/
├─ domain/                  # Entities + UseCases
│  ├─ entities/
│  ├─ repositories/
│  ├─ usecases/
├─ presentation/            # UI + ViewModels
│  ├─ screens/
│  ├─ viewmodels/
│  ├─ widgets/
├─ di/                      # Providers globales (Provider)
└─ main.dart
```

Esta estructura separa por completo:  
**UI → Lógica de presentación → Reglas de negocio → Infraestructura**

---

## 🔐 Autenticación

- Inicio de sesión por correo/contraseña usando **Firebase Authentication**
- La sesión del usuario se expone mediante `AuthViewModel`

---

## 📦 Registro de Donativos

Existen dos métodos de registro:

### 1. Registro Manual

Formulario donde el voluntario captura:
- Descripción
- Cantidad
- Unidad
- Categoría
- Ubicación

### 2. Registro vía QR

El voluntario escanea un código QR con formato JSON como:
```json
{
  "type": "donation_qr_v1",
  "description": "Agua embotellada 1L",
  "quantity": 24,
  "unit": "piezas",
  "category": "Alimentos",
  "location": "Almacén central CDMX"
}
```

La app valida el JSON, lo transforma en entidad de dominio y lo registra en Firestore.

---

## 🔎 Consultas y Estadísticas

### Inicio
- Lista de los donativos recientes (en orden cronológico)
- Dashboard con estadísticas simples (donativos del día)

### Perfil
- Datos del usuario (email y UID)
- Recuento de donativos registrados por ese voluntario:
  - Total histórico
  - Total en el mes actual

---

## 🛠️ Tecnologías Utilizadas

- **Flutter 3.x**
- **Dart**
- **Firebase Authentication**
- **Cloud Firestore**
- **Provider** (estado + DI)
- **Mobile Scanner** para lectura de QR

---

## ▶️ Demo en Video

Videos demostrativos (Android & iOs):  
[Ver demos](https://drive.google.com/drive/folders/1GYP456FgKyJlXQ1CD8T_us173llWRfTM?usp=sharing)

---

## 🚀 Cómo Correr el Proyecto

### Clonar el repositorio:
```bash
git clone https://github.com/FlowersLoop/donativos_app.git
cd donativos_app
```

### Instalar dependencias:
```bash
flutter pub get
```

### Ejecutar:
```bash
flutter run
```

---

## 📄 Licencia

Proyecto académico – Universidad Iberoamericana  
Libre para revisión por docentes

---

## 📝 Comandos para Subir al GitHub
```bash
git add README.md
git commit -m "docs: Actualizaciones"
git push
```
