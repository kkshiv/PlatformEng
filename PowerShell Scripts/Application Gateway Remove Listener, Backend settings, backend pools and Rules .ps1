# Define variables
$resourceGroup = "<ResourceGroupName>"
$appGwName = "<ApplicationGatewayName>"

# Get the Application Gateway
$appGw = Get-AzApplicationGateway -ResourceGroupName $resourceGroup -Name $appGwName

# Define the names of the components to remove (Multiple)
$httpSettingsToRemove = @("<backendsettingname1>", "<backendsettingname2">, "<backendsettingname3>")
$listenersToRemove = @("<listenername1>", "<listenername2">, "<listenername3>")
$rulesToRemove = @("<rulename1>", "<rulename2">, "<rulename3>")
$backendPoolsToRemove = @("<backendpoolname1>", "<backendpoolname2>", "<backendpoolname3>")

# Define the names of the components to remove (Single)
#$httpSettingsToRemove = @("backendsettingname")
#$listenersToRemove = @("listenername")
#$rulesToRemove = @("rulename")
#$backendPoolsToRemove = @("<backendpoolname1>")

# Step 1: Remove Routing Rules
foreach ($ruleName in $rulesToRemove) {
    $rule = $appGw.RequestRoutingRules | Where-Object { $_.Name -eq $ruleName }
    if ($rule) {
        $appGw.RequestRoutingRules.Remove($rule)
        Write-Host "Removed Routing Rule: $ruleName"
    }
}

# Step 2: Remove Listeners
foreach ($listenerName in $listenersToRemove) {
    $listener = $appGw.HttpListeners | Where-Object { $_.Name -eq $listenerName }
    if ($listener) {
        $appGw.HttpListeners.Remove($listener)
        Write-Host "Removed Listener: $listenerName"
    }
}

# Step 3: Remove Backend HTTP Settings
foreach ($httpSettingsName in $httpSettingsToRemove) {
    $httpSetting = $appGw.BackendHttpSettingsCollection | Where-Object { $_.Name -eq $httpSettingsName }
    if ($httpSetting) {
        $appGw.BackendHttpSettingsCollection.Remove($httpSetting)
        Write-Host "Removed Backend HTTP Setting: $httpSettingsName"
    }
}

# Step 4: Remove Backend Address Pools
foreach ($poolName in $backendPoolsToRemove) {
    $pool = $appGw.BackendAddressPools | Where-Object { $_.Name -eq $poolName }
    if ($pool) {
        $appGw.BackendAddressPools.Remove($pool)
        Write-Host "Removed Backend Address Pool: $poolName"
    }
}

# Step 5: Apply changes to Azure
Set-AzApplicationGateway -ApplicationGateway $appGw

Write-Host "Successfully removed specified Backend HTTP settings, listeners, backend pools and rules."
