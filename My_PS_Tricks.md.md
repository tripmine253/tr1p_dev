### Interrogating Windows Service Logs
```powershell
function Tr1p-ServiceRecords($serviceName)  
{
	Get-EventLog -LogName System | ? {$_.Message -ilike "**$serviceName**"}| select `
	Message, TimeGenerated, TimeWritten, UserName | % {[PSCustomObject]@{`
		"ServiceName"=$serviceName;`
		"TimeGenerated"=$_.TimeGenerated;`
		"TimeWritten"=$_.TimeWritten;`
		"Message"=$_.Message;`
		"UserName"=$_.UserName
		}
	}  
}
```
<!--stackedit_data:
eyJoaXN0b3J5IjpbLTEwMzAxNjk0NTZdfQ==
-->