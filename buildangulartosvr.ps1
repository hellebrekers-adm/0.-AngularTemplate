echo " Welcome to the hellebrekers build"
echo ""
echo "
##     ## ######## ##       ##       ######## ########  ########  ######## ##    ## ######## ########   ######
##     ## ##       ##       ##       ##       ##     ## ##     ## ##       ##   ##  ##       ##     ## ##    ##
##     ## ##       ##       ##       ##       ##     ## ##     ## ##       ##  ##   ##       ##     ## ##
######### ######   ##       ##       ######   ########  ########  ######   #####    ######   ########   ######
##     ## ##       ##       ##       ##       ##     ## ##   ##   ##       ##  ##   ##       ##   ##         ##
##     ## ##       ##       ##       ##       ##     ## ##    ##  ##       ##   ##  ##       ##    ##  ##    ##
##     ## ######## ######## ######## ######## ########  ##     ## ######## ##    ## ######## ##     ##  ######
"

$mypath = $PSScriptRoot

$config = (Get-Content ($mypath + "\configbuild.json") | ConvertFrom-Json)
$buildPath = $config.PSObject.Properties.Value

#print buildpat
echo "Buildpath: " $buildPath

#((Get-Content($mypath + "\src\enviroments\angular-enviroment.ts")) -replace "public static isBuildForBusinessCentral = false;", "public static isBuildForBusinessCentral = true;" | Set-Content -Path ($mypath + "\src\enviroments\angular-enviroment.ts"));
#set global build for bc var
(Get-Content ($mypath + "\src\enviroments\angular-enviroment.ts")).replace('public static isBuildForBusinessCentral = false;', 'public static isBuildForBusinessCentral = true;') | Set-Content ($mypath + "\src\enviroments\angular-enviroment.ts")

#build angular project
ng build --output-hashing=none

#reset global build for bc var
(Get-Content ($mypath + "\src\enviroments\angular-enviroment.ts")).replace('public static isBuildForBusinessCentral = true;', 'public static isBuildForBusinessCentral = false;') | Set-Content ($mypath + "\src\enviroments\angular-enviroment.ts")

#get the data from the json config
$jsonContent = Get-Content ($mypath + "\package.json")

# Convert the JSON content to a PowerShell object
$jsonObject = $jsonContent | ConvertFrom-Json

# Extract and display the property names

# Extract the project names from the JSON content
$distPath = $myPath + '/dist/' + $jsonObject.PSObject.Properties.Value[0]

echo "distpath: " $distPath

#set this in the future in an ini file
$destination_js = $buildPath + 'js'
$destination_style = $buildPath + 'style'

# if the destination folder does not already exist, create it
if (!(Test-Path -Path $destination_js -PathType Container)) {
    $null = New-Item -Path $destination_js -ItemType Directory
}

# if the destination folder does not already exist, create it
if (!(Test-Path -Path $destination_style -PathType Container)) {
    $null = New-Item -Path $destination_style -ItemType Directory
}

#copy files
Get-ChildItem -Path $distPath -Filter '*.js' -File -Recurse | ForEach-Object {
    #$newName = '{0}_{1}_{2}' -f $_.Directory.Parent.Name, $_.Directory.Name, $_.Name
    $_ | Copy-Item -Destination (Join-Path -Path $destination_js -ChildPath $_.Name)
}

Get-ChildItem -Path $distPath -Filter '*.css' -File -Recurse | ForEach-Object {
    #$newName = '{0}_{1}_{2}' -f $_.Directory.Parent.Name, $_.Directory.Name, $_.Name
    $_ | Copy-Item -Destination (Join-Path -Path $destination_style -ChildPath $_.Name)
}
