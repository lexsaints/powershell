#Ĭ������(���Ե�������)
$Password= (convertto-securestring 'root1234' -asplaintext -force)
#��·��(Users·�� ��"CN=Users,DC=lexzhang,DC=com")
$OUPath ="lexzhang.com/Users"  #"OU=testOu2,DC=lexzhang,DC=com" 
#�����׺
$mailBack="@lexzhang.com"
#�ʼ����ݿ�
$Database ="WIN-96VYFIEYNCA\First Storage Group\Mailbox Database"
#substring(0,4):��ʼ����,����;û�г��Ȳ���,��ʾ��ʼ����������
#ÿ��������,���������������У�����ᱻʶ��Ϊһ������������(ÿ��һ������)
function Addmailbox {
   Write-Host -ForegroundColor yellow Creating user - ($_.split(','))[0]
   #����exchange��������(����Ϊ07��,�����汾���ıʼ�)
   Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
   #���½����� New-Mailbox(����Ĳ���Ϊ�����еĲ���)
   New-Mailbox -Name ($_.split(","))[1] -FirstName (($_.split(","))[1]).substring(1) -LastName (($_.split(","))[1]).substring(0,1) -Alias ($_.split(","))[0] -UserPrincipalName ((($_.split(","))[0])+$mailBack).replace(" ","") -Password $Password -ResetPasswordOnNextLogon $true -OrganizationalUnit $OUPath -Database $Database
  #����������Ϣ Set-Mailbox
   set-mailbox -identity ($_.split(","))[0] -PrimarySmtpAddress ((($_.split(","))[0])+$mailBack).replace(" ","") -EmailAddressPolicyEnabled $false
   #�������û���Ϣ(�������õĲ��� Ϊ���˺��еĲ���)
   set-user -identity ($_.split(","))[0] -Department ($_.split(","))[3] -Company ($_.split(","))[4] 
   #set-aduser -description ($_.split(","))[3]
}
gc .\newmb.csv | foreach {Addmailbox}
