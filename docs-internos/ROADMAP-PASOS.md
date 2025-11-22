# 🗺️ ROADMAP-PASOS – Desarrollo Paso a Paso

- ⚠️ **IMPORTANTE:** Este archivo es un roadmap interno para desarrollo técnico.
- No forma parte del README público y no será revisado por los jueces del hackathon.
- Su propósito es organizar tareas, prompts y progreso de development.
 
**Guía completa de desarrollo modular para el Hook Anti-Sandwich (Stable Assets)**

Este documento contiene pasos específicos con prompts listos para copiar/pegar a la IA, organizados en fases lógicas.

**Contexto del Hackathon:**
- **Evento:** ETHGlobal Buenos Aires (Nov 2025)
- **Track:** Track 1 - Uniswap v4 Stable-Asset Hooks ($10,000 prize pool)
- **Organizador:** Uniswap Foundation
- **Requisitos de entrega:** TxIDs, GitHub repo, README, demo/instrucciones, video (máx. 3 min)

**Referencias:**
- `.cursor/project-context.md` - Contexto técnico completo
- `.cursor/user-rules.md` - Reglas para el asistente AI
- `docs-internos/hackathon-ethglobal-uniswap.md` - Información del hackathon
- `docs-internos/idea-general.md` - Idea y lógica del hook (NUEVA - Anti-Sandwich)
- `README.md` - Documentación pública

---

## 📋 Sistema de Progreso

- ⚪ **Pendiente** - No iniciado
- 🟡 **En progreso** - Trabajando en ello
- ✅ **Completado** - Funcional y validado
- ❌ **Bloqueado** - Requiere dependencias pendientes

---

## 🎯 Guía de Uso

1. **Sigue las fases en orden** - Cada fase depende de la anterior
2. **Copia el prompt exacto** - Pega directamente a la IA en Cursor
3. **Valida antes de continuar** - Asegúrate de que cada paso funcione
4. **Actualiza el estado** - Marca ⚪→🟡→✅ según avances

---

## 📍 Estado Actual del Proyecto (Resumen Ejecutivo)

### ✅ Completado (4/21 pasos)

1. **Fase 0.1** - Estructura base de carpetas ✅
   - Template oficial de Uniswap v4 ya incluye estructura completa
   - Carpetas: `src/`, `test/`, `script/`, `lib/` configuradas

2. **Fase 0.2** - Configuración Foundry ✅
   - `foundry.toml` configurado (Solidity 0.8.30, EVM Cancun)
   - Dependencias instaladas: Uniswap v4, hookmate, forge-std
   - `.env.example` creado
   - `.cursor/` con project-context.md y user-rules.md actualizados

3. **Fase 4.1** - README actualizado ✅ (parcial)
   - README.md actualizado con nueva idea Anti-Sandwich
   - ⚠️ Pendiente: agregar links a contract addresses (después del deployment)

4. **Fase 1.1** - Estructura base del hook ✅
   - `AntiSandwichHook.sol` creado con estructura completa
   - Storage structure `PoolStorage` con todos los campos necesarios
   - Constantes para pesos del riskScore definidas
   - `getHookPermissions()` configurado
   - Events y placeholders implementados

### 🎯 Próximo Paso Crítico

**Fase 1, Paso 1.2** - Implementar cálculo de riskScore ⚪
- **Acción:** Implementar función `_calculateRiskScore()` en `AntiSandwichHook.sol`
- **Lógica:** riskScore = (W1 * relativeSize) + (W2 * deltaPrice) + (W3 * recentSpikeCount)
- **Manejar:** Edge cases (primera vez, avgTradeSize = 0, overflow protection)

### 📋 Pendiente (18 pasos)

- **Fase 1** (6 pasos): Implementación completa del hook Anti-Sandwich
- **Fase 2** (3 pasos): Testing completo (>80% coverage, incluyendo detección de sandwich)
- **Fase 3** (2 pasos): Deployment a testnet (CRÍTICO: guardar TxIDs)
- **Fase 4** (3 pasos): Demo, video pitch y entregables del hackathon
- **Fase 5** (2 pasos): Optimizaciones opcionales

### ⏱️ Prioridades para Hackathon

1. **URGENTE:** Fase 1 completa (hook funcional con riskScore y fee dinámica)
2. **URGENTE:** Fase 2 básica (tests mínimos funcionales + tests de detección de sandwich)
3. **CRÍTICO:** Fase 3.2 (deployment con TxIDs guardados)
4. **OBLIGATORIO:** Fase 4.3 (video pitch 3 min)
5. **OBLIGATORIO:** Fase 4.4 (checklist de entregables)

---

# FASE 0: Estructura Modularizada Completa

**Objetivo:** Crear toda la estructura de carpetas y archivos orientativos sin código, preparada para escalabilidad.

---

## Paso 0.1: Crear estructura base de carpetas

