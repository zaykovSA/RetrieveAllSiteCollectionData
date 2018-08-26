cls
if(!(Get-PSSnapin Microsoft.SharePoint.PowerShell -ErrorAction:SilentlyContinue))
{
    $ver = $host | select version
	if ($ver.Version.Major -gt 1)  {$Host.Runspace.ThreadOptions = "ReuseThread"}
	Add-PsSnapin Microsoft.SharePoint.PowerShell
	Set-location $home
}

function wait4timer($solutionName, $operation) {
	if ($operation -eq $null) { $operation = "Waiting"; }
    $solution = Get-SPSolution | where-object {$_.Name -eq $solutionName}
    if ($solution -ne $null) 
    {
		Write-Host -ForegroundColor yellow "  $operation $solutionName"
        $counter = 1 
		$maximum = 1000 
		$sleeptime = 2 
		while( $solution.JobExists -and ( $counter -lt $maximum ) ) { 
			Write-Host -ForegroundColor yellow "    Please wait $counter..."
			sleep $sleeptime
			$counter++ 
		}
    }
}

function GetSolutionFile($solutionName, $solutionDir)
{
	if($solutionDir -ne $null -and $solutionDir -ne "") 
    {
        return $ScriptDir+"\"+$solutionDir+"\"+$solutionName
    }
    else
    {
        return $ScriptDir+"\"+$solutionName
    }
}

function SolutionExists($solutionFile)
{
	if([System.IO.File]::Exists("$solutionFile") -eq $false)
	{
		Write-Host -ForegroundColor Red "  Solution file '$solutionFile' is not found"
        return $false
	}
	
	return $true
}

function DeploySolution($solutionName, $solutionDir, [bool]$upgrade, [bool]$local)
{	
	$solutionFile = GetSolutionFile $solutionName $solutionDir
	
	if ( (SolutionExists $solutionFile) -eq $false ) { return $false; }
    
    $solution = Get-SPSolution $solutionName -ErrorAction:SilentlyContinue
    
    if($solution -ne $null)
    {
        Write-Host -ForegroundColor Yellow "  Solution exist. Executing upgrade."
        if ($upgrade) { return UpgradeSolution $solutionName $solutionFile }
        else { Write-Host -ForegroundColor Yellow "  Upgrade is not needed." }
    }
    else
    { 
        $solution = Add-SPSolution $solutionFile -ErrorVariable error -ErrorAction:SilentlyContinue
        if($error -ne $null -and $error -ne "")
    	{
    		Write-Host -ForegroundColor Red "$error"
            Write-Host "$error" >> errlog.txt
    		return false;
    	}
    }
    
    if ($solution.Deployed -eq $false ) 
	{
    	if ( $solution.ContainsWebApplicationResource ) 
		{ 
    		Write-Host -ForegroundColor Green "Deploying solution: $solutionName"
			Write-Host -ForegroundColor Green "Application Url: $appUrl"
			if ($local) 
			{
				Install-SPSolution -Identity $solutionName -GacDeployment -Force -Local -Webapplication $appUrl
			}
			else
			{
				Install-SPSolution -Identity $solutionName -GacDeployment -Force -Webapplication $appUrl
			}
    	} 
    	else 
		{ 
    		Write-Host -ForegroundColor Green "Deploying solution globally: $solutionName"
			if ($local)
			{
    			Install-SPSolution -Identity $solutionName -GacDeployment -Force -Local
			}
			else
			{
				Install-SPSolution -Identity $solutionName -GacDeployment -Force
			}
    	} 

        wait4timer $solutionName "Deploying"
    }
    else
    {
        Write-Host -ForegroundColor Green "  Solution '$solutionName' is already deployed to '$appUrl'"
		return $false
    }

	$solution = Get-SPSolution $solutionName

	if ($solution.Deployed -eq $false ) 
	{ 
		Write-Host -ForegroundColor Red "$solutionName deployment error"
		Write-Host ""
		return $false
	}
	else
	{
		Write-Host -ForegroundColor Green "$solutionName is deployed"
		Write-Host ""
		return $true
	}
	
	return $true
}

function Retract($solutionName, [bool]$local)
{
    $solution = Get-SPSolution $solutionName -ErrorAction:SilentlyContinue
    
    if($solution -eq $null)
    {
        Write-Host -ForegroundColor Green "$solutionName is not deployed"
		Write-Host ""
		return $true
    }
    
    if ($solution.Deployed -eq $true ) 
	{
    	if ( $solution.ContainsWebApplicationResource ) 
		{ 
    		Write-Host -ForegroundColor Green "Retracting solution: $solutionName"
			Write-Host -ForegroundColor Green "Application Url: $appUrl"
			if ($local) 
			{
				Uninstall-SPSolution -Identity $solutionName -Confirm:$false -Local -Webapplication $appUrl
			}
			else
			{
				Uninstall-SPSolution -Identity $solutionName -Confirm:$false -Webapplication $appUrl
			}
    	} 
    	else 
		{ 
    		Write-Host -ForegroundColor Green "Retracting solution globally: $solutionName"
			if ($local)
			{
    			Uninstall-SPSolution -Identity $solutionName -Confirm:$false -Local
			}
			else
			{
				Uninstall-SPSolution -Identity $solutionName -Confirm:$false
			}
    	} 
    	wait4timer $solutionName "Retracting"
    }

    Remove-SPSolution -Identity $solutionName -Force -Confirm:$false
	
	$solution = Get-SPSolution $solutionName -EA:0
	
	if ($solution -ne $null ) 
	{ 
		Write-Host -ForegroundColor Red "$solutionName removal error"
		Write-Host ""
		return $false
	}
	else
	{
		Write-Host -ForegroundColor Green "$solutionName is removed"
		Write-Host ""
		return $true
	}
	
	return $true    
}

function UpgradeSolution($solutionName){
    $literalPath = GetSolutionFile $solutionName
    Update-SPSolution -Identity "$solutionName" -LiteralPath $literalpath -GACDeployment -Force
    wait4timer $solutionName "Deploying"
}

$ScriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent;
$appUrl = "http://$($env:ComputerName)"

@(
"RetrieveAllSiteCollectionData.wsp"
) |%{
    Write-Host Solution name: $_
    Retract -solutionName:$_ -local:$false | Out-Null
    DeploySolution -solutionName:$_ -upgrade:$true -local:$false | Out-Null
}