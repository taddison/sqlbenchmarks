create database LoadTest;
alter database loadtest add filegroup FourFiles;
go
alter database LoadTest modify file (Name = LoadTest, Size = 1024MB);
alter database LoadTest modify file (Name = LoadTest_log, Size = 1024MB);
alter database loadtest add file (
	name = FourFiles_One, Size = 256MB, FileName='D:\FourFiles_One.ndf'
),
(
	name = FourFiles_Two, Size = 256MB, FileName='D:\FourFiles_Two.ndf'
),
(
	name = FourFiles_Three, Size = 256MB, FileName='D:\FourFiles_Three.ndf'
),
(
	name = FourFiles_Four, Size = 256MB, FileName='D:\FourFiles_Four.ndf'
)
to filegroup FourFiles;
go
alter authorization on database::LoadTest to sa;
alter database LoadTest set recovery simple;
alter database LoadTest set delayed_durability = allowed;
go
