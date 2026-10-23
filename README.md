# Reinos de Cinza (protótipo) — Godot 4

Protótipo jogável em 2D para Android (e PC). O nome é provisório: troque como quiser.

## O que já funciona

- Personagem que anda com um **joystick virtual** (toque e arraste na metade de baixo da tela).
- **Ataque automático** no inimigo mais próximo dentro do alcance.
- Inimigos que surgem ao redor e perseguem você, ficando mais fortes com o tempo.
- **XP e níveis**: ao subir, você recupera vida e ganha vida máxima, dano e alcance.
- Barras de vida e XP, tempo de sobrevivência, abates e tela de fim de jogo com "Jogar de novo".

## Como abrir e testar

1. Baixe o **Godot 4.3 ou mais novo** (versão padrão, não a .NET) em https://godotengine.org/download
2. Abra o Godot, clique em **Importar** e escolha o arquivo `project.godot` desta pasta.
3. Aperte **F5** para jogar.
   - No PC: arraste com o mouse na metade de baixo da tela, ou use as **setas** do teclado.

## Gerar o APK pelo GitHub (sem instalar nada)

1. Crie uma conta em https://github.com e um repositório novo (pode ser privado).
2. Envie **todo o conteúdo desta pasta** para o repositório, incluindo a pasta oculta `.github`
   (no site: **Add file > Upload files** e arraste os arquivos e pastas; confira se `.github/workflows/build-apk.yml` apareceu).
3. Abra a aba **Actions**. Se o GitHub pedir, clique para habilitar. O workflow **Gerar APK** roda sozinho a cada envio
   (ou clique em **Run workflow**). Leva uns 5 a 10 minutos.
4. Quando ficar verde, abra a execução e baixe `reinos-de-cinza-apk` em **Artifacts** (vem dentro de um .zip).
5. Passe o `reinos-de-cinza.apk` para o celular e instale (permita "instalar apps de fontes desconhecidas").

O APK é de teste (assinado com uma chave de depuração), serve para testar no seu celular mas não para publicar na Play Store.

## Como gerar o app Android no seu próprio PC

1. No Godot: **Editor > Gerenciar Modelos de Exportação** e baixe os modelos.
2. Instale o **JDK 17** e o **Android SDK** e informe os caminhos em **Editor > Configurações do Editor > Exportar > Android**.
3. **Projeto > Exportar > Adicionar > Android** e exporte o `.apk`.
   Guia oficial: https://docs.godotengine.org/pt-br/4.x/tutorials/export/exporting_for_android.html

Dica: o jeito mais simples de testar no celular é o **Deploy com um clique** (ícone do Android no topo do editor), com o celular em modo desenvolvedor e USB conectado.

## Estrutura

```
project.godot        configuração (tela vertical 720x1280)
main.tscn            cena principal (só um nó que carrega o script)
scripts/main.gd      cria tudo, gera inimigos, desenha o chão
scripts/player.gd    movimento, ataque automático, XP e níveis
scripts/enemy.gd     inimigo que persegue e causa dano
scripts/hud.gd       barras, textos e tela de fim de jogo
scripts/joystick.gd  joystick virtual flutuante
export_presets.cfg   configuração de exportação para Android
.github/workflows/   automação do GitHub que gera o APK
```

Tudo é desenhado por código (círculos e linhas), então não há imagens: depois você pode trocar por sprites seus.

## Próximos passos sugeridos

1. Mudar números no começo dos scripts (vida, velocidade, dano) para entender o efeito de cada um.
2. Adicionar **classes** (guerreiro, arqueiro, mago) com ataques diferentes.
3. Adicionar **itens** que caem dos inimigos e um inventário simples.
4. Trocar os círculos por **sprites originais** (arte própria ou livre, como a do site kenney.nl).
5. Só depois: **multiplayer** (o Godot tem rede embutida, mas um MMORPG exige servidor próprio).
