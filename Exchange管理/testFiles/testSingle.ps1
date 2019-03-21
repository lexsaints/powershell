$password=(ConvertTo-SecureString -AsPlainText "root1234" -Force) 
Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
   New-Mailbox 
   -Name 'zhangchuanlei' 
   -Alias 'zhangchuanlei' 
   -OrganizationalUnit 'lexzhang.com/Users' 
   -UserPrincipalName 'zhangchuanlei@lexzhang.com' 
   -SamAccountName 'zhangchuanlei' 
   -FirstName 'chuanlei' 
   -Initials 'zcl' 
   -LastName 'zhang' 
   -Password $password 
   -ResetPasswordOnNextLogon $true 
   -Database 'WIN-96VYFIEYNCA\First Storage Group\Mailbox Database'
   set-mailbox 
   -EmailAddressPolicyEnabled $false
   set-user 
   -Department '昆明海关'