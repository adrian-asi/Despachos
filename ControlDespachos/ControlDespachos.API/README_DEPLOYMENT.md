# Guía de Despliegue para IIS (ASP.NET Core Web API + SQL Server)

Hola. He restaurado tu solución completa migrando desde Supabase a **SQL Server** nativo con **C# y Entity Framework Core**.

## ¿Qué cambios se hicieron?
1. Se creó una solución formal en C# (`ControlDespachos.sln`) separada en 4 capas (API, Core, Data y Services) para seguir las mejores prácticas.
2. Todo tu modelo de base de datos de Supabase fue convertido a clases de **C# (Entities)** dentro de `ControlDespachos.Core`.
3. Se creó el `ApplicationDbContext` en `ControlDespachos.Data`, listo para mapear dichas tablas a **SQL Server**.
4. Tus archivos del Frontend (`index.html`, imágenes, JS, CSS) fueron movidos a la carpeta `wwwroot` dentro de `ControlDespachos.API`. Ahora **la API es capaz de servir tu frontend directamente**, por lo que podrás alojar todo junto en tu servidor IIS.

---

## Pasos para Configurar y Desplegar en tu IIS

### 1. Configurar la Base de Datos (SQL Server)
1. Abre el archivo `ControlDespachos.API/appsettings.json`.
2. Verás una sección llamada `ConnectionStrings`. Cambia el valor de `DefaultConnection` para que apunte a tu servidor de base de datos SQL Server real (con tu usuario y contraseña).
   ```json
   "DefaultConnection": "Server=TU_SERVIDOR_SQL;Database=ControlDespachosDb;User Id=tu_usuario;Password=tu_password;TrustServerCertificate=True;"
   ```
3. Abre la consola del Administrador de Paquetes en Visual Studio (o la terminal) y ejecuta las migraciones para que Entity Framework cree las tablas por ti automáticamente en tu base de datos:
   - En Visual Studio (Consola del Administrador de Paquetes), asegúrate de que el "Proyecto predeterminado" sea `ControlDespachos.Data`, y que el proyecto de inicio sea `ControlDespachos.API` dando click derecho -> Establecer como proyecto de inicio.
   - Escribe el comando:
     ```powershell
     Add-Migration Inicial_Migracion_SQL
     Update-Database
     ```
   *(También puedes hacerlo desde terminal con `dotnet ef migrations add Inicial -p ControlDespachos.Data -s ControlDespachos.API` y luego `dotnet ef database update -p ControlDespachos.Data -s ControlDespachos.API`)*.

### 2. Preparar el Servidor IIS
1. Instala el **.NET 8.0 Hosting Bundle** en tu servidor web Windows. Es necesario para que IIS entienda aplicaciones ASP.NET Core. 
2. Reinicia IIS abriendo CMD como administrador y escribiendo `iisreset`.

### 3. Publicar el Proyecto
1. Abre la solución `ControlDespachos.sln` en Visual Studio.
2. Haz clic derecho sobre el proyecto **ControlDespachos.API** y selecciona **Publicar** (Publish).
3. Selecciona **Carpeta** y elige una ruta local (por ejemplo `C:\PublicacionDespachos`).
4. Haz clic en Publicar. Todo tu Backend C# y tu Frontend (en `wwwroot`) se exportarán a esta carpeta.

### 4. Configurar el Sitio en IIS
1. Abre el Administrador de IIS.
2. Da clic derecho sobre "Sitios" -> "Agregar sitio web".
3. Nombre del sitio: `ControlDespachosWeb`.
4. Ruta física: La carpeta donde publicaste (`C:\PublicacionDespachos`).
5. Asigna el Puerto deseado (ej. 80 o 8080).
6. **MUY IMPORTANTE**: En los Grupos de Aplicaciones (Application Pools) de IIS, busca el que se creó para tu sitio, dale doble clic y pon su versión de .NET en **"Sin código administrado" / "No Managed Code"**.
7. Reinicia el sitio y navega a `http://localhost:opuerto/`. ¡Verás tu login cargando!

## ¿Y qué falta?
Tu interfaz sigue 100% igual y funcional. Ahora deberás ir reemplazando poco a poco las funciones de JavaScript (Supabase) para que hagan llamadas HTTP estándar (con `fetch` o `axios`) apuntando a los controladores `[ApiController]` de C# que debes crear en el futuro en la carpeta `Controllers`.
