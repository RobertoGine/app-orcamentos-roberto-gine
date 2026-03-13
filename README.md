
# ⚡ EletricOrçamentos Pro — Roberto Giné

Aplicativo desenvolvido em **Flutter** para geração e gestão de **orçamentos profissionais para serviços elétricos**.

O sistema permite criar, editar e gerenciar orçamentos completos, calcular deslocamento, aplicar descontos e gerar **PDF profissional personalizado para envio ao cliente**.

Além disso, o aplicativo possui **controle financeiro, dashboard com gráfico, geração de lista de materiais e histórico completo de orçamentos**.

---

# 📱 Funcionalidades

## 🔹 Gestão de Orçamentos

* ✅ Criação de orçamento com numeração automática
  `ORC-0001, ORC-0002, ORC-0003...`

* ✅ Edição completa de orçamentos salvos

* ✅ Exclusão de orçamento com confirmação

* ✅ Histórico persistente utilizando **SQLite**

* ✅ Abertura de orçamento salvo para edição

---

# 📋 Lista de Materiais

O aplicativo permite gerar **listas de materiais diretamente a partir do orçamento**.

Funcionalidades:

* ✅ Criação manual de lista de materiais
* ✅ Associação com número do orçamento
* ✅ Quantidade e unidade de medida
* ✅ Histórico de listas salvas
* ✅ Visualização posterior da lista
* ✅ Geração de **PDF profissional da lista**

---

# 🔹 Controle de Status do Orçamento

Cada orçamento possui status para controle comercial:

| Status           | Cor      | Significado                  |
| ---------------- | -------- | ---------------------------- |
| 🟠 **PENDENTE**  | Laranja  | Orçamento enviado ao cliente |
| 🟢 **FECHADO**   | Verde    | Serviço aprovado             |
| 🔴 **CANCELADO** | Vermelho | Cliente recusou              |

Funcionalidades:

* ✅ Alterar status diretamente no histórico
* ✅ Marcar orçamento como **Fechado** em um clique
* ✅ Controle visual por cores

---

# 🔎 Histórico Inteligente

Tela de histórico com recursos profissionais:

* ✅ Filtro por status

  * Todos
  * Pendentes
  * Fechados
  * Cancelados

* ✅ Busca por **cliente ou número do orçamento**

* ✅ Alteração rápida de status

* ✅ Exclusão de orçamento

* ✅ Acesso rápido para edição

---

# 🧮 Cálculos Inteligentes

* ✅ Cadastro dinâmico de itens de serviço

* ✅ Cálculo automático em tempo real

* ✅ Cálculo de deslocamento
  `Distância (km) × Custo por km`

* ✅ Campo opcional de despesas adicionais

* ✅ Aplicação de desconto percentual

* ✅ Controle e exibição do desconto no histórico

* ✅ Total geral fixo em barra inferior
  (UX profissional)

---

# 🏢 Configuração da Empresa

Cada empresa pode personalizar o aplicativo com suas próprias informações:

* ✅ Nome da empresa
* ✅ Logotipo personalizado
* ✅ Telefone de contato
* ✅ Email da empresa

Essas informações são utilizadas automaticamente nos **PDFs gerados pelo aplicativo**.

---

# 📊 Dashboard Financeiro

Tela de controle financeiro mensal com indicadores de desempenho:

* ✅ Faturamento do mês
* ✅ Total de orçamentos emitidos
* ✅ Orçamentos fechados
* ✅ Orçamentos pendentes
* ✅ Descontos concedidos

O faturamento considera **apenas orçamentos com status FECHADO**.

---

# 📈 Gráfico Financeiro

O dashboard apresenta **visualização gráfica dos dados financeiros**.

O gráfico permite acompanhar rapidamente:

* Faturamento do mês
* Total de descontos concedidos

A visualização foi implementada utilizando:

```
fl_chart
```

Essa funcionalidade melhora a **análise de desempenho comercial diretamente no aplicativo**.

---

# 📄 Geração de PDF Profissional

O aplicativo gera **PDF profissional para envio ao cliente**.

## PDF de Orçamento

* ✅ Logo personalizada da empresa
* ✅ Marca d'água no documento
* ✅ Layout profissional
* ✅ Numeração automática do orçamento
* ✅ Itens detalhados
* ✅ Cálculo completo do serviço
* ✅ Total destacado
* ✅ Compartilhamento direto

## PDF de Lista de Materiais

* ✅ Logo da empresa
* ✅ Número do orçamento
* ✅ Cliente
* ✅ Tabela de materiais
* ✅ Quantidade e unidade
* ✅ Contato da empresa

---

# 🛠 Tecnologias Utilizadas

* Flutter
* Dart
* SQLite (`sqflite`)
* `pdf`
* `printing`
* `share_plus`
* `path_provider`
* `url_launcher`
* `intl`
* `fl_chart`
* `shared_preferences`

---

# ▶ Como Executar o Projeto

### 1️⃣ Clonar o repositório

```
git clone https://github.com/RobertoGine/app-orcamentos-roberto-gine.git
```

### 2️⃣ Acessar a pasta

```
cd app-orcamentos-roberto-gine
```

### 3️⃣ Instalar dependências

```
flutter pub get
```

### 4️⃣ Executar o projeto

```
flutter run
```

---

# 📂 Estrutura do Projeto

```
lib/
 ├── models/
 │    └── orcamento_model.dart
 │
 ├── screens/
 │    ├── cliente_screen.dart
 │    ├── itens_screen.dart
 │    ├── resumo_screen.dart
 │    ├── historico_screen.dart
 │    ├── dashboard_screen.dart
 │    ├── configuracoes_screen.dart
 │    ├── lista_material_screen.dart
 │    ├── visualizar_lista_screen.dart
 │    └── splash_screen.dart
 │
 ├── services/
 │    ├── pdf_service.dart
 │    ├── pdf_lista_material_service.dart
 │    └── database_helper.dart
 │
 ├── widgets/
 │    └── grafico_financeiro.dart
 │
 └── utils/
      └── formatters.dart
```

---

# 🚀 Próximas Evoluções

Planejamento de evolução do sistema:

* [ ] Gráfico de faturamento **por mês**
* [ ] Filtro por período (mês / ano)
* [ ] Backup do banco de dados
* [ ] Exportação de relatórios
* [ ] Cadastro de clientes
* [ ] Sistema multiempresa
* [ ] Publicação na Play Store
* [ ] Versão web administrativa

---

# 👨‍💻 Autor

**Roberto Giné**

Técnico em elétrica e desenvolvedor.

Aplicativo desenvolvido para **gestão profissional de serviços elétricos e geração de orçamentos comerciais**.