**Estado:** ✅ **COMPLETADO**

### Estado Actual

✅ **Completado** - El template oficial de Uniswap v4 ya incluye la estructura base:
- `src/` - Contratos (existe Counter.sol como ejemplo)
- `test/` - Tests (existe Counter.t.sol como ejemplo)
- `script/` - Scripts de deployment (existen scripts base)
- `lib/` - Dependencias (Uniswap v4, hookmate, forge-std)

---

## Paso 0.2: Configurar Foundry y dependencias

**Estado:** ✅ **COMPLETADO**

### Estado Actual

✅ **Completado** - Foundry está configurado:
- `foundry.toml` existe y está configurado (Solidity 0.8.30, EVM Cancun)
- Dependencias instaladas: Uniswap v4, hookmate, forge-std
- `.env.example` creado con placeholders
- `.cursor/` creado con project-context.md y user-rules.md (actualizados para Track 1)

---

# FASE 1: Hook Core - Implementación Base

**Objetivo:** Implementar el hook principal con lógica de detección de riesgo y fee dinámica anti-sandwich.

**Nota:** Solo necesitamos `beforeSwap()` y `afterSwap()` para el MVP. Los otros hooks son opcionales.

---

## Paso 1.1: Crear interfaces y base del hook

**Estado:** ✅ **COMPLETADO**

### ¿Qué hacer?

Crear las interfaces necesarias de Uniswap v4 y la estructura base del contrato `AntiSandwichHook.sol` con storage mínimo para detección de sandwich.

### Estado Actual

✅ **Completado** - `AntiSandwichHook.sol` creado con:
- Estructura base heredando de `BaseHook` (OpenZeppelin)
- Storage structure `PoolStorage` con todos los campos necesarios:
  - lastPrice (uint160), lastTradeSize (uint256), avgTradeSize (uint256)
  - recentSpikeCount (uint8)
  - lowRiskFee, mediumRiskFee, highRiskFee (uint24)
  - riskThresholdLow, riskThresholdHigh (uint8)
- Constantes para pesos del riskScore (W1=50, W2=30, W3=20)
- `getHookPermissions()` configurado solo para beforeSwap y afterSwap
- Placeholders para hooks y funciones helper (marcados con TODO)
- Events definidos (PoolConfigUpdated, DynamicFeeApplied, MetricsUpdated)
- Funciones de configuración placeholder (setPoolConfig, getPoolConfig, getPoolMetrics)
- Comentarios NatSpec completos

### ¿Qué pedir a la IA?

```
Crea el contrato base AntiSandwichHook.sol basándote en cursor/project-context.md y docs-internos/idea-general.md., uniswap-LLMs.txt, y revisa el README-INERNO si te sirve algun doc de ahi

Requisitos:
1. Heredar de BaseHook (OpenZeppelin)
2. Implementar interfaces necesarias de Uniswap v4 Hooks
3. Definir storage mínimo para detección de sandwich:
   - lastPrice (uint160) - último precio del pool (sqrtPriceX96)
   - lastTradeSize (uint256) - tamaño del swap previo
   - avgTradeSize (uint256) - promedio dinámico simple de trade sizes
   - recentSpikeCount (uint8) - contador de trades grandes consecutivos
   - lowRiskFee (uint24) - fee para riesgo bajo (default: 5 bps)
   - mediumRiskFee (uint24) - fee para riesgo medio (default: 20 bps)
   - highRiskFee (uint24) - fee para riesgo alto (default: 60 bps)
   - riskThresholdLow (uint8) - umbral bajo de riesgo (default: 50)
   - riskThresholdHigh (uint8) - umbral alto de riesgo (default: 150)
4. Crear funciones hook vacías: beforeSwap(), afterSwap()
5. Implementar getHookPermissions() configurando solo beforeSwap y afterSwap como true
6. Agregar comentarios NatSpec explicando cada función
7. Seguir convenciones de cursor/user-rules.md

Referencias:
- cursor/project-context.md - Sección "Storage Mínimo" y "Estructura de código esperada"
- docs-internos/idea-general.md - Sección "Mecánica técnica exacta"
- Uniswap v4 template oficial para hooks
```

### Dependencias

- Paso 0.1 (estructura creada)
- Paso 0.2 (Foundry configurado)

### Referencias

- `.cursor/project-context.md` - Sección "Storage Mínimo"
- `docs-internos/idea-general.md` - Lógica del hook

---

## Paso 1.2: Implementar cálculo de riskScore

**Estado:** ✅ **COMPLETADO**

### ¿Qué hacer?

Implementar la función `_calculateRiskScore()` que calcula el score de riesgo basado en trade size, delta de precio y spikes consecutivos.

### ¿Qué pedir a la IA?

