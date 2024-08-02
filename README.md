# ubuntu

# Skrypt Instalacyjny na Ubuntu

Ten skrypt ma na celu zautomatyzowanie instalacji i konfiguracji różnych programów oraz usług na systemie Ubuntu. Wykorzystuje `nala` jako menedżera pakietów, instalując niezbędne oprogramowanie, konfigurując shell `fish`, uruchamiając usługę Cockpit oraz konfigurując `samba`, `ufw`, `ssh`, `pyenv` i wiele innych.

# Lista Instalowanych Pakietów

Poniżej znajduje się lista pakietów instalowanych przez skrypt:

1. **nala** - alternatywny menedżer pakietów dla `apt`.
2. **git** - system kontroli wersji.
3. **curl** - narzędzie do transferu danych z URL.
4. **btop** - narzędzie do monitorowania zasobów systemowych (alternatywa dla `htop`).
5. **python3** - język programowania Python 3.
6. **python3-pip** - menedżer pakietów dla Pythona 3.
7. **fish** - interaktywna powłoka Unix.
8. **cockpit** - interfejs webowy do zarządzania systemem.
9. **samba** - oprogramowanie do współdzielenia plików i drukarek.
10. **bat** - narzędzie do wyświetlania plików tekstowych z kolorowaniem składni (alias dla `batcat`).
11. **neofetch** - narzędzie do wyświetlania informacji o systemie.
12. **openssh-server** - serwer SSH.
13. **postgresql** - system zarządzania bazami danych SQL.
14. **postgresql-contrib** - dodatkowe moduły i narzędzia dla PostgreSQL.
15. **build-essential** - pakiet narzędzi do kompilacji oprogramowania.
16. **libssl-dev** - biblioteka SSL (deweloperska wersja).
17. **zlib1g-dev** - biblioteka kompresji (deweloperska wersja).
18. **libbz2-dev** - biblioteka kompresji Bzip2 (deweloperska wersja).
10. **libreadline-dev** - biblioteka do zarządzania wprowadzaniem linii tekstu (deweloperska wersja).
20. **libsqlite3-dev** - biblioteka SQLite (deweloperska wersja).
21. **wget** - narzędzie do pobierania plików z sieci.
22. **libncurses5-dev** - biblioteka Ncurses (deweloperska wersja).
23. **libgdbm-dev** - biblioteka GDBM (deweloperska wersja).
24. **liblzma-dev** - biblioteka LZMA (deweloperska wersja).
25. **sqlite3** - system zarządzania bazą danych SQLite.
26. **libffi-dev** - biblioteka FFI (deweloperska wersja).
27. **libtk8.6** - biblioteka Tk (wersja 8.6).
28. **libgdbm-compat-dev** - biblioteka GDBM (wersja kompatybilna, deweloperska).
29. **mc** - menedżer plików Midnight Commander.

Skrypt dodatkowo instaluje i konfiguruje `pyenv` oraz `Oh My Posh` i ich zależności, które nie są bezpośrednio pakietami systemowymi, lecz skryptami lub narzędziami instalowanymi niezależnie.

## Funkcjonalność

1. **Aktualizacja systemu**
   - Aktualizacja listy pakietów (`nala update`) i zaktualizowanie wszystkich zainstalowanych pakietów (`nala upgrade`).

2. **Instalacja `nala`**
   - Dodanie repozytorium Volian Scar i instalacja `nala`.

3. **Instalacja niezbędnych pakietów**
   - Instalacja m.in. `git`, `curl`, `btop`, `python3`, `fish`, `cockpit`, `samba`, `bat`, `neofetch`, `openssh-server`, `postgresql`, `mc` i wielu innych.

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

1. Zapisz skrypt jako `ubuntu_setup.sh`.
2. Nadaj skryptowi prawa wykonywania:
   ```bash
   chmod +x ubuntu_setup.sh
3. Uruchom skrypt:
   ```bash
   sudo ./ubuntu_setup.sh
