# ubuntu

# Skrypt Instalacyjny na Ubuntu

Ten skrypt ma na celu zautomatyzowanie instalacji i konfiguracji różnych programów oraz usług na systemie Ubuntu. Wykorzystuje `nala` jako menedżera pakietów, instalując niezbędne oprogramowanie, konfigurując shell `fish`, uruchamiając usługę Cockpit oraz konfigurując `samba`, `ufw`, `ssh`, `pyenv` i wiele innych.

## Funkcjonalność

1. **Aktualizacja systemu**
   - Aktualizacja listy pakietów (`nala update`) i zaktualizowanie wszystkich zainstalowanych pakietów (`nala upgrade`).

2. **Instalacja `nala`**
   - Dodanie repozytorium Volian Scar i instalacja `nala`.

3. **Instalacja niezbędnych pakietów**
   - Instalacja m.in. `git`, `curl`, `vim`, `btop`, `python3`, `fish`, `cockpit`, `samba`, `bat`, `neofetch`, `openssh-server`, `postgresql`, `mc` i wielu innych.

4. **Konfiguracja `pyenv`**
   - Instalacja `pyenv` i jego konfiguracja dla `fish`.
   - Instalacja najnowszej wersji Pythona i ustawienie jej jako globalnej.

5. **Konfiguracja powłoki `fish`**
   - Instalacja i konfiguracja `Oh My Posh` z wybranym motywem.
   - Dodanie aliasu `bat` dla `batcat`.
   - Ustawienie `neofetch` do wyświetlania przy każdym uruchomieniu terminala.

6. **Konfiguracja `samba`**
   - Udostępnienie katalogu domowego użytkownika jako zasobu sieciowego.

7. **Konfiguracja `ufw`**
   - Instalacja i konfiguracja `ufw` (Uncomplicated Firewall).
   - Dodanie reguł zapory dla `ssh`, `samba` i `cockpit`.

8. **Konfiguracja `ssh`**
   - Instalacja serwera SSH.

9. **Konfiguracja PostgreSQL**
   - Instalacja PostgreSQL i ustawienie hasła dla użytkownika `postgres`.

10. **Dodanie interfejsu dummy za pomocą `nmcli`**
    - Dodanie interfejsu sieciowego typu dummy z przykładową konfiguracją IP.

## Użycie

1. Zapisz skrypt jako `setup_script.sh`.
2. Nadaj skryptowi prawa wykonywania:
   ```bash
   chmod +x setup_script.sh
3. sudo ./setup_script.sh