```
Implementa la función _calculateRiskScore() en AntiSandwichHook.sol.

Lógica requerida:
1. Calcular relativeSize = tradeSize / avgTradeSize
   - Si avgTradeSize es 0 (primera vez), usar tradeSize como base
2. Calcular deltaPrice = abs(P_current - lastPrice)
3. Leer recentSpikeCount del storage
4. Calcular riskScore usando la fórmula:
   riskScore = (w1 * relativeSize) + (w2 * deltaPrice) + (w3 * recentSpikeCount)
   Donde:
   - w1 = 50 (peso del tamaño relativo)
   - w2 = 30 (peso del delta de precio)
   - w3 = 20 (peso de spikes consecutivos)
5. Retornar riskScore (uint8)

Requisitos:
- Función internal view
- Manejar edge cases (primera vez, avgTradeSize = 0, lastPrice = 0)
- Validar que no haya overflow en cálculos
- Comentarios explicando la fórmula y pesos
- Referencia a docs-internos/idea-general.md sección "Cálculo del riskScore"

NO implementar beforeSwap todavía, solo la función interna.
```

### Verificación

✅ **Implementación completada:**
- Función `_calculateRiskScore()` implementada en `src/AntiSandwichHook.sol`
- Manejo de edge cases:
  - `avgTradeSize == 0`: `relativeSize = 1` (primera vez)
  - `lastPrice == 0`: `deltaPriceNormalized = 0` (primera vez)
- Normalización de valores para prevenir overflow:
  - `relativeSize` capado a máximo 10 (10x el promedio)
  - `deltaPrice` normalizado dividiendo por 1e14 y capado a máximo 10
  - `recentSpikeCount` capado a máximo 10
- Fórmula implementada: `riskScore = (W1 * relativeSize) + (W2 * deltaPrice) + (W3 * recentSpikeCount)`
- Clamp final a `uint8` (0-255) para prevenir overflow
- Comentarios explicativos incluidos
- Sin errores de linting

### Dependencias

- Paso 1.1 (contrato base creado)

### Referencias

- `docs-internos/idea-general.md` - Sección "Cálculo del riskScore"
- `.cursor/project-context.md` - Sección "Lógica Core"

---

## Paso 1.3: Implementar cálculo de fee dinámica basada en riskScore

**Estado:** ✅ **COMPLETADO**

### ¿Qué hacer?

Implementar la función `_calculateDynamicFee()` que ajusta la fee según el riskScore calculado.

### ¿Qué pedir a la IA?

```
Implementa la función _calculateDynamicFee() en AntiSandwichHook.sol.

Lógica requerida:
1. Recibir riskScore como parámetro
2. Leer thresholds y fees del storage:
   - riskThresholdLow
   - riskThresholdHigh
   - lowRiskFee
   - mediumRiskFee
   - highRiskFee
3. Aplicar lógica de fee dinámica:
   if (riskScore < riskThresholdLow) {
       fee = lowRiskFee;        // 5 bps
   } else if (riskScore < riskThresholdHigh) {
       fee = mediumRiskFee;     // 20 bps
   } else {
       fee = highRiskFee;       // 60 bps - modo anti-sandwich
   }
4. Retornar fee en basis points (uint24)

Requisitos:
- Función internal view
- Comentarios explicando la lógica de thresholds
- Validar que thresholds y fees estén configurados correctamente
- Referencia a docs-internos/idea-general.md sección "Ajuste de fee dinámico"
```

### Verificación

✅ **Implementación completada:**
- Función `_calculateDynamicFee()` implementada en `src/AntiSandwichHook.sol`
- Lectura de thresholds y fees del storage (`poolStorage[poolId]`)
- Lógica de 3 niveles implementada:
  - **Low risk** (`riskScore < riskThresholdLow`): `lowRiskFee` (default: 5 bps)
  - **Medium risk** (`riskThresholdLow <= riskScore < riskThresholdHigh`): `mediumRiskFee` (default: 20 bps)
  - **High risk** (`riskScore >= riskThresholdHigh`): `highRiskFee` (default: 60 bps - anti-sandwich mode)
- Valores por defecto aplicados si la configuración no existe:
  - `riskThresholdLow = 50` (si no configurado)
  - `riskThresholdHigh = 150` (si no configurado)
  - `lowRiskFee = 5 bps` (si no configurado)
  - `mediumRiskFee = 20 bps` (si no configurado)
  - `highRiskFee = 60 bps` (si no configurado)
- Comentarios explicativos incluidos para cada nivel de riesgo
- Sin errores de linting

### Dependencias

- Paso 1.2 (cálculo de riskScore implementado)

### Referencias

- `docs-internos/idea-general.md` - Sección "Ajuste de fee dinámico"
- `.cursor/project-context.md` - Sección "Lógica Core"

---

## Paso 1.4: Implementar beforeSwap hook

**Estado:** ✅ **COMPLETADO**

### ¿Qué hacer?

Implementar la lógica completa de `beforeSwap()` que calcula riskScore y aplica fee dinámica.

