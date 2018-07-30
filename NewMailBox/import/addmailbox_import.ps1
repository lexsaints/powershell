#开启exchange邮箱命令(以下为07版)
   Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
#exchange2010
   #Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010
#默认密码(可以单独设置)
$Password= (convertto-securestring 'root1234' -asplaintext -force)
#域路径(Users路径 ："CN=Users,DC=lexzhang,DC=com"或者"lexzhang.com/Users")
$OUPath ="OU=testOu2,DC=lexzhang,DC=com" #kmc.intra.customs.gov.cn/Users
#邮箱后缀
$mailBack="@lexzhang.com" #@kmc.intra.customs.gov.cn
#邮件数据库
$Database ="WIN-96VYFIEYNCA\First Storage Group\Mailbox Database"#kmmaildb01/kmmaildb02(分开存储)
$count=1
#substring(0,4):起始索引,长度;没有长度参数,显示起始索引后所有
#每条命令内,各个参数不允许换行，否则会被识别为一条单独的命令(每行一条命令)
#每次执行操作之前,记录一条当前时间信息 插入log.txt
$(Get-Date).ToString() | Out-File -FilePath C:\log.txt -Append
$groups=import-csv 'C:\mb_import.csv' -encoding default
  foreach($group in $groups){
   Write-Host -ForegroundColor yellow Creating user - $group.account 
   #先新建邮箱 New-Mailbox(里面的参数为邮箱中的参数)
   $UserAccount=get-user -identity $group.account -ErrorAction "SilentlyContinue"
   if($?){
	 #查询正常,域中已存在该account:执行修改操作,为该域account设置邮箱地址
	 $log=$UserAccount[0].RecipientType.tostring()+" "+$group.account+"AlreadyExists!失败"
	 write-host $log
     $log | Out-File -FilePath C:\log.txt -Append
	 #添加失败的account,按原格式输出至csv文件,便于修改后 继续执行;注意encoding格式default utf8
	 $group | out-file -filepath C:\left.csv -EnCoding default -append
   }else{
   
	   <#
	   $count++
	   if(($count%2) -eq 1){
			write-host $count "1"
	   }else{
			write-host $count "0"
	   }
	   #>
	 #查询异常,域中无该account:执行正常的插入操作
	 New-Mailbox -Name $group.name -FirstName $group.name.substring(1) -LastName $group.name.substring(0,1) -Alias $group.account -UserPrincipalName ($group.account+$mailBack).replace(" ","") -Password $Password -OrganizationalUnit $OUPath -Database $Database
   #设置邮箱信息 Set-Mailbox
   set-mailbox -identity $group.account -PrimarySmtpAddress ($group.account+$mailBack).replace(" ","") -EmailAddressPolicyEnabled $false
   #设置域用户信息(里面设置的参数 为域account中的参数)
   set-user -identity $group.account -Department $group.department -Company $group.company
   #使用set-aduser命令,通过唯一标识identity,确定用户,修改用户description[显示department信息]
   #set-aduser -identity $group.account -Department $group.department -Company $group.company -Description $group.department
   }
 }
