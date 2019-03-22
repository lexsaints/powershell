#数据库登录信息
$Database	= 'DBNAME'
$Table		='T_NAME'
$Server		= '192.168.0.101'
$UserName	= 'user'
$Password = 'password'
#获取当前时间
$CurrentDateTime= $(Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
$SqlConn = New-Object System.Data.SqlClient.SqlConnection
$SqlConn.ConnectionString = "Data Source=$Server;Initial Catalog=$Database;user id=$UserName;pwd=$Password"
#创建数据库连接
$SqlConn.open()
#创建数据库命令
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.connection = $SqlConn
#执行SQL语句
$SqlCmd.CommandText = 'DELETE FROM '+$Table
$SqlCmd.executenonquery()
#关闭数据库连接
$SqlConn.close()