# ubuntu

# Skrypt Instalacyjny na Ubuntu

Ten skrypt ma na celu zautomatyzowanie instalacji i konfiguracji różnych programów oraz usług na systemie Ubuntu. Wykorzystuje `nala` jako menedżera pakietów, instalując niezbędne oprogramowanie, konfigurując shell `fish`, uruchamiając usługę Cockpit oraz konfigurując `samba`, `ufw`, `ssh`, `pyenv` i wiele innych.

# Lista Instalowanych Pakietów

Poniżej znajduje się lista pakietów instalowanych przez skrypt:

1. **nala** - alternatywny menedżer pakietów dla `apt`.
2. **git** - system kontroli wersji.
3. **curl** - narzędzie do transferu danych z URL.
4. **vim** - zaawansowany edytor tekstu.
5. **btop** - narzędzie do monitorowania zasobów systemowych (alternatywa dla `htop`).
6. **python3** - język programowania Python 3.
7. **python3-pip** - menedżer pakietów dla Pythona 3.
8. **fish** - interaktywna powłoka Unix.
9. **cockpit** - interfejs webowy do zarządzania systemem.
10. **samba** - oprogramowanie do współdzielenia plików i drukarek.
11. **bat** - narzędzie do wyświetlania plików tekstowych z kolorowaniem składni (alias dla `batcat`).
12. **neofetch** - narzędzie do wyświetlania informacji o systemie.
13. **openssh-server** - serwer SSH.
14. **postgresql** - system zarządzania bazami danych SQL.
15. **postgresql-contrib** - dodatkowe moduły i narzędzia dla PostgreSQL.
16. **build-essential** - pakiet narzędzi do kompilacji oprogramowania.
17. **libssl-dev** - biblioteka SSL (deweloperska wersja).
18. **zlib1g-dev** - biblioteka kompresji (deweloperska wersja).
19. **libbz2-dev** - biblioteka kompresji Bzip2 (deweloperska wersja).
20. **libreadline-dev** - biblioteka do zarządzania wprowadzaniem linii tekstu (deweloperska wersja).
21. **libsqlite3-dev** - biblioteka SQLite (deweloperska wersja).
22. **wget** - narzędzie do pobierania plików z sieci.
23. **libncurses5-dev** - biblioteka Ncurses (deweloperska wersja).
24. **libgdbm-dev** - biblioteka GDBM (deweloperska wersja).
25. **liblzma-dev** - biblioteka LZMA (deweloperska wersja).
26. **sqlite3** - system zarządzania bazą danych SQLite.
27. **libffi-dev** - biblioteka FFI (deweloperska wersja).
28. **libtk8.6** - biblioteka Tk (wersja 8.6).
29. **libgdbm-compat-dev** - biblioteka GDBM (wersja kompatybilna, deweloperska).
30. **mc** - menedżer plików Midnight Commander.

Skrypt dodatkowo instaluje i konfiguruje `pyenv` oraz `Oh My Posh` i ich zależności, które nie są bezpośrednio pakietami systemowymi, lecz skryptami lub narzędziami instalowanymi niezależnie.

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
