# 🗺️ ROADMAP-PASOS – Desarrollo Paso a Paso

> **Guía completa de desarrollo modular para el Hook Anti-LVR**

Este documento contiene pasos específicos con prompts listos para copiar/pegar a la IA, organizados en fases lógicas.

**Contexto del Hackathon:**
- **Evento:** ETHGlobal Buenos Aires (Nov 2025)
- **Track:** Track 2 - Uniswap v4 Volatile-Pairs Hooks ($10,000 prize pool)
- **Organizador:** Uniswap Foundation
- **Requisitos de entrega:** TxIDs, GitHub repo, README, demo/instrucciones, video (máx. 3 min)

**Referencias:**
- `cursor/project-context.md` - Contexto técnico completo
- `cursor/user-rules.md` - Reglas para el asistente AI
- `docs-internos/hackathon-ethglobal-uniswap.md` - Información del hackathon
- `docs-internos/idea-general.md` - Idea y lógica del hook
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

### ✅ Completado (3/21 pasos)

1. **Fase 0.1** - Estructura base de carpetas ✅
   - Template oficial de Uniswap v4 ya incluye estructura completa
   - Carpetas: `src/`, `test/`, `script/`, `lib/` configuradas

2. **Fase 0.2** - Configuración Foundry ✅
   - `foundry.toml` configurado (Solidity 0.8.30, EVM Cancun)
   - Dependencias instaladas: Uniswap v4, hookmate, forge-std
   - `.env.example` creado
   - `.cursor/` con project-context.md y user-rules.md

3. **Fase 4.1** - README actualizado ✅ (parcial)
   - README.md con documentación completa del MVP
   - ⚠️ Pendiente: agregar links a contract addresses (después del deployment)

### 🎯 Próximo Paso Crítico

**Fase 1, Paso 1.1** - Crear interfaces y base del hook ⚪
- **Acción:** Crear `src/AntiLVRHook.sol`
- **Basarse en:** `Counter.sol` del template como referencia
- **Implementar:** Estructura base con storage mínimo
- **Configurar:** `getHookPermissions()` para beforeSwap y afterSwap

### 📋 Pendiente (18 pasos)

- **Fase 1** (6 pasos): Implementación completa del hook Anti-LVR
- **Fase 2** (3 pasos): Testing completo (>80% coverage)
- **Fase 3** (2 pasos): Deployment a testnet (CRÍTICO: guardar TxIDs)
- **Fase 4** (3 pasos): Demo, video pitch y entregables del hackathon
- **Fase 5** (2 pasos): Optimizaciones opcionales

### ⏱️ Prioridades para Hackathon

1. **URGENTE:** Fase 1 completa (hook funcional)
2. **URGENTE:** Fase 2 básica (tests mínimos funcionales)
3. **CRÍTICO:** Fase 3.2 (deployment con TxIDs guardados)
4. **OBLIGATORIO:** Fase 4.3 (video pitch 3 min)
5. **OBLIGATORIO:** Fase 4.4 (checklist de entregables)

---

# FASE 0: Estructura Modularizada Completa

**Objetivo:** Crear toda la estructura de carpetas y archivos orientativos sin código, preparada para escalabilidad.

---

## Paso 0.1: Crear estructura base de carpetas

**Estado:** ✅ **COMPLETADO**

### ¿Qué hacer?

Crear la estructura completa de carpetas del proyecto basada en `cursor/project-context.md`, incluyendo:
- Carpetas para contratos, tests, scripts
- Carpetas para futuras funcionalidades (governance, oráculos opcionales, dashboard)
- READMEs orientativos en cada carpeta

### Estado Actual

✅ **Completado** - El template oficial de Uniswap v4 ya incluye la estructura base:
- `src/` - Contratos (existe Counter.sol como ejemplo)
- `test/` - Tests (existe Counter.t.sol como ejemplo)
- `script/` - Scripts de deployment (existen scripts base)
- `lib/` - Dependencias (Uniswap v4, hookmate, forge-std)

### ¿Qué pedir a la IA?

