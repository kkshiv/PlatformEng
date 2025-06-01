# Define your variables
$excelPath = "C:\Users\<UserName>\Documents\secrets.xlsx" #Excel Contains Two columns SecretName and SecretValue
$keyVaultName = "<KayVaultName>"

# Import Excel sheet
$secrets = Import-Excel -Path $excelPath

# Push each secret to Azure Key Vault
foreach ($secret in $secrets) {
    $name = $secret.SecretName
    $value = $secret.SecretValue
    Set-AzKeyVaultSecret -VaultName $keyVaultName -Name $name -SecretValue (ConvertTo-SecureString $value -AsPlainText -Force)
    Write-Host "Pushed secret: $name"
}
