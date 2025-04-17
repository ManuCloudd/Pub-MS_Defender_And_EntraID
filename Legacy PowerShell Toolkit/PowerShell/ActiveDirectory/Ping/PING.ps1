$first = $true
$firstLost = $null
$x = 0;$y = 1
 while($true) {
	$PingOutput = (((ping -n 1 -w 1500 google.fr | Out-String).Trim()) -replace '\n','--')
    if(-Not ($PingOutput -match 'temps\=(\d*) ms')) {
		if(!$firstLost) {
			$firstLost = get-date
			[console]::setcursorposition($x,$y)
			$y++
			Write-Host "$(get-date -Format 'HH:mm') : Pertes de paquets !" -foregroundcolor "red"
		}
    } else {
		if($first) {Clear-Host; $first = $false}
		[console]::setcursorposition(0, 0)
		Write-Output "Latence $($Matches[1])ms      "
		if($firstLost) {
			$duration = New-TimeSpan -Start $firstLost -End $(get-date)
			[console]::setcursorposition(0,$y)
			$y++
			Write-Host "$(get-date -Format 'HH:mm') : Perte de Paquets pendant : $($duration.TotalSeconds)" -foregroundcolor "Yellow"
			 $firstLost = $null
		}
		if([int]($Matches[1]) -gt 100) {
			[console]::setcursorposition(0,$y)
			$y++
			Write-Host "$(get-date -Format 'HH:mm') : Latence $($Matches[1])ms" -foregroundcolor "Yellow"
		}
    }
    Start-sleep -m 500
 }