### ¿Qué pedir a la IA?

```
Implementa la función beforeSwap() en AntiSandwichHook.sol.

Lógica requerida:
1. Leer precio actual del pool (sqrtPriceX96) usando poolManager.getSlot0(poolId)
2. Leer tradeSize del SwapParams (amountIn o amountSpecified)
3. Llamar _calculateRiskScore() para obtener riskScore
4. Llamar _calculateDynamicFee() para obtener fee dinámica
5. Retornar (selector, BeforeSwapDelta, fee) según interfaz de Uniswap v4
6. Emitir event DynamicFeeApplied (opcional pero recomendado)

Requisitos:
- Seguir interfaz oficial de Uniswap v4 Hooks
- Manejar edge cases (primera vez, pool sin precio, tradeSize = 0)
- Comentarios NatSpec completos
- Events para logging (DynamicFeeApplied)
- Referencia a cursor/project-context.md sección "Guía para el asistente técnico"

Validar que compile sin errores.
```

### Verificación

✅ **Implementación completada:**
- Función `_beforeSwap()` implementada en `src/AntiSandwichHook.sol`
- Lectura de precio actual usando `poolManager.getSlot0(poolId)` ✅
- Obtención de `tradeSize` desde `params.amountSpecified` (conversión de `int256` a `uint256` con `abs()`) ✅
- Llamada a `_calculateRiskScore(poolId, sqrtPriceX96, tradeSize)` ✅
- Llamada a `_calculateDynamicFee(poolId, riskScore)` ✅
- Retorno correcto: `(selector, BeforeSwapDelta.ZERO_DELTA, dynamicFee)` ✅
- Evento `DynamicFeeApplied` emitido con todas las métricas ✅
- Manejo de edge cases:
  - Pool no inicializado (`sqrtPriceX96 == 0`): retorna fee por defecto
  - `tradeSize == 0`: retorna fee por defecto
- Comentarios NatSpec completos ✅
- Sin errores de linting ✅
- Compila sin errores ✅

### Dependencias

- Paso 1.2 (cálculo de riskScore)
- Paso 1.3 (cálculo de fee)

### Referencias

- `docs-internos/idea-general.md` - Sección "En beforeSwap()"
- Uniswap v4 Hooks documentation

---

## Paso 1.5: Implementar afterSwap hook

**Estado:** ✅ **COMPLETADO**

### ¿Qué hacer?

Implementar `afterSwap()` que actualiza las métricas históricas (lastPrice, avgTradeSize, recentSpikeCount).

### ¿Qué pedir a la IA?

```
Implementa la función afterSwap() en AntiSandwichHook.sol.

Lógica requerida:
1. Leer precio actual del pool después del swap (sqrtPriceX96)
2. Leer tradeSize del SwapParams
3. Actualizar lastPrice = P_current
4. Actualizar avgTradeSize usando promedio móvil simple:
   avgTradeSize = (avgTradeSize * 9 + tradeSize) / 10
   (Si avgTradeSize es 0, usar tradeSize directamente)
5. Calcular relativeSize = tradeSize / avgTradeSize
6. Actualizar recentSpikeCount:
   if (relativeSize > 5) {
       recentSpikeCount++;
   } else {
       recentSpikeCount = 0;  // Reset si no hay spike
   }
7. Retornar selector correcto según interfaz

Requisitos:
- Función crítica para el funcionamiento
- Validar que el precio y tradeSize sean válidos antes de actualizar
- Manejar overflow en cálculos de avgTradeSize
- Comentarios explicando por qué actualizamos aquí
- Referencia a docs-internos/idea-general.md sección "En afterSwap()"

Validar que compile sin errores.
```

### Verificación

✅ **Implementación completada:**
- Función `_afterSwap()` implementada en `src/AntiSandwichHook.sol`
- Lectura de precio actual después del swap usando `poolManager.getSlot0(poolId)` ✅
- Obtención de `tradeSize` desde `params.amountSpecified` (conversión de `int256` a `uint256` con `abs()`) ✅
- Actualización de `lastPrice = sqrtPriceX96` ✅
- Actualización de `avgTradeSize` usando promedio móvil:
  - Si `avgTradeSize == 0`: inicializa con `tradeSize`
  - Si no: `avgTradeSize = (avgTradeSize * 9 + tradeSize) / 10` ✅
- Cálculo de `relativeSize = tradeSize / avgTradeSize` (con manejo de división por cero) ✅
- Actualización de `recentSpikeCount`:
  - Si `relativeSize > SPIKE_THRESHOLD (5)`: incrementa contador (capado a 255)
  - Si no: resetea contador a 0 ✅
- Actualización de `lastTradeSize = tradeSize` ✅
- Evento `MetricsUpdated` emitido con todas las métricas ✅
- Manejo de edge cases:
  - Pool no inicializado (`sqrtPriceX96 == 0`): skip update
  - `tradeSize == 0`: skip update
  - Overflow protection en cálculos de `avgTradeSize` (usando `unchecked` con valores acotados)
  - Cap en `recentSpikeCount` a 255 para prevenir overflow ✅
