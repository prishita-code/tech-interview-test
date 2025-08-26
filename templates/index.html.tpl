<html lang="en">
<head>
<title>Page Title</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
body {
  font-family: Arial, Helvetica, sans-serif;
}
</style>
</head>
<body>

<h1>Zurich Platform Engineer Test</h1>
<p>A website created by me.</p>
<ul> Instance ID: ${aws_instance.test_instance.id}</ul>
<ul> Instance Type: ${aws_instance.test_instance.instance_type}</ul>
<ul> Instance Public IP: ${aws_instance.test_instance.public_ip}</ul>
<ul> Hostname: ${aws_instance.test_instance.public_dns}</ul>
<ul> Availability Zone: ${aws_instance.test_instance.availability_zone}</ul>
<ul> VPC ID: ${aws_instance.test_instance.vpc_security_group_ids}</ul>

</body>
</html>