```
Crea la estructura completa de carpetas para el proyecto Hook Anti-LVR basándote en cursor/project-context.md.

Estructura requerida:
- contracts/hooks/ (hook principal)
- contracts/interfaces/ (interfaces Uniswap v4)
- contracts/libraries/ (librerías auxiliares)
- contracts/governance/ (futuro: governance para parámetros)
- test/unit/ (tests unitarios)
- test/integration/ (tests de integración)
- test/fork/ (tests en fork)
- script/deploy/ (scripts de deployment)
- script/utils/ (utilidades)
- docs/api/ (documentación de API futura)
- docs/architecture/ (documentación de arquitectura)

En cada carpeta, crea un README.md orientativo que explique:
- Qué va en esta carpeta
- Qué archivos se crearán aquí
- Referencias a project-context.md cuando corresponda

NO crear archivos de código todavía, solo estructura y READMEs.
```

### Dependencias

- Ninguna (es el primer paso)

### Referencias

- `cursor/project-context.md` - Sección "Organización del proyecto"

---

## Paso 0.2: Configurar Foundry y dependencias

**Estado:** ✅ **COMPLETADO**

### ¿Qué hacer?

Configurar Foundry, crear `foundry.toml`, e instalar dependencias de Uniswap v4.

### Estado Actual

✅ **Completado** - Foundry está configurado:
- `foundry.toml` existe y está configurado (Solidity 0.8.30, EVM Cancun)
- Dependencias instaladas: Uniswap v4, hookmate, forge-std
- `.env.example` creado con placeholders
- `.cursor/` creado con project-context.md y user-rules.md

### ¿Qué pedir a la IA?

```
Configura Foundry para el proyecto Hook Anti-LVR.

Tareas:
1. Crear foundry.toml con configuración para Solidity ^0.8.0
2. Crear .gitmodules para dependencias (si aplica)
3. Crear script de instalación de dependencias
4. Instalar Uniswap v4 contracts usando forge install
5. Crear .env.example con placeholders para RPC_URL, PRIVATE_KEY, etc.

Referencias:
- cursor/project-context.md - Stack de tecnologías
- cursor/user-rules.md - Comandos frecuentes

NO implementar código todavía, solo configuración.
```

### Dependencias

- Paso 0.1 (estructura creada)

### Referencias

- `cursor/project-context.md` - Sección "Stack de tecnologías"
- `cursor/user-rules.md` - Sección "Comandos frecuentes del proyecto"

---

# FASE 1: Hook Core - Implementación Base

**Objetivo:** Implementar el hook principal con lógica de precio amortiguado y fee dinámica básica.

**Nota sobre hooks:** `idea-general.md` menciona `beforeInitialize()` y `beforeModifyPosition()`, pero para el MVP solo necesitamos `beforeSwap()` y `afterSwap()`. Los otros hooks son opcionales y pueden agregarse después si se necesita funcionalidad adicional.

---

## Paso 1.1: Crear interfaces y base del hook

**Estado:** ⚪ **PRÓXIMO PASO** 🎯

### ¿Qué hacer?

Crear las interfaces necesarias de Uniswap v4 y la estructura base del contrato `AntiLVRHook.sol` con storage mínimo.

### Estado Actual

⚪ **Pendiente** - Solo existe `Counter.sol` (ejemplo del template).  
**Necesitas crear `AntiLVRHook.sol`** basado en la estructura del template pero con la lógica del hook Anti-LVR.

### ¿Qué pedir a la IA?

