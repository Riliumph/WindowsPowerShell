Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

$modules = @("oh-my-posh", "posh-git")

foreach ($module in $modules) {
    try {
        Import-Module $module -ErrorAction Stop
    } catch {
        Write-Host "'$module' is not installed. Installing..."
        try {
            Install-Module $module -Scope CurrentUser -Force -AllowClobber
            Import-Module $module
        } catch {
            Write-Host "Failed to install '$module': $_"
        }
    }
}

function open([string]$path) {
    explorer $path
}

function prompt {
    $time      = "$(Get-Date -Format "HH:mm:ss")"
    $username  = [System.Environment]::UserName
    $hostname  = $env:COMPUTERNAME
    $path      = $(Get-Location)
    $branch    = ""

    if(Test-Path ".git"){
        try{
            $branch = git rev-parse --abbrev-ref HEAD 2>$null
        }catch{
            $branch = ""
        }
    }

    $esc = [char]27
    $white  = "$esc[37m"
    $blue   = "$esc[34m"
    $green  = "$esc[32m"
    $yellow = "$esc[33m"
    $red    = "$esc[31m"
    $reset  = "$esc[0m"

    return "[$time] ${blue}$username$reset@${green}$hostname${white}: ${yellow}$path$reset| ${red}$branch$reset`nPS> "
}
