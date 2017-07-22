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