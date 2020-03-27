create directory bfile_dir as 'D:\DB\Lab_8' 
drop directory bfile_dir

--------------------esignatures table--------------------

CREATE TABLE esignatures (
  office   NUMBER(6,0)  NOT NULL,
  username VARCHAR2(10) NOT NULL,
  FOTO  blob  NOT NULL
)

drop table esignatures
INSERT INTO esignatures  
VALUES (100, 'BOB', utl_raw.cast_to_raw('D:\DB\Lab_8\image.png'));
select * from esignatures

--------------------bfile_table table--------------------

create table bfile_table(
          name varchar2(255),
          the_file bfile );
insert into bfile_table values ( 'doc 2', BFILENAME( 'bfile_dir', 'db.docx' ) );
select * from bfile_table