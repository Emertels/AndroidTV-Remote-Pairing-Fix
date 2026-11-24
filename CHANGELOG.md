# Changelog — Configuração e Otimização do Stick Mecool / Mibro 4K (Android 14)

Todas as alterações técnicas, customizações e correções realizadas via ADB e ajustes de hardware/sistema no Stick 4K (Amlogic S905Y4) conectado à TV Sony 32" HD (720p).

---

## [2026-11-24] — Correção Definitiva do Controle e Inicialização

### 🛑 Eliminação da Tela de Pareamento no Boot
- **Problema:** A cada inicialização, o sistema travava na tela de pareamento exigindo pressionar as teclas `[Voltar] + [Home]` do controle original.
- **Diagnóstico:** O stick possui um aplicativo de fábrica da OEM (`/system/app/SdtRcuPair/SdtRcuPair.apk` — pacote `com.mft.rcupair`) contendo o receptor `com.skyworthdigital.rcupair.receiver.BootCompletedReceiver`. Ele disparava compulsoriamente a atividade `com.skyworthdigital.rcupair.PairActivity` com prioridade 100 no boot sempre que o controle OEM não era detectado.
- **Ação:** Pacote desativado permanentemente no sistema via comando:
  ```bash
  pm disable-user --user 0 com.mft.rcupair
  ```
- **Resultado:** O boot agora sobe direto para o Projectivy Launcher sem interrupções nem telas de aviso de controle.

### ⚡ HDMI-CEC e Sincronização de Energia
- **Ajuste:** Habilitado o auto wake-up e auto power off global do HDMI-CEC via sistema:
  ```bash
  settings put global hdmi_control_auto_wakeup_enabled 1
  settings put global hdmi_control_auto_device_off_enabled 1
  settings put global hdmi_control_one_touch_play_enabled 1
  ```
- **Validação de Hardware:** O controle `G20S PRO Keyboard` foi validado como dispositivo de entrada ativo no subsistema de input do kernel Android (`Device 7: G20S PRO Keyboard`).
- **IR Learning:** Botão Power clonado do controle da TV Sony via feixe óptico infravermelho para acionamento confiável em conjunto com o Bravia Sync (HDMI-CEC).

---

## [2026-11-23] — Configuração Inicial, Overscan, Launcher e Limpeza

### 📺 Resolução e Calibração de Tela (Overscan)
- **Problema:** Imagem cortada nas bordas da TV Sony (720p 60Hz) com configurações de tela da TV bloqueadas em cinza.
- **Resolução:** Utilizado o menu exclusivo de calibração de escala da Amlogic exposto pelo Projectivy Launcher, calibrando o recuo de margem com gravação em memória persistente (`persist/ubootenv`).

### 🚀 Projectivy Launcher como Padrão Nativo
- **Ação:** Desativado o launcher stock do Google TV e seu fallback para liberar o Projectivy de forma permanente:
  ```bash
  pm disable-user --user 0 com.google.android.apps.tv.launcherx
  pm disable-user --user 0 com.google.android.tungsten.setupwraith
  ```
- **Resultado:** O botão Home agora responde instantaneamente abrindo o Projectivy.

### 🧹 Remoção de Bloatwares (Streamings de Fábrica)
- Desinstalados os seguintes pacotes pré-instalados de streaming para o usuário 0:
  - Netflix: `com.netflix.ninja`, `com.netflix.tokenmanager`
  - Prime Video: `com.amazon.amazonvideo.livingroom`
  - YouTube: `com.google.android.youtube.tv`
  - YouTube Music: `com.google.android.youtube.tvmusic`
  - Google Play Games: `com.google.android.play.games`

### 📦 Instalação de Aplicativos Otimizados
- **SmartTube:** Instalada a versão estável oficial `org.smarttube.stable` (v32.80) compilada para a arquitetura 32-bit (`armeabi-v7a`) do aparelho.
- **Overflight Plugin:** Instalada a versão oficial 1.20 (`tv.projectivy.plugin.wallpaperprovider.overflight`) para reprodução de vídeos aéreos (Apple TV Aerials) em segundo plano no Projectivy.
- **Live Wallpaper Picker:** Instalado `com.android.wallpaper.livepicker` para suporte a papéis de parede animados.

### 🔌 Persistência ADB
- Configurada a porta padrão TCP/IP `5555` para conexões diretas via rede local.
