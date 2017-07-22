create database LoadTest;
go
alter database LoadTest modify file (Name = LoadTest, Size = 1024MB);
alter database LoadTest modify file (Name = LoadTest_log, Size = 1024MB);
go
alter authorization on database::LoadTest to sa;
alter database LoadTest set recovery simple;
alter database LoadTest set delayed_durability = allowed;
go
