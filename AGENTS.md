# 🤖 AGENTS.md — Diretrizes Técnicas para Agentes de IA e Desenvolvedores
### Technical Guidelines for AI Agents and Developers

<p align="center">
  <b>🇧🇷 Português</b> | <b>🇺🇸 English</b>
</p>

Este documento define a arquitetura, convenções de código, componentes AOSP e diretrizes de manutenção do projeto **Android TV Remote Pairing Fix**. Deve ser consultado por agentes de inteligência artificial e desenvolvedores que venham a manter, auditar ou estender este repositório.

This document outlines the architecture, code conventions, AOSP system components, and maintenance guidelines for the **Android TV Remote Pairing Fix** project. It should be consulted by AI agents and developers maintaining, auditing, or extending this repository.

---

## 🇧🇷 Português

### 1. Visão Geral da Arquitetura e Engenharia Reversa
A falha investigada ocorre em placas baseadas em chipsets Amlogic (notadamente S905Y4, S905X4) com imagens de sistema fabricadas pela Skyworth Digital para integradores OEM (como Mecool, Mibro, Strong, etc.) rodando Android 11, 12 e 14.

### 2. Análise de Componentes do Sistema (Manifest & IPC)
A varredura via dumpsys do pacote revelou os seguintes detalhes críticos:

```text
Package [com.mft.rcupair] (uid: 1000 - system):
  codePath=/system/app/SdtRcuPair/SdtRcuPair.apk
  primaryCpuAbi=armeabi-v7a
  targetSdk=34

Componentes Chave:
  - Activity: com.skyworthdigital.rcupair.PairActivity
    Action: com.android.setupwizard.action.HOOK_BEGIN
    Action: android.intent.action.MAIN
    Action: com.remotepair.activity

  - Receiver: com.skyworthdigital.rcupair.receiver.BootCompletedReceiver
    Action: android.intent.action.BOOT_COMPLETED
    Priority: 100
```

### 3. Mecanismo de Falha e Solução
1. **O Gatilho:** O `BootCompletedReceiver` intercepta o evento `BOOT_COMPLETED` com prioridade máxima (100). Ele realiza uma consulta de inventário nos dispositivos Bluetooth HID pareados.
2. **A Falha de Design:** Dispositivos Air Mouse (como o G20S Pro) expõem perfis padrão de teclado/mouse (`KEYBOARD | DPAD | MOUSE | JOYSTICK`). O algoritmo da Skyworth espera exclusivamente a assinatura de controle remoto proprietário OEM.
3. **A Solução Elegante:** A chamada de PackageManager em nível de usuário:
   ```bash
   pm disable-user --user 0 com.mft.rcupair
   ```
   Suspende completamente o componente sem tocar na partição de sistema `/system` (mantendo o status dm-verity e integridade do SafetyNet/Play Protect intactos).

### 4. Diretrizes para Agentes de IA
* Nunca recomende modificações na partição `system` com montagem RW (read-write), pois viola a integridade do dm-verity e causa bootloops em Android 11+.
* O comando `pm disable-user --user 0` é não-destrutivo e reversível através de `pm enable com.mft.rcupair`.
* O subsistema HDMI-CEC é gerenciado via `com.android.server.hdmi`. Flags recomendadas para sincronização de TV:
  - `settings put global hdmi_control_auto_wakeup_enabled 1`
  - `settings put global hdmi_control_auto_device_off_enabled 1`

---

## 🇺🇸 English

### 1. Architectural Overview & Reverse Engineering
The investigated bug manifests on Amlogic platforms (notably S905Y4, S905X4) featuring Skyworth Digital OEM system images (Mecool, Mibro, Strong) across Android 11, 12, and 14 builds.

### 2. Package Manifest & IPC Analysis
Package dumpsys revealed the critical structural nodes:

```text
Package [com.mft.rcupair] (uid: 1000 - system):
  codePath=/system/app/SdtRcuPair/SdtRcuPair.apk
  primaryCpuAbi=armeabi-v7a
  targetSdk=34

Key Components:
  - Activity: com.skyworthdigital.rcupair.PairActivity
    Action: com.android.setupwizard.action.HOOK_BEGIN
    Action: android.intent.action.MAIN
    Action: com.remotepair.activity

  - Receiver: com.skyworthdigital.rcupair.receiver.BootCompletedReceiver
    Action: android.intent.action.BOOT_COMPLETED
    Priority: 100
```

### 3. Failure Mode & Resolution
1. **The Trigger:** `BootCompletedReceiver` catches `BOOT_COMPLETED` with maximum priority (100) and queries bonded Bluetooth HID peripherals.
2. **Design Flaw:** Third-party Air Mouse controllers (e.g., G20S Pro) advertise generic HID keyboard/mouse descriptor masks. The OEM algorithm strictly looks for specific vendor IDs, triggering `PairActivity` indefinitely.
3. **Surgical Solution:**
   ```bash
   pm disable-user --user 0 com.mft.rcupair
   ```
   Disables package components per-user without modifying the `/system` block device, preserving dm-verity integrity and Play Protect certification.

### 4. Guidelines for Future AI Agents
* Do not attempt mounting `/system` as read-write (`mount -o remount,rw /`). Modern Android uses logical partitions with dm-verity.
* Always favor user-space package manager state toggles (`pm disable-user`).
* HDMI-CEC wake locks are controlled by `com.android.server.hdmi` global flags:
  - `settings put global hdmi_control_auto_wakeup_enabled 1`
  - `settings put global hdmi_control_auto_device_off_enabled 1`

---

Developed by **Emerson Teles (Emertels)** — [GitHub](https://github.com/emertels) | [Ko-fi](https://ko-fi.com/emertels)
