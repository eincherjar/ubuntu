#!/bin/bash

# Kolory
LBLUE='\033[1;34m'   # Jasny niebieski
PURPLE='\033[0;35m'  # Fioletowy
CYAN='\033[0;36m'    # Turkusowy
RESET='\033[0m'      # Reset koloru do domyślnego

# Aktualizacja listy pakietów i uaktualnienie systemu
echo -e "${LBLUE} \n## Aktualizacja listy pakietów i uaktualnienie systemu ##\n ${RESET}"
sudo apt update
sudo apt upgrade -y

# Instalacja niezbędnych programów
echo -e "${LBLUE} \n## Instalacja niezbędnych programów ##\n ${RESET}"
sudo apt install -y \
  git \
  curl \
  btop \
  python3 \
  python3-pip \
  zsh \
  cockpit \
  bat \
  neofetch \
  openssh-server \
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
echo -e "${PURPLE} \nCzy chcesz zainstalować i skonfigurować Mega-CMD? (tak/nie) ${RESET}"
read -r INSTALL_MEGA_CMD

if [[ "$INSTALL_MEGA_CMD" =~ ^[tT][aA][kK]$ ]]; then
  echo -e "${LBLUE} \n## Instalacja Mega-CMD ##\n ${RESET}"
  wget https://mega.nz/linux/repo/xUbuntu_24.04/amd64/megacmd-xUbuntu_24.04_amd64.deb
  sudo apt install "$PWD/megacmd-xUbuntu_24.04_amd64.deb"

  echo -e "${LBLUE} \n## Podaj email MEGA-CMD: ${RESET}"
  read -s MEGACMD_EMAIL
  echo -e "${LBLUE} \n## Podaj hasło MEGA-CMD: ${RESET}"
  read -s MEGACMD_PASSWORD
  echo
  mega-login ${MEGACMD_EMAIL} "${MEGACMD_PASSWORD}"

  rm megacmd-xUbuntu_24.04_amd64.deb
  echo -e "${LBLUE} \n## Mega-CMD zostało zainstalowane ${RESET}"
  nohup mega-cmd &
  echo -e "${LBLUE} \n## Mega-CMD zostało uruchomione w tle ${RESET}"
else
  echo -e "${CYAN} \nPominięto instalację Mega-CMD. ${RESET}"
fi

# Zapytanie o konfigurację Samba
echo -e "${PURPLE} \nCzy chcesz skonfigurować Sambę? (tak/nie) ${RESET}"
read -r CONFIGURE_SAMBA

if [[ "$CONFIGURE_SAMBA" =~ ^[tT][aA][kK]$ ]]; then
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
  echo -e "${LBLUE} \n## Podaj hasło dla użytkownika SAMBA: ${RESET}"
  sudo smbpasswd -a $USERNAME
else
  echo -e "${CYAN} \nPominięto konfigurację Samba. ${RESET}"
fi

# Zapytanie o konfigurację PostgreSQL
echo -e "${PURPLE} \nCzy chcesz skonfigurować PostgreSQL? (tak/nie) ${RESET}"
read -r CONFIGURE_POSTGRESQL

if [[ "$CONFIGURE_POSTGRESQL" =~ ^[tT][aA][kK]$ ]]; then
  sudo apt install -y postgresql postgresql-contrib
  echo -e "${LBLUE} \n## Podaj hasło dla użytkownika postgres w PostgreSQL: ${RESET}"
  read -s POSTGRES_PASSWORD
  echo
  sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}';"
else
  echo -e "${CYAN} \nPominięto konfigurację PostgreSQL. ${RESET}"
fi

# Zapytanie o konfigurację interfejsu dummy
echo -e "${PURPLE} \nCzy chcesz dodać interfejs dummy za pomocą nmcli? (tak/nie) ${RESET}"
read -r CONFIGURE_DUMMY

if [[ "$CONFIGURE_DUMMY" =~ ^[tT][aA][kK]$ ]]; then
  echo -e "${LBLUE} \n## Dodawanie interfejsu dummy za pomocą nmcli ##\n ${RESET}"
  sudo nmcli con add type dummy con-name fake ifname fake0 ip4 1.2.3.4/24 gw4 1.2.3.1
else
  echo -e "${CYAN} \nPominięto konfigurację interfejsu dummy. ${RESET}"
fi

# Konfiguracja firewall
sudo ufw enable
sudo ufw allow OpenSSH
sudo ufw allow 9090/tcp  # Port dla Cockpit
sudo ufw allow Samba      # Porty dla Samba
sudo ufw allow 5432/tcp   # Port dla PostgreSQL
sudo ufw allow 8000/tcp   # Port dla Django
sudo ufw reload
sudo ufw status verbose

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
  echo -e "${LBLUE} \n## Zmiana skórki na Dracula w MC ##\n ${RESET}"
  sed -i 's/^skin=.*/skin=dracula256/' "$mc_ini"
fi

# Instalacja Oh My Posh dla ZSH
echo -e "${LBLUE} \n## Instalacja Oh My Posh ##\n ${RESET}"
mkdir -p ~/.config/oh-my-posh
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Konfiguracja motywu Oh My Posh
echo -e "${LBLUE} \n## Konfiguracja motywu Oh My Posh ##\n ${RESET}"
cp ubuntu/ein-oh-my-posh.toml ~/.config/oh-my-posh/theme.toml

# Konfiguracja ZSH do używania Oh My Posh z lokalnym motywem
echo '# Motyw do Oh-My-Posh' >> ~/.zshrc
echo 'eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/theme.toml)"' >> ~/.zshrc

# Wyłączenie powitania w zsh
echo -e "${LBLUE} \n## Wyłączenie powitania w zsh ##\n ${RESET}"
echo 'unset ZSH_GREETING' >> ~/.zshrc

# Dodanie neofetch do pliku konfiguracyjnego ZSH
echo '# NEOFETCH' >> ~/.zshrc
echo 'neofetch' >> ~/.zshrc

# Dodanie aliasu dla batcat jako bat
echo '# Aliasy' >> ~/.zshrc
echo 'alias bat="batcat"' >> ~/.zshrc
echo 'alias cls="clear"' >> ~/.zshrc

# Instalacja pyenv
echo -e "${LBLUE} \n## Instalacja pyenv ##\n ${RESET}"
curl https://pyenv.run | bash

# Konfiguracja pyenv dla bash i zsh
echo -e "${LBLUE} \n## Konfiguracja pyenv ##\n ${RESET}"
echo '# Pyenv configuration' >> ~/.bashrc
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

echo '# Pyenv configuration' >> ~/.zshrc
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

# Zmiana powłoki na ZSH
echo -e "${LBLUE} \n## Zmiana powłoki na ZSH ##\n ${RESET}"
chsh -s $(which zsh)

echo -e "${LBLUE} \n## Koniec skryptu ##\n ${RESET}"
