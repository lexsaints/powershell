$Contents=Import-Csv C:\mailbox.csv  #��CSV�ļ������ݵ��룬,��ֵ������Ϊ������������������ȡ;
$Database="WIN-96VYFIEYNCA\First Storage Group\Mailbox Database"
$password=(ConvertTo-SecureString -AsPlainText "fl2x3@c" -Force)
$password="fl2x3@c"
#��for ѭ���������ȡ��CSV��EXCEL ���ƣ�����ȡ��Ӧ��Server��Username��Password ������λ��ֵ.
for ($i=0;$i -le 2;$i++){
#$Server=$Contents.Server[$i]
$Password=(ConvertTo-SecureString -AsPlainText $Contents.Password[$i] -Force)
$pass=$Contents.Password[$i]
New-Mailbox -Name $Contents.Name[$i] -FirstName $Contents.FirstName[$i] -LastName $Contents.LastName[$i] -Alias $Contents.Alias[$i] -UserPrincipalName $Contents.UserPrincipalName[$i] -Password $Password -OrganizationalUnit $Contents.OrganizationalUnit[$i] -Database 'WIN-96VYFIEYNCA\First Storage Group\Mailbox Database'
-Department '����' -Company '��������'
#Write-Host "The $i line Servername is $pass"
}