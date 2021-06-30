FROM fedora:34

RUN dnf -y install \
	dnf-plugins-core \
	openssh-clients sudo \
	git git-secret \
	zsh zsh-syntax-highlighting zsh-autosuggestions fontconfig \
	wget rsync \
	neovim \
	python3-pip \
        jq  && \
    dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo && \
    dnf config-manager --add-repo https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64 && \
    dnf install -y terraform terraform-ls kubectl

# create user
RUN sudo useradd -u 1000 -G wheel -s /usr/bin/zsh user && \
	sudo sed -i 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers 

# After user creation 
## Copy .zshrc to /home/user
COPY --chown=user zshrc /home/user/.zshrc
RUN chmod 0600 /home/user/.zshrc

## add nvim config
COPY --chown=user init.vim /home/user/.config/nvim/init.vim
COPY --chown=user coc-settings.json /home/user/.vim/coc-settings.json
RUN chmod 0750 /home/user/.vim/ && \
    chmod 0640 /home/user/.config/nvim/init.vim && \
    chmod 0750 /home/user/.config/ && \
    chmod 0750 /home/user/.config/nvim && \
    chmod 0640 /home/user/.vim/coc-settings.json
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
RUN nvim --headless +PlugInstall +qall
RUN nvim --headless "+CocInstall coc-pyright coc-markdown coc-yaml coc-json" +qa

## Classic snap
RUN sudo ln -s /var/lib/snapd/snap /snap

### Install snaps
RUN sudo snap install kubectl glab yq

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
 	tar -xf s5cmd.tar.gz s5cmd -C /home/user/.local/bin/s5cmd &&\
        rm s5cmd.tar.gz

### Installs Glab https://github.com/profclems/glab
RUN curl -sL https://api.github.com/repos/profclems/glab/releases/latest \
        | grep -i Linux_x86_64.tar.gz \
        | grep browser_download_url \
        | cut -d '"' -f 4 \
        | wget -O glab.tar.gz -qi  - && \
        tar -xf glab.tar.gz -C $HOME/.local/bin/ --strip-components=1 bin/glab && \
        rm glab.tar.gz

### Pip packages
RUN pip3 install python-gitlab pyyaml jinja2 toml

### Terraform install
RUN terraform -install-autocomplete
