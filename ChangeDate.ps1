# Ustaw bieżącą datę i godzinę
$currentDate = Get-Date

# Formatuj datę i godzinę do użycia w nazwie pliku logu
$logFileName = "logFile_" + $currentDate.ToString("yyyy-MM-dd_HH-mm-ss") + ".log"

# Start Transkrypcji logów
Start-Transcript -Path $logFileName

try {
	# Pobierz liste ścieżek do folderów z pliku directoryPaths.txt
	$directoryPaths = Get-Content -Path "directoryPath.txt" -Encoding UTF8
	
	#Sprawdzamy wszystkie ścieżki
	foreach ($directoryPath in $directoryPaths) {
		"Path: $($directoryPath)"
		#  Walidacja ścieżki
		if (-Not (Test-Path -Path $directoryPath -PathType Container)) {
			"Provided path: $($directoryPath) in directoryPath.txt does not exist or is not a directory."

            # Stop Transkrypcji logów
			Stop-Transcript
			exit
		}

		# Przejście przez wszystkie pliki w folderze i podfolderach oraz ustawienie nowych dat
		Get-ChildItem -Path $directoryPath -Recurse -File | ForEach-Object {
			try {
				[System.IO.File]::SetCreationTime($_.FullName, $currentDate)
				[System.IO.File]::SetLastAccessTime($_.FullName, $currentDate)
				[System.IO.File]::SetLastWriteTime($_.FullName, $currentDate)
				# Wyświetlenie wyniku operacji
				"File: $($_.FullName) - All dates successfully updated to $currentDate"
			} catch {
				# Obsługa błędów
				"Failed to update dates for file: $($_.FullName) - Error: $_"
			}
        	}
	}
    
    Copy-Item -Path "directoryPath.txt" -Destination "directoryPathOld.txt"
    Clear-Content -Path "directoryPath.txt"
	
    # Stop Transkrypcji logów
	Stop-Transcript

	$sendMailMessageSplat = @{
		From = 'test@domena.pl'
		To = 'user@domena.pl'
		Subject = 'Zakończono aktualizację dat' 
		Attachments = $logFileName
		SmtpServer = 'serwer SMTP'
	}
 
} catch {

    "An error occurred: $_"
    # Stop Transkrypcji logów
    Stop-Transcript  
	
	$sendMailMessageSplat = @{
		From = 'test@domena.pl'
		To = 'user@domena.pl'
		Subject = 'Błąd w aktualizacji dat' 
		Body = 'Wystąpił błąd w trakcie przetwarzania dat. W załączeniu log'
		Attachments = $logFileName
		Priority = 'High'
		SmtpServer = 'serwer SMTP'
	}

} finally {
    Send-MailMessage @sendMailMessageSplat
}
