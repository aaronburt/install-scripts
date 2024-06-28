# Install scripts

Here, you'll find a collection of scripts designed to simplify the installation of various software tools and utilities.

## Usage

These scripts are free to use and can be executed directly using curl from our content delivery network:

For example execute:

```bash
curl https://install-scripts.b-cdn.net/scriptname.sh | sh
```
Replace scriptname.sh with the specific script you want to install.

## Docker.sh

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


## License
These scripts are provided under the MIT License. See LICENSE for more information.

