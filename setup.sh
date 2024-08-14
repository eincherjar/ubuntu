#!/bin/bash

# Kolory
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'  # Reset koloru do domyślnego

# Aktualizacja listy pakietów i uaktualnienie systemu
# sudo apt update
# sudo apt upgrade -y

# Dodanie repozytorium dla Nala
echo "deb [trusted=yes] http://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list

# Dodanie klucza GPG dla repozytorium
wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar.gpg

# Instalacja Nala
echo -e "${GREEN} \n## Instalacja Nala ##\n ${RESET}"
sudo apt install nala -y

# Aktualizacja listy pakietów
echo -e "${GREEN} \n## Aktualizacja listy pakietów ##\n ${RESET}"
sudo nala update
sudo nala upgrade -y

# Używanie Nala do instalacji niezbędnych programów
echo -e "${GREEN} \n## Używanie Nala do instalacji niezbędnych programów ##\n ${RESET}"
sudo nala install -y \
  git \
  curl \
  btop \
  python3 \
  python3-pip \
  fish \
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
  qemu-guest-agent

# Uruchomienie i włączenie Cockpit
sudo systemctl enable --now cockpit.socket

# Zapytanie użytkownika o instalację Mega-CMD
echo -e "${YELLOW} \nCzy chcesz zainstalować i skonfigurować Mega-CMD? (tak/nie) ${RESET}"
read -r INSTALL_MEGA_CMD

if [[ "$INSTALL_MEGA_CMD" =~ ^[tT][aA][kK]$ ]]; then
  echo -e "${GREEN} \n## Instalacja Mega-CMD ##\n ${RESET}"
  wget https://mega.nz/linux/repo/xUbuntu_24.04/amd64/megacmd-xUbuntu_24.04_amd64.deb
  sudo nala install "$PWD/megacmd-xUbuntu_24.04_amd64.deb"

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
# Tworzenie kopii zapasowej oryginalnego pliku konfiguracyjnego
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

# Pobranie nazwy użytkownika i ścieżki do katalogu domowego
USERNAME=$(whoami)
USER_HOME="/home/$USERNAME"
HOSTNAME=$(hostname)

# Dodanie konfiguracji do smb.conf
sudo bash -c "cat << EOF >> /etc/samba/smb.conf

[$HOSTNAME]
   path = $USER_HOME
   browsable = yes
   read only = no
   valid users = $USERNAME
EOF"

# Restartowanie usługi Samba
sudo systemctl restart smbd
echo -e "${GREEN} \n## Podaj hasło dla użytkownika SAMBA: ${RESET}"
sudo smbpasswd -a $USERNAME

# Włączenie UFW i dodanie reguł
sudo ufw enable
sudo ufw allow OpenSSH
sudo ufw allow 9090/tcp  # Port dla Cockpit
sudo ufw allow Samba      # Porty dla Samba (często 137, 138, 139, 445)
sudo ufw allow 5432/tcp   # Port dla PostgreSQL
sudo ufw reload

# Wyświetlenie statusu UFW
sudo ufw status verbose

# Pobranie hasła do PostgreSQL od użytkownika
echo -e "${GREEN} \n## Podaj hasło dla użytkownika postgres w PostgreSQL: ${RESET}"
read -s POSTGRES_PASSWORD
echo

# Konfiguracja PostgreSQL
echo -e "${GREEN} \n## Konfigurowanie PostgreSQL ##\n ${RESET}"
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}';"

# Wyświetlenie adresu do Cockpit
IP_ADDRESS=$(hostname -I | awk '{print $1}')
echo -e "${GREEN} \n## Cockpit został zainstalowany i uruchomiony. ##\n ${RESET}"
echo -e "${GREEN} Aby uzyskać dostęp do interfejsu, przejdź do: ${RESET}"
echo -e "${GREEN} http://$IP_ADDRESS:9090 ${RESET}"

# Wyświetlenie informacji o współdzielonym katalogu domowym użytkownika
echo -e "${GREEN} \n## Samba została zainstalowana i skonfigurowana. ##\n ${RESET}"
echo -e "${GREEN} Katalog domowy użytkownika $USERNAME jest udostępniony pod adresem: \\\\$IP_ADDRESS\\$HOSTNAME ${RESET}"

# Proxmox 
# sudo systemctl enable qemu-guest-agent

# Konfiguracja interfejsu sieciowego typu dummy za pomocą nmcli
echo -e "${GREEN} \n## Dodawanie interfejsu dummy za pomocą nmcli ##\n ${RESET}"
sudo nmcli con add type dummy con-name fake ifname fake0 ip4 1.2.3.4/24 gw4 1.2.3.1

