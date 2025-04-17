#Permet de construire sur la base du PRENOM + NOM + @suffixe l'adresse SMTP principale
#Puis supprimer l'ancienne. Enfin il l'ajoute l'ancienne en alias.
#Utilisation d'un CSV Obligatoire basÃ© sur "emailaddress"
############################
############################
# Output will be added to C:\temp folder. 
Start-Transcript -Path C:\temp\Add-SMTP-Address.log -Append
#ImportModule Exchange 2016 & AD
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn;
Import-Module ActiveDirectory -ErrorAction Stop

#Changez le SMTP pour correspondre Ã  votre domaine
$newdomainadd = "@domain.com"

#Requete et stockage des Proxyaddresses des comptes du CSV
$csv = Import-Csv "C:\Users\manu.LABS\Desktop\SMTP_to_smtp et ajouts nom_prenom domaine\users.csv" -Delimiter "," 
$csv | ForEach-Object {
    #Pour chaque user du CSV, requete de l'ensemble des attributs stockage dans la variable $user
        $emailaddress = $_.EmailAddress
        $User= Get-ADUser -Filter {mail -like $emailaddress} -properties *
        $sam= $User.samaccountname
        #Création des nouveaux attributs
    $Mail= $User.GivenName + "." + $User.SurName + "$newdomainAdd"
    $NewSmtp= "SMTP:" + $Mail
    $sam1= $User.samaccountname
    
                 #Si la proxy est la principale rentre dans la condition
            if($User.proxyAddresses -like "SMTP:*"){
                    #recupere la principale
                    $old=$User.EmailAddress
                    #Modifier le SMTP en smtp
                    $Replaced = "smtp:"+$old                 
                    Write-Host $old  "=> Suppression ancienne SMTP" -ForegroundColor Green
                    #Suppression de la ligne SMTP:
                    #set-ADUser -Identity $sam1 -Remove @{ProxyAddresses=$old}
                    $UserSMTP = $User.proxyAddresses -cmatch "SMTP*"
                    $Userminuscule =$UserSMTP.tolower()
                    Set-ADUser -Identity $sam1 -Remove @{proxyAddresses=$UserSMTP}
                    Write-Host $old  "=> Ajout ancienne smtp" -ForegroundColor Green
                    #Ajout de la ligne smtp:
                    set-ADUser -Identity $sam1 -Add @{ProxyAddresses=$Userminuscule}
                    Write-Host $Replaced  "=> Ajout nouvelle SMTP" -ForegroundColor Green
                    set-ADUser -Identity $sam1 -Add @{ProxyAddresses=$newsmtp}
                    Write-Host $mail  "=> Ajout nouvelle @mail" -ForegroundColor Green
                    set-ADUser -Identity $sam1 -EmailAddress $mail
                    #$sam1,$mail,$NewSmtp,$Old,$replaced
    Write-Host " > Traitement de $sam" -ForegroundColor Green
    }
        }
            

Stop-Transcript 
