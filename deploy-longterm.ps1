$tenantName = (Get-Content -Path "tenantName.txt").Trim()
$location = "West Europe"

$githubUser = "chgeuer"
$githubProject = "td"

$_ignore = & git commit -am "." -q
$branch =  & git rev-parse HEAD
$repositoryUrl = "https://raw.githubusercontent.com/$($githubUser)/$($githubProject)/$($branch)/"

Write-Host "Pushing to '$($repositoryUrl)'"
$_ignore = & git push origin master -q

$longtermResourceGroupName = "longterm-$($tenantName)"

$parameters=@{
	tenantName=$tenantName
}

New-AzureRmResourceGroup `
	-Name $longtermResourceGroupName `
	-Location $location `
	-Force

New-AzureRmResourceGroupDeployment `
	-ResourceGroupName $longtermResourceGroupName `
	-TemplateUri "$($repositoryUrl)/ARM/longterm.json" `
	-TemplateParameterObject $parameters `
	-Mode Complete  `
	-Verbose `
	-Force


# https://nocentdocent.wordpress.com/2015/09/24/deploying-azure-arm-templates-with-powershell/
