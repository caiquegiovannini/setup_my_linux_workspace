#!/bin/sh

DOCKER_VERSION="4.19.0"

URL_DOCKER_DESKTOP="https://desktop.docker.com/linux/main/amd64/docker-desktop-$DOCKER_VERSION-amd64.deb"
URL_GOOGLE_CHROME="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
URL_VSCODE="https://az764295.vo.msecnd.net/stable/b3e4e68a0bc097f0ae7907b217c1119af9e03435/code_1.78.2-1683731010_amd64.deb"
URL_DISCORD="https://dl.discordapp.net/apps/linux/0.0.27/discord-0.0.27.deb"

DOWNLOADS_DIR="$HOME/Downloads/programas"

## Atualizando repositório ##
sudo apt update

## Adicionando repositórios de terceiros ##
sudo apt install ca-certificates curl gnupg

## Download e instalação de programas externos ##
sudo apt update

mkdir "$DOWNLOADS_DIR"

wget -c "$URL_GOOGLE_CHROME" -P "$DOWNLOADS_DIR"
wget -c "$URL_VSCODE" -P "$DOWNLOADS_DIR"
wget -c "$URL_DISCORD" -P "$DOWNLOADS_DIR"

## Instalando pacotes .deb baixados na sessão anterior ##
sudo dpkg -i $DOWNLOADS_DIR/*.deb

## Instalando programas no apt ##
sudo apt install flameshot -y
sudo apt install zsh -y

## Oh My ZSH ##
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s $(which zsh)

## NVM ##
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

## Instalando versão específica do Node ##
nvm install "14.18.2"

## Instalando Docker (trocar codename dependendo da distro) ##
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$UBUNTU_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

wget -c "$URL_DOCKER_DESKTOP" -P "$DOWNLOADS_DIR"

sudo apt update
sudo apt install "$DOWNLOADS_DIR/docker-desktop-$DOCKER_VERSION-amd64.deb"

## Configurando dotfiles ##
git clone https://github.com/caiquegiovannini/dotfiles.git ~/.dotfiles
ln -s ~/.dotfiles/.zshrc ~/.zshrc
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig

## Finalizando, atualizando e limpando ##
sudo apt update && sudo apt dist-upgrade -y
sudo apt autoclean
sudo apt autoremove -y

echo "Yeey! Script finalizado \nO sistema está pronto para uso!"