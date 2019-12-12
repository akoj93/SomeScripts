
#Osäker på om detta behöver vara ett eget script. Men det får agera minneslapp så länge.
#x är hur långt lösenordet kommer bli.
#y är hur många non alfanumeriska som lösen kommer använda. Ju högre siffra desto fler specialtecken.

param(
    [Parameter(mandatory=$true)]
    [string]$leng,
    [Parameter(mandatory=$true)]
    [string]$alfa
)
[system.web.security.membership]::GeneratePassword($leng,$alfa)