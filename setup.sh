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
echo '' >> ~/.zshrc

echo '# Use modern completion system' >> ~/.zshrc
echo 'autoload -Uz compinit' >> ~/.zshrc
echo 'compinit' >> ~/.zshrc
echo '' >> ~/.zshrc
echo 'setopt histignorealldups sharehistory' >> ~/.zshrc
echo '' >> ~/.zshrc

echo '# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:' >> ~/.zshrc
echo 'HISTSIZE=1000' >> ~/.zshrc
echo 'SAVEHIST=1000' >> ~/.zshrc
echo 'HISTFILE=~/.zsh_history' >> ~/.zshrc
echo '' >> ~/.zshrc

echo 'zstyle ':completion:*' auto-description 'specify: %d'' >> ~/.zshrc
echo 'zstyle ':completion:*' completer _expand _complete _correct _approximate' >> ~/.zshrc
echo 'zstyle ':completion:*' format 'Completing %d'' >> ~/.zshrc
echo 'zstyle ':completion:*' group-name ''' >> ~/.zshrc
echo 'zstyle ':completion:*' menu select=2' >> ~/.zshrc
echo 'eval "$(dircolors -b)"' >> ~/.zshrc
echo 'zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}' >> ~/.zshrc
echo 'zstyle ':completion:*' list-colors ''' >> ~/.zshrc
echo 'zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s' >> ~/.zshrc
echo 'zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'' >> ~/.zshrc
echo 'zstyle ':completion:*' menu select=long' >> ~/.zshrc
echo 'zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s' >> ~/.zshrc
echo 'zstyle ':completion:*' use-compctl false' >> ~/.zshrc
echo 'zstyle ':completion:*' verbose true' >> ~/.zshrc
echo 'zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'' >> ~/.zshrc
echo 'zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'' >> ~/.zshrc
echo '' >> ~/.zshrc

# Dodanie neofetch do pliku konfiguracyjnego ZSH
echo '# NEOFETCH' >> ~/.zshrc
echo 'neofetch' >> ~/.zshrc
echo '' >> ~/.zshrc

# Dodanie aliasu dla batcat jako bat
echo '# Aliasy' >> ~/.zshrc
echo 'alias bat="batcat"' >> ~/.zshrc
echo 'alias cls="clear"' >> ~/.zshrc
echo 'alias ls="eza --long --icons=always --group-directories-first --all --header --group"' >> ~/.zshrc
echo '' >> ~/.zshrc

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
echo '' >> ~/.zshrc

# Instalacja wtyczek ZSH
echo -e "${LBLUE} \n## Instalacja wtyczek Zsh ##\n ${RESET}"

ZSH_PLUGIN_DIR="${ZSH_PLUGIN_DIR:-$HOME/.config/zsh}"

# Tworzenie katalogu na wtyczki
mkdir -p $ZSH_PLUGIN_DIR

# Instalacja poszczególnych wtyczek Zsh
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_PLUGIN_DIR/zsh-autosuggestions
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting $ZSH_PLUGIN_DIR/fast-syntax-highlighting
git clone https://github.com/Aloxaf/fzf-tab $ZSH_PLUGIN_DIR/fzf-tab
git clone https://github.com/zsh-users/zsh-completions $ZSH_PLUGIN_DIR/zsh-completions
git clone https://github.com/zsh-users/zsh-history-substring-search $ZSH_PLUGIN_DIR/zsh-history-substring-search
git clone https://github.com/MichaelAquilina/zsh-you-should-use $ZSH_PLUGIN_DIR/zsh-you-should-use

# Ścieżka do wtyczek
echo "export ZSH_PLUGIN_DIR=~/.config/zsh/plugins" >> ~/.zshrc

# Dodanie wszystkich wtyczek do pliku .zshrc
echo "source $ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
echo "source $ZSH_PLUGIN_DIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" >> ~/.zshrc
echo "source $ZSH_PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh" >> ~/.zshrc
echo "source $ZSH_PLUGIN_DIR/zsh-completions/zsh-completions.plugin.zsh" >> ~/.zshrc
echo "source $ZSH_PLUGIN_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh" >> ~/.zshrc
echo "source $ZSH_PLUGIN_DIR/zsh-you-should-use/you-should-use.plugin.zsh" >> ~/.zshrc

# Instalacja Mega-CMD
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

# Konfiguracja Samba
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

# Konfiguracja PostgreSQL
echo -e "${PURPLE} \nCzy chcesz skonfigurować PostgreSQL? (tak/nie) ${RESET}"
read -r CONFIGURE_POSTGRESQL

if [[ "$CONFIGURE_POSTGRESQL" =~ ^[tT][aA][kK]$ ]]; then
  sudo apt install -y postgresql postgresql-contrib
  echo -e "${LBLUE} \n## Podaj hasło dla użytkownika postgres w PostgreSQL: ${RESET}"
  read -s POSTGRES_PASSWORD
  echo
  sudo -u postgres psql -c "ALTER USER postgres PASSWORD '$POSTGRES_PASSWORD';"
  sudo systemctl enable postgresql
else
  echo -e "${CYAN} \nPominięto konfigurację PostgreSQL. ${RESET}"
fi

# Instalacja motywu Dracula dla Midnight Commander (MC)
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

# Zmiana powłoki na ZSH
echo -e "${LBLUE} \n## Zmiana powłoki na ZSH ##\n ${RESET}"
chsh -s $(which zsh)

echo -e "${LBLUE} \n## Koniec skryptu ##\n ${RESET}"

# Usunięcie folderu ubuntu
echo -e "${LBLUE} \n## Usunięcie folderu ubuntu ##\n ${RESET}"
rm -rf ~/ubuntu
