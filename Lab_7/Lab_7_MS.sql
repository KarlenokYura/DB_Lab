use Arenda

select * from Report

--------------------Report table--------------------

create table Report (
id INTEGER primary key identity(1,1),
xml_column XML
);

--------------------GenerateXML procedure--------------------

create procedure generateXML
as
declare @x XML
set @x = (select client_name, client_surname, client_father from client
for xml auto);
SELECT @x
go

execute generateXML;

--------------------IndertInReport procedure--------------------

create procedure InsertInReport
as
DECLARE  @s XML  
SET @s = (select client_name, client_surname, client_father from client
for xml raw);
insert into Report values(@s);
go
  
execute InsertInReport
select * from Report;

--------------------Index--------------------

create primary xml index My_XML_Index on Report(xml_column)

create xml index Second_XML_Index on Report(xml_column)
using xml index My_XML_Index for path

--task5
select * from Report

--------------------SelectData procedure--------------------

create procedure SelectData
as
select xml_column.query('/row') as[xml_column] from Report for xml auto, type;
go

execute SelectData

select xml_column.value('(/row/@cliend_name)[1]', 'nvarchar(max)') as[xml_column] from Report for xml auto, type;

select r.Id,
	m.c.value('@client_name', 'nvarchar(max)')
from Report as r
	outer apply r.xml_column.nodes('/row') as m(c)

select xml_column.query('/row') as [xml_column] from Report for xml auto, type;
