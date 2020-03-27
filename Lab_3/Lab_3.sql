use Arenda;

--------------------Configure--------------------

go
exec sp_configure 'clr_enabled', 1;
go
reconfigure;
go
create assembly GetCountbyPrice
	from 'D:\DB\laba3\Lab3\bin\Debug\Lab3.dll';

--------------------GetCountbtPrice procedure--------------------


go
create procedure GetCountbyPrice (@min int, @max int)
as external name GetCountbyPrice.StoredProcedures.GetCountbyPrice

go
declare @num int
exec @num = GetCountbyPrice '200', '300'
print @num
