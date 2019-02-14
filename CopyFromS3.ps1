# Powershell script to copy files files from AWS s3 and place in a specified local folder
# Import Powershell for AWS - TODO - Might not always be necessary 
Import-Module -Name AWSPowershell

# Set the AWS user credentials, the name of the S3 bucket and the region
$accessKey = ""
$secretKey = ""
$region = ""
$s3Bucket = ""

# The folder in the S3 bucket to copy from 
$keyPrefix = "daily-text-files//dailyFile_txt"
# The local file path where files should be written to
$localPath = "C:\FilesCopiedFromS3\Dailyfile_txt"

# Select the files from S3 you want to copy
$objects = Get-S3Object -BucketName $s3Bucket -KeyPrefix $keyPrefix -AccessKey $accessKey -SecretKey $secretKey -Region $region | Sort-Object LastModified -Descending | Select-Object -First 7

# Copy each file
foreach($object in $objects) {
    $localFileName = $object.Key -replace $keyPrefix, ''
    $localFilePath = Join-Path $localPath $localFileName
    Copy-S3Object -BucketName $s3Bucket -Key $object.Key -LocalFile $localFilePath -AccessKey $accessKey -SecretKey $secretKey -Region $region
}


