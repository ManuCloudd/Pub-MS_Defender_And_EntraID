# Start transcript
Start-Transcript -Path C:\Temp\Add-ADUsers.log -Append

# Import AD Module
Import-Module ActiveDirectory

# Import the data from CSV file and assign it to variable
$Users = Import-Csv "C:\Users\manu\Desktop\users.csv"

# Specify target group where the users will be added to
# You can add the distinguishedName of the group. 
$Group = "Full_F3" 

foreach ($User in $Users) {
    # Retrieve Alias (mailNickname)
    $mailNickname = $User.mailNickname

    # Retrieve mailNickname related SamAccountName
    $ADUser = Get-ADUser -Filter "mailNickname -eq '$mailNickname'" | Select-Object SamAccountName

    # User from CSV not in AD
    if ($ADUser -eq $null) {
        Write-Host "$mailNickname does not exist in AD" -ForegroundColor Red
    }
    else {
        # Retrieve AD user group membership
        $ExistingGroups = Get-ADPrincipalGroupMembership $ADUser.SamAccountName | Select-Object Name

        # User already member of group
        if ($ExistingGroups.Name -eq $Group) {
            Write-Host "$mailNickname already exists in $Group" -ForeGroundColor Yellow
        }
        else {
            # Add user to group
            Add-ADGroupMember -Identity $Group -Members $ADUser.SamAccountName 
            Write-Host "Added $mailNickname to $Group" -ForeGroundColor Green
        }
    }
}
Stop-Transcript