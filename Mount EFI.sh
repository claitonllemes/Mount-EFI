EFI_PARTITION=$(diskutil list | grep 'EFI' | awk '{print $NF}' | head -n 1)
if [ -n "$EFI_PARTITION" ]; then
    sudo diskutil mount $EFI_PARTITION
    if [ $? -eq 0 ]; then
        echo "Sucesso"
    fi
fi