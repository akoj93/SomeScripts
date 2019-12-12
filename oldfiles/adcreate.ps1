$adpath = "OU=test,OU=Users,OU=contoso,DC=contoso,DC=local"
#Invoke-Command -ComputerName DC01 -ScriptBlock {Get-ADUser -Filter 'SamAccountName -like "testes"'}
#förbättring och uppstädning https://social.technet.microsoft.com/Forums/en-US/1898d6ba-6402-4063-907a-186f6250a0e4/pass-a-local-variable-to-a-remote-session-using-the-invokecommand-cmdlet?forum=winserverpowershell
#Skriva en config med xml https://stackoverflow.com/questions/54036380/how-to-get-variables-from-config-file-in-powershell


invoke-command -ComputerName DC01 -ScriptBlock{
    $adpath = "OU=test,OU=Users,OU=contoso,DC=contoso,DC=local"
    $givenname = "Mikael"
    $surname = "abc" 
    $name = "$givenname $surname"
    #just nu bygger namname på att man har minst 3 bokstäver i efternamnet.
    #Vissa kunder har fornamn.efternamn. Då måste vi komma på en regel som kan korta ner namnet på ett fair sätt. Man kan inte ha fler än 19 chars.
    $samname = $givenname.Substring(0,3).ToLower()+$surname.Substring(0,3).ToLower()
    
#Invoke-Command -ComputerName dc01 -ScriptBlock{Add-ADPrincipalGroupMembership -Identity testes -MemberOf testgroup1}

    #Tydligen så populerar -UserPrincipalName user logon name. Vill man ha suffixet lägger man till det. testsson@contoso.se så får den rätt suffix. Saknas suffixet så skapar den suffixet....

    New-ADUser -name $name -DisplayName $name -GivenName $givenname -Surname $surname -SamAccountName $samname -Path $adpath -UserPrincipalName "$samname@contoso.se"
    # -whatif
}
