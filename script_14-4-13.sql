USE [FroudDetaction]
GO
/****** Object:  Table [dbo].[CreditCard]    Script Date: 04/14/2013 11:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CreditCard](
	[CardID] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[CardNumber] [numeric](20, 0) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[DesiredLoginName] [varchar](500) NOT NULL,
	[Password] [varchar](500) NOT NULL,
	[Email] [varchar](200) NOT NULL,
	[Gender] [varchar](10) NOT NULL,
	[PhoneNo] [varchar](15) NOT NULL,
	[dateofbirth] [varchar](10) NOT NULL,
	[AddressLine1] [varchar](200) NOT NULL,
	[AddressLine2] [varchar](200) NOT NULL,
	[City] [varchar](200) NOT NULL,
	[state] [varchar](200) NOT NULL,
	[country] [varchar](200) NOT NULL,
	[pin] [varchar](15) NOT NULL,
	[accountnumber] [varchar](50) NOT NULL,
	[bankname] [varchar](50) NOT NULL,
	[CreditLimit] [numeric](18, 2) NOT NULL,
	[Deactivate] [bit] NOT NULL,
	[cvvno] [int] NULL,
	[expirymonth] [int] NULL,
	[expiryyear] [int] NULL,
	[secque1] [int] NULL,
	[secque2] [int] NULL,
	[secque3] [int] NULL,
	[secque4] [int] NULL,
	[secque5] [int] NULL,
	[secans1] [varchar](500) NULL,
	[secans2] [varchar](500) NULL,
	[secans3] [varchar](500) NULL,
	[secans4] [varchar](500) NULL,
	[secans5] [varchar](500) NULL,
 CONSTRAINT [PK_CreditCard] PRIMARY KEY CLUSTERED 
(
	[CardID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Configuration]    Script Date: 04/14/2013 11:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Configuration](
	[TolarenceLimit] [numeric](18, 0) NOT NULL,
	[ConsiderLastNoOfTransaction] [int] NOT NULL,
	[minTolarenceLimit] [numeric](18, 0) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 04/14/2013 11:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[User](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](500) NOT NULL,
	[Password] [varchar](500) NOT NULL,
	[Deactivate] [bit] NOT NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[test]    Script Date: 04/14/2013 11:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test](
	[description] [nvarchar](max) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 04/14/2013 11:32:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Split]
(
    @RowData nvarchar(2000),
    @SplitOn nvarchar(5)
)  
RETURNS @RtnValue table 
(
    Id int identity(1,1),
    Data nvarchar(100)
) 
AS  
BEGIN 
    Declare @Cnt int
    Set @Cnt = 1

    While (Charindex(@SplitOn,@RowData)>0)
    Begin
    	Insert Into @RtnValue (data)
    	Select 
    		Data = ltrim(rtrim(Substring(@RowData,1,Charindex(@SplitOn,@RowData)-1)))

    	Set @RowData = Substring(@RowData,Charindex(@SplitOn,@RowData)+1,len(@RowData))
    	Set @Cnt = @Cnt + 1
    End

    Insert Into @RtnValue (data)
    Select Data = ltrim(rtrim(@RowData))

    Return
END
GO
/****** Object:  StoredProcedure [dbo].[sp_generate_insert_script]    Script Date: 04/14/2013 11:32:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_generate_insert_script]  
                 @tablename_mask varchar(500) = NULL,  
@whereclause varchar(1000)   = ' 1=1 '
, @excludefield varchar(100) = ''  
as  
begin  
--------------------------------------------------------------------------------  
-- Stored Procedure:  sp_generate_insert_script  
-- Language:          Microsoft Transact SQL (7.0)  
-- Author:            Inez Boone (inez.boone@xs4al.nl)  
--                    working on the Sybase version of & thanks to:  
--                    Reinoud van Leeuwen (reinoud@xs4all.nl)  
-- Version:           1.4  
-- Date:              December 6th, 2000  
-- Description:       This stored procedure generates an SQL script to fill the  
--                    tables in the database with their current content.  
-- Parameters:        IN: @tablename_mask : mask for tablenames  
-- History:           1.0 October 3rd 1998 Reinoud van Leeuwen  
--                      first version for Sybase  
--                    1.1 October 7th 1998 Reinoud van Leeuwen  
--                      added limited support for text fields; the first 252   
--                      characters are selected.  
--                    1.2 October 13th 1998 Reinoud van Leeuwen  
--                      added support for user-defined datatypes  
--                    1.3 August 4 2000 Inez Boone  
--                      version for Microsoft SQL Server 7.0  
--                      use dynamic SQL, no intermediate script  
--                    1.4 December 12 2000 Inez Boone  
--                      handles quotes in strings, handles identity columns  
--                    1.5 December 21 2000 Inez Boone  
--                      Output sorted alphabetically to assist db compares,  
--                      skips timestamps  
--------------------------------------------------------------------------------  
   
-- NOTE: If, when executing in the Query Analyzer, the result is truncated, you can remedy  
--       this by choosing Query / Current Connection Options, choosing the Advanced tab and  
--       adjusting the value of 'Maximum characters per column'.  
--       Unchecking 'Print headers' will get rid of the line of dashes.  
   
  declare @tablename       varchar (128)  
  declare @tablename_max   varchar (128)  
  declare @tableid         int  
  declare @columncount     numeric (7,0)  
  declare @columncount_max numeric (7,0)  
  declare @columnname      varchar (50)  
  declare @columntype      int  
  declare @string          varchar (200)  
  declare @leftpart        varchar (8000)    /* 8000 is the longest string SQLSrv7 can EXECUTE */  
  declare @rightpart       varchar (8000)    /* without having to resort to concatenation      */  
  declare @rightpart2       varchar (8000)    /* without having to resort to concatenation      */  
  declare @hasident        int  
   
  set nocount on  
   
  -- take ALL tables when no mask is given (!)  
  if (@tablename_mask is NULL)  
  begin  
    select @tablename_mask = '%'  
  end  
   
  -- CREATE table columninfo now, because it will be used several times  
   
  CREATE table #columninfo  
  (num      numeric (7,0) identity,  
   name     varchar(200),  
   usertype smallint)  
   
  
  select name,  
         id  
    into #tablenames  
    from sysobjects  
   where type in ('U' ,'S')  
     and name like @tablename_mask  
   
  -- loop through the table #tablenames  
   
  select @tablename_max  = MAX (name),  
         @tablename      = MIN (name)  
    from #tablenames  
   
  while @tablename <= @tablename_max  
  begin  
    select @tableid   = id  
      from #tablenames  
     where name = @tablename  
   
    if (@@rowcount <> 0)  
    begin  
      -- Find out whether the table contains an identity column  
      select @hasident = max( status & 0x80 )  
        from syscolumns  
       where id = @tableid  
 and xtype <> 34  
   
      truncate table #columninfo  
   
      insert into #columninfo (name,usertype)  
      select name, type  
        from syscolumns C  
       where id = @tableid  
         and type not in (34,37)           -- do not include timestamps, images  
 and case when @excludefield = '' then '1' else name end  <>  
 case when @excludefield = '' then '0' else @excludefield end    
   
      -- Fill @leftpart with the first part of the desired insert-statement, with the fieldnames  
  
  
      select @leftpart = 'select ''insert into '+@tablename  
      select @leftpart = @leftpart + '('  
   
      select @columncount     = MIN (num),  
             @columncount_max = MAX (num)  
        from #columninfo  
      while @columncount <= @columncount_max  
      begin  
        select @columnname = '['+name+']',  
               @columntype = usertype  
          from #columninfo  
         where num = @columncount  
        if (@@rowcount <> 0)  
        begin  
          if (@columncount < @columncount_max)  
          begin  
            select @leftpart = @leftpart + @columnname + ','  
          end  
          else  
          begin  
            select @leftpart = @leftpart + @columnname + ')'  
          end  
        end  
   
        select @columncount = @columncount + 1  
      end  
   
      select @leftpart = @leftpart + ' values('''  
   
      -- Now fill @rightpart with the statement to retrieve the values of the fields, correctly formatted  
      select @columncount     = MIN (num),  
             @columncount_max = MAX (num)  
        from #columninfo  
   
      select @rightpart = ''  
      select @rightpart2 = ''  
   
      while @columncount <= @columncount_max  
      begin  
        select @columnname ='['+name+']',  
               @columntype = usertype  
          from #columninfo  
         where num = @columncount  
  
  
        if (@@rowcount <> 0)  
        begin  
  
   
          if @columntype in (39,47) /* char fields need quotes (except when entering NULL);  
                                    *  use char(39) == ', easier readable than escaping  
                                    */  
  
   
          begin  
            select @rightpart = @rightpart + '+'  
            select @rightpart = @rightpart + 'ISNULL(' + replicate( char(39), 4 ) + '+replace(' + @columnname + ',' + replicate( char(39), 4 ) + ',' + replicate( char(39), 6) + ')+' + replicate( char(39), 4 ) + ',''NULL'')'  
          end  
   
          else if @columntype = 35 /* TEXT fields cannot be RTRIM-ed and need quotes     */  
                                   /* convert to VC 1000 to leave space for other fields */  
          begin  
            select @rightpart = @rightpart + '+'  
            select @rightpart = @rightpart + 'ISNULL(' + replicate( char(39), 4 ) + '+replace(convert(varchar(1000),' + @columnname + ')' + ',' + replicate( char(39), 4 ) + ',' + replicate( char(39), 6 ) + ')+' + replicate( char(39), 4 ) + ',''NULL'')'  







          end  
   
          else if @columntype in (58,61,111) /* datetime fields */  
          begin  
            select @rightpart = @rightpart + '+'  
            select @rightpart = @rightpart + 'ISNULL(' + replicate( char(39), 4 ) + '+convert(varchar(20),' + @columnname + ')+'+ replicate( char(39), 4 ) + ',''NULL'')'  
          end  
   
          else   /* numeric types */  
          begin  
            select @rightpart = @rightpart + '+'  
            select @rightpart = @rightpart + 'ISNULL(convert(varchar(99),' + @columnname + '),''NULL'')'  
          end  
   
          if ( @columncount < @columncount_max)  
          begin  
            select @rightpart = @rightpart + '+'','''  
          end  
        end  
        select @columncount = @columncount + 1  
          if len(@rightpart) >= 7900  
   begin  
      select @rightpart2 = @rightpart  