```
Crea el contrato base AntiLVRHook.sol basándote en cursor/project-context.md.

Requisitos:
1. Heredar de BaseHook (o equivalente de Uniswap v4)
2. Implementar interfaces necesarias de Uniswap v4 Hooks
3. Definir storage mínimo:
   - lastPrice (uint256) - último precio del pool
   - baseFee (uint256) - fee base en basis points
   - volatilityMultiplier (uint256) - multiplicador de volatilidad
   - volatilityThreshold (uint256) - umbral para aplicar amortiguación
4. Crear funciones hook vacías: beforeSwap(), afterSwap()
5. Implementar getHookPermissions() configurando solo beforeSwap y afterSwap como true
6. Agregar comentarios NatSpec explicando cada función
7. Seguir convenciones de cursor/user-rules.md

Nota: beforeInitialize() y beforeModifyPosition() mencionados en idea-general.md son opcionales.
Para el MVP, solo necesitamos beforeSwap() y afterSwap() que son suficientes para la funcionalidad core.

Referencias:
- cursor/project-context.md - Sección "Estructura de código esperada"
- docs-internos/idea-general.md - Sección "Objetivo" (menciona hooks opcionales)
- Uniswap v4 template oficial para hooks
```

### Dependencias

- Paso 0.1 (estructura creada)
- Paso 0.2 (Foundry configurado)

### Referencias

- `cursor/project-context.md` - Sección "Estructura de código esperada"
- `docs-internos/idea-general.md` - Lógica del hook

---

## Paso 1.2: Implementar cálculo de precio amortiguado

**Estado:** ⚪

### ¿Qué hacer?

Implementar la función `_calculateAmortizedPrice()` que suaviza el precio usando el histórico.

### ¿Qué pedir a la IA?

```
Implementa la función _calculateAmortizedPrice() en AntiLVRHook.sol.

Lógica requerida:
1. Leer precio actual del pool (sqrtPriceX96)
2. Comparar con lastPrice almacenado
3. Calcular delta = abs(P_current - lastPrice)
4. Si delta > volatilityThreshold:
   - Calcular P_effective = (P_current + lastPrice) / 2
   - Retornar P_effective
5. Si delta <= volatilityThreshold:
   - Retornar P_current (sin amortiguación)

Requisitos:
- Función internal pure/view según corresponda
- Comentarios explicando la matemática
- Manejo de edge cases (primera vez, lastPrice = 0)
- Referencia a docs-internos/idea-general.md sección "Cómo funciona"

NO implementar beforeSwap todavía, solo la función interna.
```

### Dependencias

- Paso 1.1 (contrato base creado)

### Referencias

- `docs-internos/idea-general.md` - Sección "Cómo funciona (simple)"
- `cursor/project-context.md` - Sección "Funcionalidades por módulo"

---

## Paso 1.3: Implementar cálculo de fee dinámica

**Estado:** ⚪

### ¿Qué hacer?

Implementar la función `_calculateDynamicFee()` que ajusta la fee según volatilidad.

### ¿Qué pedir a la IA?

```
Implementa la función _calculateDynamicFee() en AntiLVRHook.sol.

Lógica requerida:
1. Calcular delta = abs(P_current - lastPrice)
2. Calcular volatilityFee = baseFee + (delta * volatilityMultiplier)
3. Aplicar límites: minFee <= volatilityFee <= maxFee
4. Retornar fee en basis points

Parámetros:
- baseFee: fee base (ej: 5 bps = 0.05%)
- volatilityMultiplier: multiplicador (ajustable)
- minFee: fee mínima (ej: 5 bps)
- maxFee: fee máxima (ej: 50 bps)

Requisitos:
- Función internal view
- Comentarios explicando la fórmula
- Validación de parámetros
- Referencia a docs-internos/idea-general.md sección "Fee dinámico simple"
```

### Dependencias

- Paso 1.2 (cálculo de precio implementado)

### Referencias

- `docs-internos/idea-general.md` - Sección "Fee dinámico simple (pero ganador)"
- `cursor/project-context.md` - Sección "Funcionalidades por módulo"

---

## Paso 1.4: Implementar beforeSwap hook

**Estado:** ⚪

### ¿Qué hacer?

Implementar la lógica completa de `beforeSwap()` que aplica precio amortiguado y fee dinámica.

### ¿Qué pedir a la IA?

