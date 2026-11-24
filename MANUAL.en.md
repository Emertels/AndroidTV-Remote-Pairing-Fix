# 📖 Instruction and Diagnostic Manual — Android TV Remote Pairing Fix

<p align="center">
  <a href="MANUAL.md">🇧🇷 Português</a> | <b>🇺🇸 English</b>
</p>

This manual provides comprehensive diagnostic, operational, and maintenance instructions for the remote control unblock utility on TV Sticks and TV Boxes running **Android TV** and **Google TV** (Mecool, Mibro, Skyworth, and compatible devices).

---

## 🎯 Utility Objective

This utility was created to permanently resolve the system boot-lock state characterized by:
1. TV Box or Stick booting into a forced pairing wizard prompting to press and hold **Back + Home** on the factory OEM remote control.
2. Third-party or universal controllers (Air Mouse like **G20S Pro**, **G10**, wireless USB keyboards, or generic Bluetooth remotes) being unable to dismiss the overlay.
3. Needing to power cycle the device repeatedly or mash random keys hoping the timeout dismisses the pairing prompt.

---

## 🚀 How to Use (Two Distinct Methods)

---

### Method 1: Using Windows PC via Quick Script (.BAT) *(Recommended)*

This is the fastest and most convenient method, executing the fix wirelessly over your home network without installing extra apps on the TV Box.

#### 1. Preparation on the TV:
1. Power on your TV Box and ensure it is connected to your home **Wi-Fi** network.
2. Navigate to **Settings > Developer Options**.
   *(If Developer Options are hidden: go to `Settings > System > About > OS Build Number` and click OK 7 consecutive times).*
3. Locate and enable **Wireless Debugging** (or *Network Debugging*).

#### 2. Execution on Windows PC:
1. On your Windows PC (connected to the same Wi-Fi), go to the [Releases v1.0.0](https://github.com/Emertels/AndroidTV-Remote-Pairing-Fix/releases) tab and download `AndroidTV-Remote-Pairing-Fix-v1.0.0-win64.zip`.
2. Right-click the downloaded `.zip` file and select **Extract All**.
3. Double-click the file **`Corrigir_Controle_Stick.bat`**.
4. The console interface will launch:
   - Enter your TV Stick's local IP address (e.g., `192.168.1.14`) and press Enter.
   - On the first connection, look at the TV screen: a prompt will ask *"Allow USB debugging?"*. Check the box **"Always allow from this computer"** and select **Allow / OK** using your remote.
5. In the script menu on your PC, type **`1`** (for the quick remote fix) or **`2`** (for full optimization including debloat and HDMI-CEC sync).
6. A green success message will be displayed. The `com.mft.rcupair` package is permanently disabled!

---

### Method 2: Directly on the TV Box without a Computer (via LADB App)

If you don't have a PC available, you can execute the command directly on your TV Box using the **LADB (Local ADB Shell)** application.

#### 1. Installation & Preparation:
1. On your TV Box, install **LADB — Local ADB Shell** via the Google Play Store (or sideload the APK using Downloader or a USB drive).
2. Ensure Developer Options are active (`Settings > System > About > OS Build Number` clicked 7 times).

#### 2. Pairing on Android 11, 12, or 14:
1. Navigate to `Settings > Developer Options > Wireless Debugging`.
2. Click on **"Pair device with pairing code"**.
3. A modal popup will appear displaying:
   * **Wi-Fi pairing code:** 6 digits (e.g., `556717`).
   * **IP address & Port:** (e.g., `192.168.1.14:41237`).
   *(The pairing port refers only to the numbers **after the colon**, in this example: `41237`).*
4. Open the **LADB** app on your TV:
   * Enter the 6-digit code in the *Pairing Code* field.
   * Enter the pairing port in the *Port* field.
   * Click **Pair**. LADB will connect and present an interactive shell terminal.

#### 3. Applying the Fix:
1. In the LADB terminal, type the exact command:
   ```bash
   pm disable-user --user 0 com.mft.rcupair
   ```
2. Press Enter on your remote keyboard.
3. The system will respond:  
   `Package com.mft.rcupair new state: disabled-user`
4. Done! The pairing wizard has been eliminated and your device will always boot straight to the home launcher.

---

## 🔍 Diagnostics & Troubleshooting

| Observed Symptom | Probable Cause | Recommended Action |
|---|---|---|
| The script outputs `cannot connect to IP:5555: Connection refused`. | The device rebooted and Android 14 closed the default port 5555. | In the script menu, enter the dynamic port shown under *Wireless Debugging* or use the 6-digit pair option. |
| The LADB app reports `failed to pair`. | The 6-digit pairing code timed out after leaving the dialog. | Re-open the pairing modal on the TV and immediately enter the new code and port into LADB. |
| The G20S Pro remote powers off the TV, but cannot power it back on. | The stick went into deep power off, cutting USB/BT power. | Perform IR Learning on the Power button with the TV remote or set the stick's power mode to **Suspend (Standby)**. |
| I want to restore the original OEM remote pairing wizard. | The user acquired an original OEM remote and wants the assistant back. | In the PC script, select **Option [3]** or in LADB run `pm enable com.mft.rcupair`. |

---

## ⚙️ System Requirements

* **Supported Hardware:** TV Sticks and TV Boxes with Amlogic SoC (S905Y4, S905X4, etc.) running Android 11, 12, or 14 with Google TV or Android TV interface.
* **PC Environment (Method 1):** Windows 10 or 11 (64-bit). No administrator privileges required.
* **TV Environment (Method 2):** LADB (Local ADB Shell) application installed directly on the TV Box.

---

## 📄 License & Authorship

- **Author:** Emerson Teles ([@Emertels](https://github.com/emertels))
- **Technical Assistance:** Gemini (Google DeepMind)
- **License:** MIT License
