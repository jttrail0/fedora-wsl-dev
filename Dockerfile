FROM fedora:34

RUN dnf -y install \
	dnf-plugins-core \
	openssh-clients sudo \
	git git-secret \
	zsh zsh-syntax-highlighting zsh-autosuggestions fontconfig \
	wget rsync \
	neovim nodejs \
	python3-pip \
        jq file && \
    dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo && \
    dnf install -y terraform terraform-ls

# create user
RUN sudo useradd -u 1000 -G wheel -s /usr/bin/zsh user && \
	sudo sed -i 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers 

# After user creation 

## Run as user
USER user
WORKDIR /home/user

## Copy .zshrc to /home/user
COPY --chown=user zshrc /home/user/.zshrc
RUN chmod 0600 /home/user/.zshrc

## add nvim config
COPY --chown=user init.vim /home/user/.config/nvim/init.vim
COPY --chown=user coc-settings.json /home/user/.vim/coc-settings.json
RUN chmod 0750 /home/user/.vim/ && \
    chmod 0640 /home/user/.config/nvim/init.vim && \
    chmod 0750 /home/user/.config/nvim && \
    chmod 0750 /home/user/.config/ && \
    chmod 0640 /home/user/.vim/coc-settings.json
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
RUN nvim --headless +PlugInstall +qall
RUN nvim --headless "+CocInstall coc-pyright coc-markdownlint coc-yaml coc-json" +qa

## Download & install powerline-go, dircolors
RUN mkdir -p .local/bin/ && \
	wget -O $HOME/.local/bin/powerline-go https://github.com/justjanne/powerline-go/releases/latest/download/powerline-go-linux-amd64 && \
	chmod u+x $HOME/.local/bin/powerline-go && \
	wget -O $HOME/.dir_colors https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-dark

### Download & install s5cmd
RUN curl -sL https://api.github.com/repos/peak/s5cmd/releases/latest \
 	| grep -i Linux-64bit.tar.gz \
 	| grep browser_download_url \
   	| cut -d '"' -f 4 \
 	| wget -O s5cmd.tar.gz -qi  - && \
 	tar -xf s5cmd.tar.gz -C $HOME/.local/bin/ s5cmd && \
        rm s5cmd.tar.gz

### Installs Glab https://github.com/profclems/glab
RUN curl -sL https://api.github.com/repos/profclems/glab/releases/latest \
        | grep -i Linux_x86_64.tar.gz \
        | grep browser_download_url \
        | cut -d '"' -f 4 \
        | wget -O glab.tar.gz -qi  - && \
        tar -xf glab.tar.gz -C $HOME/.local/bin/ --strip-components=1 bin/glab && \
        rm glab.tar.gz

### Install Kubectl from google
RUN curl -LO https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl && \ 
	sudo install -o user -g user -m 0750 kubectl $HOME/.local/bin/kubectl && \
        rm -f kubectl

### Pip packages
RUN pip3 install python-gitlab pyyaml jinja2 toml yq

### Terraform install
RUN terraform -install-autocomplete
