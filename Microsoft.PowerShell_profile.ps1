Import-Module posh-git
Import-Module oh-my-posh
set-alias -name pn -value pnpm
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
$commandOverride = [ScriptBlock]{ param($Location) Write-Host $Location }
oh-my-posh init pwsh --config C:\Users\Lili\AppData\Local\oh-my-posh\themes\bubblesline.omp.json | Invoke-Expression

# pass your override to PSFzf:
Set-PsFzfOption -AltCCommand $commandOverride
Set-PsFzfOption -EnableAliasFuzzyEdit
Set-PsFzfOption -EnableAliasFuzzyFasd
Set-PsFzfOption -EnableAliasFuzzyHistory
Set-PsFzfOption -EnableAliasFuzzyKillProcess
Set-PsFzfOption -EnableAliasFuzzySetLocation
Set-PsFzfOption -EnableAliasFuzzySetEverything
Set-PsFzfOption -EnableAliasFuzzyScoop
Set-PsFzfOption -EnableAliasFuzzyZLocation
Set-PsFzfOption -EnableFd
Set-PsFzfOption -EnableAliasFuzzyGitStatus


Enable-PoshTooltips
Enable-PoshLineError
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
$env:POSH_GIT_ENABLED = $true
Set-PSReadLineOption -PredictionSource History
Set-PsFzfOption -TabExpansion
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
$AppData = "$env:APPDATA"
$localApp = "$env:LOCALAPPDATA"
New-Alias which get-command
New-Alias touch New-Item
function eval-ssh (){
    Start-Service ssh-agent
}

function runFish {
  bash -c fish
}

Set-Alias -Name ls -value "Get-ChildItem" -Option AllScope
Set-Alias -Name cat -value "Get-Content" -Option AllScope
Set-Alias -Name cp -value "Copy-Item" -Option AllScope
Set-Alias -Name mv -value "Move-Item" -Option AllScope
Set-Alias -Name rm -value "Remove-Item" -Option AllScope
Set-Alias -Name rmdir -value "Remove-Item" -Option AllScope
Set-Alias -Name grep -value "Select-String" -Option AllScope
Set-Alias -Name df -value "Get-PSDrive" -Option AllScope
function Start-TsNodeSkipProject {ts-node --skip-project}
Set-Alias -Name ts -value "Start-TsNodeSkipProject" -Option AllScope

New-Alias -Force -Name fish -value runFish -Option AllScope

$github = "E:\Documents\Github"
$pingouin = "E:\Documents\Github\Pingouin\.obsidian\plugins"
$vault = "E:\Constellation"
$scripts = "E:\Documents\Github\SimpleScript\Python"
$downloads = "E:\Téléchargements"
$publisher = "E:\Documents\Github\Obsidian Publisher"

function mkdir {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path
    )

    New-Item -ItemType Directory -Path $Path | Out-Null
}

function run() {
  $folder = "E:\Documents\Github\SimpleScript\Python"
  $file = $args[0]
  $cmd = $args[1..$args.Length]
  python "$folder\$file.py" $cmd
}

function obsidiandev {
    $cmd = $args -join " "
    $folder = $args -split '/' | Select-Object -Last 1
    cd $Pingouin
    Invoke-Expression $cmd
    cd $folder
    code .
}

function plug {
  cd ~/BetterDiscord;
  & git pull
  & pnpm install
  & C:\Users\Lili\AppData\Local\DiscordCanary\Update.exe --processStart DiscordCanary.exe
  & Stop-Process -name DiscordCanary -Force
  & C:\Users\Lili\AppData\Local\DiscordCanary\Update.exe --processStart DiscordCanary.exe
  & pnpm run inject canary
}

function initPlugin {
  cd $Pingouin
  pnpm exec @lisandra-dev/obsidian-plugin@latest
}

function vps {
  ssh -i ~\.ssh\vps ubuntu@140.238.215.226
}

function ovh {
  ssh -i ~\.ssh\ovh_vps ubuntu@152.228.134.48
}

function ora {
  ssh -i ~\.ssh\oracle ubuntu@140.238.175.207
}

function Obsidian-Tools {
  $folder = "E:\Documents\Github\SimpleScript\Python\Obsidian-tools"
  $file = $args[0]
  $cmd = $args[1..$args.Length]
  python "$folder\$file.py" $cmd
}

function RunScript {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$ScriptName,
        [Parameter(Mandatory = $false, Position = 1)]
        [string[]]$Arguments
    )
    $scriptPath = Join-Path $HOME ".powershell\$ScriptName.ps1"
    if (Test-Path $scriptPath) {
        powershell -File $scriptPath $Arguments
    } else {
        Write-Host "Le script '$ScriptName' n'a pas été trouvé."
    }
}
# pip powershell completion start
if ((Test-Path Function:\TabExpansion) -and -not `
    (Test-Path Function:\_pip_completeBackup)) {
    Rename-Item Function:\TabExpansion _pip_completeBackup
}
function TabExpansion($line, $lastWord) {
    $lastBlock = [regex]::Split($line, '[|;]')[-1].TrimStart()
    if ($lastBlock.StartsWith("C:\Python311\python.exe -m pip ")) {
        $Env:COMP_WORDS=$lastBlock
        $Env:COMP_CWORD=$lastBlock.Split().Length - 1
        $Env:PIP_AUTO_COMPLETE=1
        (& C:\Python311\python.exe -m pip).Split()
        Remove-Item Env:COMP_WORDS
        Remove-Item Env:COMP_CWORD
        Remove-Item Env:PIP_AUTO_COMPLETE
    }
    elseif (Test-Path Function:\_pip_completeBackup) {
        # Fall back on existing tab expansion
        _pip_completeBackup $line $lastWord
    }
}
# pip powershell completion end

# function lint that run eslint --fix $args/**{} -c ~/.eslintrc.js
function lint {
  param (
    [string]$path = $null
  )
  if ($path -eq $null) {
    $path = "."
  }
  if ($path.endsWith("/")) {
    $path = $path.Substring(0, $path.Length - 1)
  }
  Write-Host -ForeGroundColor Blue "🔄 Running 'eslint --fix' on $path"
  $cmd = "eslint --no-eslintrc --fix '$path/**/*.{js,ts,json,html}' -c '$env:USERPROFILE\.eslintrc.js'"
  Invoke-Expression $cmd
  Write-Host -ForeGroundColor Green "🎉 Done"
}

function gpt {
  cd $github\open-access-gpt\app
  npm start
}