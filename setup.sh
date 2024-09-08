#!/bin/bash

# Kolory
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'  # Reset koloru do domyślnego

# Aktualizacja listy pakietów i uaktualnienie systemu
echo -e "${GREEN} \n## Aktualizacja listy pakietów i uaktualnienie systemu ##\n ${RESET}"
sudo apt update
sudo apt upgrade -y

# Instalacja niezbędnych programów
echo -e "${GREEN} \n## Instalacja niezbędnych programów ##\n ${RESET}"
sudo apt install -y \
  git \
  curl \
  btop \
  python3 \
  python3-pip \
  zsh \
  cockpit \
  samba \
  bat \
  neofetch \
  openssh-server \
  postgresql \
  postgresql-contrib \
  build-essential \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  wget \
  libncurses5-dev \
  libgdbm-dev \
  liblzma-dev \
  sqlite3 \
  libffi-dev \
  libtk8.6 \
  libgdbm-compat-dev \
  mc \
  eza \
  qemu-guest-agent \
  fzf  # Instalacja fzf

# Uruchomienie i włączenie Cockpit
sudo systemctl enable --now cockpit.socket

# Zapytanie użytkownika o instalację Mega-CMD
echo -e "${YELLOW} \nCzy chcesz zainstalować i skonfigurować Mega-CMD? (tak/nie) ${RESET}"
read -r INSTALL_MEGA_CMD

if [[ "$INSTALL_MEGA_CMD" =~ ^[tT][aA][kK]$ ]]; then
  echo -e "${GREEN} \n## Instalacja Mega-CMD ##\n ${RESET}"
  wget https://mega.nz/linux/repo/xUbuntu_24.04/amd64/megacmd-xUbuntu_24.04_amd64.deb
  sudo apt install "$PWD/megacmd-xUbuntu_24.04_amd64.deb"

  echo -e "${GREEN} \n## Podaj email MEGA-CMD: ${RESET}"
  read -s MEGACMD_EMAIL
  echo -e "${GREEN} \n## Podaj hasło MEGA-CMD: ${RESET}"
  read -s MEGACMD_PASSWORD
  echo
  mega-login ${MEGACMD_EMAIL} "${MEGACMD_PASSWORD}"

  rm megacmd-xUbuntu_24.04_amd64.deb
  echo -e "${GREEN} \n## Mega-CMD zostało zainstalowane ${RESET}"
  nohup mega-cmd &
  echo -e "${GREEN} \n## Mega-CMD zostało uruchomione w tle ${RESET}"
else
  echo -e "${YELLOW} \nPominięto instalację Mega-CMD. ${RESET}"
fi

# Konfiguracja Samba do udostępnienia katalogu domowego użytkownika
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

USERNAME=$(whoami)
USER_HOME="/home/$USERNAME"
HOSTNAME=$(hostname)

sudo bash -c "cat << EOF >> /etc/samba/smb.conf

[$HOSTNAME]
   path = $USER_HOME
   browsable = yes
   read only = no
   valid users = $USERNAME
EOF"

sudo systemctl restart smbd
echo -e "${GREEN} \n## Podaj hasło dla użytkownika SAMBA: ${RESET}"
sudo smbpasswd -a $USERNAME

# Konfiguracja firewall
sudo ufw enable
sudo ufw allow OpenSSH
sudo ufw allow 9090/tcp  # Port dla Cockpit
sudo ufw allow Samba      # Porty dla Samba
sudo ufw allow 5432/tcp   # Port dla PostgreSQL
sudo ufw allow 8000/tcp   # Port dla Django
sudo ufw reload
sudo ufw status verbose

# Konfiguracja PostgreSQL
echo -e "${GREEN} \n## Podaj hasło dla użytkownika postgres w PostgreSQL: ${RESET}"
read -s POSTGRES_PASSWORD
echo
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}';"

# Konfiguracja interfejsu dummy
echo -e "${GREEN} \n## Dodawanie interfejsu dummy za pomocą nmcli ##\n ${RESET}"
sudo nmcli con add type dummy con-name fake ifname fake0 ip4 1.2.3.4/24 gw4 1.2.3.1

# Motyw Dracula do MC
mc_skin="$HOME/.local/share/mc/skins"
mc_ini="$HOME/.config/mc/ini"

if [ ! -d "$mc_skin" ]; then
  echo "Tworzenie folderu na skórki."
  mkdir -p "$mc_skin"
fi

wget -P "$mc_skin" "https://raw.githubusercontent.com/dracula/midnight-commander/master/skins/dracula256.ini"

if [ ! -f "$mc_ini" ]; then
  mc
fi

if [ -f "$mc_ini" ];then
  echo -e "${GREEN} \n## Zmiana skórki na Dracula w MC ##\n ${RESET}"
  sed -i 's/^skin=.*/skin=dracula256/' "$mc_ini"
fi

# Instalacja Oh My Posh dla ZSH
echo -e "${GREEN} \n## Instalacja Oh My Posh ##\n ${RESET}"
mkdir -p ~/.config/oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Konfiguracja motywu Oh My Posh
echo -e "${GREEN} \n## Konfiguracja motywu Oh My Posh ##\n ${RESET}"
cp ubuntu/ein-oh-my-posh.toml ~/.config/oh-my-posh/theme.toml

