# good for stuff like custom ESM audio alert messages.
$speechObj = New-Object -ComObject SAPI.SpVoice
$fileStream = New-Object -ComObject SAPI.SpFileStream
$fileName = "C:\Users\Tim\Documents\sample.txt"; #Enter the file that has to be converted to an audio file
$fileToCreate = "C:\Users\Tim\Documents\VoiceToFile.wav";
$speechObj.Rate = 0.05 ; #Speaking rate of the voice.
$data = Get-Content $fileName
$SSMCreateForWrite = 3; # FileMode. Default value is SSFMOpenForRead
$DoEvents = 0; # False . Optional Value
$fileStream.Open($fileToCreate,$SSMCreateForWrite,$DoEvents);
$speechobj.AudioOutputStream = $fileStream
$speechObj.speak($data)
$fileStream.Close();

