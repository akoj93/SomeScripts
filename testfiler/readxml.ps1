$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
$config = "$dir\demo.xml"
Write-Host $config
[XML]$xml = Get-Content $config
$enhet = "goteborg"
$xml.root.enheter.$enhet.path
$xml.root.enheter.$enhet.groups
$xml.root.enheter.$enhet.upnsuffix

Invoke-Command -ComputerName dc01 -ScriptBlock{
   # New-ADUser -name $name -DisplayName $name -GivenName $givenname -Surname $surname -SamAccountName $samname -Path $xml.root.enheter.$enhet.path -UserPrincipalName $samname@$xml.root.enheter.$enhet.upnsuffix
    # Add-ADPrincipalGroupMembership -Identity testes -MemberOf @$xml.root.enheter.$enhet.groups -whatif
}
