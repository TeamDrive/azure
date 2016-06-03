$tenantName = "saxony13"
$location="West Europe"

$authorizedKeyFilename = "C:\Users\chgeuer\puttykeys\authorizedkeys.txt"
$githubUser = "chgeuer"
$githubProject = "td"


$_ignore = & git commit -am "." -q
$branch =  & git rev-parse HEAD
$repositoryUrl = "https://raw.githubusercontent.com/$($githubUser)/$($githubProject)/$($branch)/"

Write-Host "Pusing to '$($repositoryUrl)'"
$_ignore = & git push origin master -q

$resourceGroupName="rg-$($tenantName)"
$hostServerInstanceCount = 1
$regServerInstanceCount = 2
$portalServerInstanceCount = 0

$commonSettings = @{
	tenantName=$tenantName
	repositoryUrl=$repositoryUrl
	longtermResourceGroupName="longterm-$($tenantName)"
	hostServerInstanceCount=$hostServerInstanceCount
	deployRegServer=$(if($regServerInstanceCount -gt 0) { "enabled" } else { "disabled" })
	regServerInstanceCount=$regServerInstanceCount
	deployPortalServer=$(if($portalServerInstanceCount -gt 0) { "enabled" } else { "disabled" })
	portalServerInstanceCount=$portalServerInstanceCount
	adminUsername=$env:USERNAME.ToLower()
	adminSecureShellKey=$(Get-Content -Path $authorizedKeyFilename).Trim()
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
