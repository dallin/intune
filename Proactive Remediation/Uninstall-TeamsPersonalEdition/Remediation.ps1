try {
    # Remove the app package(s)
    Get-AppxPackage -AllUsers | Where-Object { $_.Name -eq "MicrosoftTeams" } | Remove-AppxPackage -AllUsers
    Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq "MicrosoftTeams" } | Remove-AppxProvisionedPackage -Online

    # Grab SetACL to modify the permissions of the reg key, since there is not a better way to do this in PowerShell
    Invoke-WebRequest -Uri "https://github.com/andrew-s-taylor/public/raw/main/De-Bloat/SetACL.exe" -Outfile "C:\Windows\Temp\SetACL.exe"
    C:\Windows\Temp\SetACL.exe -on "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" -ot reg -actn setowner -ownr "n:administrators"
    C:\Windows\Temp\SetACL.exe -on "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" -ot reg -actn ace -ace "n:administrators;p:full"
    Remove-Item C:\Windows\Temp\SetACL.exe -Recurse

    # Set "ConfigureChatAutoInstall" property to prevent the app from being reinstalled
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications"
    If (!(Test-Path $regPath)) { 
        New-Item $regPath
    }
    Set-ItemProperty $regPath ConfigureChatAutoInstall -Value 0

    Write-Host "Removed Teams personal edition"
}
catch {
    $errMsg = $_.Exception.Message
    return $errMsg
    exit 1
}