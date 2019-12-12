
#Detta scriptet skulle man kunna göra ner till ett enda script istället för att ha det uppdelat. Men nu är det dev och jag vill leva galet.
#Vet inte om texten som är i noten är bra heller. Skrev något bara.

#får man inte unicode i sin output så kan man kolla här. Skall automatisera detta tänkte jag.
#https://stackoverflow.com/questions/57131654/using-utf-8-encoding-chcp-65001-in-command-prompt-windows-powershell-window/57134096#57134096

#Detta kommer komma in i framtida fönster. Man kan inte sätta en enviroment variabel i samma fönster som man vill använda den. Men man kan även sätta $env:FOO = BAR om man vill sätta den i current.
#[System.Environment]::SetEnvironmentVariable('FOO', 'BAR', 'User')

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath

#som en variabel för jag vet inte hur jag tänker om en vecka.
$envname = "NOTESHREDAPIKEY"
if (-not (Test-Path Env:NOTESHREDAPIKEY)) {
    $envdata = Read-Host -Prompt "No API key found. Please enter your API key and make sure it's correct before pressing enter"
    #Detta lägger till nyckeln till användarens env vars. Kommer inte appliceras på denna processen men kommer appliceras på framtida sessioner.
    [System.Environment]::SetEnvironmentVariable($envname, $envdata, 'User')
    #appliceras på denna processen så man slipper starta om scriptet.
    [System.Environment]::SetEnvironmentVariable($envname, $envdata, 'Process')
    Write-Host "Added the API key: $Env:NOTESHREDAPIKEY to the user $env:USERNAME"
}

#Denna skulle man kunna flytta från eget script in då den är så kort i det andra scriptet.
$pass = .$dir\pwgen -leng 15 -alfa 0
$title = Read-Host -Prompt "Skriv in ditt ärendenummer"
$username = Read-Host -Prompt "Skriv in användarens användarnamn"
$userpass = Read-Host -Prompt "Skriv in användarens nya lösenord"
$content = "Hej,`nHär kommer uppgifterna till din nya användare.`n`nAnvändarnamn: "+$username+"`nLösenord: "+$userpass+"`n`nTänk på att du bara kan visa denna anteckningen en gång. Så spara ner uppgifterna på ett säkert ställe.`n`nSkulle du ha några problem kan du kontakta oss på servicedesk@bmoreit.se så hjälper vi dig."
$hint = "Kom ihåg att du bara kan öppna denna en gång."
#Denna vill jag ha separat fortfarande.
.$dir\noteshred.ps1 -api_key $Env:NOTESHREDAPIKEY -noteTitle $title -noteContent $content -notePassword $pass -noteHint $hint -noteShareMail $mail -noteComments $comment


