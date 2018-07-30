$Password= (convertto-securestring 'root1234' -asplaintext -force)
$OUPath ="OU=testOu2,DC=lexzhang,DC=com"
function Addmailbox {
   Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
   Write-Host -ForegroundColor yellow Creating user - ($_.split(','))[0]
   #先新建邮箱 New-Mailbox
  New-Mailbox -Name ($_.split(","))[0] -FirstName ($_.split(","))[0] -LastName ($_.split(","))[0] -Alias ($_.split(","))[0] -UserPrincipalName ($_.split(","))[3] -Password $Password -ResetPasswordOnNextLogon $true -OrganizationalUnit $OUPath -Database 'WIN-96VYFIEYNCA\First Storage Group\Mailbox Database'
  #设置邮箱信息 Set-Mailbox
   set-mailbox -identity ($_.split(","))[1] -PrimarySmtpAddress ($_.split(","))[3] -EmailAddressPolicyEnabled $false
   #设置域用户信息
   set-user -identity ($_.split(","))[1] -Department ($_.split(","))[4] -Company 'Kmcustoms'
}
gc .\mb.csv | foreach {Addmailbox}