# Global settings
$quickTest = $false
$server = "localhost"
$database = "LoadTest"
$user = "loadtest"
$pass = "S3c|_|re"
$connectionString = "server=$server;initial catalog=$database;user id=$user;password=$pass;"

$guid = [System.Guid]::NewGuid()
$payload = '{ "trackingData" : { "lat": "68.643525", "long" : "-95.9754966" } }'
$arguments = "@telemetryId = '$guid', @statusId = 1, @deviceId = 1, @locationId = 1, @payload = '$payload'"

$threadCounts = @(1,2,4,8,16,32,64,128)
$total = 1000000
$trialCount = 3

if($quickTest)
{
    $threadCounts = @(1,2)
    $total = 10000
    $trialCount = 1
}

# Create csv with headers
"id,threads,repeats,duration,completed,failed,median,p90,p95,p99,p999,max" | Out-File results.csv

# Configure and run benchmark
$ref = "CCS_FullDurability"
$command = "exec dbo.InsertTelemetry_FullDurability $arguments"

foreach($threads in $threadCounts)
{
    $repeats = [int]($total / $threads)
    for($trial = 1; $trial -le $trialCount; $trial++)
    {
        ..\..\tools\SQLDriver.exe -r $repeats -t $threads -c $connectionString -s $command -m -i $ref *>> results.csv
        Invoke-Sqlcmd -ServerInstance $server -Database $database -Username $user -Password $pass -Query "truncate table dbo.Telemetry"
    }
}

$ref = "CCS_DelayedDurability"
$command = "exec dbo.InsertTelemetry_DelayedDurability $arguments"

foreach($threads in $threadCounts)
{
    $repeats = [int]($total / $threads)
    for($trial = 1; $trial -le $trialCount; $trial++)
    {
        ..\..\tools\SQLDriver.exe -r $repeats -t $threads -c $connectionString -s $command -m -i $ref *>> results.csv
        Invoke-Sqlcmd -ServerInstance $server -Database $database -Username $user -Password $pass -Query "truncate table dbo.Telemetry"
    }
}