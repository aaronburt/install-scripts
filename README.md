# Install scripts

Here, you'll find a collection of scripts designed to simplify the installation of various software tools and utilities.

## Usage

These scripts are free to use and can be executed directly using curl from our content delivery network:

### Docker.sh

```bash
curl https://install-scripts.b-cdn.net/docker.sh | sh
```

Stages: 

1. Verifies if the script is being executed with root privileges (sudo). If not, it prompts the user to run it as root and exits if not.

2. Defines a function compute_sha256() to calculate the SHA256 hash of a file (get-docker.sh) using available tools (shasum or sha256sum). If neither tool is found, it offers to install shasum (Perl Digest-SHA) and calculates the hash afterwards.

3. Downloads the official Docker installation script (get-docker.sh) from https://get.docker.com.

4. Computes the SHA256 hash of get-docker.sh using the compute_sha256 function and asks the user to confirm the hash's correctness.

5. If the hash is confirmed, executes the downloaded Docker installation script (sh get-docker.sh) to install Docker.

6. Deletes the downloaded Docker installation script (get-docker.sh) after installation is complete.

7. Checks for non-root users on the system (UID >= 1000).
If only the root user is detected, it recommends adding non-root users to the Docker group for security reasons.

8. Offers to create a non-root user named 'docker' specifically for Docker usage.
If accepted, creates the 'docker' user, assigns it to the 'docker' group, and sets the password to 'docker'.

9. Lists non-root users and prompts whether to add each user to the Docker group (docker).
If confirmed (y), adds the user to the Docker group using usermod.


### Update.sh

```bash
curl https://install-scripts.b-cdn.net/update.sh | sh
```

Stages:

1. Asks the user if they want to run a dist-upgrade (full system upgrade) with a timeout of 10 seconds. If no response is given within the timeout, it skips the upgrade.

2. Updates the package lists using `sudo apt update`.

3. Upgrades installed packages using `sudo apt upgrade -y`.

4. Calls the ask_dist_upgrade function to handle user input for running `sudo apt dist-upgrade -y`.

5. Cleans up unnecessary packages using `sudo apt autoremove -y` and `sudo apt autoclean`.

6. Notifies the user when the update and upgrade process is complete.



## License
These scripts are provided under the MIT License. See LICENSE for more information.

