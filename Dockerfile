FROM fedora:33

RUN dnf -y install \
	openssh-clients sudo \
	git git-secret \
	zsh zsh-syntax-highlighting zsh-autosuggestions fontconfig \
	wget rsync \
	neovim \
	python3-pip \
        snapd

# create user
RUN sudo useradd -u 1000 -g wheel -s /usr/bin/zsh user && \
	sudo sed -i 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers 

# After user creation 
## Copy .zshrc to /home/user
COPY zshrc /home/user/.zshrc
RUN chmod 0600 /home/user/.zshrc

## add nvim config
COPY init.vim /home/user/.config/nvim/init.vim
RUN chmod 0600 /home/user/.config/nvim/init.vim && \
	nvim --headless +PlugInstall +qall

## Classic snap
RUN sudo ln -s /var/lib/snapd/snap /snap

### Install snaps
RUN sudo snap install kubectl glab

## Run as user
USER user
WORKDIR /home/user

## Download & install powerline-go, dircolors
RUN mkdir -p .local/bin/ && \
	wget -O /home/user/.local/bin/powerline-go https://github.com/justjanne/powerline-go/releases/latest/download/powerline-go-linux-amd64 && \
	wget -O /home/user/.dir_colors https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-dark

### Download & install s5cmd
 RUN curl -sL https://api.github.com/repos/peak/s5cmd/releases/latest \
 	| grep -i Linux-64bit.tar.gz \
 	| grep browser_download_url \
   	| cut -d '"' -f 4 \
 	| wget -O s5cmd.tar.gz -qi  - && \
 	tar --extract --file=s5cmd.tar.gz /home/user/.local/bin/s5cmd
