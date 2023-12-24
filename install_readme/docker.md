To install Docker and Docker Compose on Ubuntu, follow these steps:

### 1. **Update your package list:**
   Open a terminal and run the following command to update your package list:
   ```bash
   sudo apt-get update
   ```

### 2. **Install required packages:**
   You'll need a few prerequisite packages to allow `apt` to use HTTPS:
   ```bash
   sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
   ```

### 3. **Add Docker’s official GPG key:**
   To ensure the software comes from Docker, you need to add Docker's official GPG key:
   ```bash
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
   ```

### 4. **Set up the Docker stable repository:**
   Add the Docker repository to the `apt` sources:
   ```bash
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```

### 5. **Update your package list again:**
   After adding the repository, update your package list again:
   ```bash
   sudo apt-get update
   ```

### 6. **Install Docker Engine:**
   Now install Docker:
   ```bash
   sudo apt-get install docker-ce docker-ce-cli containerd.io
   ```

### 7. **Verify Docker installation:**
   Check if Docker is installed correctly by running:
   ```bash
   sudo docker --version
   ```

### 8. **Install Docker Compose:**
   To install Docker Compose, you can either use the official release or a package manager. Here's the method using `curl`:

   First, download the Docker Compose binary:
   ```bash
   sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   ```

   Then, apply executable permissions to the binary:
   ```bash
   sudo chmod +x /usr/local/bin/docker-compose
   ```

### 9. **Verify Docker Compose installation:**
   Check the installation by running:
   ```bash
   docker-compose --version
   ```

### 10. **Enable Docker to run at startup (optional):**
   You can enable Docker to start on boot with the following command:
   ```bash
   sudo systemctl enable docker
   ```

Now Docker and Docker Compose should be successfully installed on your Ubuntu system!