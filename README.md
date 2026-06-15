# CineCatalog - Coleção de Filmes (Tema 09)

## 1. Integrante
- Ana Clara de Jesus Régis

## 2. Tema Escolhido
- **Tema:** 09 - Coleção de Filmes
- **Banco de Dados:** SQLite (com suporte nativo para Windows Desktop)

## 3. Descrição do App
O **CineCatalog** é um catálogo pessoal robusto onde os usuários podem gerenciar sua coleção privada de filmes. Projetado para cinéfilos, o app permite registrar títulos, diretores, gêneros, anos de lançamento e avaliações pessoais. O sistema conta com um módulo de autenticação completo, garantindo que cada usuário acesse exclusivamente sua própria lista de filmes, tudo armazenado localmente para máxima performance e privacidade.

## 4. Funcionalidade Aplicada ao Tema
**Filtragem por Gênero e Busca Dinâmica Inteligente:**
- **Busca Global:** Barra de pesquisa em tempo real que filtra por título, diretor ou gênero simultaneamente.
- **Chips de Gênero:** Filtros dinâmicos que se adaptam automaticamente aos gêneros presentes na coleção do usuário, permitindo navegar por categorias com um único clique.

## 5. Requisitos do Sistema e Extensões
Para rodar este projeto efetivamente no **Windows**, você precisará:

1.  **Flutter SDK:** Versão 3.10.0 ou superior (estável).
2.  **Visual Studio 2022:** Com a carga de trabalho *"Desenvolvimento para desktop com C++"* instalada (obrigatório para compilação nativa no Windows).
3.  **Extensões do VS Code / Android Studio:**
    - Flutter
    - Dart
4.  **Dependências Especiais:** O projeto utiliza `sqflite_common_ffi` para permitir o uso de SQLite em ambiente desktop Windows.

## 6. Passo a Passo para Rodar o Projeto

1.  **Clonar o Repositório:**
    ```bash
    git clone https://github.com/AnaClaraJR/Colecao-de-Filmes
    ```
2.  **Entrar no Diretório:**
    ```bash
    cd 09_Filmes
    ```
3.  **Instalar Dependências:**
    ```bash
    flutter pub get
    ```
4.  **Executar para Windows Desktop:**
    ```bash
    flutter run -d windows
    ```

> **Nota:** Caso tente executar no Navegador (Chrome), o app exibirá um erro informando que o SQLite local não é suportado nativamente na Web nesta configuração. Utilize sempre o **Windows (Desktop)** para teste completo.

## 7. Estrutura do Projeto
- `lib/models/`: Modelos de dados (`UsuarioModel`, `FilmeModel`).
- `lib/database/`: Lógica de banco de dados (`BancoDadosHelper`).
- `lib/providers/`: Gerenciamento de estado (`AutenticacaoProvider`, `FilmeProvider`).
- `lib/screens/`: Interfaces do usuário (`TelaLogin`, `TelaCadastro`, `TelaListaFilmes`, `TelaFormularioFilme`).
