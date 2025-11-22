# 🪝 Hook Anti-LVR - Project Context

## 📌 Resumen Ejecutivo

**Proyecto:** Hook Anti-LVR para Uniswap v4  
**Track:** Track 2 - Volatile-Pairs Hooks ($10,000 prize pool)  
**Hackathon:** ETHGlobal Buenos Aires (Nov 2025)  
**Organizador:** Uniswap Foundation

### Problema que Resuelve

Los Liquidity Providers (LPs) pierden dinero debido a **Loss Versus Rebalancing (LVR)** cuando:
- El precio interno del pool se mueve con saltos bruscos
- Los arbitradores explotan esos saltos
- El LP vende barato y compra caro

Esto ocurre frecuentemente en pares volátiles (ETH/USDC, BTC/USDC, etc.).

### Solución

Hook de Uniswap v4 que:
1. **Suaviza el precio interno** durante swaps (precio amortiguado)
2. **Ajusta fees dinámicamente** según volatilidad detectada
3. **Reduce LVR** sin usar oráculos externos
4. **No rompe la UX** - no bloquea swaps ni modifica la curva AMM

---

## 🎯 Objetivo del MVP

Implementar un hook funcional que demuestre:
- ✅ Precio amortiguado funcionando en `beforeSwap()`
- ✅ Fee dinámica basada en volatilidad
- ✅ Actualización de estado en `afterSwap()`
- ✅ Tests completos (>80% coverage)
- ✅ Deployment en testnet con TxIDs
- ✅ README y demo funcional

---

## 🧩 Arquitectura Técnica

### Hooks Utilizados

- `beforeSwap()` - Aplica precio amortiguado y fee dinámica
- `afterSwap()` - Actualiza `lastPrice` en storage

**Nota:** `beforeInitialize()` y `beforeModifyPosition()` mencionados en `idea-general.md` son opcionales para el MVP.

### Storage Mínimo

```solidity
struct HookStorage {
    uint256 lastPrice;              // Último precio del pool (sqrtPriceX96)
    uint256 baseFee;                // Fee base en basis points (ej: 5 = 0.05%)
    uint256 volatilityMultiplier;   // Multiplicador de volatilidad
    uint256 volatilityThreshold;    // Umbral para aplicar amortiguación
    uint256 minFee;                 // Fee mínima
    uint256 maxFee;                 // Fee máxima
}
```

### Lógica Core

#### 1. Precio Amortiguado

```solidity
// En beforeSwap()
P_current = pool.sqrtPriceX96
delta = abs(P_current - lastPrice)

if (delta > volatilityThreshold) {
    P_effective = (P_current + lastPrice) / 2  // Suavizado
} else {
    P_effective = P_current  // Sin cambios
}
```

#### 2. Fee Dinámica

```solidity
volatilityFee = baseFee + (delta * volatilityMultiplier)
volatilityFee = clamp(volatilityFee, minFee, maxFee)
```

#### 3. Actualización de Estado

```solidity
// En afterSwap()
lastPrice = pool.sqrtPriceX96  // Actualizar después del swap
```

---

## 🛠️ Stack de Tecnologías

- **Solidity:** ^0.8.0
- **Foundry:** Para testing y deployment
- **Uniswap v4:** Template oficial de hooks
- **Testnet:** Sepolia o Base Sepolia
- **GitHub:** Repositorio público

---

## 📁 Organización del Proyecto

```
.
├── src/
│   └── AntiLVRHook.sol          # Hook principal
├── test/
│   ├── AntiLVRHook.t.sol        # Tests unitarios
│   └── integration/             # Tests de integración
├── script/
│   └── deploy/
│       └── DeployAntiLVRHook.s.sol
├── .cursor/
│   ├── project-context.md       # Este archivo
│   └── user-rules.md            # Reglas para IA
├── docs-internos/               # Documentación interna
└── README.md                    # Documentación pública
```

---

## 🎯 Casos de Uso Principales

1. **Swap en par volátil (ETH/USDC)**
   - Hook detecta salto de precio grande
   - Aplica amortiguación al precio
   - Aumenta fee según volatilidad
   - LP sufre menos LVR

2. **Swap en par estable**
   - Hook detecta cambio pequeño
   - No aplica amortiguación
   - Fee se mantiene en baseFee
   - Comportamiento normal

3. **Múltiples swaps consecutivos**
   - Hook trackea volatilidad histórica
   - Ajusta fees progresivamente
   - Protege LP durante períodos volátiles

---

## ✅ Resultados Esperados

### Métricas Clave

- **Reducción de LVR:** 20-40% en pares volátiles (estimado)
- **Fee dinámica:** 5 bps (base) → 15-20 bps (alta volatilidad)
- **Gas cost:** <100k gas por swap (objetivo)

### Validaciones

