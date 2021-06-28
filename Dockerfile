dnf install \
	openssh-clients \
	git \
	zsh zsh-syntax-highlighting zsh-autosuggestions \
	wget rsync \
	neovim \
	python3-pip \
	kubectl \


# After user creation 

## Run as user

### Install oh-my-zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

### Install powerline10K
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k


### Install kubectl

### Add ohmyzsh plugins to .zshrc
