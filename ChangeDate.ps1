# Ustaw bieżącą datę i godzinę
$currentDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Formatuj datę i godzinę do użycia w nazwie pliku logu
$logFileName = "LOGI\logFile_ChangeTime.log"

# Funkcja do zapisywania do logu
function Write-Log {
    param (
        [string]$message
    )
    Add-Content -Path $logFileName -Value "$currentDate - $message"
}

Write_log "====================================="
Write_log "= Script Run at $currentDate ="
Write_log "====================================="

try {
	# Pobierz liste ścieżek do folderów z pliku directoryPaths.txt
	$directoryPaths = Get-Content -Path "directoryPath.txt" -Encoding UTF8
	
	#Sprawdzamy wszystkie ścieżki
	foreach ($directoryPath in $directoryPaths) {
		Write-Log "Path: $($directoryPath)"
		#  Walidacja ścieżki
		if (-Not (Test-Path -Path $directoryPath -PathType Container)) {
			Write-Log "Provided path: $($directoryPath) in directoryPath.txt does not exist or is not a directory."
            continue
		}

        # Licznik zmodyfikowanych plików
        $modifiedFilesCount = 0

		# Przejście przez wszystkie pliki w folderze i podfolderach oraz ustawienie nowych dat
		Get-ChildItem -Path $directoryPath -Recurse -File | ForEach-Object {
			try {
				[System.IO.File]::SetCreationTime($_.FullName, $currentDate)
				[System.IO.File]::SetLastAccessTime($_.FullName, $currentDate)
				[System.IO.File]::SetLastWriteTime($_.FullName, $currentDate)
				# Wyświetlenie wyniku operacji
				$modifiedFilesCount++
			} catch {
				# Obsługa błędów
				Write-Log "Failed to update dates for file: $($_.FullName) - Error: $_"
			}
        }

        Write-Log "In directory: $($directoryPath) - $($modifiedFilesCount) files changed"
	}
	
    Copy-Item -Path "directoryPath.txt" -Destination "OldDirectoryPath.txt"
    Clear-Content -Path "directoryPath.txt"
	
	$subject = 'Zakończono aktualizację dat'
	$priority = 'Normal'

} catch {

    Write-Log "An error occurred: $_"
	$subject = 'Błąd w aktualizacji dat'
	$priority = 'High'

} finally {
	
	Write-Log "Message will be sent with subcject: $subject on priority: $priority"
	
    # Logowanie wiadomości o wysłaniu e-maila
    try {
        $sendMailMessageSplat = @{
            From = 'e-mail@domena.com'
            To = 'e-mail1@domena.com, e-mail2@domena.com'
            Subject = $subject
            Attachments = $logFileName
            SmtpServer = 'smtp server'
            Priority = $priority
            Port = 25
        }
        
        Send-MailMessage @sendMailMessageSplat
        Write-Log "Email sent successfully to recipients."

    } catch {
        Write-Log "Failed to send email. Error: $_"
    }

    exit
}