- Comentarios explicativos sobre por qué actualizamos aquí ✅
- Sin errores de linting ✅
- Compila sin errores ✅

### Dependencias

- Paso 1.4 (beforeSwap implementado)

### Referencias

- `docs-internos/idea-general.md` - Sección "En afterSwap()"

---

## Paso 1.6: Agregar funciones de configuración

**Estado:** ⚪

### ¿Qué hacer?

Agregar funciones para configurar parámetros del hook (fees, thresholds) con control de acceso.

### ¿Qué pedir a la IA?

```
Agrega funciones de configuración a AntiSandwichHook.sol.

Funciones requeridas:
1. setPoolConfig(PoolKey, lowRiskFee, mediumRiskFee, highRiskFee, riskThresholdLow, riskThresholdHigh)
   - Actualizar todos los parámetros de configuración
2. getPoolConfig(PoolId) - view function que retorna todos los parámetros
3. getPoolMetrics(PoolId) - view function que retorna métricas actuales (lastPrice, avgTradeSize, recentSpikeCount)

Requisitos:
- Control de acceso (onlyOwner o similar)
- Validación de parámetros:
   - Fees deben ser > 0 y <= 10000 (100%)
   - lowRiskFee < mediumRiskFee < highRiskFee
   - riskThresholdLow < riskThresholdHigh
- Events para cada cambio de configuración (PoolConfigUpdated)
- Función de inicialización en constructor o setup inicial
- Comentarios NatSpec

Referencias:
- cursor/project-context.md - Sección "Configurabilidad"
- cursor/user-rules.md - Convenciones de código
```

### Dependencias

- Paso 1.5 (afterSwap implementado)

### Referencias

- `.cursor/project-context.md` - Sección "Configurabilidad"

---

# FASE 2: Testing Completo

**Objetivo:** Crear suite completa de tests con >80% coverage, incluyendo tests específicos de detección de sandwich.

---

## Paso 2.1: Setup de testing y tests básicos

**Estado:** ⚪

### ¿Qué hacer?

Configurar ambiente de testing y crear tests básicos para funciones internas.

### ¿Qué pedir a la IA?

```
Crea tests básicos para AntiSandwichHook usando Foundry.

Setup requerido:
1. Crear test/AntiSandwichHook.t.sol
2. Setup de fixtures (mock pool, tokens, etc.)
3. Helper functions para crear pools y ejecutar swaps

Tests iniciales:
1. test_CalculateRiskScore() - verificar cálculo de riskScore con diferentes inputs
2. test_CalculateDynamicFee() - verificar que fee se ajusta según riskScore
3. test_FirstSwap() - verificar comportamiento en primer swap (avgTradeSize = 0)
4. test_RelativeSizeCalculation() - verificar cálculo de relativeSize
5. test_RecentSpikeCountUpdate() - verificar actualización de recentSpikeCount

Requisitos:
- Usar Foundry testing best practices
- Comentarios explicando cada test
- Assertions claras
- Referencia a cursor/user-rules.md - Sección "Testing"

Ejecutar forge test para validar.
```

### Dependencias

- Paso 1.6 (hook completo implementado)

### Referencias

- `.cursor/user-rules.md` - Sección "Testing"
- `.cursor/project-context.md` - Sección "Resultados esperados"

---

## Paso 2.2: Tests de detección de sandwich

**Estado:** ⚪

### ¿Qué hacer?

Crear tests específicos que prueben la detección de patrones de sandwich attack.

### ¿Qué pedir a la IA?

```
Crea tests de detección de sandwich para AntiSandwichHook.

Tests requeridos:
1. test_SandwichPatternDetection() - simular patrón: swap grande → pequeño → grande
2. test_LargeTradeSizeDetection() - verificar que trade 10× mayor que promedio aumenta fee
3. test_ConsecutiveSpikes() - verificar que múltiples spikes consecutivos aumentan riskScore
4. test_PriceJumpDetection() - verificar que saltos bruscos de precio aumentan fee
5. test_NormalSwapLowFee() - verificar que swaps normales mantienen fee baja (5 bps)

Setup:
- Crear pool con tokens estables (mock USDC/USDT)
- Ejecutar secuencia de swaps simulando diferentes escenarios
- Medir fees aplicadas y riskScores

Requisitos:
- Tests en test/sandwich/ o test/integration/
- Comentarios explicando cada patrón de sandwich
- Validar que fee aumenta correctamente cuando se detecta riesgo
- Referencia a docs-internos/idea-general.md sección "Patrón clásico de sandwich"
```

### Dependencias

- Paso 2.1 (tests básicos)

### Referencias

