# dot source all script files
Get-ChildItem -Path "$PSScriptRoot\functions" -Recurse -File -Filter '*.ps1' | ForEach-Object {
	. $_.FullName

	# Export all functions except internal
	if ($_.FullName -notcontains 'internal') {
		Export-ModuleMember $_.BaseName
	}
}

# Load all package dlls
try {
	Get-ChildItem $Global:packagesPath | Where-Object { $_.Name -like '*.dll' } | ForEach-Object { Add-Type -Path $_ -ErrorAction Stop }
}
catch {
	Write-Error ($_.Exception.GetBaseException().LoaderExceptions | Format-Table | Out-String)
}