# 📺 Android TV Remote Pairing Fix — Desbloqueador e Corretor Definitivo

<p align="center">
  <b>🇧🇷 Português</b> | <a href="README.en.md">🇺🇸 English</a>
</p>

<p align="center">
  <a href="https://github.com/Emertels/AndroidTV-Remote-Pairing-Fix/releases"><img src="https://img.shields.io/badge/Release-v1.0.0-blue.svg" alt="Versão v1.0.0"></a>
  <a href="https://android.com"><img src="https://img.shields.io/badge/Plataforma-Android%20TV%20%7C%20Google%20TV-3DDC84.svg?logo=android&logoColor=white" alt="Plataforma"></a>
  <a href="https://microsoft.com/windows"><img src="https://img.shields.io/badge/OS-Windows%2010%20%2F%2011-0078D6.svg?logo=windows&logoColor=white" alt="Windows"></a>
  <img src="https://img.shields.io/badge/i18n-PT--BR%20%7C%20EN-success.svg" alt="Idiomas">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-brightgreen.svg" alt="Licença MIT"></a>
</p>

Utilitário portátil e inteligente desenvolvido por **Emerson Teles** (com assistência técnica do **Gemini**) para solucionar de forma definitiva o problema de travamento na tela de pareamento forçado de controle remoto (`com.mft.rcupair`) e fornecer otimização total para TV Sticks e TV Boxes (Mecool, Mibro, Skyworth e compatíveis rodando Android 11, 12 e 14 / Google TV).

---

## 📋 Sumário