- `docs-internos/idea-general.md` - Sección "Patrón clásico de sandwich"
- `.cursor/project-context.md` - Sección "Casos de uso principales"

---

## Paso 2.3: Tests de integración y edge cases

**Estado:** ⚪

### ¿Qué hacer?

Crear tests de integración con Uniswap v4 y tests de edge cases/seguridad.

### ¿Qué pedir a la IA?

```
Crea tests de integración y edge cases para AntiSandwichHook.

Tests de integración:
1. test_SwapWithHook() - ejecutar swap completo con hook activo
2. test_MultipleSwaps() - verificar comportamiento en múltiples swaps consecutivos
3. test_FeeAppliedCorrectly() - verificar que fee dinámica se aplica en el swap

Tests de edge cases:
1. test_ZeroPrice() - manejo de precio cero
2. test_ZeroTradeSize() - manejo de trade size cero
3. test_OverflowProtection() - verificar protección contra overflow en cálculos
4. test_Reentrancy() - verificar protección contra reentrancy
5. test_AccessControl() - verificar que solo owner puede configurar
6. test_InvalidParameters() - verificar validación de parámetros

Requisitos:
- Tests en test/integration/ y test/unit/
- Usar forge test --fork-url para tests en fork
- Comentarios explicando cada caso
- Validar que no hay vulnerabilidades obvias

Ejecutar forge test --gas-report para análisis de gas.
```

### Dependencias

- Paso 2.2 (tests de detección de sandwich)

### Referencias

- `.cursor/project-context.md` - Sección "Privacidad y seguridad"

---

# FASE 3: Deployment y Scripts

**Objetivo:** Crear scripts de deployment y configurar para testnet/mainnet.

---

## Paso 3.1: Crear script de deployment

**Estado:** ⚪

### ¿Qué hacer?

Crear script de deployment usando Foundry scripts.

### ¿Qué pedir a la IA?

```
Crea script de deployment para AntiSandwichHook usando Foundry.

Script requerido: script/deploy/DeployAntiSandwichHook.s.sol

Funcionalidad:
1. Deploy AntiSandwichHook con parámetros iniciales
2. Configurar parámetros (lowRiskFee, mediumRiskFee, highRiskFee, thresholds)
3. Verificar contrato (opcional, para mainnet)
4. Guardar addresses en archivo o variables de entorno
5. Logging de información de deployment

Requisitos:
- Usar forge script
- Soporte para múltiples networks (Sepolia, Base, Mainnet)
- Variables de entorno para RPC_URL, PRIVATE_KEY
- Comentarios explicando cada paso
- NO hardcodear claves privadas

Referencias:
- cursor/user-rules.md - Sección "Comandos frecuentes del proyecto"
- cursor/project-context.md - Sección "Flujo de ejecución básico"
```

### Dependencias

- Paso 2.3 (tests pasando)

### Referencias

- `.cursor/project-context.md` - Sección "Flujo de ejecución básico"

---

## Paso 3.2: Deployment a testnet

**Estado:** ⚪

### ¿Qué hacer?

Deployar el hook a testnet (Sepolia o Base Sepolia) y validar funcionamiento. **CRÍTICO para hackathon: guardar TxIDs.**

### ¿Qué pedir a la IA?

```
Guíame para deployar AntiSandwichHook a testnet.

Pasos requeridos:
1. Configurar .env con RPC_URL y PRIVATE_KEY de testnet
2. Obtener testnet ETH para gas
3. Ejecutar script de deployment
4. Verificar contrato en explorer
5. Ejecutar tests en fork de testnet para validar
6. Guardar contract address para documentación
7. **GUARDAR TxIDs de deployment** (requisito del hackathon)
8. Ejecutar swap de prueba para validar funcionamiento

Validaciones:
- Contrato deployado correctamente
- Parámetros iniciales configurados
- Hook funciona en testnet
- **TxIDs guardados en archivo o documentación** (requisito obligatorio hackathon)

Referencias:
- cursor/project-context.md - Sección "Requisitos del Hackathon"
- docs-internos/hackathon-ethglobal-uniswap.md - Requisitos de calificación
```

### Dependencias

- Paso 3.1 (script de deployment)

### Referencias

- `docs-internos/hackathon-ethglobal-uniswap.md` - Requisitos de calificación

---

# FASE 4: Documentación y Demo

**Objetivo:** Crear documentación pública y demo funcional para hackathon.

---

## Paso 4.1: Actualizar README con información completa

**Estado:** ✅ **COMPLETADO** (parcial)

### Estado Actual

✅ **Completado parcialmente** - README.md actualizado con:
- Descripción del problema y solución (Anti-Sandwich)
- Instrucciones de instalación y setup
- Comandos de testing
- Arquitectura y cómo funciona
- Información del hackathon (Track 1)

⚠️ **Pendiente**: Agregar links a contract addresses en testnet (después del deployment)

---

