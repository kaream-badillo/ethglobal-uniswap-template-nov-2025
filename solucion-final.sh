#!/bin/bash

# Solución final para el problema de rutas largas en Windows

echo "🔧 Configurando Git para rutas largas..."
git config --global core.longpaths true

echo ""
echo "✅ Configuración aplicada. Verificando..."
git config --global core.longpaths

echo ""
echo "📦 Volviendo al directorio raíz del proyecto..."
cd /c/Users/karea/Documents/PROJECTs/WEB3/BLOCKCHAINs/ethglobal/ethglobal-uniswap-template-nov-2025

echo ""
echo "🔨 Intentando compilar el proyecto..."
echo "   (Los submodules anidados que fallaron probablemente no son necesarios)"
echo ""

forge build

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ ¡ÉXITO! El proyecto compila correctamente."
    echo ""
    echo "Los submodules que fallaron NO son necesarios para tu proyecto."
    echo "Puedes continuar normalmente con:"
    echo "  forge test"
    echo "  forge script script/deploy/DeployAntiSandwichHook.s.sol --rpc-url ..."
else
    echo ""
    echo "❌ Error de compilación."
    echo ""
    echo "Opciones:"
    echo "  1. Habilitar Long Paths en Windows (requiere admin):"
    echo "     - Abre PowerShell como Administrador"
    echo "     - Ejecuta: New-ItemProperty -Path \"HKLM:\\SYSTEM\\CurrentControlSet\\Control\\FileSystem\" -Name \"LongPathsEnabled\" -Value 1 -PropertyType DWORD -Force"
    echo "     - Reinicia la computadora"
    echo ""
    echo "  2. Usar WSL (Windows Subsystem for Linux) si está disponible"
    echo ""
    echo "  3. Mover el proyecto a una ruta más corta (ej: C:/projects/ethglobal)"
fi