1. [O Problema Crônico](#-o-problema-crônico)
2. [A Descoberta da Causa Raiz](#-a-descoberta-da-causa-raiz)
3. [As Duas Formas de Resolver](#-as-duas-formas-de-resolver)
   - [Método 1: Script Portátil 1-Clique para Windows (.BAT)](#método-1-script-portátil-1-clique-para-pc-windows)
   - [Método 2: Direto no TV Box sem Computador (via LADB)](#método-2-direto-no-tv-box-sem-computador-via-ladb)
4. [Recursos Extras e Otimizações de Sistema](#-recursos-extras-e-otimizações-de-sistema)
5. [Estrutura do Repositório](#-estrutura-do-repositório)
6. [Licença](#-licença)
7. [Sobre o Autor & Redes Oficiais](#-sobre-o-autor--redes-oficiais)

---

## 🚨 O Problema Crônico

Usuários de aparelhos TV Stick e TV Box baseados em hardware Skyworth/Amlogic (como Mecool KD3, KD5, Mibro 4K Stick e similares) frequentemente enfrentam um problema extremamente frustrante:

- Toda vez que o aparelho é ligado ou reiniciado do zero (boot completo), o sistema trava em uma tela preta exibindo uma animação pedindo para pressionar e segurar os botões **Voltar + Home** do controle remoto original de fábrica.
- Ao utilizar controles universais, Air Mouse (como **G20S Pro**, **G10**, **G20**, teclados sem fio USB ou controles Bluetooth de terceiros), **a tela simplesmente não sai**, impedindo o acesso à tela inicial.
- O usuário fica refém de pressionar teclas aleatórias insistentemente na esperança de o sistema ignorar a tela ou precisa manter o controle quebrado/original guardado.

---

## 🧠 A Descoberta da Causa Raiz

Durante uma análise de baixo nível da árvore de processos e pacotes do sistema Android 14 realizada por **Emerson Teles** com suporte analítico do **Gemini**, descobriu-se que a falha **não é problema de hardware e nem defeito do seu controle Air Mouse**:

```mermaid
flowchart TD
    A["Inicialização do Android (Boot)"] --> B["Broadcast: android.intent.action.BOOT_COMPLETED"]
    B --> C["com.mft.rcupair (BootCompletedReceiver - Prioridade 100)"]
    C --> D{"Controle Original OEM Detectado?"}
    D -- "NÃO (Usando G20S Pro / Air Mouse)" --> E["Dispara com.skyworthdigital.rcupair.PairActivity"]
    E --> F["🚫 TELA DE PAREAMENTO TRAVADA NO BOOT"]
    D -- "SIM" --> G["Inicializa Launcher Normal"]
    
    H["Solução Emerson Teles: pm disable-user com.mft.rcupair"] -.-> C
    C -. "DESATIVADO" .-> G
```

1. **O Aplicativo Oculto de Fábrica:**  
   O firmware traz embutido na partição de sistema o pacote `/system/app/SdtRcuPair/SdtRcuPair.apk` (identificador: `com.mft.rcupair`).
2. **Receptor com Prioridade Máxima:**  
   Ele possui registrado o componente `com.skyworthdigital.rcupair.receiver.BootCompletedReceiver` escutando o evento `BOOT_COMPLETED` com prioridade **100**.
3. **Bloqueio de Controles Genéricos:**  
   O aplicativo verifica exclusivamente o identificador Bluetooth de fábrica da OEM. Quando detecta que você está usando um controle alternativo (mesmo conectado por Bluetooth ou dongle USB), ele assume erroneamente que o dispositivo está "sem controle" e força a abertura da atividade `PairActivity`.
4. **Persistência Irritante:**  
   Como o pacote é nativo do sistema operacional, as configurações convencionais do Google TV não oferecem nenhuma opção para desinstalá-lo ou desativá-lo pela interface visual.

---

## 🛠️ As Duas Formas de Resolver

Disponibilizamos duas abordagens práticas e 100% testadas para eliminar esse incômodo de forma definitiva.

### Método 1: Script Portátil 1-Clique para PC Windows

Esta é a opção mais rápida e automatizada, ideal para quem tem um computador na mesma rede Wi-Fi do TV Box.

1. Baixe o pacote pronto para uso na aba [Releases v1.0.0](https://github.com/Emertels/AndroidTV-Remote-Pairing-Fix/releases) (`AndroidTV-Remote-Pairing-Fix-v1.0.0-win64.zip`).
2. Extraia o arquivo `.zip` em qualquer pasta do seu computador.
3. Certifique-se de que a **Depuração por Wi-Fi** está ativada no seu Stick (`Configurações > Opções do desenvolvedor > Depuração por Wi-Fi`).
4. Execute o arquivo **`Corrigir_Controle_Stick.bat`** com dois cliques.
5. Digite o endereço IP do seu Stick quando solicitado (ex: `192.168.1.14`).
6. Escolha a **Opção [1]** para desativar a tela do controle em 1 segundo, ou a **Opção [2]** para otimização completa (desativação do launcher pesado, remoção de bloatwares e sincronização HDMI-CEC).

---

### Método 2: Direto no TV Box sem Computador (via LADB)

Se você não tiver um computador por perto, é possível desativar o pacote diretamente de dentro do próprio TV Box usando o aplicativo **LADB (Local ADB)**:

1. **Baixar o LADB:** Instale o aplicativo **LADB — Local ADB Shell** no seu Stick (via Play Store ou baixando o APK).
2. **Ativar Opções do Desenvolvedor:**
   - Vá em `Configurações > Sistema > Sobre > Número da versão (Build)` e clique 7 vezes no botão OK até aparecer a mensagem *"Você agora é um desenvolvedor"*.
3. **Parear o LADB com o Sistema:**
   - Abra o LADB na TV. Ele solicitará a **Porta** e o **Código de Pareamento**.
   - Coloque o LADB em tela dividida (ou abra em janela sobreposta) e acesse `Configurações > Opções do desenvolvedor > Depuração por Wi-Fi > Parear dispositivo com código de pareamento`.
   - Digite o código de 6 dígitos e a porta de pareamento no LADB e clique em **Pair**.
4. **Executar o Comando:**
   - No terminal do LADB dentro da TV, cole e execute o comando:
     ```bash
     pm disable-user --user 0 com.mft.rcupair
     ```
5. Pronto! Ao receber a resposta `Package com.mft.rcupair new state: disabled-user`, a tela estará permanentemente extinta.

---

## ⚡ Recursos Extras e Otimizações de Sistema

Além da correção do controle, este repositório documenta e automatiza as melhores práticas para deixar seu TV Stick leve e rápido:

* **Projectivy Launcher como Padrão Nativo:**  
  Desativação do launcher pesado com propagandas da Google TV (`launcherx`) e de seu fallback (`setupwraith`), garantindo abertura instantânea do Projectivy ao pressionar a tecla Home.
* **Remoção de Bloatwares de Streaming:**  
  Desinstalação de pacotes pesados pré-instalados de fábrica (Netflix, Prime Video, YouTube, YouTube Music, Google Play Games).
* **Sincronização Total HDMI-CEC:**  
  Ativação das flags globais do sistema (`hdmi_control_auto_wakeup_enabled = 1`) para ligar e desligar o aparelho em conjunto com a televisão (especialmente TVs Sony Bravia Sync).

---

## 📂 Estrutura do Repositório

```text
AndroidTV-Remote-Pairing-Fix/
├── Corrigir_Controle_Stick.bat  # Script interativo 1-clique com menu em português
├── README.md                    # Documentação principal em Português
├── README.en.md                 # Full documentation in English
├── MANUAL.md                    # Manual passo a passo detalhado (PC e LADB)
├── MANUAL.en.md                 # Comprehensive step-by-step User Manual (EN)
├── AGENTS.md                    # Diretrizes técnicas para IA e desenvolvedores
├── CHANGELOG.md                 # Registro histórico de alterações
└── LICENSE                      # Licença de código aberto MIT
```

---

## 📄 Licença

Distribuído sob a licença **MIT**. Consulte o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 👨‍💻 Sobre o Autor & Redes Oficiais

Desenvolvido e mantido por **Emerson Teles** (conhecido na comunidade como **Emertels**).

Entusiasta de tecnologia, informática, eletrônica, jogos, manutenção avançada de sistemas e tradução/localização técnica de softwares para Português do Brasil (PT-BR). Desenvolvedor focado em utilitários práticos, ferramentas de produtividade, automação inteligente e correções de sistema para a comunidade.

### 🌐 Conecte-se comigo & Comunidades Oficiais

<div align="left">

[![GitHub](https://img.shields.io/badge/GitHub-Emertels-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/emertels)
[![Website](https://img.shields.io/badge/Website-Emerson_Teles-0070F3?style=for-the-badge&logo=googlechrome&logoColor=white)](https://emertels.github.io)
[![Discord](https://img.shields.io/badge/Discord-Emertels%20Server-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://emertels.github.io/discord)
[![X / Twitter](https://img.shields.io/badge/X_Twitter-@emertels-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/emertels)
[![YouTube](https://img.shields.io/badge/YouTube-Emerson_Teles-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@emersonteles2379)
[![Telegram](https://img.shields.io/badge/Telegram-Aplicativos%20Mods-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/apksmodsandroid)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-Apoiar%20Projeto-FF5E5B?style=for-the-badge&logo=kofi&logoColor=white)](https://ko-fi.com/emertels)

</div>
