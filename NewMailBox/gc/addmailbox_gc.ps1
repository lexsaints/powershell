  #Ĭ������(���Ե�������)
  $Password= (convertto-securestring 'root1234' -asplaintext -force)
  #��·��(Users·�� ��"CN=Users,DC=lexzhang,DC=com"����"lexzhang.com/Users")
  $OUPath ="OU=test,DC=saints,DC=com" 
  #�����׺
  $mailBack="@saints.com" #@kmc.intra.customs.gov.cn
  #�ʼ����ݿ�(�������������ݿ�,�����н��о��ȷ���)
  $Database ="saintsfc"#kmmaildb01/kmmaildb02(�ֿ��洢)
  #substring(0,4):��ʼ����,����;û�г��Ȳ���,��ʾ��ʼ����������
  #ÿ��������,���������������У�����ᱻʶ��Ϊһ������������(ÿ��һ������)
  
  
  #����exchange��������(����Ϊ07��)
  #Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
  #exchange2010
  Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010
  #ÿ��ִ�в���֮ǰ,��¼һ����ǰʱ����Ϣ ����log.txt
  $(Get-Date).ToString() | Out-File -FilePath C:\log.txt -Append
  #newmb.csv��ps1�ű�����ͬһĿ¼��,����ʹ�þ���·��
  $all=gc .\mb_gc.csv
  #ִ��ʧ����Աcsv�ı�ͷ��
  $all[0] | out-file -filepath C:\left.csv -EnCoding default -append
  #ѭ���ӵ�2�п�ʼ,��һ��Ϊ��ͷ,ע������
  for($i=1;$i -le $all.length-1;$i++)
  {
   Write-Host -ForegroundColor yellow Creating user - $all[$i].split(',')[0]
   #���½����� New-Mailbox(����Ĳ���Ϊ�����еĲ���)
   $UserAccount=get-user -identity ($all[$i].split(","))[0] -ErrorAction "SilentlyContinue"
   if($?){
	 #��ѯ����,�����Ѵ��ڸ��˺�:ִ���޸Ĳ���,Ϊ�����˺����������ַ
	 $log=$UserAccount[0].RecipientType.tostring()+" "+($all[$i].split(","))[0]+" AlreadyExists! ���ʧ��"
	 write-host $log
     $log | Out-File -FilePath C:\log.txt -Append
	 #���ʧ�ܵ��˺�,��ԭ��ʽ�����csv�ļ�,�����޸ĺ� ����ִ��;ע��encoding��ʽutf8
	 
	 $all[$i] | out-file -filepath C:\left.csv -EnCoding default -append
	 #($UserAccount.RecipientType ($all[$i].split(","))[0] "already exists") | Out-File -FilePath C:\hints.txt -Append 
   }else{
		#�����������ݿ����
	   if(($i%2) -eq 1){
			$Database ="saintsfc"#kmmaildb01
	   }else{
			$Database ="saintsfc"#kmmaildb02
	   }
	 #��ѯ�쳣,�����޸��˺�:ִ�������Ĳ������
	 New-Mailbox -Name ($all[$i].split(","))[1] -FirstName (($all[$i].split(","))[1]).substring(1) -LastName (($all[$i].split(","))[1]).substring(0,1) -Alias ($all[$i].split(","))[0] -UserPrincipalName ((($all[$i].split(","))[0])+$mailBack).replace(" ","") -Password $Password -OrganizationalUnit $OUPath -Database $Database
     #����������Ϣ Set-Mailbox
     set-mailbox -identity ($all[$i].split(","))[0] -PrimarySmtpAddress ((($all[$i].split(","))[0])+$mailBack).replace(" ","") -EmailAddressPolicyEnabled $false
     #�������û���Ϣ(�������õĲ��� Ϊ���˺��еĲ���)
     #set-user -identity ($all[$i].split(","))[0] -Department ($all[$i].split(","))[3] -Company ($all[$i].split(","))[4] 
     #ʹ��set-aduser����,ͨ��Ψһ��ʶidentity,ȷ���û�,�޸��û�description[��ʾ������Ϣ]
     set-aduser -identity ($all[$i].split(","))[0] -Department ($all[$i].split(","))[3] -Company ($all[$i].split(","))[4] -Description ($all[$i].split(","))[3] -ChangePasswordAtLogon $false -PasswordNeverExpires $false 
   }
}

