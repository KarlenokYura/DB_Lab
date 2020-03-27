use Arenda;

--------------------Flat type table--------------------

create table flat_type(
flat_type_id int IDENTITY(1,1) primary key,
flat_type_name nvarchar(50)
);

insert into flat_type values('One-room');
insert into flat_type values('Two-room');
insert into flat_type values('Three-room');
insert into flat_type values('Four-room');

select * from flat_type;

drop table flat_type;

--------------------Flat table--------------------

create table flat(
flat_id int IDENTITY(1,1) primary key,
flat_address int,
flat_flat_type int,
flat_price int,
flat_realtor int,
constraint flat_flat_type_fk foreign key (flat_flat_type) REFERENCES flat_type(flat_type_id) ON DELETE CASCADE,
constraint flat_address_fk foreign key (flat_address) REFERENCES address(address_id) ON DELETE CASCADE,
constraint flat_realtor_fk foreign key (flat_realtor) REFERENCES realtor(realtor_id) ON DELETE CASCADE
)

insert into flat values(1, 1, 100, 1);
insert into flat values(2, 2, 200, 1);
insert into flat values(3, 3, 300, 2);
insert into flat values(4, 4, 400, 2);

select * from flat;

drop table flat;

--------------------Country table--------------------

create table country(
country_id int IDENTITY(1,1) primary key,
country_name nvarchar(50)
)

insert into country values('Belarus');
insert into country values('Russia');
insert into country values('USA');

select * from country;

--drop table country;

--------------------Town table--------------------

create table town(
town_id int IDENTITY(1,1) primary key,
town_name nvarchar(50),
town_country int,
constraint town_country_fk foreign key (town_country) REFERENCES country(country_id) ON DELETE CASCADE
)

insert into town values('Minsk', 1);
insert into town values('Svetlogorsk', 1);
insert into town values('Svetlogorsk', 2);

select * from town;

--drop table town;

--------------------Address table--------------------

create table address(
address_id int IDENTITY(1,1) primary key,
address_town int,
address_street nvarchar(100),
constraint address_town_fk foreign key (address_town) REFERENCES town(town_id) ON DELETE CASCADE
)

insert into address values(1, 'Sverdlova 34, 213');
insert into address values(1, 'Sverdlova 34, 214');
insert into address values(1, 'Sverdlova 34, 215');
insert into address values(1, 'Sverdlova 34, 216');

select * from address;

--drop table address;

--------------------Realtor table--------------------

create table realtor(
realtor_id int IDENTITY(1,1) primary key,
realtor_name nvarchar(50),
realtor_surname nvarchar(50),
realtor_father nvarchar(50),
realtor_price int
)

insert into realtor values('Yura', 'Karlenok', 'Andreevich', 50);
insert into realtor values('Liza', 'Borodina', 'Dmitrievna', 100);

select * from realtor;

--drop table realtor;

--------------------Client table--------------------

create table client(
client_id int IDENTITY(1,1) primary key,
client_name nvarchar(50),
client_surname nvarchar(50),
client_father nvarchar(50)
)

insert into client values('Nikita', 'Velesevich', 'Victorovich');
insert into client values('Lesha', 'Rauba', 'Alexandrovich');

select * from client;

--drop table client;

--------------------Rent table--------------------

create table rent(
rent_id int IDENTITY(1,1) primary key,
rent_flat int,
rent_client int,
rent_start date,
rent_end date,
constraint rent_flat_fk foreign key (rent_flat) REFERENCES flat(flat_id) ON DELETE CASCADE,
constraint rent_client_fk foreign key (rent_client) REFERENCES client(client_id) ON DELETE CASCADE
)

insert into rent values(1, 1, '10-10-2018', '11-11-2018');
insert into rent values(2, 1, '10-10-2019', '11-11-2019');
insert into rent values(3, 2, '10-10-2020', '11-11-2020');

select * from rent;

drop table rent;

--------------------Indexes--------------------

go
create index flat_price
on flat(flat_price)

go
create index realtor_price
on realtor(realtor_price)

go
create index client_surname
on client(client_surname)

go
create index rent_date
on rent(rent_start, rent_end)

--------------------Flat view--------------------

create view flat_view as select flat.flat_id, country.country_name, town.town_name, address.address_street, 
flat_type.flat_type_name, flat.flat_price, flat.flat_realtor
from flat inner join flat_type on flat.flat_flat_type = flat_type.flat_type_id
inner join address on flat.flat_address = address.address_id
inner join town on address.address_town = town.town_id
inner join country on town.town_country = country.country_id;

select * from flat_view;

--drop view flat_view;

