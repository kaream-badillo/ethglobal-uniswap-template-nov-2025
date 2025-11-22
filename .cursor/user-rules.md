# 🎯 User Rules - Hook Anti-LVR

## 🧭 Propósito

Definir cómo debe responder la IA (Cursor) cuando el usuario interactúa en el contexto del proyecto **Hook Anti-LVR**. Reglas de tono, estilo, enfoque y prioridades para asegurar consistencia en hackathons y desarrollo real.

---

## 🧭 Lineamientos de Respuesta

- Mantener siempre un **tono profesional, directo y claro**, evitando rodeos o textos innecesarios.
- Responder en **bloques Markdown** listos para copiar/pegar en Cursor o Notion.
- Priorizar **acciones prácticas y ejecutables** (comandos, pasos cortos, ejemplos).
- Incluir siempre comentarios `//` cuando haya ambigüedad o suposiciones necesarias.
- Usar siempre placeholders claros (`TODO_RPC_URL`, `TODO_CONTRACT_ADDR`) cuando falten datos reales.
- Respetar la **convención de inputs con 🔴** cuando se pidan datos del usuario.

---

## 🧩 Estilo Esperado

- Respuestas estructuradas en secciones con títulos.
- Uso de tablas cuando corresponda para KPIs, comparativas o decisiones.
- Código en bloques formateados con sintaxis (`bash`, `solidity`, `typescript`, etc.).
- Siempre indicar qué acciones son **para hacer en Cursor** o con un prompt adicional.
- Mantener la claridad entre secciones **técnicas** y secciones de **narrativa/pitch**.

---

## 🚦 Prioridades de Entrega

1. **MVP funcional en testnet**: hook deployado → validar acción → mintear/swap → ver en explorer.
2. **Demo ejecutable y README claro**.
3. **Pitch público** (video 3 min EN con subtítulos).
4. **Iteraciones opcionales** (governance, métricas avanzadas, optimizaciones).

---

## 🔒 Límites

- No incluir datos sensibles (claves privadas, RPC reales, cuentas personales).
- No reemplazar las decisiones estratégicas ya tomadas en `project-context.md`.
- No omitir bloques obligatorios (checklists, READMEs, commits sugeridos).

---

## 💻 Convenciones de Código

### Solidity

- **Nombres descriptivos:** `calculateAmortizedPrice()` no `calcPrice()`
- **Comentarios NatSpec:** Todas las funciones públicas
- **Events:** Para cambios importantes de estado
- **Modifiers:** Para validaciones reutilizables
- **Storage packing:** Optimizar structs cuando sea posible

### Testing

- **Foundry tests:** Usar `forge test`
- **Fork tests:** Usar `--fork-url` para tests de integración
- **Coverage:** Objetivo >80%
- **Fuzzing:** Donde sea apropiado

### Deployment

- **Scripts Foundry:** Usar `forge script`
- **Keystore:** Nunca hardcodear private keys
- **Variables de entorno:** Usar `.env` para RPC_URL, PRIVATE_KEY, etc.

---

## 📝 Comandos Frecuentes del Proyecto

### Setup Inicial

```bash
# Instalar dependencias
forge install

# Ejecutar tests
forge test

# Tests con gas report
forge test --gas-report
```

### Testing

```bash
# Tests unitarios
forge test

# Tests en fork (testnet)
forge test --fork-url $RPC_URL

# Tests específicos
forge test --match-test test_CalculateAmortizedPrice

# Coverage
forge coverage
```

### Deployment

```bash
# Deploy a testnet
forge script script/deploy/DeployAntiLVRHook.s.sol \
  --rpc-url $RPC_URL \
  --account $ACCOUNT \
  --sender $SENDER \
  --broadcast

# Verificar contrato
forge verify-contract \
  --rpc-url $RPC_URL \
  --chain sepolia \
  --verifier etherscan \
  --etherscan-api-key $ETHERSCAN_API_KEY \
  $CONTRACT_ADDRESS \
  src/AntiLVRHook.sol:AntiLVRHook
```

### Desarrollo Local

```bash
# Iniciar Anvil
anvil

# O fork de testnet
anvil --fork-url $RPC_URL

# Ejecutar scripts localmente
forge script script/deploy/DeployAntiLVRHook.s.sol \
  --rpc-url http://localhost:8545 \
  --private-key $PRIVATE_KEY \
  --broadcast
```

---

## 🎨 Estructura de Archivos Esperada

### Contratos

- `src/AntiLVRHook.sol` - Hook principal
- `src/interfaces/` - Interfaces de Uniswap v4
- `src/libraries/` - Librerías auxiliares (si aplica)

### Tests

- `test/AntiLVRHook.t.sol` - Tests unitarios
- `test/integration/` - Tests de integración
- `test/utils/` - Helpers para tests

### Scripts

- `script/deploy/DeployAntiLVRHook.s.sol` - Script de deployment
- `script/utils/` - Utilidades para scripts

---

## 📚 Referencias Rápidas

### Archivos Clave

- `.cursor/project-context.md` - Contexto completo del proyecto
- `docs-internos/idea-general.md` - Lógica del hook
- `docs-internos/hackathon-ethglobal-uniswap.md` - Info del hackathon
- `docs-internos/ROADMAP-PASOS.md` - Guía paso a paso
- `README.md` - Documentación pública

### Recursos Externos

- [Uniswap v4 Docs](https://docs.uniswap.org/contracts/v4/overview)
- [v4-template](https://github.com/uniswapfoundation/v4-template)
- [Foundry Book](https://book.getfoundry.sh/)

---

## 🎯 Checklist de Calidad

Antes de considerar una tarea completa:

- [ ] Código compila sin errores
- [ ] Tests pasan (`forge test`)
- [ ] Comentarios NatSpec en funciones públicas
- [ ] No hay datos sensibles hardcodeados
- [ ] README actualizado (si aplica)
- [ ] Commits con mensajes claros

---

## 🚨 Errores Comunes a Evitar

1. **Hardcodear private keys** - Usar keystore o .env
2. **Olvidar actualizar lastPrice** - Crítico en afterSwap()
3. **No validar parámetros** - Siempre validar inputs
4. **Tests incompletos** - Cubrir edge cases
5. **Documentación desactualizada** - Mantener README sincronizado

---

## 💡 Tips para Desarrollo Rápido

1. **Usar el template oficial** - Base sólida de Uniswap v4
2. **Tests primero** - TDD ayuda a validar lógica
3. **Fork tests** - Validar con pools reales
4. **Gas optimization después** - MVP primero, optimizar después
5. **Documentar mientras desarrollas** - No dejar para el final

---

📅 **Última edición:** 2025-11-22  
👤 **Creado por:** kaream  
🎯 **Versión:** 1.0
