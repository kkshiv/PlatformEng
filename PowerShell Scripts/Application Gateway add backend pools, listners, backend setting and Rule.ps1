# Variables
$resourceGroup = "<ResourceGroupName>"
$appGwName = "<ApplicationGatewayName>"

# Get existing Application Gateway
$appGw = Get-AzApplicationGateway -Name $appGwName -ResourceGroupName $resourceGroup

# Step 1: Add Backend Pool
$backendPool = New-AzApplicationGatewayBackendAddressPool -Name "myBackendPool" -BackendAddress @(
    New-AzApplicationGatewayBackendAddress -IPAddress "10.0.1.4"
)
$appGw.BackendAddressPools.Add($backendPool)
Write-Host "Added backend pool"

# Step 2: Add Backend HTTP Setting
$httpSetting = New-AzApplicationGatewayBackendHttpSetting -Name "myHttpSetting" `
    -Port 443 -Protocol Https -CookieBasedAffinity Disabled -PickHostNameFromBackendAddress $false
$appGw.BackendHttpSettingsCollection.Add($httpSetting)
Write-Host "Added backend HTTP setting"

# Step 3: Add Frontend Listener
$frontendIPConfig = $appGw.FrontendIPConfigurations[0]
$frontendPort = New-AzApplicationGatewayFrontendPort -Name "myFrontendPort" -Port 443
$appGw.FrontendPorts.Add($frontendPort)

$listener = New-AzApplicationGatewayHttpListener -Name "myListener" `
    -Protocol Http -FrontendIPConfiguration $frontendIPConfig `
    -FrontendPort $frontendPort
$appGw.HttpListeners.Add($listener)
Write-Host "Added listener"

# Step 4: Add Request Routing Rule
$rule = New-AzApplicationGatewayRequestRoutingRule -Name "myRoutingRule" `
    -RuleType Basic -HttpListener $listener `
    -BackendAddressPool $backendPool `
    -BackendHttpSetting $httpSetting
$appGw.RequestRoutingRules.Add($rule)
Write-Host "Added routing rule"

# Step 5: Commit changes
Set-AzApplicationGateway -ApplicationGateway $appGw
Write-Host "Successfully updated Application Gateway"
