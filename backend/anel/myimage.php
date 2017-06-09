<?php

$conn = mysql_connect("localhost", "root", "") or die ("Unable to connect to MySQL<br>");
$db = mysql_select_db("phonebook_almaty") or die ("Could not select database<br>");
mysql_query("SET NAMES utf8");
$category= "языковые школы";
$start = 0;
$count = 25;
if(isset($_GET["category"]))$category = $_GET['category'];
if(isset($_GET["start"]))$start = $_GET['start'];
if(isset($_GET["count"]))$count = $_GET['count'];
$start = $start*$count;
#SQL CODE
$q = mysql_query("SELECT companies.id, companies.name, companies.created, companies.tags, companies.schedule, companies.info, companies.social, companies.websites, companies.emails, phones.phone, filials.lat, filials.longt, filials.address, categories.category
FROM `companies`
join compcat on companies.id = compcat.company_id
join categories on categories.id = compcat.category_id
join filials on filials.company_id = companies.id
join phones on phones.filial_id = filials.id
WHERE lower(categories.category) LIKE '%$category%'
GROUP by companies.id
LIMIT $start,$count
");
#
$ar = array();
while($r = mysql_fetch_assoc($q))
    array_push($ar,$r);
echo json_encode($ar);

?>
