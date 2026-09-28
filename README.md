# Experimentos: modelos polinómicos multivariados para el cierre de ETH

Datos y configuración de los experimentos de la tesis *Evolutionary Algorithm for Polynomial Model Optimization Applied to Multivariate Analysis of Digital Assets*. Cada carpeta numerada corresponde a un dataset. Sobre cada uno, el algoritmo híbrido FAA + EGA obtiene polinomios que estiman el precio de cierre diario de Ethereum (`ETH.close`).

## Datos comunes a todas las carpetas

- **Fuente:** velas diarias de ETH, BTC, XRP, LTC y SOL, del 31 dic 2025 al 1 sep 2026.
- **Atributos por activo:** `high`, `low`, `volume`, `numberOfTrades`, `takerBuyBaseAssetVolume` y `close`. No se incluye `open`, porque coincide prácticamente con `close(t−1)`.
- **Instantes:** vela actual (sin sufijo) y rezagos `_1` a `_5` (t−1 a t−5), salvo en las carpetas del experimento de rezagos (09–14).
- **Variable objetivo:** siempre la **última columna**, `ETH.close`.
- **Partición cronológica:**
  - Entrenamiento + validación: 1 ene – 31 jul 2026 (212 registros). El algoritmo usa el 70% inicial para entrenar (148 registros, hasta el 28 may) y el 30% final para validar (64 registros, 29 may – 31 jul).
  - Test: 1 – 31 ago 2026 (31 registros), fuera de muestra.

## Estructura de cada carpeta

| Archivo | Contenido |
|---|---|
| `original.csv` | Serie completa (31 dic 2025 – 1 sep 2026) con los atributos y rezagos del dataset. Es la fuente de los demás archivos |
| `training-validation.csv` | Registros del 1 ene al 31 jul 2026, sin modificar. Es el archivo que se registra en el backend |
| `[NN] … .csv` | Copia idéntica de `training-validation.csv` con el nombre con que se registró en el backend |
| `test.csv` | Registros del 1 al 31 ago 2026. Lleva al final dos columnas extra, `ETH.low` y `ETH.high`, que la interfaz usa para dibujar el rango real del día. No son entradas del modelo |
| `experimentos-parametros.xlsx` | Una fila por corrida con sus hiperparámetros y semillas, y los resultados: `idTest`, `RMS_train` y `RMS_val` en escala normalizada 0–1. La hoja `Leyenda` describe el contenido. Los valores de `idDataset` e `idTest` corresponden a la instalación donde se ejecutaron los experimentos: en otro equipo, `idDataset` debe sustituirse por el id asignado al registrar el dataset, y `idTest` y los resultados se generan de nuevo |
| `run_experiments.py` | Script que lanza las corridas del Excel contra el backend (`POST /api/tests`), en lotes, y escribe los resultados en el Excel. Es reanudable |

## Carpetas

### Experimentos principales (objetivo Y = `ETH.close(t)`)

| Carpeta | ID | Activos | Entradas | Corridas |
|---|---|---|---|---|
| `01 BTC-XRP-ETH` | A | BTC + XRP + ETH | 107 | 100 |
| `02 BTC-LTC-ETH` | B | BTC + LTC + ETH | 107 | 100 |
| `03 BTC-SOL-ETH` | C | BTC + SOL + ETH | 107 | 100 |

### Controles (objetivo Y)

| Carpeta | ID | Activos | Entradas | Corridas |
|---|---|---|---|---|
| `04 ETH` | D | Solo ETH | 35 | 30 |
| `05 BTC-ETH` | E | BTC + ETH | 71 | 30 |
| `06 ETH-XRP` | H | ETH + XRP (sin BTC) | 71 | 30 |
| `07 ETH-LTC` | I | ETH + LTC (sin BTC) | 71 | 30 |
| `08 ETH-SOL` | J | ETH + SOL (sin BTC) | 71 | 30 |

Junto con A, B y C forman un diseño factorial: con o sin BTC, y con o sin un tercer activo.

### Estimación a un paso (objetivo Y+1 = `ETH.close(t+1)`)

Son las subcarpetas `y+1` de las carpetas 01, 02 y 03. Tienen las mismas entradas que su carpeta madre, y el objetivo es el cierre del día siguiente. No incluyen `original.csv`, porque se generan a partir del de la carpeta madre.

| Carpeta | ID | Activos | Entradas | Corridas |
|---|---|---|---|---|
| `01 BTC-XRP-ETH/y+1` | A+1 | BTC + XRP + ETH | 107 | 100 |
| `02 BTC-LTC-ETH/y+1` | B+1 | BTC + LTC + ETH | 107 | 100 |
| `03 BTC-SOL-ETH/y+1` | C+1 | BTC + SOL + ETH | 107 | 100 |

En estos `test.csv`, las columnas extra `ETH.low` y `ETH.high` contienen los límites de la vela objetivo (t+1).

### Experimento de rezagos (objetivo Y)

Son los mismos datos que D y A, B y C, pero con menos rezagos: solo la vela actual (`lag0`) o la vela actual y el día anterior (`lag1`).

| Carpeta | ID | Activos | Rezagos | Entradas | Corridas |
|---|---|---|---|---|---|
| `09 ETH-lag0` | D0 | Solo ETH | t | 5 | 30 |
| `10 ETH-lag1` | D1 | Solo ETH | t, t−1 | 11 | 30 |
| `11 BTC-XRP-ETH-lag0` | A0 | BTC + XRP + ETH | t | 17 | 100 |
| `12 BTC-XRP-ETH-lag1` | A1 | BTC + XRP + ETH | t, t−1 | 35 | 30 |
| `13 BTC-LTC-ETH-lag0` | B0 | BTC + LTC + ETH | t | 17 | 100 |
| `14 BTC-SOL-ETH-lag0` | C0 | BTC + SOL + ETH | t | 17 | 100 |

## Configuración de las corridas

Todas las carpetas usan la **misma lista de combinaciones de hiperparámetros y semillas** (diseño pareado). Los datasets de 100 corridas usan las 100 combinaciones, y los de 30 corridas, las 30 primeras. Así, las diferencias entre carpetas se deben al conjunto de variables y no a la configuración del algoritmo.

| Parámetro | Valor |
|---|---|
| `numTerm` | 9 (fijo) |
| `powerL` | 3–6 (grado máximo L = 5, 7, 9, 11) |
| `numGeneration` | 15–50 |
| `numIndividual` | 20–50 |
| `crossRate` | 0.6–1.0 |
| `mutationRate` | 0.1–0.7 |
| `quasiMinmax` / `trainingRate` / `regularizationFactor` | 0.0 / 70 / 1e-7 |
| `seedDataset` | 20260101 (no altera la partición, que es cronológica) |
| `seedEga`, `seedFaa` | Enteros distintos por corrida, en ±2^47 |

Las combinaciones se generaron por muestreo Latin Hypercube con semilla maestra fija, por lo que son reproducibles.

## Notas

- En los archivos `training-validation.csv` de Y+1, el objetivo de la última fila (31 jul) es el cierre del 1 de agosto, que pertenece al periodo de test.
- No abras y guardes los CSV con Excel: redondea las columnas con notación científica (por ejemplo, volúmenes de XRP) a 3 cifras significativas. Si hace falta, se regeneran recortando `original.csv` por fechas.
- `run_experiments.py` requiere el backend de la aplicación y su base de datos PostgreSQL. La URL de la API y la cadena de conexión están definidas al inicio del script.
