using namespace System.Management.Automation.Host

param(
    [switch]$verbose = $false
)

function New-Menu {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Title,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Question
    )
    
    $share = [ChoiceDescription]::new('&1 Share', 'Setup LocalDB Share: Share')
    $start = [ChoiceDescription]::new('&2 Start', 'Start LocalDB: Start')
    $stop = [ChoiceDescription]::new('&3 Stop', 'Stop LocalDB: Stop')
    $restart = [ChoiceDescription]::new('&4 Restart', 'Restart LocalDB: Restart')
    $exit = [ChoiceDescription]::new('&Quit', 'Exit LocalDB Utility: Quit')

    $options = [ChoiceDescription[]]($share, $start, $stop, $restart, $exit)

    $Title = "================= " + $Title + " ================="
    return $host.ui.PromptForChoice($Title, $Question, $options, 0)
}

function Set-Location {
    Push-Location "C:\Program Files\Microsoft SQL Server\130\Tools\Binn"
}

do
{
    Set-Location
    if(!$verbose) {
        cls
    }
    $result = New-Menu -Title 'LocalDB Utility' -Question 'Please Select An Action:'

    switch ($result) {
        0 
        {
            Write-Host 'Sharing LocalDB' -foregroundcolor Cyan
            sqllocaldb share MsSqlLocalDb SharedDb
            Write-Host 'Restarting LocalDB' -foregroundcolor Cyan
            sqllocaldb stop MsSqlLocalDb 
            sqllocaldb start MsSqlLocalDb 
            Write-Host 'Share Complete' -foregroundcolor Green
        } 
        1
        {
            Write-Host 'Starting LocalDB' -foregroundcolor Cyan
            sqllocaldb start MsSqlLocalDb 
            Write-Host 'LocalDB Started' -foregroundcolor Green
        }
        2
        {
            Write-Host 'Stopping LocalDB' -foregroundcolor Cyan
            sqllocaldb stop MsSqlLocalDb
            Write-Host 'LocalDB Stopped' -foregroundcolor Green
        }
        3
        {
            Write-Host 'Restarting LocalDB' -foregroundcolor Cyan
            sqllocaldb stop MsSqlLocalDb
            sqllocaldb start MsSqlLocalDb
            Write-Host 'LocalDB Restarted' -foregroundcolor Green
        }
    }
    Pop-Location
}
until ($result -eq 4)