select @rightpart = ''   
          end  
      end  
   
    end  
  
  
    select @rightpart = @rightpart + '+'')''' + ' from ' + @tablename+' where '+@whereclause   
    -- Order the select-statements by the first column so you have the same order for  
    -- different database (easy for comparisons between databases with different creation orders)  
    select @rightpart = @rightpart + ' order by 1'  
   -- For tables which contain an identity column we turn identity_insert on  
    -- so we get exactly the same content  
   
    if @hasident > 0  
       select 'SET IDENTITY_INSERT ' + @tablename + ' ON'  
    --select @leftpart + @rightpart2 + @rightpart  
    exec ( @leftpart + @rightpart2 + @rightpart )  
   
    if @hasident > 0  
       select 'SET IDENTITY_INSERT ' + @tablename + ' OFF'  
   
    select @tablename      = MIN (name)  
      from #tablenames  
     where name            > @tablename  
  end  
   
  
end
GO
/****** Object:  Table [dbo].[securityquestion]    Script Date: 04/14/2013 11:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[securityquestion](
	[id] [int] NULL,
	[description] [nvarchar](150) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sale]    Script Date: 04/14/2013 11:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Sale](
	[saleid] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[cardid] [numeric](18, 0) NOT NULL,
	[productid] [int] NOT NULL,
	[quantity] [numeric](18, 2) NOT NULL,
	[rate] [numeric](18, 2) NOT NULL,
	[amount] [numeric](18, 2) NOT NULL,
	[remark] [varchar](500) NOT NULL,
	[id] [numeric](18, 0) NOT NULL,
	[status] [varchar](20) NULL,
 CONSTRAINT [PK_Sale] PRIMARY KEY CLUSTERED 
(
	[saleid] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Product]    Script Date: 04/14/2013 11:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Product](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [varchar](500) NOT NULL,
	[Rate] [numeric](18, 2) NOT NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[onetimepassword]    Script Date: 04/14/2013 11:32:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[onetimepassword](
	[cardid] [numeric](18, 0) NOT NULL,
	[password] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[usp_list_Product]    Script Date: 04/14/2013 11:32:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[usp_list_Product]
(
	@DisplayAll			[bit],
	@DisplayBlank		[bit]
)
as
	begin
		set nocount on
		
		select p.[ProductName], p.[ProductID]
		from [Product] p
		union all
		select 'All', 0
		where @DisplayAll	= 1
		union all
		select '', 0
		where @DisplayBlank	= 1
		order by [ProductName]
	end
GO
/****** Object:  UserDefinedFunction [dbo].[SplitAll]    Script Date: 04/14/2013 11:32:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[SplitAll](@SplitOn nvarchar(5))
RETURNS @RtnValue table
(
    Id int identity(1,1),
    Data nvarchar(100)
)
AS
BEGIN
DECLARE My_Cursor CURSOR FOR SELECT Description FROM dbo.test
DECLARE @description varchar(50)

OPEN My_Cursor
FETCH NEXT FROM My_Cursor INTO @description
WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO @RtnValue
    SELECT Data FROM dbo.Split(@description, @SplitOn)
   FETCH NEXT FROM My_Cursor INTO @description
END
CLOSE My_Cursor
DEALLOCATE My_Cursor

RETURN

END
GO
/****** Object:  StoredProcedure [dbo].[getavaragetransactionamount]    Script Date: 04/14/2013 11:32:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[getavaragetransactionamount]
(
	@cardid		numeric
)
as
	begin
		set nocount on
		
		declare @ConsiderLastNoOfTransaction int = 1
		select @ConsiderLastNoOfTransaction = [ConsiderLastNoOfTransaction] from configuration
		
		declare @TolarenceLimit int = 1
		select @TolarenceLimit = [TolarenceLimit] from configuration
		
		SET ROWCOUNT @ConsiderLastNoOfTransaction
		
		select SUM(amount) as amount, id 
		into #sale
		from sale
		where cardid = @cardid
		and ISNULL(status, '') = 'sucess'
		group by id
		order by id desc
		
		select AVG(amount) + @TolarenceLimit as maxtotalamount ,
		AVG(amount) + minTolarenceLimit as mintotalamount 
		from #sale
	end
GO
/****** Object:  StoredProcedure [dbo].[generaterandomnumber]    Script Date: 04/14/2013 11:32:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[generaterandomnumber]
(
	@cardid	numeric
)
as
	begin
		declare @emailid varchar(200)		
		DECLARE @Randomsecurityquestion INT;
		DECLARE @Upper INT;
		DECLARE @Lower INT
		declare @description nvarchar(150)
		declare @answer nvarchar(150)
		
		---- This will create a random number between 1 and 999
		SET @Lower = 1 ---- The lowest random number
		SET @Upper = 5 ---- The highest random number
		SELECT @Randomsecurityquestion = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
		
		select @description = description from securityquestion
		where id = @Randomsecurityquestion
		
		select @emailid  = Email,
		@answer = case @Randomsecurityquestion when 1 then secans1
		when 2 then secans2 when 3 then secans3 when 4 then secans4
		when 5 then secans5 end
		from creditcard a
		where cardid = @cardid
		
		DECLARE @Random INT;
		
		---- This will create a random number between 1 and 999
		SET @Lower = 11111 ---- The lowest random number
		SET @Upper = 999999 ---- The highest random number
		SELECT @Random = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
		
		delete from onetimepassword
		where cardid = @cardid
		
		insert into onetimepassword
		values (@cardid, @Random)
		
		select password, @emailid as [email], @description as [description], @answer as [answer]
		from onetimepassword
		where cardid = @cardid
	end
GO
/****** Object:  StoredProcedure [dbo].[splitdata]    Script Date: 04/14/2013 11:32:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[splitdata]
as
	begin
		

		SELECT DISTINCT Data FROM dbo.SplitAll(N' ')
	end
GO
/****** Object:  Default [DF__Configura__minTo__182C9B23]    Script Date: 04/14/2013 11:32:23 ******/
ALTER TABLE [dbo].[Configuration] ADD  DEFAULT ((0)) FOR [minTolarenceLimit]
GO
/****** Object:  Default [DF__Sale__status__1273C1CD]    Script Date: 04/14/2013 11:32:23 ******/
ALTER TABLE [dbo].[Sale] ADD  DEFAULT ('sucess') FOR [status]
GO
