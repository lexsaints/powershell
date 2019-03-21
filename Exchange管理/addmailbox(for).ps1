$Contents=Import-Csv C:\mailbox.csv  #将CSV文件中内容导入，,赋值给变量为了利用数组进行逐个读取;
$Database="WIN-96VYFIEYNCA\First Storage Group\Mailbox Database"
$password=(ConvertTo-SecureString -AsPlainText "fl2x3@c" -Force)
$password="fl2x3@c"
#用for 循环，逐个读取，CSV和EXCEL 类似，我们取对应的Server，Username，Password 三个栏位的值.
for ($i=0;$i -le 2;$i++){
#$Server=$Contents.Server[$i]
$Password=(ConvertTo-SecureString -AsPlainText $Contents.Password[$i] -Force)
$pass=$Contents.Password[$i]
New-Mailbox -Name $Contents.Name[$i] -FirstName $Contents.FirstName[$i] -LastName $Contents.LastName[$i] -Alias $Contents.Alias[$i] -UserPrincipalName $Contents.UserPrincipalName[$i] -Password $Password -OrganizationalUnit $Contents.OrganizationalUnit[$i] -Database 'WIN-96VYFIEYNCA\First Storage Group\Mailbox Database'
-Department '部门' -Company '昆明海关'
#Write-Host "The $i line Servername is $pass"
}