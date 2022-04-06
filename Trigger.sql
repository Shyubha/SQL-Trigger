create table productstable
(
id int,
pname varchar(50),
price decimal
)

create table productsaudit
(
id int identity(1,1),
info varchar(100)
);

-------------Insert Trigger--------------

create trigger tr_productstable_insert
on productstable
for insert
as
begin
declare @id int
declare @pname varchar(50)
declare @price decimal	
select @id = id from inserted
insert into productsaudit values
(
'new id inserted = ' + cast(@id as varchar(50)) + 
'added at = ' +cast(getdate() as varchar(20))
)
end

	select*from productstable
	select*from productsaudit

    insert into productstable values(101,'Maza Products',20);
    insert into productstable values(102,'Amul Products',30);
    insert into productstable values(103,'Parle Products',25);
	insert into productstable values(104,'Balaji Products',10);

------------Delete Trigger ----------------

create trigger tr_productstable_ForDelete
on productstable
for delete
as
begin
    declare @id int
	declare @pname varchar(50)
	declare @price decimal
	select @id = id from deleted
	insert into productsaudit values
	(
	 'Existing id = ' +cast(@id as varchar(5))+
	 'deleted at = ' +cast(getdate() as varchar(50))
	)
	end

	delete from productstable where id = 101;

	select*from productstable
	select*from productsaudit

--------------Update Trigger-------------------------

create trigger tr_productstable_ForUpdate
on productstable
for update
as 
begin
    select*from deleted
	select*from inserted
end

update productstable set pname ='Campus Product',price = 45 where id in(102,104);

alter trigger tr_productstable_ForUpdate
on productstable
for update
as 
begin
    declare @id int
	declare @oldpname varchar(50),@Newpname varchar(50)
	declare @oldprice decimal,@Newprice decimal

	declare @AuditString varchar(1000)

	select *into #TampTable	from inserted
	while(Exists(select id from #TampTable))
	begin
	     set @AuditString = ''
		 select Top 1 
		 @id = id, @Newpname = pname, @Newprice = price
		 from #TampTable
		 
		 select
		 @oldpname = pname, @oldprice = price
		 from deleted where id = @id

         set @AuditString = 'ProductsT ID =' +cast(@id as varchar(5)) +'Changed'
		 if(@oldpname <> @Newpname)
		    set  @AuditString = @AuditString +'name from'+@oldpname+'to'+@Newpname

		 if(@oldprice <> @Newprice)
		   set @AuditString = @AuditString +'price from'+cast(@oldprice as varchar(10))

		 insert into productsaudit values(@AuditString)
		 delete from #TampTable where id = @id

		end
end	

