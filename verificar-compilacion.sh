#!/bin/bash

# Script para verificar si el proyecto compila con las dependencias instaladas

echo "🔍 Verificando compilación del proyecto..."
echo ""

# Intentar compilar
forge build

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ ¡Compilación exitosa! Las dependencias instaladas son suficientes."
    echo ""
    echo "Puedes continuar con:"
    echo "  forge test"
else
    echo ""
    echo "❌ Error de compilación. Algunos submodules faltantes pueden ser necesarios."
    echo ""
    echo "Los submodules que fallaron son muy anidados y probablemente no críticos."
    echo "Puedes intentar:"
    echo "  1. Instalar manualmente solo los que faltan"
    echo "  2. O trabajar con lo que tienes si los errores no son críticos"
fi

