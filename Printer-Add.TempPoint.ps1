<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2014 v4.1.63
	 Created on:   	8/21/2014 2:34 PM
	 Created by:   	Gabriel.Jensen
	 Organization: 	Advanced Diagnostic Imaging PC.
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

$CompName = $env:COMPUTERNAME


function Get-ComputerSite($ComputerName)
{
	$site = nltest /server:$ComputerName /dsgetsite 2>$null
	if ($LASTEXITCODE -eq 0) { $site[0] }
}

$ADsite = Get-ComputerSite $CompName

Import-Module PrintManagement
if ($ADsite -eq "Premier")
{
	Add-Printer -ConnectionName \\pmr-fp01\FrontDesk-Ricoh <#Front Desk Richo Printer#> -Priority 1 -AsJob
	Add-Printer -ConnectionName \\pmr-fp01\
}
elseif ($ADsite -eq "Phydata")
{
	Add-Printer	-ConnectionName \\Phy-FP01\
	Add-Printer -ConnectionName \\phy-fp01\
}
elseif ( $ADsite -eq "")
{
}
elseif ($ADsite -eq "")
{
}