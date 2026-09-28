# Paquete de despliegue — ML Multivariate

Esta carpeta contiene todo lo necesario para levantar la aplicación completa
(backend, frontend y base de datos) con un solo comando, usando Docker. Solo
incluye los **ejecutables ya compilados** (jar de Spring Boot, build estático
de Angular y scripts SQL) — no el código fuente ni las herramientas de build
(Maven/Node) son necesarias en la máquina destino.

## Contenido

```
app-container/
├── backend/
│   └── backend-ml-multivariate.jar   # Jar ejecutable de Spring Boot
├── frontend/
│   └── browser/                      # Build estático de producción de Angular
├── database/
│   ├── 01_init_schema.sql            # Script de creación de esquema/tablas (se ejecuta automáticamente)
│   └── tables_reference/             # Copia de referencia de las tablas individuales (no se ejecuta)
├── docker/
│   ├── backend.Dockerfile
│   ├── frontend.Dockerfile
│   └── nginx.conf
├── docker-compose.yml
├── .env                               # Variables de configuración (opcional, ver nota abajo)
└── README.md
```

## Requisitos

- Docker Desktop (incluye Docker Compose) instalado en la máquina. Nada más:
  no se requiere Java, Node ni PostgreSQL instalados localmente.

## Uso

Desde esta carpeta (`app-container/`):

```bash
docker compose up --build
```

Esto construye las imágenes de backend y frontend a partir de los ejecutables
ya incluidos, descarga la imagen oficial de PostgreSQL, inicializa la base de
datos con el esquema del proyecto y levanta los tres servicios.

Una vez arriba:

- Frontend: http://localhost:4200
- Backend (API): http://localhost:8080

Para detener todo (conserva los datos de la base de datos):

```bash
docker compose down
```

Para volver a encenderlo después, ya sin reconstruir (arranque rápido):

```bash
docker compose up -d
```

`-d` lo corre en segundo plano; si se omite, se queda mostrando los logs en
la terminal. Solo hace falta volver a usar `--build` si se reemplazan los
ejecutables dentro de `app-container/` (ver "Regenerar los ejecutables" más
abajo).

Para detener y borrar también los datos de la base de datos (reinicio limpio):

```bash
docker compose down -v
```

## Nota sobre `.env`

El archivo `.env` está incluido con valores por defecto, pero el `.gitignore`
del repositorio ignora cualquier archivo `.env` (por buena práctica, ya que
normalmente ahí van credenciales). Esto significa que **no viajará al
clonar el repositorio**. No es un problema: `docker-compose.yml` ya trae los
mismos valores como valores por defecto (`ml_multivariate_db` / `postgres` /
`12345`, puertos `8080` y `4200`), así que `docker compose up --build`
funciona igual sin necesidad de ese archivo. Si se quiere personalizar algo,
basta con crear un `.env` en esta carpeta con las variables que se deseen
sobreescribir.

## Notas importantes

- **Puerto del backend (8080):** la URL del API ya quedó incluida dentro del
  build de Angular en tiempo de compilación (`http://localhost:8080`). Si se
  cambia `BACKEND_PORT` en `.env`, el frontend dejará de encontrar el backend
  a menos que se regenere el build de Angular con la nueva URL. Se recomienda
  dejar `BACKEND_PORT=8080`.
- **Credenciales de base de datos:** definidas en `.env` (`POSTGRES_USER`,
  `POSTGRES_PASSWORD`, `POSTGRES_DB`). Deben coincidir con lo que el backend
  usa por defecto (usuario `postgres`, contraseña `12345`, base de datos
  `ml_multivariate_db`); si se cambian, el backend no podrá conectarse salvo
  que también se actualicen sus variables de entorno en `docker-compose.yml`.
- **Persistencia:** los datos de PostgreSQL se guardan en un volumen Docker
  (`db_data`), por lo que sobreviven a reinicios (`docker compose restart` /
  `docker compose up` posteriores) mientras no se use `down -v`.