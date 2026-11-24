# 📖 Manual de Instruções e Diagnóstico — Android TV Remote Pairing Fix

<p align="center">
  <b>🇧🇷 Português</b> | <a href="MANUAL.en.md">🇺🇸 English</a>
</p>

Este manual contém instruções completas de diagnóstico, utilização e manutenção do utilitário de desbloqueio de controle para TV Sticks e TV Boxes com **Android TV** e **Google TV** (Mecool, Mibro, Skyworth, etc.).

---

## 🎯 Objetivo do Utilitário

O utilitário foi concebido para resolver de forma definitiva o travamento da tela de inicialização caracterizado por:
1. TV Box ou Stick iniciando travado na tela de pareamento pedindo para pressionar e segurar as teclas **Voltar + Home** do controle de fábrica.
2. Controles alternativos (Air Mouse como **G20S Pro**, **G10**, teclados sem fio USB ou controles Bluetooth de terceiros) sem conseguir fechar a tela.
3. Necessidade de desligar e ligar da tomada ou apertar teclas aleatórias insistentemente na esperança de o sistema ignorar o assistente.

---

## 🚀 Como Utilizar (Duas Formas de Correção)

---

### Método 1: Pelo Computador via Script Rápido (.BAT) *(Recomendado)*

Esta é a opção mais prática e rápida, pois executa a correção pelo Wi-Fi sem precisar instalar nada no seu TV Box.

#### 1. Preparação na TV:
1. Ligue o TV Box e certifique-se de que ele está conectado à rede **Wi-Fi** da sua casa.
2. Acesse **Configurações > Opções do Desenvolvedor**.
   *(Se as opções do desenvolvedor não estiverem visíveis: vá em `Configurações > Sistema > Sobre > Número da versão (Build)` e clique no botão OK 7 vezes seguidas).*
3. Localize e ative a opção **Depuração por Wi-Fi** (ou *Depuração de rede*).

#### 2. Execução no Computador:
1. No seu computador com Windows (conectado no mesmo Wi-Fi), acesse a aba [Releases v1.0.0](https://github.com/Emertels/AndroidTV-Remote-Pairing-Fix/releases) e baixe o arquivo `AndroidTV-Remote-Pairing-Fix-v1.0.0-win64.zip`.
2. Clique com o botão direito no arquivo baixado e selecione **Extrair Tudo**.
3. Dê **dois cliques** no arquivo **`Corrigir_Controle_Stick.bat`**.
4. Uma tela azul com o menu do utilitário se abrirá:
   - Digite o endereço IP do seu Stick (exemplo: `192.168.1.14`) e pressione Enter.
   - Na primeira conexão, olhe para a tela da TV: aparecerá uma janela perguntando *"Permitir depuração USB?"*. Marque a caixa de seleção **"Sempre permitir a partir deste computador"** e selecione **Permitir / OK** com o controle.
5. No menu do script no PC, digite **`1`** (para a correção rápida) ou **`2`** (para a otimização completa com remoção de bloatwares e ativação de HDMI-CEC).
6. A mensagem de sucesso verde será exibida. O pacote `com.mft.rcupair` estará desativado permanentemente!

---

### Método 2: Direto no TV Box sem Computador (via Aplicativo LADB)

Caso você não tenha um computador disponível, é possível aplicar o mesmo comando diretamente dentro do TV Box usando o aplicativo **LADB (Local ADB Shell)**.

#### 1. Instalação e Preparação:
1. No TV Box, instale o aplicativo **LADB — Local ADB Shell** através da Google Play Store (ou transferindo o APK via pendrive/Downloader).
2. Garanta que o Modo de Desenvolvedor está ativo (`Configurações > Sistema > Sobre > Número da versão (Build)` clicando 7 vezes).

#### 2. Pareamento no Android 11, 12 ou 14:
1. Vá em `Configurações > Opções do Desenvolvedor > Depuração por Wi-Fi`.
2. Clique na opção **"Parear dispositivo com código de pareamento"**.
3. Uma tela pop-up será exibida com:
   * **Código de pareamento por Wi-Fi:** 6 dígitos (ex: `556717`).
   * **Endereço IP e porta:** (ex: `192.168.1.14:41237`).
   *(A porta de pareamento corresponde apenas aos 5 números **após os dois pontos**, no exemplo: `41237`).*
4. Abra o aplicativo **LADB** na TV:
   * No campo *Pairing Code*, digite o código de 6 números.
   * No campo *Port*, digite a porta de pareamento.
   * Clique em **Pair** (Parear). O LADB confirmará a conexão e abrirá o terminal.

#### 3. Aplicando o Desbloqueio:
1. No terminal do LADB na TV, digite exatamente o comando:
   ```bash
   pm disable-user --user 0 com.mft.rcupair
   ```
2. Pressione Enter no controle remoto.
3. O sistema responderá com:  
   `Package com.mft.rcupair new state: disabled-user`
4. Pronto! O assistente foi eliminado e o stick ligará sempre direto na tela inicial.

---

## 🔍 Diagnóstico e Resolução de Problemas

| Sintoma Observado | Causa Provável | Ação Recomendada |
|---|---|---|
| O script exibe `cannot connect to IP:5555: Connection refused`. | O aparelho reiniciou e o Android 14 fechou a porta padrão 5555. | No menu do script, informe a porta dinâmica que aparece em *Depuração por Wi-Fi* ou faça o pareamento com código. |
| O aplicativo LADB não conecta (`failed to pair`). | O código de 6 dígitos expirou após sair da tela de pareamento. | Abra a janela de pareamento na TV novamente e insira o novo código e a nova porta imediatamente no LADB. |
| O controle G20S Pro desliga a TV, mas não consegue ligar. | O stick entrou em desligamento total (Power Off) cortando a energia das portas USB/BT. | Realize a clonagem infravermelha (IR Learning) do botão Power com o controle da TV ou mude a configuração de energia do stick para **Suspender (Standby)**. |
| Desejo restaurar as configurações originais de fábrica do controle. | O usuário comprou um controle original e quer o assistente de volta. | No script do PC, selecione a **Opção [3]** ou no LADB digite `pm enable com.mft.rcupair`. |

---

## ⚙️ Requisitos do Sistema

* **Dispositivos Suportados:** TV Sticks e TV Boxes com processadores Amlogic (S905Y4, S905X4, etc.) rodando Android 11, 12 ou 14 com interface Google TV ou Android TV.
* **Ambiente PC (Método 1):** Windows 10 ou 11 (64-bit). Não requer privilégios de Administrador.
* **Ambiente TV (Método 2):** Aplicativo LADB (Local ADB Shell) instalado no próprio TV Box.

---

## 📄 Licença e Autoria

- **Autor:** Emerson Teles ([@Emertels](https://github.com/emertels))
- **Assistência Técnica:** Gemini (Google DeepMind)
- **Licença:** MIT License