# Motyw Dracula do MC
mc_skin="$HOME/.local/share/mc/skins"
mc_ini="$HOME/.config/mc/ini"

# Sprawdzenie, czy folder na skórki istnieje
if [ ! -d "$mc_skin" ]; then
  echo "Folder na skórki nie istnieje. Tworzę nowy folder."
  mkdir -p "$mc_skin"
else
  echo "Folder na skórki już istnieje."
fi

# Pobranie skórki Dracula
wget -P "$mc_skin" "https://raw.githubusercontent.com/dracula/midnight-commander/master/skins/dracula256.ini"

# Uruchomienie mc, aby wygenerować domyślny plik konfiguracyjny
if [ ! -f "$mc_ini" ]; then
  mc
fi

# Zmiana skórki na Dracula
if [ -f "$mc_ini" ]; then
  echo -e "${GREEN} \n## Zmiana skórki na Dracula w pliku konfiguracyjnym MC. ##\n ${RESET}"
  sed -i 's/^skin=.*/skin=dracula256/' "$mc_ini"
else
  echo "Błąd: Plik konfiguracyjny MC nie został znaleziony."
fi

# Zmiana domyślnej powłoki na Fish
echo -e "${GREEN} \n## Zmiana domyślnej powłoki na Fish ##\n ${RESET}"
chsh -s /usr/bin/fish

# Kontynuacja skryptu w nowej powłoce Fish
exec fish << 'EOF'

# Uaktualnienie konfiguracji Fish Shell
mkdir -p ~/.config/oh-my-posh
mkdir -p ~/.config/fish

# Instalacja Oh My Posh
echo -e "$GREEN \n## Instalacja Oh My Posh ##\n $RESET"
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Konfiguracja motywu Oh My Posh
echo -e "$GREEN \n## Konfiguracja motywu Oh My Posh ##\n $RESET"
cp ubuntu/ein-oh-my-posh.toml ~/.config/oh-my-posh/theme.toml

# Konfiguracja Fish Shell do używania Oh My Posh z lokalnym motywem
echo '# Motyw do Oh-My-Posh' >> ~/.config/fish/config.fish
echo 'oh-my-posh init fish --config ~/.config/oh-my-posh/theme.toml | source' >> ~/.config/fish/config.fish

# Dodanie neofetch do pliku konfiguracyjnego Fish Shell, aby wyświetlał się przy każdym uruchomieniu terminala
echo '# NEOFETCH' >> ~/.config/fish/config.fish
echo 'neofetch' >> ~/.config/fish/config.fish

# Dodanie aliasu dla batcat jako bat
echo '# Aliasy' >> ~/.config/fish/config.fish
echo 'alias bat="batcat"' >> ~/.config/fish/config.fish
echo 'alias cls="clear"' >> ~/.config/fish/config.fish

# Instalacja pyenv
echo -e "$GREEN \n## Instalowanie pyenv ##\n $RESET"
curl https://pyenv.run | bash

# Dodanie pyenv do ścieżki PATH
set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
eval (pyenv init - | source)

echo '# PyEnv' >> ~/.config/fish/config.fish
echo 'pyenv init - | source' >> ~/.config/fish/config.fish

# Pobranie i instalacja najnowszej wersji Pythona
echo -e "$GREEN \n## Pobieranie i instalacja najnowszej wersji Pythona ##\n $RESET"
set LATEST_PYTHON_VERSION (pyenv install --list | grep -E "^\s*3\.[0-9]+\.[0-9]+\$" | tail -1 | tr -d ' ')
pyenv install $LATEST_PYTHON_VERSION
pyenv global $LATEST_PYTHON_VERSION

# Uaktualnienie konfiguracji Fish Shell
source ~/.config/fish/config.fish

# Wyłączenie powitania w fish
echo -e "$GREEN \n## Wyłączenie powitania w fish ##\n $RESET"
set -U fish_greeting

# Usuwanie wszystkich plików oraz folderu nadrzędnego "ubuntu"
echo -e "$GREEN \n## Usuwanie wszystkich plików oraz folder 'ubuntu' ##\n $RESET"
rm -rf ubuntu

# Tworzenie folderów Dokumenty i Projekty
echo -e "$GREEN \n## Tworzenie folderów Dokumenty i Projekty ##\n $RESET"
mkdir -p ~/Dokumenty
mkdir -p ~/Projekty

EOF
