# Mount-EFI

Este script do Shortcuts app para macOS é projetado para automatizar a gestão de `partições EFI` e a personalização da interface do Finder. Ele é composto por dois componentes principais de script de shell e uma lógica condicional para controle de fluxo.


### Funcionalidades Principais do Script:

> [!IMPORTANT]
> O script verifica se a montagem foi feita corretametne antes de prosseguir. É importante que o usuário saiba que, se houver um problema na montagem da partição, o script `não executará` as ações subsequentes.


### Identificação e Montagem da Partição EFI:

- O script começa identificando a partição EFI do sistema usando o comando `diskutil list`.
- Ele extrai o identificador da partição EFI encontrada, **caso seja encontrado** e tenta montá-la com `sudo diskutil mount`.
- Se a montagem for bem-sucedida, o script exibe uma mensagem de `Sucesso`.

### Condicional de Verificação de Sucesso:

- Após a tentativa de montagem, o script verifica se a palavra `Sucesso` foi gerada.
- Se `Sucesso` for detectado, significa que a partição EFI foi montada com êxito.

### Notificação de Sucesso e Ações Adicionais:

- Quando a partição EFI é montada com sucesso, o script dispara uma notificação informando `EFI montada com sucesso`.
- Em seguida, executa outro comando de shell script para alterar uma configuração do Finder: `defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true`. Isto faz com que os discos rígidos sejam exibidos na área de trabalho.
- O Finder é reiniciado com `killall Finder` para aplicar a mudança.

> [!WARNING]
> O comando `killall Finder` irá reiniciar o Finder. É importante informar o usuário de que isso fechará todas as janelas do Finder e pode interromper o trabalho em andamento..

  
### Gestão de Erro:

- Caso a partição EFI não seja encontrada ou não possa ser montada, o script gera uma notificação de erro `EFI não encontrada`.
- Nesse caso, ele não executa as ações subsequentes relacionadas ao Finder.

### Conclusão

Este script oferece uma maneira automatizada e eficiente de gerenciar partições EFI de forma extremamente fácil e sem nenhum código de terminal. Ele é especialmente útil para usuários que precisam acessar de frequentemente a partição EFI. A integração de verificações de sucesso e gestão de erros garante que as operações sejam realizadas com segurança e eficácia.
