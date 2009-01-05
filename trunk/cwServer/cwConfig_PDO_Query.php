<?php
/* 	数据库连接参数	*/
$dbms='mysql';    	//数据库类型 Oracle 用ODI
$host='localhost';		//数据库主机名
$dbName='amfphp';   	//使用的数据库
$user='root';     		//数据库连接用户名
$pass='root';         	//对应的密码
$dsn="$dbms:host=$host;dbname=$dbName";

/*	配置参数变量	*/
$circleoid ="";
$circlecx = 0;
$circlecy = 0;

$circlexml = "";
$svgxml ="";

try{
	/*	初始化一个PDO对象，就是创建了数据库连接对象	*/
	$dbh=new PDO($dsn,$user,$pass);
	//echo "连接成功<br/>";	//调试用途

	/*	从传入参数获得查询条件	*/
	$oid =$_REQUEST["oid"];
	
	/*	拼装SQL语句			*/
	$sql = "SELECT oid,cx,cy from gis where oid='" . $oid . "'";	//有查询条件
	$sqlall = "SELECT oid,cx,cy from gis";				//无查询条件

	foreach($dbh->query($sql) as $row)
	{
		//print_r($row);	//调试用途
		$circleoid = $row[oid];
		$circlecx = $row[cx];
		$circlecy = $row[cy];
		
		//生成课件浏览器端需要的xml文件
		$circlexml = "<circle id='". $circleoid ."' cx='". $circlecx ."' cy='" . $circlecy ."' r='10' fill='#FFFFFF' stroke='#000000' />";
		//拼装全部的XML定义
		$svgxml = $svgxml . $circlexml;	
	}
	
	//输出给浏览器端的内容
	echo $configXML;
   
	// 释放PHP的数据库连接，即此处清空后Oracle OCI8驱动客户端会重用连接
	$dbh=null;
}catch(PDOException $e){
	//显示数据库操作错误信息
	die("Error!: ".$e->getMessage()."<br/>");
}


/*	help
	采用PHP PDO开发，支持数据库无关性，
	连接不同数据库只需修改dbms,可能的值有mysql/odi/mssql/postsql/odbc等
	默认这个不是长连接，如果需要数据库长连接，需要最后加一个参数：array(PDO::ATTR_PERSISTENT => true) 变成这样：
	$db=new PDO($dsn,$user,$pass,array(PDO::ATTR_PERSISTENT=>true));
	测试：
		http://localhost/chd/DGGeo_PDO.php
		http://loclahost/chd/DBGeo_PDO.php?oid=1
		故意设置错误的数据连接参数或sql语句，测试数据库错误消息处理
	Flex中如何使用：
		Flex中获得的文本来自echo的输出
		绝对路径	http://localhost/chd/DGGeo_PDO.php
		相对路径	DGGeo_PDO.php(swf文件在同一个目录)
*/
?>