FROM ubuntu:18.04

# OS updates and install
RUN apt-get -qq update
RUN apt-get install -qq -y \
  wget git coreutils file build-essential sudo g++ xz-utils libssl-dev

# Create test user and add to sudoers
RUN useradd -m -s /bin/bash tester
RUN usermod -aG sudo tester
RUN echo "tester   ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers

# Add dotfiles and chown
ADD . /home/tester/dotfiles
RUN chown -R tester:tester /home/tester

# Switch testuser
USER tester
ENV HOME /home/tester

# Change working directory
WORKDIR /home/tester/dotfiles

# Run setup
RUN ./install.sh

RUN ./install/download.sh

RUN ./install/all.sh

CMD ["/bin/bash"]