# Konfiguracja ZSH do używania Oh My Posh z lokalnym motywem
echo '# Motyw do Oh-My-Posh' >> ~/.zshrc
echo 'eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.toml)"' >> ~/.zshrc

# Wyłączenie powitania w zsh
echo -e "${GREEN} \n## Wyłączenie powitania w zsh ##\n ${RESET}"
echo 'unset ZSH_GREETING' >> ~/.zshrc

# Dodanie neofetch do pliku konfiguracyjnego ZSH
echo '# NEOFETCH' >> ~/.zshrc
echo 'neofetch' >> ~/.zshrc

# Dodanie aliasu dla batcat jako bat
echo '# Aliasy' >> ~/.zshrc
echo 'alias bat="batcat"' >> ~/.zshrc
echo 'alias cls="clear"' >> ~/.zshrc
echo 'alias ls='eza --long --icons=always --group-directories-first --all --header --group'' >> ~/.zshrc

# Instalacja pyenv
echo -e "${GREEN} \n## Instalowanie pyenv ##\n ${RESET}"
curl https://pyenv.run | bash

# Konfiguracja pyenv dla Bash i ZSH
echo -e "${GREEN} \n## Konfiguracja pyenv dla Bash i ZSH ##\n ${RESET}"
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

# Pobranie i instalacja najnowszej wersji Pythona
echo -e "${GREEN} \n## Pobieranie i instalacja najnowszej wersji Pythona ##\n ${RESET}"
LATEST_PYTHON_VERSION=$(pyenv install --list | grep -E "^\s*3\.[0-9]+\.[0-9]+\$" | tail -1 | tr -d ' ')
pyenv install $LATEST_PYTHON_VERSION
pyenv global $LATEST_PYTHON_VERSION

# Uaktualnienie konfiguracji ZSH
source ~/.zshrc

# Instalacja wtyczek ZSH
echo -e "${GREEN} \n## Instalacja wtyczek ZSH ##\n ${RESET}"
ZSH_PLUGIN_DIR=~/.config/plugins
mkdir -p $ZSH_PLUGIN_DIR

git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_PLUGIN_DIR/zsh-autosuggestions
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting $ZSH_PLUGIN_DIR/fast-syntax-highlighting
git clone https://github.com/Aloxaf/fzf-tab $ZSH_PLUGIN_DIR/fzf-tab
git clone https://github.com/zsh-users/zsh-direnv $ZSH_PLUGIN_DIR/zsh-direnv
git clone https://github.com/zsh-users/zsh-interactive-cd $ZSH_PLUGIN_DIR/zsh-interactive-cd
git clone https://github.com/zsh-users/zsh-completions $ZSH_PLUGIN_DIR/zsh-completions
git clone https://github.com/zsh-users/zsh-history-substring-search $ZSH_PLUGIN_DIR/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-navigation-tools $ZSH_PLUGIN_DIR/zsh-navigation-tools
git clone https://github.com/zsh-users/zsh-autopair $ZSH_PLUGIN_DIR/zsh-autopair
git clone https://github.com/MichaelAquilina/zsh-you-should-use $ZSH_PLUGIN_DIR/zsh-you-should-use

# Aktywacja wtyczek w ZSH
echo -e "${GREEN} \n## Aktywacja wtyczek ZSH ##\n ${RESET}"
echo 'source $ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh' >> ~/.zshrc
echo 'source $ZSH_PLUGIN_DIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh' >> ~/.zshrc
echo 'source $ZSH_PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh' >> ~/.zshrc
echo 'source $ZSH_PLUGIN_DIR/zsh-direnv/direnv.zsh' >> ~/.zshrc
echo 'source $ZSH_PLUGIN_DIR/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh' >> ~/.zshrc
echo 'source $ZSH_PLUGIN_DIR/zsh-completions/zsh-completions.plugin.zsh' >> ~/.zshrc
echo 'source $ZSH_PLUGIN_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh' >> ~/.zshrc
echo 'source $ZSH_PLUGIN_DIR/zsh-navigation-tools/zsh-navigation-tools.plugin.zsh' >> ~/.zshrc
echo 'source $ZSH_PLUGIN_DIR/zsh-autopair/autopair.zsh' >> ~/.zshrc
echo 'source $ZSH_PLUGIN_DIR/zsh-you-should-use/you-should-use.plugin.zsh' >> ~/.zshrc

# Usuwanie wszystkich plików oraz folderu nadrzędnego "ubuntu"
echo -e "${GREEN} \n## Usuwanie wszystkich plików oraz folder 'ubuntu' ##\n ${RESET}"
rm -rf ubuntu

# Tworzenie folderów Dokumenty i Projekty
echo -e "${GREEN} \n## Tworzenie folderów Dokumenty i Projekty ##\n ${RESET}"
mkdir -p ~/Dokumenty
mkdir -p ~/Projekty

# Koniec skryptu
echo -e "${GREEN} \n## Skrypt został wykonany pomyślnie ##\n ${RESET}"

# Zmiana domyślnej powłoki na ZSH
echo -e "${GREEN} \n## Zmiana domyślnej powłoki na ZSH ##\n ${RESET}"
chsh -s $(which zsh)
