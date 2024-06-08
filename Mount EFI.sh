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

# Verifica cada disco GPT para encontrar a partição EFI
for disk in $GUID_DISKS; do
    EFI_PARTITION=$(diskutil list "$disk" | awk '/ EFI / {print $NF}' | head -n 1)
    if [ -n "$EFI_PARTITION" ]; then
        # Verifica se a partição EFI está montada
        MOUNT_POINT=$(diskutil info "$EFI_PARTITION" | grep 'Mount Point' | awk -F: '{print $2}' | xargs)
        if [ -n "$MOUNT_POINT" ]; then
            EFI_MOUNTED=true
            break
        fi
    fi
done

# Se a partição EFI estiver montada, desmonta-a
if [ "$EFI_MOUNTED" = true ]; then
    if sudo diskutil unmount "$EFI_PARTITION"; then
        echo "🔴 EFI desmontada com sucesso"
    else
        print_error "❌ Falha ao desmontar a partição EFI."
    fi
else
    # Se a partição EFI não estiver montada, tenta montá-la
    for disk in $GUID_DISKS; do
        EFI_PARTITION=$(diskutil list "$disk" | awk '/ EFI / {print $NF}' | head -n 1)
        if [ -n "$EFI_PARTITION" ]; then
            if sudo diskutil mount "$EFI_PARTITION"; then
                echo "🟢 EFI montada com sucesso"
                EFI_MOUNTED=true
                break
            fi
        fi
    done

    # Verifica se a partição EFI foi montada com sucesso
    if [ "$EFI_MOUNTED" = false ]; then
        print_error "❌ Nenhuma partição EFI encontrada."
    fi
fi
