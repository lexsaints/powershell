#默认密码(可以单独设置)
$Password= (convertto-securestring 'root1234' -asplaintext -force)
#域路径(Users路径 ："CN=Users,DC=lexzhang,DC=com")
$OUPath ="lexzhang.com/Users"  #"OU=testOu2,DC=lexzhang,DC=com" 
#邮箱后缀
$mailBack="@lexzhang.com"
#邮件数据库
$Database ="WIN-96VYFIEYNCA\First Storage Group\Mailbox Database"
#substring(0,4):起始索引,长度;没有长度参数,显示起始索引后所有
#每条命令内,各个参数不允许换行，否则会被识别为一条单独的命令(每行一条命令)
function Addmailbox {
   Write-Host -ForegroundColor yellow Creating user - ($_.split(','))[0]
   #开启exchange邮箱命令(以下为07版,其他版本查阅笔记)
   Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
   #先新建邮箱 New-Mailbox(里面的参数为邮箱中的参数)
   New-Mailbox -Name ($_.split(","))[1] -FirstName (($_.split(","))[1]).substring(1) -LastName (($_.split(","))[1]).substring(0,1) -Alias ($_.split(","))[0] -UserPrincipalName ((($_.split(","))[0])+$mailBack).replace(" ","") -Password $Password -ResetPasswordOnNextLogon $true -OrganizationalUnit $OUPath -Database $Database
  #设置邮箱信息 Set-Mailbox
   set-mailbox -identity ($_.split(","))[0] -PrimarySmtpAddress ((($_.split(","))[0])+$mailBack).replace(" ","") -EmailAddressPolicyEnabled $false
   #设置域用户信息(里面设置的参数 为域账号中的参数)
   set-user -identity ($_.split(","))[0] -Department ($_.split(","))[3] -Company ($_.split(","))[4] 
   #set-aduser -description ($_.split(","))[3]
}
gc .\newmb.csv | foreach {Addmailbox}
