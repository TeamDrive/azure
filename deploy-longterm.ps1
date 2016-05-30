$location = "West Europe"
$repositoryUrl = "https://raw.githubusercontent.com/chgeuer/td/master/"

$tenantName = "saxony"
$resourceGroupName = "rg-$($tenantName)"
$longtermResourceGroupName = "longterm-$($tenantName)"

$parameters=@{
	tenantName=$tenantName
	longtermResourceGroupName=$longtermResourceGroupName
}

git commit -am "."
git push origin master

New-AzureRmResourceGroup `
	-Name $longtermResourceGroupName `
	-Location $location

New-AzureRmResourceGroupDeployment `
	-ResourceGroupName $longtermResourceGroupName `
	-TemplateUri "$($repositoryUrl)/ARM/longterm.json" `
	-TemplateParameterObject $parameters `
	-Mode Complete  `
	-Verbose




# https://nocentdocent.wordpress.com/2015/09/24/deploying-azure-arm-templates-with-powershell/

