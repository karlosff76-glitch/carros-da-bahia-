# Carros da Bahia — protótipo Android

Este é o projeto-fonte inicial em Godot 4.3+ (renderizador Compatibility), com:
- mapa 3D de comunidade fictícia inspirada em bairros brasileiros;
- personagem controlável;
- câmera em terceira e primeira pessoa;
- veículos dirigíveis em protótipo (Gol, Uno e BYD), com aceleração, ré e direção por botões;
- HUD com botões de toque e atalhos de celular/som em desenvolvimento.

## Como abrir
1. Instale Godot 4.3 ou mais recente em um computador.
2. Descompacte a pasta e importe `project.godot`.
3. Pressione F6/F5 para executar e testar.

## Como gerar APK Android
1. No Godot, instale/configure os templates de exportação.
2. Configure Android SDK, JDK e o caminho do SDK em Editor > Editor Settings > Export > Android.
3. Em Project > Export, crie um preset Android e exporte o APK.
4. Para instalar, transfira o APK para o Android e permita a instalação da fonte usada.

## Importante
Isto é um protótipo-fonte, não um APK pronto. Os veículos ainda são modelos simples; dirigir, acelerar, dar ré e virar já está implementado como protótipo. Música local, Spotify, dirigibilidade real, garagem, missões e montagem funcional de som ainda precisam ser implementados. Spotify exige integração oficial, autenticação e respeito às condições do serviço.


## Gerar APK usando somente o celular (GitHub Actions)
1. Crie uma conta gratuita no GitHub pelo navegador do celular.
2. Crie um repositório novo chamado `carros-da-bahia`.
3. Envie os arquivos deste ZIP para o repositório (extraia o ZIP antes, mantendo também a pasta `.github`).
4. Abra a aba **Actions** do repositório e permita executar workflows, se o GitHub pedir.
5. O workflow `Build Android APK` compila automaticamente quando houver push na branch `main`. Também pode ser iniciado em Actions > Build Android APK > Run workflow.
6. Quando terminar com sucesso, abra a execução e baixe o artefato `Carros-da-Bahia-Android`. Dentro dele estará `Carros_da_Bahia.apk`.

Observação: a compilação acontece nos servidores do GitHub, não no celular. O APK só estará disponível se a execução terminar com status verde. Se houver erro, envie a mensagem/print do erro para corrigirmos.
