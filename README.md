# qa-api-automation-karate

Arquitectura de automatizacion de APIs con [Karate](https://github.com/karatelabs/karate) (Maven + JUnit5).

Incluye como ejemplo la API publica [reqres.in](https://reqres.in) para dejar la estructura
lista para ejecutar. Reemplazar `baseUrl` en `karate-config.js` y los features de `src/test/java/features`
por los de tu propia API.

> **Nota:** el tier gratuito de reqres.in limita a 40 requests/dia por IP. Si al correr la
> suite ves errores `429 rate_limit_exceeded`, es la API de ejemplo (no la arquitectura); espera
> al reset diario o reemplaza `baseUrl` por tu propia API para correr sin limites.

## Estructura

```
src/test/java/
├── karate-config.js          # config central: ambientes, baseUrl, headers, timeouts
├── logback-test.xml          # logging de las corridas
├── features/
│   ├── common/                # features reutilizables (call read(...))
│   │   └── get-token.feature
│   ├── auth/
│   │   └── auth.feature
│   └── users/
│       └── users-crud.feature
└── runners/
    ├── TestRunner.java        # runner maestro (default de "mvn test")
    ├── SmokeRunner.java        # solo @smoke
    ├── UsersRunner.java        # solo el modulo users
    └── AuthRunner.java         # solo el modulo auth
```

Convenciones:
- Un feature por recurso/endpoint agrupado en su carpeta bajo `features/<dominio>`.
- Logica reutilizable (login, generacion de datos, etc.) va en `features/common` y se
  invoca con `call read('classpath:features/common/xxx.feature')`.
- Tags `@smoke` / `@regression` para poder correr subconjuntos de pruebas.
- `@ignore` para features en construccion (no se ejecutan en `TestRunner`).

## Requisitos

- Java 17+
- Maven 3.9+

## Como correr las pruebas

```bash
# Regresion completa (runner maestro), ambiente dev por defecto
mvn test

# Especificar ambiente (dev | qa | prod), definido en karate-config.js
mvn test -Dkarate.env=qa

# Solo smoke tests
mvn test -Dtest=SmokeRunner -Dkarate.env=qa

# Solo un modulo puntual
mvn test -Dtest=UsersRunner
mvn test -Dtest=AuthRunner

# Filtrar por tag Cucumber/Karate en cualquier runner
mvn test -Dkarate.options="--tags @regression" -Dtest=TestRunner
```

## Reportes

Cada corrida (`mvn test`) genera en `target/karate-reports/`:
- `karate-summary.html` – resumen de la corrida con link a cada feature.
- `<feature>.html` – detalle por feature (request/response, logs).
- `<feature>.json` – reporte en formato Cucumber estandar (habilitado via
  `Runner.outputCucumberJson(true)` en los runners), insumo del dashboard consolidado.

Para el dashboard HTML consolidado (todas las features en una sola vista, con
tendencias de build), correr:

```bash
mvn verify -Dkarate.env=qa
```

y abrir `target/cucumber-html-reports/overview-features.html` en el navegador.

## CI

`.github/workflows/karate-tests.yml` corre la suite en cada push/PR a `master` contra el
ambiente `qa` (configurable via `workflow_dispatch`), publica el reporte consolidado como
artefacto descargable y falla el job si alguna prueba falla.

## Extender a una API real

1. Editar `src/test/java/karate-config.js`: actualizar `baseUrl` por ambiente y los headers
   globales (auth, API keys).
2. Crear una carpeta por dominio en `src/test/java/features/<dominio>/` con sus `.feature`.
3. Agregar un runner en `src/test/java/runners/<Dominio>Runner.java` si se quiere poder
   correr ese modulo de forma aislada (no es obligatorio: `TestRunner` ya cubre todo
   `features/**` salvo lo marcado `@ignore`).
4. Reusar autenticacion/setup comun desde `features/common/`.
