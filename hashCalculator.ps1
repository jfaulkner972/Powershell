#This script allows you to get the hash of a file and compare it easily.
#To use this script run the shortcut and when prompted enter the provided hash to compare integrity

#Set Hash Formula and begin searh
$alg = Read-Host -Prompt 'Please select a hashing algorithm: 1:SHA-256 2:MD5'
$chosen = Read-Host -Prompt 'Please enter the name of the thing you want to hash'
write-host ''

#move to root of user folder
cd C:\Users\$env:Username

#Get all results that are similar to the designated phrase and print them to the screen
$ar = @()
get-childitem -Recurse | where {$_ -like "*$chosen*"} | select -ExpandProperty FullName | foreach { $ar += $_ }

$string = ''
$counter = 1
$ara = @()
foreach( $i in $ar ){
    $string = "$counter" + ': ' + "$i"
    $ara += $string
    $counter++
}

foreach( $k in $ara){
    Write-Host $k
}

#Select the number of the correct thing to hash
write-host ''
$select = Read-Host -Prompt 'Please enter the number of your selection'
write-host ''
$file =''

#Parse the file path of the selection and eliminate extra white space
foreach( $l in $ara){
    if ( $l -match "$select.*"){
        $file =  $l -split "\d+: "
        $file = "$file".Trim()
    }
}

#Calculate the hash of the selected item
if($alg -match "1.*"){
    if( Test-Path $file -PathType Container ){
        Write-Host 'A folder has been selected. Please select a file'
        break 
    }
    else {
        $hashFile = Get-FileHash -Algorithm SHA256 $file | select -ExpandProperty Hash
    }
    write-host "SHA-256 Hash is: $hashFile"
    write-host ''
}
else{
    if( Test-Path $file -PathType Container ){
        Write-Host 'A folder has been selected. Please select a file'
        break 
    }
    else {
        $hashFile = Get-FileHash -Algorithm MD5 $file | select -ExpandProperty Hash
    }
    write-host "MD5 Hash is: $hashFile"
    write-host ''
}

#Enter the provided hash here and get result.
$hash = Read-Host -Prompt 'Please enter the hash to compare against'
$hash = $hash.Replace(" ",'')

if ( $hashFile.ToUpper() -eq $hash.ToUpper()){
    write-host 'The file has not been altered.'
}
else {
    Write-Host 'Hashes do not match. Re-run this script to verify. If result is still incorrect do not execute the file.'
}
