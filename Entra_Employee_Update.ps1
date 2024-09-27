# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Import CSV file with user data
$users = Import-Csv -Path "C:\Users\DarrellMcMillon\OneDrive - NOVOS FiBER\Entra_HR_Updates.csv"

foreach ($user in $users) {
    $upn = $user.UserPrincipalName
    $jobTitle = $user.'Job Title'
    $hireDate = $user.'Employee Hire Date'
    $managerUpn = $user.ManagerUserPrincipalName
    $companyName = $user.'Company Name'
    $officeLocation = $user.'Office Location'

    # Get the user object
    $mgUser = Get-MgUser -UserId $upn

    # Get the manager object
    $manager = Get-MgUser -UserId $managerUpn

    # Manager Ref
    $ManagerRef = @{"@odata.id" = "https://graph.microsoft.com/v1.0/users/$managerUpn"}

    # Update user properties
    Update-MgUser -UserId $mgUser.Id -JobTitle $jobTitle -EmployeeHireDate $hireDate -CompanyName $companyName -OfficeLocation $officeLocation

    # Set the manager
    Set-MgUserManagerbyRef -UserId $mgUser.Id -BodyParameter $ManagerRef

    Write-Host "Updated user: $upn"
}

# Disconnect from Microsoft Graph
Disconnect-MgGraph