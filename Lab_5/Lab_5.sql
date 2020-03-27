use Arenda;

--------------------Lab_5 table--------------------

CREATE TABLE Lab_5(
  hid hierarchyid NOT NULL,
  userId int NOT NULL,
  userName nvarchar(50) NOT NULL,
CONSTRAINT PK_Lab_5 PRIMARY KEY CLUSTERED 
(
  [hid] ASC
));

insert into Lab_5 values(hierarchyid::GetRoot(), 1, 'Us1'); 
select * from Lab_5;

go
declare @Id hierarchyid  
select @Id = MAX(hid) from Lab_5 where hid.GetAncestor(1) = hierarchyid::GetRoot() ; 
insert into Lab_5 values(hierarchyid::GetRoot().GetDescendant(@id, null), 2, 'Us2');

go
declare @Id hierarchyid
select @Id = MAX(hid) from Lab_5 where hid.GetAncestor(1) = hierarchyid::GetRoot() ;
insert into Lab_5 values(hierarchyid::GetRoot().GetDescendant(@id, null), 3, 'Us2');
 
go
declare @phId hierarchyid
select @phId = (SELECT hid FROM Lab_5 WHERE userId = 2);
declare @Id hierarchyid
select @Id = MAX(hid) from Lab_5 where hid.GetAncestor(1) = @phId;
insert into Lab_5 values( @phId.GetDescendant(@id, null), 7, 'Us2');

select hid.ToString(), hid.GetLevel(), * from Lab_5; 

--------------------SelectRoot procedure--------------------

GO  
CREATE PROCEDURE SelectRoot(@level int)    
AS   
BEGIN  
   select hid.ToString(), * from Lab_5 where hid.GetLevel() = @level;
END;
  
GO  
exec SelectRoot 1;

--------------------AddDocherRoot procedure--------------------

GO  
CREATE PROCEDURE AddDocherRoot(@UserId int, @UserName nvarchar(50))   
AS   
BEGIN  
declare @Id hierarchyid
declare @phId hierarchyid
select @phId = (SELECT hid FROM Lab_5 WHERE UserId = @UserId);

select @Id = MAX(hid) from Lab_5 where hid.GetAncestor(1) = @phId

insert into Lab_5 values( @phId.GetDescendant(@id, null),@UserId,@UserName);
END;  

GO  
exec AddDocherRoot 2, 'Us3';
select * from Lab_5; 

--------------------MovRoot procedure--------------------

go
CREATE PROCEDURE MovRoot(@old_uzel int, @new_uzel int )
AS  
BEGIN  
DECLARE @nold hierarchyid, @nnew hierarchyid  
SELECT @nold = hid FROM Lab_5 WHERE UserId = @old_uzel ;  
  
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE  
BEGIN TRANSACTION  
SELECT @nnew = hid FROM Lab_5 WHERE UserId = @new_uzel ; 
  
SELECT @nnew = @nnew.GetDescendant(max(hid), NULL)   
FROM Lab_5 WHERE hid.GetAncestor(1)=@nnew ; 
UPDATE Lab_5   
SET hid = hid.GetReparentedValue(@nold, @nnew)   
WHERE hid.IsDescendantOf(@nold) = 1 ;   
 commit;
  END ;  
GO  

exec MovRoot 2,3
select hid.ToString(), hid.GetLevel(), * from Lab_5