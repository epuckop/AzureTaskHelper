<# 
    .DESCRIPTION 
        Controls the power state of VMs in a specified resource group where 'Scheduler ON-OFF' tag is set to 'true'. 
        System identity must have appropriate RBAC permissions. 
 
    .NOTES 
        AUTHOR: Goldenberg Dmitry         
#> 
Param( 
    [Parameter(Mandatory = $true)] 
    [string]$subscription_id, 
 
    [Parameter(Mandatory = $true)] 
    [string]$resource_group_name, 
 
    [Parameter(Mandatory = $true)] 
    [string]$action 
) 
 
$ErrorActionPreference = "Stop" 
 
try { 
    # Authenticate using system-assigned managed identity 
    Connect-AzAccount -Identity 
    # Set context to the specified subscription 
    Set-AzContext -SubscriptionId $subscription_id 
} 
catch { 
    Write-Error -Message $_.Exception.Message 
    throw 
} 
 
$action = $action.ToLower() 
 
# Retrieve VMs based on power state and 'Scheduler ON-OFF' tag 
$vmList = Get-AzVM -ResourceGroupName $resource_group_name -Status | Where-Object { 
    if ($action -eq 'on') { 
        $_.PowerState -ne 'VM running' -and $_.Tags['Scheduler ON-OFF'] -eq 'true' 
    } 
    elseif ($action -eq 'off') { 
        $_.PowerState -eq 'VM running' -and $_.Tags['Scheduler ON-OFF'] -eq 'true' 
    } 
    else { 
        Write-Error 'The "Action" parameter accepts only "ON" or "OFF" values.' 
        Exit-PSSession 
    } 
} 
 
# Perform the action on filtered VMs 
foreach ($vm in $vmList) { 
    if ($action -eq 'on') { 
        "Starting VM $($vm.Name)" 
        Start-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name 
        "VM $($vm.Name) started" 
    } 
    elseif ($action -eq 'off') { 
        "Deallocating VM $($vm.Name)" 
        Stop-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name -Force 
        "VM $($vm.Name) deallocated" 
    } 
} 
 
# Disconnect from Azure to clear the authentication context 
Disconnect-AzAccount -Scope Process