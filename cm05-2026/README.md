# CM05 — Laboratorio de Diseño Metodológico (2026)

**Portal para estudiantes:** https://williamsjimenez.github.io/class/cm05-2026/

## Modelo de acceso

Ningún estudiante necesita cuenta de GitHub ni tiene acceso de escritura al repositorio. Los accesos al laboratorio funcionan por correo electrónico verificado (Supabase Auth).

Cada correo se asigna a un grupo. Las políticas de acceso de la base de datos (RLS) garantizan que los integrantes de un grupo **solo pueden leer y editar el proyecto de su grupo**. El docente autorizado puede leer y editar todos y administrar los integrantes. Los nombres, correos y teléfonos de entrevistados no aparecen en GitHub.

La aplicación **no tiene formularios de subida de archivos**. Los alumnos escriben sus respuestas en campos y pueden descargar un documento **TXT**. El docente puede descargar un **único archivo maestro CSV**, compatible con Excel, que incorpora una fila por grupo y las respuestas de todos los campos. El CSV se genera a petición; el almacenamiento en línea persistente es la base de datos.

## Estado de la instalación

- Front-end publicado en GitHub Pages.
- Pantalla de acceso por correo y editor por diez estaciones.
- Lista de opciones metodológicas y categorías adicionales por grupo.
- Panel docente, administración de grupos y membresías.
- Guardado por campo, suscripción a cambios en tiempo real, exportación TXT y CSV.
- **FALTA activar el servicio Supabase**. Mientras config.js esté vacío, el portal muestra una presentación y no captura respuestas. No presentar esto como una plataforma sincronizada antes de la configuración.

## Activación del servicio (solo docente / administrador)

1. Crear un proyecto Supabase o conectar uno existente y **habilitar acceso por email OTP**.
2. Ejecutar el archivo \`SUPABASE_SETUP.sql\` en SQL Editor. Crea las tablas, funciones y políticas RLS.
3. Registrar el correo del profesor como docente con el comando comentado al final del SQL. Sustituir **TU_CORREO_VERIFICADO** por su correo real.
4. En Authentication > URL Configuration, añadir a las URLs de redirección permitidas \`https://williamsjimenez.github.io/class/cm05-2026/\`.
5. En \`config.js\`, introducir **solo** la URL de proyecto y la clave pública/publishable de Supabase. **Nunca** poner la clave \`service_role\`, contraseñas privadas o datos de estudiantes en GitHub.
6. Entrar al portal con el correo del docente. En **Administrar grupos**, crear los 16 temas y después pegar el JSON del archivo privado \`CM05_2026_integrantes_PRIVADO_importar.json\` que ya se le entregó al docente, para llenar nombres y preguntas iniciales. No subir ese JSON al repositorio.
7. Autorizar los correos de cada estudiante asignándolos a su número de grupo, desde el panel docente.
8. Probar con dos correos de estudiantes de grupos distintos y con el correo del docente. Confirmar que cada estudiante puede editar su grupo y no leer ni editar el de otro. Confirmar que el tablero docente se actualiza y que las descargas TXT y CSV funcionan.

## Para impartir la clase

Los grupos construyen su metodología durante la explicación. El profesor proyecta el tablero en tiempo real, selecciona casos, compara argumentos y retroalimenta. El tablero debe utilizarse en una pantalla del docente; los estudiantes solo ven el proyecto al que pertenecen.

**Advertencia:** la edición simultánea de campos diferentes está contemplada. Si dos personas del mismo grupo escriben *exactamente el mismo campo* al mismo tiempo, queda la última versión guardada; coordinar la escritura de ese campo.

## Datos y privacidad

GitHub Pages ofrece el sitio estático; **no almacena datos personales ni guarda respuestas de los estudiantes**. Los registros quedan en Supabase, protegidos por autenticación y RLS. Para hacer imposible consultar el propio código fuente en GitHub, habría que cambiar la modalidad de alojamiento o publicar desde un repositorio privado compatible; no basta con quitar el enlace de la interfaz. La página actual no muestra enlaces al repositorio.

## Soporte

El código es estático y se encuentra en \`cm05-2026/index.html\`. El servicio necesita la URL/clave pública de un proyecto Supabase propio del curso, o la conexión de la app Supabase desde ChatGPT para completar la configuración. No debe ponerse la clave privada en archivos públicos.
