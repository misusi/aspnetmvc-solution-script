# ARGV AND VARIABLES
$solutionName=$args[0]

$dotnetCoreVersion="net7.0"

$bootstrapCssLink='<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">'
$bootstrapJsLink='<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>'

$dataLayerExtension="Data"
$modelLayerExtension="Models"
$webLayerExtension="Web"
$utilityLayerExtension="Utils"

$dataProjName="$solutionName.$dataLayerExtension"
$modelProjName="$solutionName.$modelLayerExtension"
$webProjName="$solutionName.$webLayerExtension"
$utilityProjName="$solutionName.$utilityLayerExtension"


# CREATE SOLUTION AND OTHER PROJECTS
## Create Solution
mkdir $solutionName
cd $solutionName
dotnet new sln --name $solutionName
## Web - Add Project and Nuget Packages
dotnet new mvc --name $webProjName --framework $dotnetCoreVersion --auth Individual
dotnet sln add $webProjName
dotnet add $webProjName package Microsoft.AspNetCore.Authentication.Facebook
dotnet add $webProjName package Microsoft.AspNetCore.Identity.EntityFrameworkCore
dotnet add $webProjName package Microsoft.AspNetCore.Identity.UI
dotnet add $webProjName package Microsoft.EntityFrameworkCore.Design
dotnet add $webProjName package Microsoft.EntityFrameworkCore.SqlServer
dotnet add $webProjName package Microsoft.EntityFrameworkCore.Tools
dotnet add $webProjName package Microsoft.VisualStudio.Web.CodeGeneration.Design
dotnet add $webProjName package MvcScaffolding
#dotnet add $webProjName package Stripe.net
## DataAccess - Add Project and Nuget Packages
dotnet new classlib --name $dataProjName --framework $dotnetCoreVersion
dotnet sln add $dataProjName
dotnet add $dataProjName package Microsoft.EntityFrameworkCore
dotnet add $dataProjName package Microsoft.EntityFrameworkCore.Design
dotnet add $dataProjName package Microsoft.EntityFrameworkCore.Tools
dotnet add $dataProjName package Microsoft.EntityFrameworkCore.SqlServer
dotnet add $dataProjName package Microsoft.EntityFrameworkCore.Relational
dotnet add $dataProjName package Microsoft.AspNetCore.Identity.EntityFrameworkCore
## Model - Add Project and Nuget Packages
dotnet new classlib --name $modelProjName --framework $dotnetCoreVersion
dotnet sln add $modelProjName
dotnet add $modelProjName package Microsoft.AspNetCore.Mvc.ViewFeatures
dotnet add $modelProjName package Microsoft.Extensions.Identity.Stores
## Utility - Add Project and Nuget Packages
dotnet new classlib --name $utilityProjName --framework $dotnetCoreVersion
dotnet sln add $utilityProjName
dotnet add $utilityProjName package Microsoft.AspNetCore.Identity.UI
#dotnet add $utilityProjName package MailKit
#dotnet add $utilityProjName package MimeKit
#dotnet add $utilityProjName package SendGrid


# PROJECT REFERENCES
## Web - Add References
dotnet add $webProjName/$webProjName.csproj reference $dataProjName/$dataProjName.csproj
dotnet add $webProjName/$webProjName.csproj reference $utilityProjName/$utilityProjName.csproj
## Data - Add References
dotnet add $dataProjName/$dataProjName.csproj reference $modelProjName/$modelProjName.csproj


# ADD ORGANIZING FOLDERS / OTHER FILES
## Web - Add Files/Folders
mkdir -p $webProjName/wwwroot/images
cp $webProjName/Models/* $modelProjName
Remove-Item $webProjName/Models -Force -Recurse -Confirm:$false
cp ../templateResourceFiles/Program.cs $webProjName
cp ../templateResourceFiles/appsettings.json $webProjName
mkdir -p $webProjName/Areas/Admin
mkdir $webProjName/Areas/Admin/Controllers
mkdir $webProjName/Areas/Admin/Views
mkdir -p $webProjName/Areas/User
mkdir $webProjName/Areas/User/Controllers
mkdir $webProjName/Areas/User/Views
cp -r $webProjName/Views/Home $webProjName/Areas/User/Views
Remove-Item $webProjName/Views/Home -Force -Recurse -Confirm:$false
cp $webProjName/Controllers/HomeController.cs $webProjName/Areas/User/Controllers
Remove-Item $webProjName/Controllers -Force -Recurse -Confirm:$false
cp -r $webProjName/Data/Migrations $dataProjName
Remove-Item $webProjName/Data -Force -Recurse -Confirm:$false
## Data - Add Files/Folders
Remove-Item $dataProjName/Class1.cs -Force -Recurse -Confirm:$false
mkdir -p $dataProjName/Repository/IRepository
cp ../templateResourceFiles/IRepository.cs $dataProjName/Repository/IRepository/
cp ../templateResourceFiles/IUnitOfWork.cs $dataProjName/Repository/IRepository/
cp ../templateResourceFiles/UnitOfWork.cs $dataProjName/Repository/
cp ../templateResourceFiles/Repository.cs $dataProjName/Repository/
cp ../templateResourceFiles/ApplicationDbContext.cs $dataProjName
## Models - Add Files/Folders
Remove-Item $modelProjName/Class1.cs -Force -Recurse -Confirm:$false
## Utility - Add Files/Folders
Remove-Item $utilityProjName/Class1.cs -Force -Recurse -Confirm:$false

# TEXT REPLACEMENT IN TEMPLATE FILES
(Get-Content $dataProjName/Repository/IRepository/IRepository.cs).replace('<ProjectName>', $solutionName) | Set-Content $dataProjName/Repository/IRepository/IRepository.cs
(Get-Content $dataProjName/Repository/IRepository/IUnitOfWork.cs).replace('<ProjectName>', $solutionName) | Set-Content $dataProjName/Repository/IRepository/IUnitOfWork.cs
(Get-Content $dataProjName/Repository/Repository.cs).replace('<ProjectName>', $solutionName) | Set-Content $dataProjName/Repository/Repository.cs
(Get-Content $dataProjName/Repository/UnitOfWork.cs).replace('<ProjectName>', $solutionName) | Set-Content $dataProjName/Repository/UnitOfWork.cs
(Get-Content $dataProjName/ApplicationDbContext.cs).replace('<ProjectName>', $solutionName) | Set-Content $dataProjName/ApplicationDbContext.cs
(Get-Content $webProjName/Program.cs).replace('<ProjectName>', $solutionName) | Set-Content $webProjName/Program.cs
## For migrations that have been moved from mvc project to data project
$migrationPath = "$dataProjName/Migrations"
get-childitem $migrationPath -recurse -include *.cs |
ForEach-Object {
    (Get-Content $_).replace("Web.Data","Data") |
    Set-Content $_
}


# ADD BOOTSTRAP
## Add bootstrap css line before closing head
$fileName = "$webProjName/Views/Shared/_Layout.cshtml"
(Get-Content $fileName) | 
    Foreach-Object {
        if ($_ -match "</head>") 
        {
            #Add Lines before the selected pattern 
            "    $bootstrapCssLink"
        }
        $_ # send the current line to output
    } | Set-Content $fileName
## Add js line before "@await RenderSectionAsync"
$fileName = "$webProjName/Views/Shared/_Layout.cshtml"
(Get-Content $fileName) | 
    Foreach-Object {
        if ($_ -match "@await RenderSectionAsync") 
        {
            #Add Lines before the selected pattern 
            "    $bootstrapJsLink"
        }
        $_ # send the current line to output
    } | Set-Content $fileName