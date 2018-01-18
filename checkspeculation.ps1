
<#
.SYNOPSIS
    Version 1.0
    
  Script will indicates if your instance/computer is protected against speculative execution side-channel vulnerabilities.

  Script will download the Speculation Control Validation PowerShell Script, unzip it and run it against it's module - this zip file contains a PowerShell module 
  that can be used to confirm whether a system has enabled the protections needed to validate that the speculation control vulnerability. 
  This is described in the blog topic: "Windows Server guidance to protect against the speculative execution side-channel vulnerabilities."

#>

Param(
  [parameter(mandatory=$false)]
  [System.Boolean]
  $loggingEnabled = $true,
  
  [parameter(mandatory=$false)]
  [System.String]
  $logPath
)

#region Variables

$url = "https://gallery.technet.microsoft.com/scriptcenter/Speculation-Control-e36f0050/file/185444/1/SpeculationControl.zip"
$output = "$PSScriptRoot\SpeculationControl.zip" 
$start_time = Get-Date
$file="SpeculationControl.zip"
$destination="SpeculationControl"

#endregion


#Process to download the Speculation-Control zip file.

Import-Module BitsTransfer
Start-BitsTransfer -Source $url -Destination $output
#OR
Start-BitsTransfer -Source $url -Destination $output -Asynchronous

Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

#end of Process

#Process to unzip the Speculation-Control zip file for older PowerShell

shell_app=new-object -com shell.application
$zip_file = $shell_app.namespace((Get-Location).Path + "\$file")
$destination = $shell_app.namespace((Get-Location).Path)
$destination.Copyhere($zip_file.items())

#end of Process


#Process that determines if the instance/computer is protected against speculative control.

$SaveExecutionPolicy = Get-ExecutionPolicy 
#  
Set-ExecutionPolicy RemoteSigned -Scope Currentuser # this won't be necessary if executed from Run Command (AWS)
 
Import-Module .\SpeculationControl\SpeculationControl.psd1

Get-SpeculationControlSettings 
 
Set-ExecutionPolicy $SaveExecutionPolicy -Scope Currentuser

#end of Process



