# Powershell script to upload files to an AWS S3 bucket

#set the extension type - passed as parameters within the job
$backuptype = '*.txt'

# Set the AWS user credentials and the name of the S3 bucket
$accessKey = ''
$secretKey = ''
$s3Bucket = ''

# Go the location where the files are stored
Set-Location c:\DailyTextFiles

# loop thorugh the sub directories for each folder in the above path
Get-ChildItem | Foreach-Object {
    if ($_.PSIsContainer) { #if its a directory - i.e if there is any sub directories to loop through
    
        # Set the prefix for the s3 key
        $keyPrefix = "daily-text-files/" + $_.name + '_txt'
        # Switch to sub directory
        Set-Location $_.name

        # Get the newest daily text file 
        $backupName = Get-ChildItem $backuptype | Sort-Object -Property LastAccessTime | Select-Object -Last 1
      
        # S3 stores objects in key/values pairs
        # So create a S3 key
        $s3Keyname = $keyPrefix + "/" + $backupName.Name
        # Write the backup to S3
        if ($backupName)
        {
            Write-S3Object -BucketName $s3Bucket -Key $s3Keyname -File $backupName -AccessKey $accessKey -SecretKey $secretKey
        }

        # Go back to the location where the files are stored
       Set-Location c:\DailyTextFiles
    }
}