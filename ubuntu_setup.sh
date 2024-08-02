#!/bin/bash

# Aktualizacja listy pakietów i uaktualnienie systemu
# sudo apt update
# sudo apt upgrade -y

# Dodanie repozytorium dla Nala
echo "deb [trusted=yes] http://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list

# Dodanie klucza GPG dla repozytorium
wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar.gpg

# Instalacja Nala
echo "Instalacja Nala"
sudo apt install nala -y

# Aktualizacja listy pakietów
echo "Aktualizacja listy pakietów"
sudo nala update
sudo nala upgrade -y

# Używanie Nala do instalacji niezbędnych programów
echo "Używanie Nala do instalacji niezbędnych programów"
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

# Proxmox 
# sudo systemctl enable qemu-guest-agent

# Zmiana domyślnej powłoki na Fish
echo "Zmiana domyślnej powłoki na Fish..."
chsh -s /usr/bin/fish

# Uaktualnienie konfiguracji Fish Shell
source ~/.config/fish/config.fish

# Instalacja Oh My Posh
echo "Instalacja Oh My Posh..."
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

# Konfiguracja motywu Oh My Posh
echo "Konfiguracja motywu Oh My Posh..."
# Zakładamy, że plik ein-oh-my-posh.toml znajduje się w tym samym katalogu co skrypt
mkdir -p ~/.config/oh-my-posh
cp ein-oh-my-posh.toml ~/.config/oh-my-posh/theme.toml

# Konfiguracja Fish Shell do używania Oh My Posh z lokalnym motywem
echo 'eval (oh-my-posh init fish --config ~/.config/oh-my-posh/theme.toml)' >> ~/.config/fish/config.fish

# Dodanie aliasu dla batcat jako bat
echo 'alias bat="batcat"' >> ~/.config/fish/config.fish

# Dodanie neofetch do pliku konfiguracyjnego Fish Shell, aby wyświetlał się przy każdym uruchomieniu terminala
echo 'neofetch' >> ~/.config/fish/config.fish

# Instalacja pyenv
echo "Instalowanie pyenv..."
curl https://pyenv.run | bash

# Konfiguracja pyenv dla Fish
set -U fish_user_paths $fish_user_paths $HOME/.pyenv/bin
echo 'set -gx PYENV_ROOT $HOME/.pyenv' >> ~/.config/fish/config.fish
echo 'set -gx PATH $PYENV_ROOT/bin $PATH' >> ~/.config/fish/config.fish
echo 'status --is-interactive; and . (pyenv init --path)' >> ~/.config/fish/config.fish
echo 'status --is-interactive; and . (pyenv init -)' >> ~/.config/fish/config.fish
echo 'status --is-interactive; and . (pyenv virtualenv-init -)' >> ~/.config/fish/config.fish

# Pobranie i instalacja najnowszej wersji Pythona
echo "Pobieranie i instalacja najnowszej wersji Pythona..."
LATEST_PYTHON_VERSION=$(pyenv install --list | grep -E "^\s*3\.[0-9]+\.[0-9]+$" | tail -1 | tr -d ' ')
pyenv install $LATEST_PYTHON_VERSION
pyenv global $LATEST_PYTHON_VERSION

# Uaktualnienie konfiguracji Fish Shell
source ~/.config/fish/config.fish

# Uruchomienie i włączenie Cockpit
sudo systemctl enable --now cockpit.socket

# Konfiguracja Samba do udostępnienia katalogu domowego użytkownika
# Tworzenie kopii zapasowej oryginalnego pliku konfiguracyjnego
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

# Pobranie nazwy użytkownika i ścieżki do katalogu domowego
USERNAME=$(whoami)
USER_HOME="/home/$USERNAME"

# Dodanie konfiguracji do smb.conf
sudo bash -c "cat << EOF >> /etc/samba/smb.conf

[Home]
   path = $USER_HOME
   browsable = yes
   read only = no
   valid users = $USERNAME
EOF"

# Restartowanie usługi Samba
sudo systemctl restart smbd

# Instalacja i konfiguracja UFW
sudo nala install -y ufw

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
echo -n "Podaj hasło dla użytkownika postgres w PostgreSQL: "
read -s POSTGRES_PASSWORD
echo

# Konfiguracja PostgreSQL
echo "Konfigurowanie PostgreSQL..."
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '${POSTGRES_PASSWORD}';"

# Wyświetlenie adresu do Cockpit
IP_ADDRESS=$(hostname -I | awk '{print $1}')
echo "Cockpit został zainstalowany i uruchomiony."
echo "Aby uzyskać dostęp do interfejsu, przejdź do:"
echo "http://$IP_ADDRESS:9090"

# Wyświetlenie informacji o współdzielonym katalogu domowym użytkownika
echo "Samba została zainstalowana i skonfigurowana."
echo "Katalog domowy użytkownika $USERNAME jest udostępniony pod adresem: \\\\$IP_ADDRESS\\Home"

# Konfiguracja interfejsu sieciowego typu dummy za pomocą nmcli
echo "Dodawanie interfejsu dummy za pomocą nmcli..."
sudo nmcli con add type dummy con-name fake ifname fake0 ip4 1.2.3.4/24 gw4 1.2.3.1

# Dodatkowe kroki konfiguracyjne (jeśli są potrzebne)
# ...

echo "Instalacja zakończona. Uruchom ponownie lub zaloguj się ponownie, aby zastosować zmiany."

# Usuwanie wszystkich plików oraz folderu nadrzędnego "ubuntu"
CURRENT_DIR=$(pwd)
PARENT_DIR=$(basename "$CURRENT_DIR")

if [ "$PARENT_DIR" = "ubuntu" ]; then
  cd .. # Przejście do katalogu nadrzędnego
  rm -rf "$PARENT_DIR" # Usunięcie folderu "ubuntu" i jego zawartości
  echo "Folder $PARENT_DIR i wszystkie jego pliki zostały usunięte."
else
  echo "Folder nadrzędny nie jest 'ubuntu'. Nie usunięto żadnych plików."
fi
