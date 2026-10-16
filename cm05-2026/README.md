# CM05 · Laboratorio de Diseño Metodológico — acceso sin registro (2026)

**Sitio:** https://williamsjimenez.github.io/class/cm05-2026/

## Entrada directa y simultánea

Cada grupo tiene un enlace privado diferente. El profesor recibe los 17 enlaces en el archivo local **CM05_ENLACES_PRIVADOS_2026.txt**: uno exclusivo del docente y uno por cada grupo. **No publicar este archivo en GitHub ni compartir el enlace docente**. La mera posesión de un enlace otorga acceso al trabajo correspondiente; los enlaces son credenciales compartidas, no identificación personal.

Al abrir un enlace, el sitio almacena temporalmente la clave en la sesión del navegador, la elimina de la barra de direcciones y abre directamente el trabajo. No se solicita correo, contraseña, enlace de un solo uso ni cuenta de GitHub. El enlace base sin clave no muestra datos de los grupos.

Cada grupo solo puede leer o escribir su proyecto. Esto se aplica en la **base de datos mediante políticas RLS de PostgreSQL**, basadas en el hash SHA-256 de la clave privada del enlace; no solo en la apariencia del navegador. El docente dispone de un enlace con acceso a todos los grupos.

Los datos privados quedan en Supabase. GitHub Pages solo contiene código y categorías de metodología, nunca claves de acceso ni integrantes.

## Funciones

- 16 grupos precargados con sus temas, integrantes y preguntas provisionales.
- Diez estaciones de construcción de diseño metodológico, categorías preestablecidas y campos abiertos para categorías propias.
- Guardado automático por campo. Dos personas del mismo grupo pueden editar secciones distintas. Si escriben **simultáneamente en el mismo campo**, el último guardado prevalece.
- Actualización de la vista docente cada 6 segundos y de los grupos cada 9 segundos; es una aproximación a tiempo real mediante consulta periódica, no sincronización instantánea de pulsaciones.
- Los estudiantes descargan TXT. No pueden subir archivos.
- El docente edita datos de grupos, revisa proyectos y descarga un único CSV compatible con Excel que incluye todos los avances.
- El docente puede crear grupos nuevos; el sitio descarga su enlace privado en TXT.

## Privacidad y precauciones

No existe una autenticación individual del estudiante. Por tanto, **cualquiera que reciba o encuentre el enlace de un grupo podrá leer y modificar su información**. Distribuir cada enlace solo a los integrantes correspondientes y nunca publicar los enlaces ni el TXT privado del profesor. Si un enlace se comparte accidentalmente, se debe revocar y generar uno nuevo antes de continuar trabajando.

Los datos de contacto de expertos y los nombres de estudiantes deben quedar exclusivamente en Supabase y en las descargas privadas.

El antiguo flujo de acceso con correo del repositorio ya no se usa en esta interfaz.

## Verificación realizada

Se verificó mediante consultas SQL simulando peticiones anónimas que el enlace del grupo 1 ve únicamente su grupo, un enlace inválido no ve ninguno y el enlace docente permite ver los 16. El despliegue de GitHub Pages terminó correctamente. **No se ha completado aún una prueba real de carga con los 16 grupos conectados al mismo tiempo**.

## Soporte

El sitio se encuentra en `cm05-2026/index.html` y la URL pública/clave de publicación Supabase en `cm05-2026/config.js`. Los permisos del servidor se gestionan desde Supabase. No publicar contraseñas, enlaces privados o claves administrativas.
