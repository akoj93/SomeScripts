<#
.Synopsis
Script som hanterar noteshred
.Description
Detta scriptet använder inga Set kommandon utan är bara Get kommandon för att hämta information.
Just nu matar den ut lösenord och annan information i konsolen för felsökning. Det kommer försvinna.
.Parameter api_key
This is your noteshred api key. You can find your api key in your noteshred settings (https://www.noteshred.com/users/edit)
.Parameter noteTitle
Detta är namnet på din anteckning
.Parameter noteContent
Detta är innehållet. Vill man ha en linebreak i sitt meddelande så får man skriva `n. Detta gör att man får en ny line.
.Parameter noteHint
This is a small hint to what the password for the note might be. Not mandatory.
.Parameter notePassword
Detta är lösenordet som anändaren måste skriva in för att kunna öppna din note.
.Parameter noteShareMail
Use this if you want to share your note to a users email etc. They will recieve a email with the link to the note and the -noteComments note.
.Parameter noteComments
This is the small hint to what the note contains to your user that you share your note to.
.Example
Såhär ser det ut än så länge.
noteshred.ps1 -api_key abc123thisismyapikeyabc123 -noteTitle "awesometitle" -noteContent "secretPASSWORD123!" -notePassword "Grisgurka123!"
.Example
.\noteshred.ps1 -api_key abc123 -noteTitle "this is your note" -noteContent "firstline`nsecondline`nyou get the point" -notePassword PazzW0rd -noteHint "Do you remember mars?" -noteShareMail shareto@mail.org -noteComments "this note contains x password."
.notes
Written by Anders and Erik
#>

param(
    [Parameter(mandatory=$true)]
    [string]$api_key,
    [Parameter(mandatory=$true)]
    [string]$noteTitle,
    [Parameter(mandatory=$true)]
    [String]$noteContent,
    [String]$noteHint,
    [ValidateLength(8,30)]
    [Parameter(mandatory=$true)]
    [String]$notePassword,
    [String]$noteShareMail,
    [String]$noteComments
)

$url = 'https://api.noteshred.com/v1/notes'
$header = @{'Authorization'= 'Token token=' + $api_key}

#detta är body för att skapa en note
$body = @{
    title = $noteTitle;
    shred_method = 1;
    hint = $noteHint;
    password = $notePassword;
    content = $noteContent
  }
  # Här skickas det via automagi upp i molnet.
  $result = Invoke-WebRequest -Uri $url -Method 'Post' -Headers $header -Body $body
  $result = $result | ConvertFrom-Json

  # Detta kan tas bort när scriptet är igång på riktigt.
  Write-Host "-T-E-S-T-O-U-T-P-U-T--"
  Write-Host "title:    "$result.title
  Write-Host "url:      "$result.url
  Write-Host "password: "$notePassword
  Write-Host "sharemail:"$noteShareMail
  Write-Host "----------------------"

  # Här skickas din note vidare om den skall delas.
  $shareurl = 'https://api.noteshred.com/v1/notes/'+$result.token + '/share'
  $sharebody = @{
    dest_email = $noteShareMail;
    password = $notePassword;
    comments = $noteComments
}
# Här delas din note om du delat en mail.
$result = Invoke-WebRequest -Uri $shareurl -Method 'Post' -Headers $header -Body $sharebody

  