## Paso 4.2: Crear demo funcional

**Estado:** ⚪

### ¿Qué hacer?

Crear demo que muestre el hook en acción: swap normal vs swap con hook, comparación de fees, detección de sandwich.

### ¿Qué pedir a la IA?

```
Crea demo funcional para mostrar AntiSandwichHook en acción.

Demo requerido:
1. Script o guía para ejecutar swaps de prueba
2. Comparación visual o numérica:
   - Swap normal vs swap con hook
   - Fee baja (5 bps) vs fee alta (60 bps) cuando se detecta sandwich
   - RiskScore calculado para diferentes escenarios
3. Métricas clave para mostrar a jurados:
   - Detección de patrones de sandwich
   - Reducción de MEV estimada
   - Fee dinámica funcionando
4. Screenshots o logs de transacciones

Formato:
- Script ejecutable (bash o similar)
- Documentación de cómo ejecutar demo
- Output claro mostrando diferencias

Requisitos:
- Fácil de ejecutar
- Resultados claros y medibles
- Preparado para video demo de 3 minutos

Referencias:
- cursor/project-context.md - Sección "Resultados esperados"
- docs-internos/hackathon-ethglobal-uniswap.md - Requisitos de demo
```

### Dependencias

- Paso 4.1 (README actualizado)
- Paso 3.2 (deployment completado)

### Referencias

- `docs-internos/hackathon-ethglobal-uniswap.md` - Requisitos de calificación

---

## Paso 4.3: Crear guión para video pitch

**Estado:** ⚪

### ¿Qué hacer?

Crear guión estructurado para video demo de 3 minutos (inglés con subtítulos). **REQUISITO OBLIGATORIO del hackathon.**

### ¿Qué pedir a la IA?

```
Crea guión completo para video pitch de 3 minutos del Hook Anti-Sandwich.

Estructura requerida:
1. Hook (0-15s) - Problema: Sandwich attacks en stable assets
2. Solución (15-60s) - Cómo funciona: riskScore + fee dinámica
3. Demo (60-150s) - Mostrar hook en acción, métricas, comparación
4. Cierre (150-180s) - Por qué es ganador, sin oráculos, elegante, Track 1

Requisitos:
- Máximo 3 minutos (requisito del hackathon)
- Inglés con subtítulos
- Puntos clave de docs-internos/idea-general.md
- Enfoque en: sin oráculos, simple, efectivo, alineado con Track 1
- Mostrar TxIDs y contract address en explorer
- Preparado para grabación

Referencias:
- docs-internos/idea-general.md - Sección "Resumen en frase para tu pitch"
- cursor/project-context.md - Sección "Requisitos del Hackathon"
- docs-internos/hackathon-ethglobal-uniswap.md - Requisitos de video
```

### Dependencias

- Paso 4.2 (demo funcional)

### Referencias

- `docs-internos/idea-general.md` - Sección "Resumen en frase para tu pitch"
- `docs-internos/hackathon-ethglobal-uniswap.md` - Requisitos de video

---

## Paso 4.4: Checklist de entregables del hackathon

**Estado:** ⚪

### ¿Qué hacer?

Verificar y preparar todos los entregables obligatorios del hackathon.

### ¿Qué pedir a la IA?

```
Crea checklist completo de entregables para ETHGlobal Buenos Aires - Track 1.

Verificar que tenemos:
1. ✅ TxIDs de transacciones (testnet/mainnet) - Guardados en archivo o README
2. ✅ Repositorio GitHub público - Verificar que esté público y accesible
3. ✅ README.md completo - Con instrucciones claras de instalación y uso
4. ✅ Demo funcional o instrucciones - Scripts o guía para ejecutar el hook
5. ✅ Video demo (máx. 3 min) - Subido a YouTube/Vimeo con link en README

Crear archivo HACKATHON_SUBMISSION.md con:
- Links a todas las transacciones (TxIDs)
- Contract addresses deployados
- Link al video demo
- Resumen ejecutivo del proyecto
- Alineación con Track 1 (Stable-Asset Hooks)

Referencias:
- cursor/project-context.md - Sección "Requisitos del Hackathon"
- docs-internos/hackathon-ethglobal-uniswap.md - Requisitos de calificación
```

### Dependencias

- Paso 3.2 (deployment completado)
- Paso 4.1 (README actualizado)
- Paso 4.2 (demo funcional)
- Paso 4.3 (video pitch)

### Referencias

- `.cursor/project-context.md` - Sección "Requisitos del Hackathon"
- `docs-internos/hackathon-ethglobal-uniswap.md` - Requisitos de calificación

---

# FASE 5: Optimización y Mejoras (Opcional)

**Objetivo:** Optimizaciones de gas, mejoras opcionales, preparación para escalabilidad.

---

## Paso 5.1: Optimización de gas

**Estado:** ⚪

### ¿Qué hacer?

