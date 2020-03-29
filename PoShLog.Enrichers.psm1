# dot source all script files
Get-ChildItem -Path "$PSScriptRoot\functions" -Recurse -File -Filter '*.ps1' | ForEach-Object {
	. $_.FullName

	# Export all functions except internal
	if ($_.FullName -notlike '*\internal\*') {
		Export-ModuleMember $_.BaseName
	}
}

# Load all package dlls
try {
	foreach ($path in (Get-ChildItem "$PSScriptRoot\lib" | Where-Object { $_.Name -like '*.dll' } | Select-Object -ExpandProperty FullName)){
		Add-Type -Path $path -ErrorAction Stop
	}
}
catch {
	Write-Error $_.Exception
}