# Claiton Lemes - Universo Hackintosh
# Lista todos os discos com esquema de partição GPT
GUID_DISKS=$(diskutil list | grep 'GUID_partition_scheme' | awk '{print $NF}')

# Flag para verificar se a partição EFI foi montada
EFI_MOUNTED=false

# Verifica cada disco GPT para encontrar e montar a partição EFI
echo "$GUID_DISKS" | while read -r disk; do
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
    echo "EFI montada com sucesso"
else
    echo "Erro: Nenhuma partição EFI encontrada."
fi

# Exibe os discos na area de trabalho
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true

killall Finder
