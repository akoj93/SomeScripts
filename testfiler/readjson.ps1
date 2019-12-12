#detta är för att man skall få en hård länk till vart scriptet körs ifrån.
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
#Här importeras jsonh
$jsonfile = Get-Content -Raw -Path $dir\demo.json | ConvertFrom-Json
#detta kall konverteras till 
$enhet = "enhet2"
$givenname = "Test"
$surname = "Testsson" 
Write-Host $givenname
Write-Host $surname
 Invoke-Command -ComputerName $jsonfile.config.servername -ArgumentList $jsonfile.enheter.$enhet.groups,$givenname,$surname,$jsonfile.enheter.$enhet.upnsuffix,$jsonfile.enheter.$enhet.path -ScriptBlock{

    $creationloop = $true

    $prenum

    while($creationloop){

        $name = $args[1]+" "+$args[2]+$prenum
        $samname = $args[1].Substring(0,2).ToLower()+$args[2].Substring(0,2).ToLower()+$prenum
        $upn = $args[1].ToLower()+"."+$args[2].ToLower()+$prenum+"@"+$args[3]


        $usercheck = Get-ADUser -Filter {sAMAccountName -eq $samname}
        If ($usercheck -eq $null) {
            Write-Host "User $samname does not exist. Creating new user."

            New-ADUser -Name $name -DisplayName $name -GivenName $args[1] -Surname $args[2] -SamAccountName $samname -Path $args[4] -UserPrincipalName $upn
            Add-ADPrincipalGroupMembership -Identity $samname -MemberOf $args[0]
            $creationloop = $false
        }
        #Här skall konflikthanteringen hamna. Kommer lägga på en siffra på slutet för att det är smidigt. Måste kolla hur man skall hantera email adresser. kan inte finnas 
        #två st bo.lonn@ljurs.se
        else {
            Write-Host "User $samname already exist. I'm adding a number to the username."
            $prenum++
        }
    }
}