```
Implementa la función beforeSwap() en AntiLVRHook.sol.

Lógica requerida:
1. Leer precio actual del pool (sqrtPriceX96)
2. Llamar _calculateAmortizedPrice() para obtener precio amortiguado
3. Llamar _calculateDynamicFee() para obtener fee dinámica
4. Aplicar precio amortiguado al swap (si corresponde según Uniswap v4 API)
5. Aplicar fee dinámica al swap
6. Retornar selector correcto (bytes4)

Requisitos:
- Seguir interfaz oficial de Uniswap v4 Hooks
- Manejar edge cases (primera vez, pool sin precio)
- Comentarios NatSpec completos
- Events para logging (opcional pero recomendado)
- Referencia a cursor/project-context.md sección "Guía para el asistente técnico"

Validar que compile sin errores.
```

### Dependencias

- Paso 1.2 (cálculo de precio)
- Paso 1.3 (cálculo de fee)

### Referencias

- `docs-internos/idea-general.md` - Sección "En beforeSwap lees"
- Uniswap v4 Hooks documentation

---

## Paso 1.5: Implementar afterSwap hook

**Estado:** ⚪

### ¿Qué hacer?

Implementar `afterSwap()` que actualiza el `lastPrice` después de cada swap.

### ¿Qué pedir a la IA?

```
Implementa la función afterSwap() en AntiLVRHook.sol.

Lógica requerida:
1. Leer precio actual del pool después del swap (sqrtPriceX96)
2. Actualizar lastPrice = P_current
3. Retornar selector correcto (bytes4)

Requisitos:
- Función simple pero crítica para el funcionamiento
- Validar que el precio sea válido antes de actualizar
- Comentarios explicando por qué actualizamos aquí
- Referencia a docs-internos/idea-general.md sección "En afterSwap actualizas el storage"

Validar que compile sin errores.
```

### Dependencias

- Paso 1.4 (beforeSwap implementado)

### Referencias

- `docs-internos/idea-general.md` - Sección "En afterSwap actualizas el storage"

---

## Paso 1.6: Agregar funciones de configuración

**Estado:** ⚪

### ¿Qué hacer?

Agregar funciones para configurar parámetros del hook (baseFee, volatilityMultiplier, etc.) con control de acceso.

### ¿Qué pedir a la IA?

```
Agrega funciones de configuración a AntiLVRHook.sol.

Funciones requeridas:
1. setBaseFee(uint256 newBaseFee) - actualizar fee base
2. setVolatilityMultiplier(uint256 newMultiplier) - actualizar multiplicador
3. setVolatilityThreshold(uint256 newThreshold) - actualizar umbral
4. getConfig() - view function que retorna todos los parámetros

Requisitos:
- Control de acceso (onlyOwner o similar)
- Validación de parámetros (ej: baseFee > 0, maxFee >= baseFee)
- Events para cada cambio de configuración
- Función de inicialización en constructor
- Comentarios NatSpec

Referencias:
- cursor/project-context.md - Sección "Notas para escalabilidad futura"
- cursor/user-rules.md - Convenciones de código
```

### Dependencias

- Paso 1.5 (afterSwap implementado)

### Referencias

- `cursor/project-context.md` - Sección "Configurabilidad"

---

# FASE 2: Testing Completo

**Objetivo:** Crear suite completa de tests con >80% coverage.

---

## Paso 2.1: Setup de testing y tests básicos

**Estado:** ⚪

### ¿Qué hacer?

Configurar ambiente de testing y crear tests básicos para funciones internas.

### ¿Qué pedir a la IA?

```
Crea tests básicos para AntiLVRHook usando Foundry.

Setup requerido:
1. Crear test/AntiLVRHook.t.sol
2. Setup de fixtures (mock pool, tokens, etc.)
3. Helper functions para crear pools y ejecutar swaps

Tests iniciales:
1. test_CalculateAmortizedPrice() - verificar cálculo de precio amortiguado
2. test_CalculateDynamicFee() - verificar cálculo de fee dinámica
3. test_FirstSwap() - verificar comportamiento en primer swap (lastPrice = 0)
4. test_NoSmoothingWhenDeltaSmall() - verificar que no se amortigua si delta < threshold

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

- `cursor/user-rules.md` - Sección "Testing"
- `cursor/project-context.md` - Sección "Resultados esperados"

---

## Paso 2.2: Tests de integración con Uniswap v4

**Estado:** ⚪

### ¿Qué hacer?

Crear tests de integración que prueben el hook con pools reales de Uniswap v4.

### ¿Qué pedir a la IA?

```
Crea tests de integración para AntiLVRHook con Uniswap v4.

