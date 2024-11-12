Import-Module PSReadLine
Set-PSReadLineOption -EditMode Vi

function OnViModeChange {
    param($mode)
    if ($mode -eq 'Command') {
        # Set the cursor to a steady block.
        Write-Host -NoNewLine "`e[2 q"
    } else {
        # Set the cursor to a thin line.
        Write-Host -NoNewLine "`e[6 q"
    }
}
OnViModeChange 'Insert'
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

# Reasigna la función BackwardDeleteChar a Ctrl+h
Set-PSReadLineKeyHandler -Chord 'Ctrl+h' -Function BackwardDeleteChar


# funcion para salir con 'jj' del modo insert
$jTimer = [System.Diagnostics.Stopwatch]::StartNew()
$global:lastKey = $null

# Define un ScriptBlock para la tecla 'j'
$scriptBlockJ = {
    param($key, $arg)

    if ($jTimer.ElapsedMilliseconds -lt 500 -and $global:lastKey -eq 'j') {
        # Si 'j' fue presionado dos veces dentro de 500ms, elimina la última 'j' y cambia al modo de comando
        [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteChar()
        [Microsoft.PowerShell.PSConsoleReadLine]::ViCommandMode()
    } else {
        # Si no, inserta 'j' y reinicia el cronómetro
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert('j')
        $jTimer.Restart()
    }
    # Actualiza la última tecla presionada
    $global:lastKey = 'j'
}

# Asigna el ScriptBlock a la tecla 'j'
Set-PSReadLineKeyHandler -Chord 'j' -ScriptBlock $scriptBlockJ


# oh-my-posh config
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/agnoster.minimal.omp.json" | Invoke-Expression
# Icons for powershell
Import-Module -Name Terminal-Icons
