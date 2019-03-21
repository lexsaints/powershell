  #默认密码(可以单独设置)
  $Password= (convertto-securestring '123456' -asplaintext -force)
  #域路径(Users路径 ："CN=Users,DC=lexzhang,DC=com"或者"lexzhang.com/Users")
  $OUPath ="OU=test,DC=saints,DC=com"
  #邮箱后缀
  #$mailBack="@saints.com" 
  #邮件数据库(由于有两个数据库,代码中进行均匀分配)
  #$Database ="saintsfc"#kmmaildb01/kmmaildb02(分开存储)
  #substring(0,4):起始索引,长度;没有长度参数,显示起始索引后所有
  #每条命令内,各个参数不允许换行，否则会被识别为一条单独的命令(每行一条命令)
 
  #开启exchange邮箱命令(以下为07版)
  #Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin
  #exchange2010
  #Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010
  #每次执行操作之前,记录一条当前时间信息 插入log.txt
  $(Get-Date).ToString() | Out-File -FilePath C:\log.txt -Append
  #newmb.csv与ps1脚本放在同一目录下,或者使用绝对路径
  $all=gc .\mb_gc.csv
  #执行失败人员csv的表头行
  $all[0] | out-file -filepath C:\left.csv -EnCoding utf8 -append
  #循环从第2行开始,第一行为表头,注意索引
  for($i=1;$i -le $all.length-1;$i++)
  {
   Write-Host -ForegroundColor yellow Creating user - $all[$i].split(',')[0]
   #先新建邮箱 New-Mailbox(里面的参数为邮箱中的参数)
   $UserAccount=get-aduser -identity ($all[$i].split(","))[0] -ErrorAction "SilentlyContinue"
   if($?){
	 #查询正常,域中已存在该账号:执行修改操作,为该域账号设置邮箱地址
	 $log=$UserAccount[0].RecipientType.tostring()+" "+($all[$i].split(","))[0]+" AlreadyExists! 添加失败"
	 write-host $log
     $log | Out-File -FilePath C:\log.txt -Append
	 #添加失败的账号,按原格式输出至csv文件,便于修改后 继续执行;注意encoding格式utf8
	 
	 $all[$i] | out-file -filepath C:\left.csv -EnCoding utf8 -append
	 #($UserAccount.RecipientType ($all[$i].split(","))[0] "already exists") | Out-File -FilePath C:\hints.txt -Append 
   }else{
     #设置域用户信息(里面设置的参数 为域账号中的参数)
     #set-user -identity ($all[$i].split(","))[0] -Department ($all[$i].split(","))[3] -Company ($all[$i].split(","))[4] 
     #使用set-aduser命令,通过唯一标识identity,确定用户,修改用户description[显示部门信息]
     new-aduser -name ($all[$i].split(","))[0] -UserPrincipalName ($all[$i].split(","))[0]+"@kmc.intra.customs.gov.cn" -AccountPassword $Password -DisplayName ($all[$i].split(","))[1] -Department ($all[$i].split(","))[3] -Company ($all[$i].split(","))[4] -Description ($all[$i].split(","))[3] -Path $OUPath -ChangePasswordAtLogon $true -PasswordNeverExpires $true -enabled $true
	 
	 #注意：UserPrincipalName 后面必须加上后缀 @lexzhang.com 这种，否则不行
   }
}

