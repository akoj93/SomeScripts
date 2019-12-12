<#
.Synopsis
Ett script som hämtar rättigheter för kalendern på en användare.
.Description
Detta scriptet använder inga Set kommandon utan är bara Get kommandon för att hämta information
.Parameter SrcUser
Detta är användaren som du vill ha ut information om.
.Parameter Userbox
Detta är vilken del av användaren som du vill ha ut information om. Antingen en kalender eller en maillåda.
.Example
testscript -SrcUser grit -Userbox Kalender
#>

param(
    [Parameter(mandatory=$true)]
    [string[]]$SrcUser,
    [String[]]$Userbox
)
  
Import-Module MSOnline
$o365cred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://ps.outlook.com/powershell/ -Credential $o365Cred -Authentication Basic –AllowRedirection
Get-MailboxFolderPermission $SrcUser${:\}$Userbox
Remove-PSSession $session
