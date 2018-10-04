# https://apisof.net/catalog/System.IO.Compression.ZipFile.OpenRead(String)
add-type -AssemblyName System.IO.Compression.FileSystem
$zipFile = ([System.IO.Compression.ZipFile])
($zipFile::OpenRead('.\Desktop\0x539\WMICodeCreator.zip')).Entries | select Name
