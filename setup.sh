
# Install any dependencies you need here (you can run more than apt-get, and
# this script runs as root)
apt-get -y install openjdk-8-jdk valgrind


# This last line must stay to avoid ssh errors
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
