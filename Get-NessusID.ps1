<#
    .SYNOPSIS
        Script to query the Nessus vulnerability name from an ID.

    .DESCRIPTION
        Queries a Nessus plugin ID and returns the plugin name. Option to open the details page or the Nessus page.

    .PARAMETER ID
        The Nessus plugin ID to look up.

    .PARAMETER details
        Optional. Opens the tenable page for the plugin ID.

    .PARAMETER nessus
        Optional. Opens the nessus.corp.com page for the plugin ID.

    .EXAMPLE
        Get-NessusID.ps1 -ID 106818

    .EXAMPLE
        Get-NessusID.ps1 -ID 106818 -nessus

    .EXAMPLE
        Get-NessusID.ps1 -ID 106818 -details

    .NOTES
        File Name: Get-NessusID.ps1
        Author: keyboardcrunch
        Date Created: 28/02/18
#>

param (
    [string]$ID = $(throw "-ID is required."),
    [switch]$details,
    [switch]$nessus
)

$QueryURL = "https://www.tenable.com/plugins/nessus/$ID"
$NessusURL = "https://nessus.corp.com/#vulnerabilities/cumulative/sumid/%7B%22filt%22%3A%5B%7B%22id%22%3A%22pluginID%22%2C%22filterName%22%3A%22pluginID%22%2C%22operator%22%3A%22%3D%22%2C%22type%22%3A%22vuln%22%2C%22isPredefined%22%3Atrue%2C%22value%22%3A%22$ID%22%7D%5D%2C%22sortCol%22%3A%22severity%22%2C%22sortDir%22%3A%22desc%22%7D"

$Response = Invoke-WebRequest $QueryURL
$PageTitle = $Response.AllElements | Where {$_.TagName -eq "Title"}
$Title = $PageTitle.innerText
$IDName = $Title.replace(" | Tenable™","")

Write-Host "`n`t$IDName" -ForegroundColor Green

If ($details) {
    $null = [System.Diagnostics.Process]::Start($QueryURL)
}

If ($nessus) {
    $null = [System.Diagnostics.Process]::Start($NessusURL)
}