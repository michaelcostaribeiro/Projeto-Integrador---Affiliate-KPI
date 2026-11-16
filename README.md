# 🎓 PROJETO INTEGRADOR: Análise de Soluções Integradas para Organizações

## 💻 Descrição do Projeto

O **Affiliate KPI** é uma aplicação web desenvolvida como parte do Projeto Integrador do 5º semestre. A proposta é oferecer uma plataforma para que afiliados do TikTok Shop possam acompanhar o desempenho dos produtos divulgados e visualizar métricas relacionadas às suas atividades.

O sistema conta com um painel de acompanhamento, gerenciamento de produtos e visualização de indicadores de desempenho, reunindo informações relevantes em uma única interface.

Este repositório contém a documentação completa e o Mínimo Produto Viável (MVP) referentes à primeira e segunda entregas do Projeto.

## 🛠️ Funcionalidades 
Atualmente, o projeto contempla as seguintes funcionalidades:

✔️ Painel inicial: visualização de informações e indicadores relacionados ao desempenho dos produtos.

✔️ Gerenciamento de produtos: cadastro, consulta, edição e exclusão de produtos.

✔️ Detalhes do produto: acesso a informações individuais e métricas de desempenho.

✔️ Filtros por período: consulta de dados de acordo com datas selecionadas.

✔️ Notificações: estrutura de consulta de notificações não lidas.

❗ Observação: os dados de desempenho apresentados são gerados de forma simulada para fins de demonstração. O projeto não possui integração direta com a API oficial do TikTok Shop.

## 🛠️ Tecnologias utilizadas

### **Front-end**

✔️ React 19: desenvolvimento da interface e dos componentes.

✔️ Vite: ferramenta de build e ambiente de desenvolvimento.

✔️ Tailwind CSS 4: estilização da aplicação.

✔️ React Router 7: gerenciamento de rotas e navegação.

✔️ Recharts: criação de gráficos e visualizações de dados.

### **Back-end**

✔️ Python 3.12: linguagem utilizada no desenvolvimento do servidor.

✔️ FastAPI: criação e gerenciamento da API REST.

✔️ SQLAlchemy: comunicação e interação com o banco de dados.

✔️ Alembic: gerenciamento de migrações do banco de dados.

✔️ Uvicorn: servidor ASGI responsável pela execução da aplicação.

✔️ Banco de dados e infraestrutura.

✔️ MySQL 8.4: armazenamento dos dados da aplicação.

✔️ Docker: containerização dos serviços.

✔️ Docker Compose: configuração e execução conjunta dos containers.

✔️ Nginx: disponibilização da aplicação frontend.

## 🗄️ Modelagem e Banco de Dados

O projeto utiliza MySQL 8.4 como sistema de gerenciamento de banco de dados. A modelagem foi desenvolvida por meio de um Diagrama Entidade-Relacionamento (DER), representando as entidades, seus atributos e os relacionamentos necessários para o funcionamento da aplicação.

Os arquivos relacionados à modelagem e à estrutura do banco de dados estão disponíveis no repositório:

- **DER (PDF):** diagrama visual para consulta da estrutura e dos relacionamentos entre as entidades.
- **DER (DBML):** arquivo editável contendo a definição da modelagem.
- **Script SQL:** arquivo contendo os comandos de criação das tabelas, relacionamentos e inserção de dados fictícios para demonstração.

Os arquivos estão organizados nas pastas `docs/database/` e `database/`.

## 💻 Estrutura do Projeto
```bash
Projeto-Integrador---Affiliate-KPI/
│
├── backend/
│   ├── alembic/
│   │   └── versions/
│   │
│   ├── controllers.py
│   ├── services.py
│   ├── fake_api.py
│   ├── main.py
│   └── requirements.txt
│
├── frontend/
│   ├── public/
│   │
│   └── src/
│       ├── assets/
│       ├── components/
│       ├── pages/
│       ├── App.jsx
│       ├── App.css
│       ├── index.css
│       ├── api.js
│       └── main.jsx
│
├── docs/
│   └── database/
│       ├── DER.dbml
│       └── DER.pdf
│
├── database/
│   └── database.sql
│
├── .env.example
├── Dockerfile
├── docker-compose.yml
└── alembic.ini
```

## 💻 Executando o projeto

A aplicação utiliza Docker Compose para facilitar a configuração e a inicialização dos serviços.

### Pré-requisitos
Antes de começar, certifique-se de ter instalado:

✔️ Git

✔️ Docker

✔️ Docker Compose

### 1. Clone o repositório
``` git clone https://github.com/michaelcostaribeiro/Projeto-Integrador---Affiliate-KPI.git ```

Entre na pasta do projeto:

```cd Projeto-Integrador---Affiliate-KPI```

### 2. Configure as variáveis de ambiente
Crie o arquivo .env a partir do modelo disponibilizado:

``` cp .env.example .env ```

O arquivo contém as configurações necessárias para a conexão com o banco de dados e as portas utilizadas pelos serviços.

### 3. Inicialize a aplicação
Execute o comando:

``` docker compose up --build ```

O Docker Compose será responsável por construir as imagens e inicializar os três serviços:

✔️ Banco de dados MySQL

✔️ Backend desenvolvido com FastAPI

✔️ Frontend desenvolvido com React.

Na inicialização do backend, as migrações do banco de dados são executadas automaticamente.

### 4. Acesse a aplicação
Após a inicialização dos serviços, os endereços disponíveis são:

✔️ Serviço

✔️ Endereço

✔️ Aplicação (Frontend)

``` http://localhost:5173 ```

✔️ API (Backend)

``` http://localhost:8000 ```

✔️ Documentação da API

```http://localhost:8000/docs``` 

Para encerrar a execução dos containers:

```docker compose down```

Para encerrar os containers e remover também os volumes do banco de dados:

```docker compose down -v```

❗ Atenção: o segundo comando remove os dados persistidos no volume do MySQL.

## 💻 Endpoints da API

A API disponibiliza rotas para o gerenciamento de produtos e a consulta de notificações.

| Método | Endpoint | Descrição |
|---|---|---|
| GET | `/api/afiliados/{usuario_id}/produtos` | Lista os produtos de um afiliado. |
| POST | `/api/afiliados/{usuario_id}/produtos` | Cadastra um novo produto. |
| GET | `/api/afiliados/{usuario_id}/produtos/{produto_id}` | Consulta os detalhes de um produto. |
| PUT | `/api/afiliados/{usuario_id}/produtos/{produto_id}` | Atualiza os dados de um produto. |
| DELETE | `/api/afiliados/{usuario_id}/produtos/{produto_id}` | Exclui um produto. |
| GET | `/api/usuarios/{usuario_id}/notificacoes/nao-lidas` | Consulta as notificações não lidas de um usuário. |

As rotas de consulta de produtos também aceitam os parâmetros `data_inicio` e `data_fim`, permitindo filtrar os resultados por período.

A documentação interativa dos endpoints pode ser acessada pelo Swagger, em:

```http://localhost:8000/docs```

## 👥 Equipe e Contribuições

Este projeto foi desenvolvido em colaboração por toda a equipe. Todos os membros da equipe estão cadastrados como contribuidores neste repositório do GitHub e constam como Colaboradores.

| Membro | Github |
|---------|----------|
| MICHAEL COSTA RIBEIRO | @michaelcostaribeiro  |
| BRUNO FRESCHI CONTE | @brunofreschii  | 
| BIANCA LIMA HABKOUK | @devbibs  |
| RICARDO RIGONI VIEIRA LIGO | @ricardoligosenac  |
| GUSTAVO SILVA | @gusilvo  |