Tests requeridos:
1. test_SwapWithHook() - ejecutar swap completo con hook activo
2. test_PriceSmoothingEffect() - verificar que precio se amortigua correctamente
3. test_DynamicFeeApplied() - verificar que fee aumenta con volatilidad
4. test_MultipleSwaps() - verificar comportamiento en múltiples swaps consecutivos
5. test_LVRReduction() - comparar LVR antes/después del hook (métrica clave)

Setup:
- Usar fork de testnet o mainnet
- Crear pool real con tokens
- Ejecutar swaps y medir resultados

Requisitos:
- Tests en test/integration/
- Usar forge test --fork-url para tests en fork
- Comentarios explicando métricas
- Validar que LVR se reduce efectivamente

Referencias:
- cursor/project-context.md - Sección "Casos de uso principales"
- docs-internos/idea-general.md - Sección "Por qué esta idea es brutalmente ganadora"
```

### Dependencias

- Paso 2.1 (tests básicos)

### Referencias

- `cursor/project-context.md` - Sección "Resultados esperados"

---

## Paso 2.3: Tests de edge cases y seguridad

**Estado:** ⚪

### ¿Qué hacer?

Crear tests para edge cases, casos límite y posibles vulnerabilidades.

### ¿Qué pedir a la IA?

```
Crea tests de edge cases y seguridad para AntiLVRHook.

Tests requeridos:
1. test_ZeroPrice() - manejo de precio cero
2. test_ExtremeVolatility() - comportamiento con cambios de precio extremos
3. test_Reentrancy() - verificar protección contra reentrancy
4. test_AccessControl() - verificar que solo owner puede configurar
5. test_InvalidParameters() - verificar validación de parámetros
6. test_GasOptimization() - medir gas costs y optimizar si necesario

Requisitos:
- Tests en test/unit/ o test/security/
- Usar fuzzing donde sea apropiado (Foundry fuzz testing)
- Comentarios explicando cada caso
- Validar que no hay vulnerabilidades obvias

Ejecutar forge test --gas-report para análisis de gas.
```

### Dependencias

- Paso 2.2 (tests de integración)

### Referencias

- `cursor/project-context.md` - Sección "Privacidad y seguridad"

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
Crea script de deployment para AntiLVRHook usando Foundry.

Script requerido: script/deploy/DeployAntiLVRHook.s.sol

Funcionalidad:
1. Deploy AntiLVRHook con parámetros iniciales
2. Configurar parámetros (baseFee, volatilityMultiplier, etc.)
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

- `cursor/project-context.md` - Sección "Flujo de ejecución básico"

---

## Paso 3.2: Deployment a testnet

**Estado:** ⚪

### ¿Qué hacer?

Deployar el hook a testnet (Sepolia o Base Sepolia) y validar funcionamiento. **CRÍTICO para hackathon: guardar TxIDs.**

### ¿Qué pedir a la IA?

```
Guíame para deployar AntiLVRHook a testnet.

Pasos requeridos:
1. Configurar .env con RPC_URL y PRIVATE_KEY de testnet
2. Obtener testnet ETH para gas
3. Ejecutar script de deployment
4. Verificar contrato en explorer
5. Ejecutar tests en fork de testnet para validar
6. Guardar contract address para documentación
7. **GUARDAR TxIDs de deployment** (requisito del hackathon)

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

**Estado:** ✅ **COMPLETADO** (parcial - falta info de deployment)

### ¿Qué hacer?

Actualizar README.md con información completa del proyecto, instrucciones de uso, y links de deployment.

### Estado Actual

