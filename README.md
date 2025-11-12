# ToolBox

ToolBox est un script bash permettant l'installation d'outils essentiels pour transformer votre distribution Linux en serveur.

## Key Features & Benefits

*   **Automated Installation:** Simplifies server setup by automating the installation of essential tools and dependencies.
*   **Essential Tools:** Installs commonly used server tools, such as Docker, Docker Compose, and security utilities.
*   **Time Saving:** Reduces the manual effort required to configure a server environment.
*   **Base Configuration:** Provides a foundation for further server customization.
*   **Package Updates:** Ensures the system is up-to-date with the latest package versions.

## Prerequisites & Dependencies

*   A Linux distribution (tested primarily on Debian-based systems).
*   `bash` shell.
*   `sudo` privileges for installing packages.
*   Internet access to download packages.

## Installation & Setup Instructions

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/angle-droit/ToolBox.git
    cd ToolBox
    ```

2.  **Make the script executable:**

    ```bash
    chmod +x script.sh
    ```

3.  **Run the script with sudo privileges:**

    ```bash
    sudo ./script.sh
    ```

    **Important:** Review the script's content before executing it to understand which packages will be installed.

## Usage Examples

After running the script, the following tools (if selected during script execution) will be available:

*   **Docker:** `docker --version`
*   **Docker Compose:** `docker-compose --version`
*   **Fail2ban:** (Will run as a service) `sudo systemctl status fail2ban`
*   **UFW:** (Will be enabled with default firewall rules) `sudo ufw status`

## Configuration Options

The `script.sh` file can be modified to customize the installation process:

*   **Package Selection:** Edit the script to add or remove packages to be installed.
*   **Firewall Rules:** Customize UFW rules directly in the script.
*   **Service Configuration:** Modify the configuration files of installed services (e.g., `/etc/fail2ban/jail.conf` or `/etc/ufw/ufw.conf`) after installation.
*   **Custom Installation Paths:** Modify the install locations within the script

## Contributing Guidelines

Contributions are welcome! Here's how you can contribute:

1.  Fork the repository.
2.  Create a new branch for your feature or bug fix: `git checkout -b feature/your-feature-name` or `git checkout -b bugfix/your-bugfix-name`.
3.  Make your changes.
4.  Commit your changes: `git commit -m "Add your commit message"`
5.  Push to the branch: `git push origin feature/your-feature-name`
6.  Create a pull request.

Please ensure your code follows the existing style and includes appropriate comments.

## License Information

This project is licensed under the Apache License 2.0 - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

*   This project uses the `bash` scripting language.
*   Special thanks to the open-source community for providing valuable tools and resources.