- ✅ Tests unitarios pasando
- ✅ Tests de integración con Uniswap v4
- ✅ Deployment exitoso en testnet
- ✅ TxIDs guardados para hackathon
- ✅ Demo funcional mostrando diferencia

---

## 📋 Requisitos del Hackathon

### Entregables Obligatorios

1. **TxIDs de transacciones** (testnet/mainnet)
2. **Repositorio GitHub** público
3. **README.md** completo
4. **Demo funcional** o instrucciones de instalación
5. **Video demo** (máx. 3 minutos, inglés con subtítulos)

### Criterios de Evaluación

- Funcionalidad del hook
- Innovación y utilidad
- Calidad del código
- Documentación
- Demo y presentación

---

## 🔒 Privacidad y Seguridad

- **No hardcodear** claves privadas
- **Usar .env** para variables sensibles
- **Validar parámetros** en funciones de configuración
- **Control de acceso** (onlyOwner) para configuraciones
- **Tests de seguridad** (reentrancy, edge cases)

---

## 🚀 Flujo de Ejecución Básico

1. **Setup:**
   ```bash
   forge install
   forge test
   ```

2. **Deployment:**
   ```bash
   forge script script/deploy/DeployAntiLVRHook.s.sol \
     --rpc-url $RPC_URL \
     --account $ACCOUNT \
     --broadcast
   ```

3. **Testing:**
   ```bash
   forge test
   forge test --fork-url $RPC_URL  # Tests en fork
   ```

---

## 📚 Referencias Clave

- `docs-internos/idea-general.md` - Lógica detallada del hook
- `docs-internos/hackathon-ethglobal-uniswap.md` - Info del hackathon
- `docs-internos/ROADMAP-PASOS.md` - Guía de desarrollo paso a paso
- `docs-internos/README-INTERNO.md` - Info del template Uniswap v4

### Recursos Externos

- [Uniswap v4 Docs](https://docs.uniswap.org/contracts/v4/overview)
- [v4-template](https://github.com/uniswapfoundation/v4-template)
- [OpenZeppelin Hooks Library](https://docs.openzeppelin.com/uniswap-hooks)

---

## 🎨 Estructura de Código Esperada

### Convenciones

- **Nombres descriptivos:** `calculateAmortizedPrice()` no `calcPrice()`
- **Comentarios NatSpec:** Todas las funciones públicas
- **Events:** Para cambios importantes de estado
- **Modifiers:** Para validaciones reutilizables
- **Libraries:** Para cálculos complejos

### Ejemplo de Estructura

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {BaseHook} from "uniswap-v4/...";

contract AntiLVRHook is BaseHook {
    // Storage
    struct HookStorage {
        uint256 lastPrice;
        // ...
    }
    
    // Hooks
    function beforeSwap(...) external override returns (bytes4) {
        // Lógica
    }
    
    function afterSwap(...) external override returns (bytes4) {
        // Actualizar lastPrice
    }
    
    // Helpers internos
    function _calculateAmortizedPrice(...) internal view returns (uint256) {
        // ...
    }
    
    // Configuración
    function setBaseFee(uint256 newFee) external onlyOwner {
        // ...
    }
}
```

---

## 🔧 Configurabilidad

### Parámetros Ajustables

- `baseFee`: Fee base (default: 5 bps)
- `volatilityMultiplier`: Multiplicador (default: 1)
- `volatilityThreshold`: Umbral de amortiguación (default: calculado)
- `minFee`: Fee mínima (default: 5 bps)
- `maxFee`: Fee máxima (default: 50 bps)

### Control de Acceso

- **Owner:** Puede cambiar parámetros
- **Futuro:** Governance o timelock (opcional)

---

## 📈 Notas para Escalabilidad Futura

### Mejoras Opcionales (Post-MVP)

1. **Métricas más sofisticadas:**
   - EWMA (Exponentially Weighted Moving Average) para volatilidad
   - Histórico de precios en storage (circular buffer)

2. **Governance:**
   - Timelock para cambios de parámetros
   - Multi-sig para configuración

3. **Analytics:**
   - Events más detallados
   - Funciones view para consultar métricas

4. **Gas Optimization:**
   - Pack structs
   - Usar uint128 donde sea posible
   - Caching de variables

---

## 🎯 Guía para el Asistente Técnico

### Prioridades

1. **MVP funcional** - Hook básico con precio amortiguado y fee dinámica
2. **Tests completos** - >80% coverage
3. **Deployment** - Testnet con TxIDs
4. **Documentación** - README claro y demo

### Enfoque

- **Simplicidad:** MVP primero, mejoras después
- **Testing:** Validar cada función antes de continuar
- **Documentación:** Comentarios claros y README completo
- **Seguridad:** Validar inputs y edge cases

### Comandos Frecuentes

Ver `user-rules.md` para comandos específicos del proyecto.

---

📅 **Última actualización:** 2025-11-22  
👤 **Creado por:** kaream  
🎯 **Versión:** 1.0
