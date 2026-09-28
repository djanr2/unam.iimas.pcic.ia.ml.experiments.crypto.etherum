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
| `experimentos-parametros.xlsx` | Una fila por corrida con sus hiperparámetros y semillas, y los resultados: `idTest`, `RMS_train` y `RMS_val` en escala normalizada 0–1. La hoja `Leyenda` describe el contenido |
| `run_experiments.py` | Script que lanza las corridas del Excel contra el backend (`POST /api/tests`), en lotes, y escribe los resultados en el Excel. Es reanudable |

## Carpetas

### Experimentos principales (objetivo Y = `ETH.close(t)`)

| Carpeta | ID | Activos | Entradas | idDataset | Corridas | idTest | Mejor individuo |
|---|---|---|---|---|---|---|---|
| `01 BTC-XRP-ETH` | A | BTC + XRP + ETH | 107 | 174 | 100 | 1724–1823 | 1318408 |
| `02 BTC-LTC-ETH` | B | BTC + LTC + ETH | 107 | 175 | 100 | 1824–1923 | 1318618 |
| `03 BTC-SOL-ETH` | C | BTC + SOL + ETH | 107 | 176 | 100 | 1924–2023 | 1318818 |

### Controles (objetivo Y)

| Carpeta | ID | Activos | Entradas | idDataset | Corridas | idTest | Mejor individuo |
|---|---|---|---|---|---|---|---|
| `04 ETH` | D | Solo ETH | 35 | 177 | 30 | 2024–2053 | 1318868 |
| `05 BTC-ETH` | E | BTC + ETH | 71 | 178 | 30 | 2054–2083 | 1318928 |
| `06 ETH-XRP` | H | ETH + XRP (sin BTC) | 71 | 179 | 30 | 2084–2113 | 1318978 |
| `07 ETH-LTC` | I | ETH + LTC (sin BTC) | 71 | 180 | 30 | 2114–2143 | 1319072 |
| `08 ETH-SOL` | J | ETH + SOL (sin BTC) | 71 | 181 | 30 | 2144–2173 | 1319098 |

Junto con A, B y C forman un diseño factorial: con o sin BTC, y con o sin un tercer activo.

### Estimación a un paso (objetivo Y+1 = `ETH.close(t+1)`)

Son las subcarpetas `y+1` de las carpetas 01, 02 y 03. Tienen las mismas entradas que su carpeta madre, y el objetivo es el cierre del día siguiente. No incluyen `original.csv`, porque se generan a partir del de la carpeta madre.

| Carpeta | ID | idDataset | Corridas | idTest | Mejor individuo |
|---|---|---|---|---|---|
| `01 BTC-XRP-ETH/y+1` | A+1 | 182 | 100 | 2174–2273 | 1319318 |
| `02 BTC-LTC-ETH/y+1` | B+1 | 183 | 100 | 2274–2373 | 1319514 |
| `03 BTC-SOL-ETH/y+1` | C+1 | 184 | 100 | 2374–2473 | 1319656 |

En estos `test.csv`, las columnas extra `ETH.low` y `ETH.high` contienen los límites de la vela objetivo (t+1).

### Experimento de rezagos (objetivo Y)

Son los mismos datos que D y A, B y C, pero con menos rezagos: solo la vela actual (`lag0`) o la vela actual y el día anterior (`lag1`).

| Carpeta | ID | Activos | Rezagos | Entradas | idDataset | Corridas | idTest | Mejor individuo |
|---|---|---|---|---|---|---|---|---|
| `09 ETH-lag0` | D0 | Solo ETH | t | 5 | 185 | 30 | 2474–2503 | 1319762 |
| `10 ETH-lag1` | D1 | Solo ETH | t, t−1 | 11 | 186 | 30 | 2504–2533 | 1319846 |
| `11 BTC-XRP-ETH-lag0` | A0 | BTC + XRP + ETH | t | 17 | 187 | 100 | 2564–2663 | 1320104 |
| `12 BTC-XRP-ETH-lag1` | A1 | BTC + XRP + ETH | t, t−1 | 35 | 188 | 30 | 2534–2563 | 1319878 |
| `13 BTC-LTC-ETH-lag0` | B0 | BTC + LTC + ETH | t | 17 | 189 | 100 | 2664–2763 | 1320298 |
| `14 BTC-SOL-ETH-lag0` | C0 | BTC + SOL + ETH | t | 17 | 190 | 100 | 2764–2863 | 1320356 |

«Mejor individuo» es el `id_individual` de menor error de validación del dataset, el que se evaluó en test.

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
