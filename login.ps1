$tenantId =       "942023a6-efbe-4d97-a72d-532ef7337595"
$applicationId =  "29845b10-e037-4c15-8383-c1dc1f0949a2"
$certThumbprint = "B8789A48A020FB1F5589C9ACAF63A4EBFFF5FA1C"
$subscriptionID = "724467b5-bee4-484b-bf13-d6a5505d2b51"

Login-AzureRmAccount `
	-ServicePrincipal `
	-TenantId $tenantId `
	-ApplicationId $applicationId `
	-CertificateThumbprint $certThumbprint

Set-AzureRmContext -SubscriptionID $subscriptionID