--------------------Realtor view--------------------

create view realtor_view as select flat_view.flat_id, flat_view.country_name, flat_view.town_name, flat_view.address_street, 
flat_view.flat_type_name, flat_view.flat_price,
realtor.realtor_name, realtor.realtor_surname, realtor.realtor_father, realtor.realtor_price
from flat_view inner join realtor on flat_view.flat_realtor = realtor.realtor_id;

select * from realtor_view;

--drop view realtor_view;

--------------------Rent view--------------------

create view rent_view as select realtor_view.flat_id, realtor_view.country_name, realtor_view.town_name, realtor_view.address_street, 
realtor_view.flat_type_name, realtor_view.flat_price,
realtor_view.realtor_name, realtor_view.realtor_surname, realtor_view.realtor_father, realtor_view.realtor_price,
client.client_name, client.client_surname, client.client_father,
rent.rent_start, rent.rent_end
from rent inner join realtor_view on rent.rent_flat = realtor_view.flat_id
inner join client on rent.rent_client = client.client_id;

select * from rent_view;

drop view rent_view;

--------------------Flat_type--------------------
--------------------Insert procedures--------------------

go  
create procedure flat_type_insert(@flat_type_name nvarchar(50))    
as   
begin  
    insert into flat_type values(@flat_type_name);
end;  
go  

exec flat_type_insert 'Test-Room';

--drop procedure flat_type_insert;

--------------------Update procedures--------------------

go  
create procedure flat_type_update(@flat_type_id int, @flat_type_name nvarchar(50))    
as   
begin  
	update flat_type set flat_type_name = @flat_type_name where flat_type_id = @flat_type_id
end;  
go  

exec flat_type_update '6', 'New-Test-Room';

--drop procedure flat_type_update;

--------------------Delete procedures--------------------

go  
create procedure flat_type_delete(@flat_type_id int)    
as   
begin  
    delete flat_type where flat_type_id = @flat_type_id;
end;  
go  

exec flat_type_delete '7';

--drop procedure flat_type_delete;

select * from flat_type;

--------------------Counrty--------------------
--------------------Insert procedures--------------------

go  
create procedure country_insert(@country_name nvarchar(50))    
as   
begin  
    insert into country values(@country_name);
end;  
go  

exec country_insert 'Ukraine';

--drop procedure country_insert;

--------------------Update procedures--------------------

go  
create procedure country_update(@country_id int, @country_name nvarchar(50))    
as   
begin  
	update country set country_name = @country_name where country_id = @country_id
end;  
go  

exec country_update '4', 'New-Ukraine';

--drop procedure country_update;

--------------------Delete procedures--------------------

go  
create procedure country_delete(@country_id int)    
as   
begin  
    delete country where country_id = @country_id;
end;  
go  

exec country_delete '5';

--drop procedure country_delete;

select * from country;

--------------------Town--------------------
--------------------Insert procedures--------------------

go  
create procedure town_insert(@town_name nvarchar(50), @town_country int)    
as   
begin  
    insert into town values(@town_name, @town_country);
end;  
go  

exec town_insert 'Vitebsk', '1';

--drop procedure town_insert;

--------------------Update procedures--------------------

go  
create procedure town_update(@town_id int, @town_name nvarchar(50), @town_country int)    
as   
begin  
	update town set town_name = @town_name, town_country = @town_country where town_id = @town_id
end;  
go  

exec town_update '4', 'New-Vitebsk', '1';

--drop procedure town_update;

--------------------Delete procedures--------------------

go  
create procedure town_delete(@town_id int)    
as   
begin  
    delete town where town_id = @town_id;
end;  
go  

exec town_delete '4';

--drop procedure town_delete;

select * from town;

--------------------Address--------------------
--------------------Insert procedures--------------------

go  
create procedure address_insert(@address_town int, @address_street nvarchar(50))    
as   
begin  
    insert into address values(@address_town, @address_street);
end;  
go  

exec address_insert '1', 'Belorusskaya 21, 315';

--drop procedure address_insert;

--------------------Update procedures--------------------

go  
create procedure address_update(@address_id int,  @address_town int, @address_street nvarchar(50))    
as   
begin  
	update address set address_town = @address_town, address_street = @address_street where address_id = @address_id
end;  
go  

exec address_update '6', '1', 'New-Belorusskaya 21, 315';

--drop procedure address_update;

--------------------Delete procedures--------------------

go  
create procedure address_delete(@address_id int)    
as   
begin  
    delete address where address_id = @address_id;
end;  
go  

exec address_delete '6';

--drop procedure address_delete;

select * from address;