# ⚡ App Orçamentos — Roberto Giné

Aplicativo desenvolvido em **Flutter** para geração e gestão de **orçamentos profissionais para serviços elétricos**.

O sistema permite criar, editar e gerenciar orçamentos completos, calcular deslocamento, aplicar descontos e gerar **PDF profissional personalizado para envio ao cliente**.

O aplicativo também possui **histórico avançado com filtros, busca, controle de status e dashboard financeiro mensal**.

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

## 🔹 Controle de Status do Orçamento

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

## 🔹 Histórico Inteligente

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

## 🔹 Cálculos Inteligentes

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

## 🔹 Persistência de Dados

Banco de dados local com **SQLite**.

Cada orçamento salva:

* Km de deslocamento
* Custo por km
* Despesas adicionais
* Desconto aplicado
* Total final
* Status do orçamento

Os **itens ficam vinculados ao orçamento**.

---

## 🔹 Dashboard Financeiro

Tela de controle financeiro mensal com:

* ✅ Faturamento do mês
* ✅ Total de orçamentos emitidos
* ✅ Orçamentos fechados
* ✅ Orçamentos pendentes
* ✅ Descontos concedidos

O faturamento considera **apenas orçamentos fechados**.

---

## 🔹 Geração de PDF Profissional

O aplicativo gera **PDF profissional para envio ao cliente**:

* ✅ Logo personalizada da empresa
* ✅ Marca d'água no documento
* ✅ Layout profissional
* ✅ Numeração automática do orçamento
* ✅ Itens detalhados
* ✅ Total do serviço
* ✅ Compartilhamento direto

---

# 🛠 Tecnologias Utilizadas

* Flutter
* Dart
* SQLite (`sqflite`)
* `pdf`
* `share_plus`
* `path_provider`
* `url_launcher`
* `intl`

---

# ▶ Como Executar o Projeto

### 1️⃣ Clonar o repositório

```bash
git clone https://github.com/RobertoGine/app-orcamentos-roberto-gine.git
```

### 2️⃣ Acessar a pasta

```bash
cd app-orcamentos-roberto-gine
```

### 3️⃣ Instalar dependências

```bash
flutter pub get
```

### 4️⃣ Executar o projeto

```bash
flutter run
```

---

# 📂 Estrutura do Projeto

```text
lib/
 ├── screens/
 │    ├── cliente_screen.dart
 │    ├── itens_screen.dart
 │    ├── resumo_screen.dart
 │    ├── historico_screen.dart
 │    ├── dashboard_screen.dart
 │
 ├── services/
 │    ├── pdf_service.dart
 │    ├── database_helper.dart
```

---

# 🚀 Próximas Evoluções

Planejamento de evolução do sistema:

* [ ] Gráfico de faturamento mensal
* [ ] Filtro por período (mês / ano)
* [ ] Backup do banco de dados
* [ ] Exportação de relatórios
* [ ] Sistema multiempresa
* [ ] Publicação na Play Store

---

# 👨‍💻 Autor

**Roberto Giné**

Técnico em elétrica e desenvolvedor.

Aplicativo desenvolvido para **gestão profissional de serviços elétricos e geração de orçamentos comerciais**.