Analizar y optimizar gas costs del hook.

### ¿Qué pedir a la IA?

```
Optimiza gas costs de AntiSandwichHook.

Análisis requerido:
1. Ejecutar forge test --gas-report
2. Identificar funciones con mayor gas cost
3. Optimizar storage (pack structs, usar uint8/uint160 donde sea posible)
4. Optimizar cálculos (evitar divisiones, usar bit shifts)
5. Reducir SLOADs (caching de variables)

Requisitos:
- Mantener funcionalidad intacta
- Tests deben seguir pasando
- Documentar optimizaciones realizadas
- Comparar gas antes/después

Referencias:
- cursor/project-context.md - Sección "Gas efficiency"
```

### Dependencias

- Paso 4.3 (pitch preparado)

### Referencias

- `.cursor/project-context.md` - Sección "Notas para escalabilidad futura"

---

## Paso 5.2: Mejoras opcionales (si hay tiempo)

**Estado:** ⚪

### ¿Qué hacer?

Implementar mejoras opcionales mencionadas en project-context.md.

### ¿Qué pedir a la IA?

```
Implementa mejoras opcionales para AntiSandwichHook (si hay tiempo antes del hackathon).

Mejoras posibles (elegir según tiempo disponible):
1. Métricas más sofisticadas (EWMA para avgTradeSize)
2. Events más detallados para analytics
3. Funciones view para consultar métricas históricas
4. Mejoras en configuración (timelock, multi-sig)

Requisitos:
- No romper funcionalidad existente
- Tests deben seguir pasando
- Documentar nuevas features
- Priorizar según impacto vs tiempo

Referencias:
- cursor/project-context.md - Sección "Notas para escalabilidad futura"
```

### Dependencias

- Paso 5.1 (optimización de gas)

### Referencias

- `.cursor/project-context.md` - Sección "Notas para escalabilidad futura"

---

# 📊 Tabla de Progreso

| Fase | Paso | Título | Estado | Notas |
|------|------|--------|--------|-------|
| 0 | 0.1 | Estructura base de carpetas | ✅ | ✅ Completado - Template oficial ya tiene estructura |
| 0 | 0.2 | Configurar Foundry | ✅ | ✅ Completado - foundry.toml configurado, dependencias instaladas |
| 1 | 1.1 | Interfaces y base del hook | ✅ | ✅ Completado - AntiSandwichHook.sol creado con estructura completa |
| 1 | 1.2 | Cálculo de riskScore | ⚪ | Requiere Paso 1.1 |
| 1 | 1.3 | Cálculo de fee dinámica | ⚪ | Requiere Paso 1.2 |
| 1 | 1.4 | Implementar beforeSwap | ⚪ | Requiere Pasos 1.2 y 1.3 |
| 1 | 1.5 | Implementar afterSwap | ⚪ | Requiere Paso 1.4 |
| 1 | 1.6 | Funciones de configuración | ⚪ | Requiere Paso 1.5 |
| 2 | 2.1 | Setup de testing | ⚪ | Requiere Paso 1.6 |
| 2 | 2.2 | Tests de detección de sandwich | ⚪ | Requiere Paso 2.1 - **CRÍTICO** |
| 2 | 2.3 | Tests de integración y edge cases | ⚪ | Requiere Paso 2.2 |
| 3 | 3.1 | Script de deployment | ⚪ | Requiere Paso 2.3 |
| 3 | 3.2 | Deployment a testnet | ⚪ | Requiere Paso 3.1 - **CRÍTICO: Guardar TxIDs** |
| 4 | 4.1 | Actualizar README | ✅ | ✅ Completado parcialmente - Falta info de deployment |
| 4 | 4.2 | Demo funcional | ⚪ | Requiere Paso 3.2 |
| 4 | 4.3 | Guión video pitch | ⚪ | Requiere Paso 4.2 - **REQUISITO OBLIGATORIO** |
| 4 | 4.4 | Checklist entregables hackathon | ⚪ | Requiere Pasos 3.2, 4.1, 4.2, 4.3 - **REQUISITO OBLIGATORIO** |
| 5 | 5.1 | Optimización de gas | ⚪ | Opcional - Requiere Paso 4.3 |
| 5 | 5.2 | Mejoras opcionales | ⚪ | Opcional - Requiere Paso 5.1 |

---

## 📝 Notas Finales

- **Actualiza el estado** de cada paso según avances (⚪→🟡→✅)
- **Valida cada fase** antes de continuar a la siguiente
- **Consulta referencias** cuando tengas dudas
- **Mantén simplicidad** - MVP funcional es la prioridad
- **Enfócate en Track 1** - Stable assets, detección de sandwich, fee dinámica

---

📅 **Última actualización:** 2025-11-22  
👤 **Creado por:** kaream  
🎯 **Versión:** 2.0 (Track 1 - Stable Assets - Anti-Sandwich Hook)
