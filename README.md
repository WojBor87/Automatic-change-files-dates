# Change Date and Time Powershell Script

## SYNOPSIS
Skrypt PowerShell do aktualizacji dat utworzenia, ostatniego dostępu oraz modyfikacji plików w określonych katalogach na bieżącą datę i godzinę.

## DESCRIPTION
Skrypt ten wczytuje listę katalogów z pliku tekstowego `directoryPath.txt` i przechodzi przez wszystkie pliki w tych katalogach oraz ich podkatalogach. Dla każdego pliku w katalogach aktualizuje daty:

- **utworzenia (Creation Date)**,
- **ostatniego dostępu (Last Access Date)**,
- **ostatniej modyfikacji (Last Write Date)**

na bieżącą datę i godzinę z systemu.

Ponadto, skrypt tworzy szczegółowy log zawierający listę przetworzonych plików oraz liczbę zmodyfikowanych plików w każdym katalogu. Na koniec wysyła wiadomość e-mail z powiadomieniem o zakończeniu procesu oraz załączonym plikiem logu.

### Kluczowe funkcjonalności:
- Wczytywanie listy katalogów z pliku `directoryPath.txt`
- Walidacja istnienia ścieżek katalogów
- Aktualizacja dat utworzenia, ostatniego dostępu oraz modyfikacji plików
- Tworzenie pliku logu z raportem operacji
- Wysyłanie wiadomości e-mail z raportem o sukcesie lub błędach

## USAGE
1. Umieść ścieżki katalogów w pliku `directoryPath.txt`, każdy katalog w osobnej linii.
2. Uruchom skrypt PowerShell, np.:
   ```bash
   ./ChangeDate.ps1
   ```
3. Skrypt zaktualizuje daty plików i wygeneruje plik logu w katalogu LOGI.
4. Na koniec skrypt wyśle wiadomość e-mail z podsumowaniem oraz załączonym plikiem logu.
   
## REQUIREMENTS
- **System operacyjny Windows z zainstalowanym PowerShellem**
- **Uprawnienia dostępu do katalogów i plików wymienionych w directoryPath.txt**
- **Uprawnienia do wysyłania e-maili przez skonfigurowany serwer SMTP**
  
## EXAMPLES
Przykład zawartości pliku directoryPath.txt:
```vbent
C:\Dane\Projekty
C:\Dane\Dokumenty
D:\Backup\Pliki
\\192.168.1.100\Shared\Folder1
\\192.168.1.100\Shared\Folder2
```
Przykład uruchomienia skryptu:
   ```bash
   ./ChangeDate.ps1
   ```

## NOTES
- **Autor: Wojciech Borawski**
- **Email: w.borawski@cotynatostudio.pl**
- **Organizacja: Co Ty Na To Studio Wojciech Borawski**
