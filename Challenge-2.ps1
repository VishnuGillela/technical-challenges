[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]
    $VMName
)

function GetLinuxVMInstanceMetadata {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Microsoft.Azure.Commands.Compute.Models.PSVirtualMachine]
        $VM
    )
    
    
    $ScriptBlock = 'curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01"'
    $CommandId = "RunShellScript"
    $RunCommandOutput = Invoke-AzVMRunCommand -ResourceGroupName $VM.ResourceGroupName -VMName $VM.Name -ScriptString $ScriptBlock -CommandId $CommandId
    return $RunCommandOutput.Value[0].Message
    
}

function GetWindowsVMInstanceMetadata {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Microsoft.Azure.Commands.Compute.Models.PSVirtualMachine]
        $VM
    )
    
    $ScriptBlock = 'Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/instance?api-version=2017-08-01" | ConvertTo-Json -Depth 100'
    $CommandId = "RunPowerShellScript"
    $RunCommandOutput = Invoke-AzVMRunCommand -ResourceGroupName $VM.ResourceGroupName -VMName $VM.Name -ScriptString $ScriptBlock -CommandId $CommandId
    return $RunCommandOutput.Value[0].Message
    
}

Write-Host "Login to Azure..."
Connect-AzAccount
$ErrorActionPreference = 'Stop'
$WarningPreference = 'SilentlyContinue'
$Subscription = (Get-AzSubscription | Where-Object { $_.State -eq "Enabled" }) | Out-GridView -Title "Select Azure Subscription..." -PassThru

Write-Host "Selecting subscription context..."
Select-AzSubscription -SubscriptionObject $Subscription | Out-Null
Write-Host "$($Subscription.Name) Subscription is selected as context"

Write-Host "Checking for $($VM.Name) virtual machine in $($Subscription.Name) subscription"
$VM = Get-AzVM -Name $VMName -ErrorAction SilentlyContinue
$OsType = $VM.StorageProfile.OsDisk.OsType

if ($VM) {
    Write-Host "Virtual machine with name $($VM.Name) is found $($Subscription.Name) subscription"
    
    if ($OsType -eq "Linux") {
        try {
            Write-Host "============================[Linux VM MetaData]============================="
            $Output = GetLinuxVMInstanceMetadata -VM $VM
            $Output

            $macaddress = ($Output.Replace("[stderr]", "").Substring(28) | ConvertFrom-Json).network.interface.macAddress
        
            Write-Host "MAC Address of linux virtual machine $($VM.Name) : $($macaddress)"
        }
        catch {
            Write-Host "[ERROR] Failed to get linux virutal machine instance metadata due to below exception: `n`n $($_.Exception.Message)"
        }
        
    }
    elseif ($OsType -eq "Windows") {
        try {
            Write-Host "============================[Windows VM MetaData]==========================="
            $Output = GetWindowsVMInstanceMetadata -VM $VM
            $Output
        
            Write-Host "MAC Address of linux virtual machine $($VM.Name) : $(($Output | ConvertFrom-Json).network.interface.macAddress)"
        }
        catch {
            Write-Host "[ERROR] Failed to get windows virutal machine instance metadata due to below exception: `n`n $($_.Exception.Message)"
        }
    }
    
    
}
else {
    Write-Error "Virtual machine with name $($VM.Name) is not found in $($Subscription.Name) subscription"
}