✅ **Completado parcialmente** - README.md actualizado con:
- Descripción del problema y solución
- Instrucciones de instalación y setup
- Comandos de testing
- Arquitectura y cómo funciona
- Información del hackathon

⚠️ **Pendiente**: Agregar links a contract addresses en testnet (después del deployment)

### ¿Qué pedir a la IA?

```
Actualiza README.md con información completa del proyecto.

Contenido requerido:
1. Descripción clara del problema y solución
2. Instrucciones de instalación y setup
3. Comandos de testing y deployment
4. Links a contract addresses en testnet
5. Ejemplos de uso
6. Arquitectura y cómo funciona
7. Contribuciones y licencia

Requisitos:
- Todo en inglés (público)
- Formato markdown profesional
- Incluir badges si aplica
- Links a recursos de Uniswap v4
- Referencias a cursor/project-context.md para contexto técnico interno

NO incluir información privada o sensible.
```

### Dependencias

- Paso 3.2 (deployment completado)

### Referencias

- `README.md` (actual) - Base para actualizar
- `cursor/project-context.md` - Información técnica

---

## Paso 4.2: Crear demo funcional

**Estado:** ⚪

### ¿Qué hacer?

Crear demo que muestre el hook en acción: swap normal vs swap con hook, comparación de LVR, fee dinámica.

### ¿Qué pedir a la IA?

```
Crea demo funcional para mostrar AntiLVRHook en acción.

Demo requerido:
1. Script o guía para ejecutar swaps de prueba
2. Comparación visual o numérica:
   - Swap sin hook vs swap con hook
   - LVR antes vs después
   - Fee estática vs fee dinámica
3. Métricas clave para mostrar a jurados
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

### Referencias

- `docs-internos/hackathon-ethglobal-uniswap.md` - Requisitos de calificación

---

## Paso 4.3: Crear guión para video pitch

**Estado:** ⚪

### ¿Qué hacer?

Crear guión estructurado para video demo de 3 minutos (inglés con subtítulos). **REQUISITO OBLIGATORIO del hackathon.**

### ¿Qué pedir a la IA?

```
Crea guión completo para video pitch de 3 minutos del Hook Anti-LVR.

Estructura requerida:
1. Hook (0-15s) - Problema: LVR afecta a LPs
2. Solución (15-60s) - Cómo funciona: precio amortiguado + fee dinámica
3. Demo (60-150s) - Mostrar hook en acción, métricas, comparación
4. Cierre (150-180s) - Por qué es ganador, sin oráculos, elegante

Requisitos:
- Máximo 3 minutos (requisito del hackathon)
- Inglés con subtítulos
- Puntos clave de docs-internos/idea-general.md
- Enfoque en: sin oráculos, simple, efectivo
- Mostrar TxIDs y contract address en explorer
- Preparado para grabación

Referencias:
- docs-internos/idea-general.md - Sección "Resumen en frase (para tu pitch)"
- cursor/project-context.md - Sección "Requisitos del Hackathon"
- docs-internos/hackathon-ethglobal-uniswap.md - Requisitos de video
```

### Dependencias

- Paso 4.2 (demo funcional)

### Referencias

- `docs-internos/idea-general.md` - Sección "Resumen en frase (para tu pitch)"
- `docs-internos/hackathon-ethglobal-uniswap.md` - Requisitos de video

---

# FASE 4.4: Preparar Entregables del Hackathon

**Objetivo:** Asegurar que todos los requisitos del hackathon estén completos antes de la entrega.

---

## Paso 4.4: Checklist de entregables del hackathon

**Estado:** ⚪

### ¿Qué hacer?

Verificar y preparar todos los entregables obligatorios del hackathon.

### ¿Qué pedir a la IA?

```
Crea checklist completo de entregables para ETHGlobal Buenos Aires - Track 2.

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

- `cursor/project-context.md` - Sección "Requisitos del Hackathon"
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
Optimiza gas costs de AntiLVRHook.

Análisis requerido:
1. Ejecutar forge test --gas-report
2. Identificar funciones con mayor gas cost
3. Optimizar storage (pack structs, usar uint128 donde sea posible)
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

