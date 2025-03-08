#!/bin/bash

set -e  # Stopper en cas d'erreur

echo "🔧 Installation des outils nécessaires..."

# Détection de Fish
if [ -n "$FISH_VERSION" ]; then
    IS_FISH=true
    FISH_CONFIG="$HOME/.config/fish/config.fish"
else
    IS_FISH=false
fi

# Installation de Bun
if ! command -v bun &> /dev/null; then
    echo "🚀 Installation de Bun..."
    curl -fsSL https://bun.sh/install | bash

    # Ajouter Bun au PATH dans Fish
    if $IS_FISH; then
        echo 'set -Ux PATH $HOME/.bun/bin $PATH' >> "$FISH_CONFIG"
    fi
else
    echo "✅ Bun est déjà installé."
fi

# Installation de uv
if ! command -v uv &> /dev/null; then
    echo "🐍 Installation de uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh

    # Ajouter uv au PATH dans Fish
    if $IS_FISH; then
        echo 'set -Ux PATH $HOME/.local/bin $PATH' >> "$FISH_CONFIG"
    fi
else
    echo "✅ uv est déjà installé."
fi

# Installation de Task
if ! command -v task &> /dev/null; then
    echo "📋 Installation de Task..."
    sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d

    # Ajouter Task au PATH dans Fish
    if $IS_FISH; then
        echo 'set -Ux PATH $HOME/.local/bin $PATH' >> "$FISH_CONFIG"
    fi
else
    echo "✅ Task est déjà installé."
fi

# Vérification
echo "📦 Vérification des installations..."
bun --version && uv --version && task --version

echo "🎉 Installation terminée !"
