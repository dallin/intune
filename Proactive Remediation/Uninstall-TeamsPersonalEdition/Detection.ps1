try {
	$detections = @(Get-AppxPackage -AllUsers | Where-Object { $_.Name -eq "MicrosoftTeams" }).Count
	$detections += @(Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq "MicrosoftTeams" }).Count

	Write-Host "$detections instances of Teams personal edition found"

	if ($detections -gt 0) {
		exit 1
	}
	else {
		exit 0
	}
}
catch {
	$errMsg = $_.Exception.Message
	return $errMsg
	exit 1
}