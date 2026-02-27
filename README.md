# ⚡ App Orçamentos - Roberto Giné

Aplicativo desenvolvido em Flutter para geração e gestão de orçamentos profissionais para serviços elétricos.

Sistema completo com histórico, edição, controle de desconto, cálculo de deslocamento e geração de PDF personalizado.

---

## 📱 Funcionalidades Atuais

### 🔹 Gestão de Orçamentos

- ✅ Criação de orçamento com numeração automática (ORC-0001, ORC-0002...)
- ✅ Edição completa de orçamentos salvos
- ✅ Exclusão com confirmação
- ✅ Histórico persistente (SQLite)

### 🔹 Cálculos Inteligentes

- ✅ Cadastro dinâmico de itens
- ✅ Cálculo automático em tempo real
- ✅ Cálculo de deslocamento (km x custo por km)
- ✅ Campo opcional de alimentação
- ✅ Aplicação de desconto percentual
- ✅ Controle e exibição do desconto no histórico
- ✅ Total geral fixo em barra inferior (UX profissional)

### 🔹 Persistência de Dados

- ✅ Banco de dados local (SQLite)
- ✅ Itens vinculados ao orçamento
- ✅ Salvamento de:
  - Km
  - Custo por km
  - Alimentação
  - Desconto
  - Total final

### 🔹 Geração de PDF Profissional

- ✅ Logo personalizada
- ✅ Marca d'água
- ✅ Layout organizado e profissional
- ✅ Numeração do orçamento no PDF
- ✅ Compartilhamento direto

---

## 🛠 Tecnologias Utilizadas

- Flutter
- Dart
- SQLite (sqflite)
- package:pdf
- share_plus
- path_provider
- url_launcher
- intl

---

## ▶ Como Executar o Projeto

1. Clone o repositório: git clone <https://github.com/RobertoGine/app-orcamentos-roberto-gine.git>

2. Acesse a pasta: cd app-orcamentos-roberto-gine

3. Instale as dependências: flutter pub get

4. Execute: flutter run

---

## 📂 Estrutura do Projeto

```text
lib/
 ├── screens/
 │    ├── cliente_screen.dart
 │    ├── itens_screen.dart
 │    ├── resumo_screen.dart
 │    ├── historico_screen.dart
 ├── services/
 │    ├── pdf_service.dart
 │    ├── database_helper.dart
```

---

## Próximas Evoluções

- [ ] Status do orçamento (Aberto / Aprovado / Pago)

- [ ] Dashboard financeiro mensal

- [ ] Filtro por cliente

- [ ] Backup do banco de dados

- [ ] Versão comercial para Play Store

---

## 👨‍💻 Autor

Roberto Giné
Sistema desenvolvido para gestão profissional de serviços elétricos.

---
