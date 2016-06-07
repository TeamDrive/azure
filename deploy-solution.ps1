$tenantName = (Get-Content -Path "tenantName.txt").Trim()
$location="West Europe"

# concat(parameters('tenantName'), variables('publicIPs').webportal)

$authorizedKeyFilename = "C:\Users\chgeuer\puttykeys\authorizedkeys.txt"
$githubUser = "chgeuer"
$githubProject = "td"

$_ignore = & git commit -am "." -q
$branch =  & git rev-parse HEAD
$repositoryUrl = "https://raw.githubusercontent.com/$($githubUser)/$($githubProject)/$($branch)/"

Write-Host "Pusing to '$($repositoryUrl)'"
$_ignore = & git push origin master -q

$longtermResourceGroupName = "$($tenantName)-longterm"
$resourceGroupName="$($tenantName)-rg"

New-AzureRmResourceGroup `
	-Name $longtermResourceGroupName `
	-Location $location `
	-Force

$longtermGroupDeploymentResults = New-AzureRmResourceGroupDeployment `
	-ResourceGroupName $longtermResourceGroupName `
	-TemplateUri "$($repositoryUrl)/ARM/longterm.json" `
	-TemplateParameterObject @{ tenantName=$tenantName } `
	-Mode Complete  `
	-Verbose `
	-Force

$hostServerInstanceCount = 2
$regServerInstanceCount = 2
$portalServerInstanceCount = 0
$databaseNodeInstanceCount = 1

$commonSettings = @{
	tenantName=$tenantName
	repositoryUrl=$repositoryUrl
	longtermResourceGroupName=$longtermResourceGroupName
	hostServerInstanceCount=$hostServerInstanceCount
	deployRegServer=$(if($regServerInstanceCount -gt 0) { "enabled" } else { "disabled" })
	regServerInstanceCount=$regServerInstanceCount
	deployPortalServer=$(if($portalServerInstanceCount -gt 0) { "enabled" } else { "disabled" })
	portalServerInstanceCount=$portalServerInstanceCount
	databaseNodeInstanceCount=$databaseNodeInstanceCount
	adminUsername=$env:USERNAME.ToLower()
	adminSecureShellKey=$(Get-Content -Path $authorizedKeyFilename).Trim()
	regserverIp=$longtermGroupDeploymentResults.Outputs['regserver-ip'].Value
	regserverFqdn=$longtermGroupDeploymentResults.Outputs['regserver-fqdn'].Value
	hostserverIp=$longtermGroupDeploymentResults.Outputs['hostserver-ip'].Value
	hostserverFqdn=$longtermGroupDeploymentResults.Outputs['hostserver-fqdn'].Value
	webportalIp=$longtermGroupDeploymentResults.Outputs['webportal-ip'].Value
	webportalFqdn=$longtermGroupDeploymentResults.Outputs['webportal-fqdn'].Value
}


New-AzureRmResourceGroup `
 	-Name $resourceGroupName `
 	-Location $location `
	-Force

$deploymentResult = New-AzureRmResourceGroupDeployment `
	-ResourceGroupName $resourceGroupName `
	-TemplateUri "$($repositoryUrl)/ARM/azuredeploy.json" `
	-TemplateParameterObject $commonSettings `
	-Mode Complete  `
	-Force `
	-Verbose

Write-Host "Deployment to $($commonSettings['resourceGroupName']) is $($deploymentResult.ProvisioningState)"

# https://nocentdocent.wordpress.com/2015/09/24/deploying-azure-arm-templates-with-powershell/

