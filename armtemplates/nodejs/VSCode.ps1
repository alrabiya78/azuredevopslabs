[CmdletBinding()]
param (
    [string] $DownloadPath = "C:\Downloads"
)

# Set Execution Policy
Set-ExecutionPolicy Unrestricted -Force

# Create download folder if it doesn't exist
if (-not (Test-Path -Path $DownloadPath)) {
    New-Item -ItemType Directory -Path $DownloadPath | Out-Null
}

# List of software to download and install
$softwareList = @(
    @{
        Name = "Visual Studio Code"
        Url = "https://go.microsoft.com/fwlink/?Linkid=852157"
        FileName = "vscode.exe"
        SilentArgs = "/VERYSILENT /MERGETASKS=!runcode"
    },
    @{
        Name = "NodeJS"
        Url = "https://nodejs.org/dist/v6.11.4/node-v6.11.4-x64.msi"
        FileName = "node.msi"
        SilentArgs = "/passive"
    }
)

foreach ($software in $softwareList) {
    $destination = Join-Path -Path $DownloadPath -ChildPath $software.FileName

    Write-Output "Downloading $($software.Name)..."
    try {
        Invoke-WebRequest -Uri $software.Url -OutFile $destination -UseBasicParsing -ErrorAction Stop
        Write-Output "Download completed: $destination"

        Write-Output "Installing $($software.Name)..."
        Start-Process -FilePath $destination -ArgumentList $software.SilentArgs -Wait
        Write-Output "$($software.Name) installation completed."
    } catch {
        Write-Warning "Failed to download or install $($software.Name): $_"
    }
}

Write-Output "All installations completed."