- `cursor/project-context.md` - Sección "Notas para escalabilidad futura"

---

## Paso 5.2: Mejoras opcionales (si hay tiempo)

**Estado:** ⚪

### ¿Qué hacer?

Implementar mejoras opcionales mencionadas en project-context.md.

### ¿Qué pedir a la IA?

```
Implementa mejoras opcionales para AntiLVRHook (si hay tiempo antes del hackathon).

Mejoras posibles (elegir según tiempo disponible):
1. Métricas de volatilidad más sofisticadas (EWMA)
2. Events más detallados para analytics
3. Funciones view para consultar métricas históricas
4. Mejoras en configuración (timelock, multi-sig)

Requisitos:
- No romper funcionalidad existente
- Tests deben seguir pasando
- Documentar nuevas features
- Priorizar según impacto vs tiempo

Referencias:
- cursor/project-context.md - Sección "Posibles mejoras (sin predefinir fases)"
```

### Dependencias

- Paso 5.1 (optimización de gas)

### Referencias

- `cursor/project-context.md` - Sección "Notas para escalabilidad futura"

---

# 📊 Tabla de Progreso

| Fase | Paso | Título | Estado | Notas |
|------|------|--------|--------|-------|
| 0 | 0.1 | Estructura base de carpetas | ✅ | ✅ Completado - Template oficial ya tiene estructura |
| 0 | 0.2 | Configurar Foundry | ✅ | ✅ Completado - foundry.toml configurado, dependencias instaladas |
| 1 | 1.1 | Interfaces y base del hook | ⚪ | 🎯 **PRÓXIMO PASO** - Crear AntiLVRHook.sol |
| 1 | 1.2 | Cálculo de precio amortiguado | ⚪ | Requiere Paso 1.1 |
| 1 | 1.3 | Cálculo de fee dinámica | ⚪ | Requiere Paso 1.2 |
| 1 | 1.4 | Implementar beforeSwap | ⚪ | Requiere Pasos 1.2 y 1.3 |
| 1 | 1.5 | Implementar afterSwap | ⚪ | Requiere Paso 1.4 |
| 1 | 1.6 | Funciones de configuración | ⚪ | Requiere Paso 1.5 |
| 2 | 2.1 | Setup de testing | ⚪ | Requiere Paso 1.6 |
| 2 | 2.2 | Tests de integración | ⚪ | Requiere Paso 2.1 |
| 2 | 2.3 | Tests de edge cases | ⚪ | Requiere Paso 2.2 |
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

---

---

## 🎯 Estado Actual del Proyecto

### ✅ Completado

1. **Fase 0.1** - Estructura base de carpetas
   - Template oficial de Uniswap v4 ya incluye estructura completa
   - Carpetas: `src/`, `test/`, `script/`, `lib/`

2. **Fase 0.2** - Configuración Foundry
   - `foundry.toml` configurado (Solidity 0.8.30, EVM Cancun)
   - Dependencias instaladas (Uniswap v4, hookmate, forge-std)
   - `.env.example` creado
   - `.cursor/` con project-context.md y user-rules.md

3. **Fase 4.1** - README actualizado (parcial)
   - README.md con documentación completa del MVP
   - Falta: links a contract addresses (después del deployment)

### 🎯 Próximo Paso

**Fase 1, Paso 1.1** - Crear interfaces y base del hook
- Crear `src/AntiLVRHook.sol`
- Basarse en `Counter.sol` del template
- Implementar estructura base con storage mínimo
- Configurar `getHookPermissions()` para beforeSwap y afterSwap

### 📋 Pendiente

- **Fase 1** (Pasos 1.1-1.6): Implementación completa del hook
- **Fase 2** (Pasos 2.1-2.3): Testing completo
- **Fase 3** (Pasos 3.1-3.2): Deployment a testnet
- **Fase 4** (Pasos 4.2-4.4): Demo, video pitch y entregables

---

📅 **Última actualización:** 2025-11-22  
👤 **Creado por:** kaream  
🎯 **Versión:** 1.1

