<#	
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.140
	 Created on:   	16/06/2017 23:45
	 Created by:   	PEZ
	 Organization: 	
	 Filename:     	PowerSDP.psm1
	-------------------------------------------------------------------------
	 Module Name: PowerSDP
	===========================================================================
#>

Get-ChildItem -Path $PSScriptRoot\MEFunctions\*.ps1 -Exclude *.tests.ps1, *profile.ps1 |
ForEach-Object {
	. $_.FullName
}
