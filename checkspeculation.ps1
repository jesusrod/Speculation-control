
$url = "https://gallery.technet.microsoft.com/scriptcenter/Speculation-Control-e36f0050/file/185444/1/SpeculationControl.zip"
$output = "$PSScriptRoot\SpeculationControl.zip"
$start_time = Get-Date
$file="SpeculationControl.zip"
$destination="SpeculationControl"

Import-Module BitsTransfer
Start-BitsTransfer -Source $url -Destination $output
#OR
Start-BitsTransfer -Source $url -Destination $output -Asynchronous

Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"

$shell_app=new-object -com shell.application
$zip_file = $shell_app.namespace((Get-Location).Path + "\$file")
$destination = $shell_app.namespace((Get-Location).Path)
$destination.Copyhere($zip_file.items())

$SaveExecutionPolicy = Get-ExecutionPolicy 
#  
Set-ExecutionPolicy RemoteSigned -Scope Currentuser 
 
Import-Module .\SpeculationControl\SpeculationControl.psd1
Get-SpeculationControlSettings 
 
Set-ExecutionPolicy $SaveExecutionPolicy -Scope Currentuser
