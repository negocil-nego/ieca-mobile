# Hinário App

O **Hinário App** é uma aplicação móvel desenvolvida em Flutter, criada com o objetivo de facilitar o acesso e a utilização dos hinos da IECA (Igreja Evangélica Congregacional em Angola) de forma digital, prática e acessível.

O projeto visa centralizar o hinário completo, permitindo que fiéis, coros e líderes de louvor encontrem hinos rapidamente, tanto em momentos de culto como em devoções pessoais.

## Funcionalidades Principais

*   **Biblioteca Completa:** Acesso a todos os hinos do hinário oficial, organizados para facilitar a leitura.
*   **Busca Inteligente:** Pesquisa rápida por título ou número do hino.
*   **Interface Intuitiva:** Design limpo e otimizado para uma experiência de leitura confortável em dispositivos móveis.
*   **Modo Offline:** O conteúdo está disponível sem a necessidade de uma ligação constante à internet.

## Tecnologias Utilizadas

*   **Flutter:** Framework multiplataforma utilizado para garantir uma performance fluida tanto em Android como em iOS.
*   **Dart:** Linguagem de programação base para a lógica do aplicativo.
*   **Play App Signing:** Implementação segura de assinatura de pacotes via Google Play, garantindo a integridade das atualizações.

## Como Começar

Este projeto é um aplicativo Flutter estruturado. Para configurar o ambiente de desenvolvimento localmente, siga os passos abaixo:

### Pré-requisitos
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.
*   Android Studio ou VS Code configurado.

### Configuração do Projeto
1.  **Clonar o repositório:**
    `git clone <url-do-teu-repositorio>`
2.  **Configurar credenciais:**
    Crie o arquivo `android/key.properties` (baseado no `key.properties.example`) e insira as informações do seu `keystore` para assinatura em ambiente de *release*.
    > **Nota:** Nunca submeta o seu `key.properties` real para o repositório (ele está incluído no `.gitignore` por motivos de segurança).

3.  **Compilar o projeto:**
    Execute o comando abaixo na pasta raiz:
    `flutter pub get`
    `flutter run`

## Publicação e Distribuição

O processo de *deploy* e integração contínua é gerido através do **Fastlane**, que automatiza a compilação e o envio dos *App Bundles* (`.aab`) para o Google Play Console.

Para realizar o envio de uma nova versão:
*   Certifique-se de que a `signingConfig` no `build.gradle` está configurada.
*   Utilize o comando `fastlane <lane_nome>` para enviar o aplicativo diretamente para as faixas de teste ou produção na Play Store.

## Contribuições
Este aplicativo é uma ferramenta de serviço para a comunidade. Sugestões de melhorias na interface ou na organização dos hinos são bem-vindas.