use LoadTest
go
create table dbo.Telemetry
(
	TelemetryId uniqueidentifier not null
	,StatusId int not null
	,DeviceId bigint not null
	,LocationId int not null
	,Payload varchar(400) not null
	,InsertDate datetime2(3) not null default getutcdate()
);
go
create clustered columnstore index CCS_Telemetry on dbo.Telemetry;
go
create or alter procedure dbo.InsertTelemetry_FullDurability
	@telemetryId uniqueidentifier
	,@statusId int
	,@deviceId bigint
	,@locationId int
	,@payload varchar(400)
as
begin
	set xact_abort on;
	set nocount on;
	begin tran;
	insert into dbo.Telemetry
	(
		TelemetryId
		,StatusId
		,DeviceId
		,LocationId
		,Payload
	)
	values
	(
		@telemetryId
		,@statusId
		,@deviceId
		,@locationId
		,@payload
	);
	commit tran;
end
go
create or alter procedure dbo.InsertTelemetry_DelayedDurability
	@telemetryId uniqueidentifier
	,@statusId int
	,@deviceId bigint
	,@locationId int
	,@payload varchar(400)
as
begin
	set xact_abort on;
	set nocount on;
	begin tran;
	insert into dbo.Telemetry
	(
		TelemetryId
		,StatusId
		,DeviceId
		,LocationId
		,Payload
	)
	values
	(
		@telemetryId
		,@statusId
		,@deviceId
		,@locationId
		,@payload
	);
	commit tran with (delayed_durability = on);
end
go
create table dbo.Telemetry_FourFiles
(
	TelemetryId uniqueidentifier not null
	,StatusId int not null
	,DeviceId bigint not null
	,LocationId int not null
	,Payload varchar(400) not null
	,InsertDate datetime2(3) not null default getutcdate()
) on FourFiles
go
create clustered columnstore index CCS_FourFiles_Telemetry on dbo.Telemetry_FourFiles;
go
create or alter procedure dbo.InsertTelemetry_FourFiles_DelayedDurability
	@telemetryId uniqueidentifier
	,@statusId int
	,@deviceId bigint
	,@locationId int
	,@payload varchar(400)
as
begin
	set xact_abort on;
	set nocount on;
	begin tran;
	insert into dbo.Telemetry_FourFiles
	(
		TelemetryId
		,StatusId
		,DeviceId
		,LocationId
		,Payload
	)
	values
	(
		@telemetryId
		,@statusId
		,@deviceId
		,@locationId
		,@payload
	);
	commit tran with (delayed_durability = on);
end
go
create partition function pf_hash (tinyint)
as range left for values (0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18)
go
create partition scheme ps_hash
as partition pf_hash all to ([primary])
go
create table dbo.Telemetry_HashPartition
(
	TelemetryId uniqueidentifier not null
	,StatusId int not null
	,DeviceId bigint not null
	,LocationId int not null
	,Payload varchar(400) not null
	,InsertDate datetime2(3) not null default getutcdate()
	,HashId tinyint not null
) on ps_hash(HashId)
go
create clustered columnstore index CCS_HashPartition on dbo.Telemetry_HashPartition on ps_hash(HashId)
go
create or alter procedure dbo.InsertTelemetry_HashPartition_DelayedDurability_1
	@telemetryId uniqueidentifier
	,@statusId int
	,@deviceId bigint
	,@locationId int
	,@payload varchar(400)
as
begin
	set xact_abort on;
	set nocount on;
	begin tran;
	insert into dbo.Telemetry_HashPartition
	(
		TelemetryId
		,StatusId
		,DeviceId
		,LocationId
		,Payload
		,HashId
	)
	values
	(
		@telemetryId
		,@statusId
		,@deviceId
		,@locationId
		,@payload
		,cast(abs(convert(bigint,convert(varbinary, newid()))) % 1 as tinyint)
	);
	commit tran with (delayed_durability = on);
end
go
create or alter procedure dbo.InsertTelemetry_HashPartition_DelayedDurability_2
	@telemetryId uniqueidentifier
	,@statusId int
	,@deviceId bigint
	,@locationId int
	,@payload varchar(400)
as
begin
	set xact_abort on;
	set nocount on;
	begin tran;
	insert into dbo.Telemetry_HashPartition
	(
		TelemetryId
		,StatusId
		,DeviceId
		,LocationId
		,Payload
		,HashId
	)
	values
	(
		@telemetryId
		,@statusId
		,@deviceId
		,@locationId
		,@payload
		,cast(abs(convert(bigint,convert(varbinary, newid()))) % 2 as tinyint)
	);
	commit tran with (delayed_durability = on);
end
go
create or alter procedure dbo.InsertTelemetry_HashPartition_DelayedDurability_3
	@telemetryId uniqueidentifier
	,@statusId int
	,@deviceId bigint
	,@locationId int
	,@payload varchar(400)
as
begin
	set xact_abort on;
	set nocount on;
	begin tran;
	insert into dbo.Telemetry_HashPartition
	(
		TelemetryId
		,StatusId
		,DeviceId
		,LocationId
		,Payload
		,HashId
	)
	values
	(
		@telemetryId
		,@statusId
		,@deviceId
		,@locationId
		,@payload
		,cast(abs(convert(bigint,convert(varbinary, newid()))) % 3 as tinyint)
	);
	commit tran with (delayed_durability = on);
end
go
create or alter procedure dbo.InsertTelemetry_HashPartition_DelayedDurability_4
	@telemetryId uniqueidentifier
	,@statusId int
	,@deviceId bigint
	,@locationId int
	,@payload varchar(400)
as
begin
	set xact_abort on;
	set nocount on;
	begin tran;
	insert into dbo.Telemetry_HashPartition
	(
		TelemetryId
		,StatusId
		,DeviceId
		,LocationId
		,Payload
		,HashId
	)
	values
	(
		@telemetryId
		,@statusId
		,@deviceId
		,@locationId
		,@payload
		,cast(abs(convert(bigint,convert(varbinary, newid()))) % 4 as tinyint)
	);
	commit tran with (delayed_durability = on);
end
go