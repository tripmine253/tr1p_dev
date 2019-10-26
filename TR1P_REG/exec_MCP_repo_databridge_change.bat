echo Windows Registry Editor Version 5.00 > C:\Scripts\mcp_db_repo_change.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\prefs\cpof\bc13\cpof\servers\databridge] >> C:\Scripts\mcp_db_repo_change.reg
echo "default"="192.168.2.45" >> C:\Scripts\mcp_db_repo_change.reg
echo "type"="ipaddress" >> C:\Scripts\mcp_db_repo_change.reg
echo "value"="A.B.C.D" >> C:\Scripts\mcp_db_repo_change.reg
echo "display"="/Data/Bridge" >> C:\Scripts\mcp_db_repo_change.reg
echo "description"="/I/P address of the /Data/Bridge server" >> C:\Scripts\mcp_db_repo_change.reg
echo "seq"="10" >> C:\Scripts\mcp_db_repo_change.reg

echo [HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\prefs\cpof\bc13\cpof\servers\repository] >> C:\Scripts\mcp_db_repo_change.reg
echo "default"="192.168.2.2" >> C:\Scripts\mcp_db_repo_change.reg
echo "type"="ipaddress" >> C:\Scripts\mcp_db_repo_change.reg
echo "value"="A.B.C.D" >> C:\Scripts\mcp_db_repo_change.reg
echo "display"="/Repository" >> C:\Scripts\mcp_db_repo_change.reg
echo "description"="/I/P address of the repository server" >> C:\Scripts\mcp_db_repo_change.reg
echo "seq"="30" >> C:\Scripts\mcp_db_repo_change.reg
regedit /s C:\Scripts\mcp_db_repo_change.reg
shutdown /r /t 300 /c "changing databridge - MSG Gomez"