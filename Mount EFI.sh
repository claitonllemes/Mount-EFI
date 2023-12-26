#!/bin/bash

# Função para imprimir mensagens de erro
print_error() {
    echo "Erro: $1"
}

# Verifica se o diskutil está disponível
if ! command -v diskutil &> /dev/null; then
    print_error "diskutil não encontrado. Este script requer diskutil."
    exit 1
fi

# Lista todos os discos com esquema de partição GPT
GUID_DISKS=$(diskutil list | grep 'GUID_partition_scheme' | awk '{print $NF}')

# Flag para verificar se a partição EFI foi montada
EFI_MOUNTED=false

# Verifica cada disco GPT para encontrar e montar a partição EFI
for disk in $GUID_DISKS; do
    # Alterado para corresponder exatamente com a partição chamada 'EFI'
    EFI_PARTITION=$(diskutil list "$disk" | awk '/ EFI / {print $NF}' | head -n 1)
    if [ -n "$EFI_PARTITION" ]; then
        if sudo diskutil mount "$EFI_PARTITION"; then
            EFI_MOUNTED=true
            break
        fi
    fi
done

# Verifica se a partição EFI foi montada com sucesso
if [ "$EFI_MOUNTED" = true ]; then
    echo "✅ EFI montada com sucesso"
else
    print_error "❌ Nenhuma partição EFI encontrada."
fi

# Exibe os discos na area de trabalho
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true

killall Finder
