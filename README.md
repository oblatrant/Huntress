

<div align="center">




<h1> HUNTRESS </h1>


**A comprehensive network stress testing tool for authorized penetration testing and educational purposes.**


[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Platform](https://img.shields.io/badge/Platform-Linux-green.svg)](https://www.linux.org/)
[![Shell](https://img.shields.io/badge/Shell-Bash-orange.svg)](https://www.gnu.org/software/bash/)


</div>



⚠️ Legal Disclaimer

**THIS TOOL IS FOR EDUCATIONAL AND AUTHORIZED TESTING PURPOSES ONLY**

• Only use this tool on systems you own or have explicit written permission to test

• Unauthorized network attacks are illegal and unethical

• Always comply with local laws and regulations

• Use responsibly and ethically

<br>

🚀 Features


• 🎨 **Beautiful ASCII Interface** - Eye-catching terminal UI with color-coded output

• 🔧 **Multiple Attack Types** - TCP Flood, UDP Flood, HTTP GET/POST Flood, SYN Flood

• 🌐 **Proxy Support** - Configure proxy settings for enhanced testing

• 📊 **Target Monitoring** - Check target status before and after attacks

• ⚙️ **Highly Configurable** - Customize threads, duration, ports, and more

• 🛡️ **Safety Features** - Built-in warnings and confirmation prompts

• 📚 **Comprehensive Help** - Detailed help system and command explanations

• 🚫 **Cancel Functionality** - Stop attacks at any time

<br>

📋 Prerequisites

• **Operating System**: Linux (Kali Linux recommended)

• **Privileges**: Root access required for some attack types

• **Dependencies**: `hping3`, `curl`, `bash`

<br>

📥 Installation

Step 1: Clone Repository

git clone https://github.com/yourusername/huntress.git

cd huntress

chmod +x huntress.sh

<br>

Step 2: Install Dependencies

**Debian/Ubuntu/Kali:**

sudo apt-get update

sudo apt-get install hping3 curl


**CentOS/RHEL:**

sudo yum install epel-release

sudo yum install hping3 curl


**Fedora:**

sudo dnf install hping3 curl

<br>

Step 3: Verify Installation

hping3 --version

curl --version

<br>

🚀 Quick Start

1. Launch Huntress

sudo ./huntress.sh

<br>

2. Basic Usage Flow

huntress> help                    # View all commands

huntress> set-target 192.168.1.100

huntress> set-port 80

huntress> attack-type             # Choose from 5 attack types

huntress> show-config             # Verify settings

huntress> check-target            # Test connectivity

huntress> start-attack            # Begin stress test

<br>

📖 Commands

Command	Description

`set-target`	Set target IP or domain

`set-port`	Set target port (default: 80)

`set-threads`	Set number of threads (default: 100)

`set-duration`	Set attack duration in seconds (default: 60)

`set-proxy`	Configure proxy settings

`attack-type`	Choose attack method

`show-config`	Display current configuration

`start-attack`	Begin the stress test

`check-target`	Check if target is responsive

`cancel`	Stop current attack

`help`	Show help menu

`exit`	Exit Huntress

<br>

🎯 Attack Types

1. TCP Flood

Overwhelms target with TCP connections

huntress> attack-type
> 1


2. UDP Flood

Floods target with UDP packets (requires root)

huntress> attack-type
> 2


3. HTTP GET Flood

Sends multiple HTTP GET requests

huntress> attack-type
> 3


4. HTTP POST Flood

Sends multiple HTTP POST requests

huntress> attack-type
> 4


5. SYN Flood

TCP SYN packet flooding (requires root)

huntress> attack-type
> 5

<br>

💡 Usage Examples

Web Server Stress Test

huntress> set-target example.com

huntress> set-port 80

huntress> attack-type
> 3

huntress> set-threads 50

huntress> set-duration 30

huntress> start-attack


Network Service Test

huntress> set-target 192.168.1.50

huntress> set-port 22

huntress> attack-type
> 1

huntress> set-threads 200

huntress> set-duration 60

huntress> start-attack


Using Proxy

huntress> set-target target.example.com

huntress> set-proxy
> y
> 127.0.0.1:8080

huntress> attack-type
> 4

huntress> start-attack

<br>

🔧 Troubleshooting

Common Issues

**Permission Denied**

sudo ./huntress.sh


**Missing Dependencies**

sudo apt-get install hping3 curl


**Target Not Responding**

huntress> check-target


**Attack Not Effective**

huntress> show-config  # Verify settings

<br>

🤝 Contributing
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


📝 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.


⸻


<div align="center">


**🔒 Remember: Use responsibly and only on authorized targets**


</div>
