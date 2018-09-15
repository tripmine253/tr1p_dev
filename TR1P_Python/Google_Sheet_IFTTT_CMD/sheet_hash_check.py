#!/usr/bin/env python2
from __future__ import print_function
from apiclient.discovery import build
from httplib2 import Http
from oauth2client import file, client, tools
import hashlib
import os
import paramiko
CLIENT_CREDS = 'credentials.json'
CLIENT_SECRET = 'client_secret.json'
SPREADSHEET_ID = 'STRING'
RANGE_NAME = 'STRING'
lastEntryNow = ""

def querySpreadsheet(SPREADSHEET_ID,RANGE_NAME):
    SCOPES = 'https://www.googleapis.com/auth/spreadsheets.readonly'
    store = file.Storage(CLIENT_CREDS)
    creds = store.get()
    if not creds or creds.invalid:
        flow = client.flow_from_clientsecrets(CLIENT_SECRET, SCOPES)
        creds = tools.run_flow(flow, store)
    service = build('sheets', 'v4', http=creds.authorize(Http()))
    result = service.spreadsheets().values().get(spreadsheetId=SPREADSHEET_ID,
                                             range=RANGE_NAME,majorDimension="ROWS").execute()
    values = result.get('values', [])
    if not values:
        print('No data found.')
    else:
        index = len(values) - 1
        lastEntryNow = entryHashCheck(values[index][0])
        return lastEntryNow

def localHashCheck(lastEntryNow):
    if os.path.isfile('.lastEntryOnline') is True:
        lastEntryOnline = open('.lastEntryOnline','r').readline()
        if lastEntryOnline == lastEntryNow:
            print("No Changes")
            exit
    else:
        lastEntryOnline = open('.lastEntryOnline','w')
        lastEntryOnline.write(lastEntryNow)
        lastEntryOnline.close()
        checkAlive        
        exit
        
def checkAlive():
    miner = '192.168.1.172'
    response = os.system('ping -c 5 ' + miner)
    if response == 0:
        remoteCommand("shutdown")
    else:
        remoteCommand("startup")

def remoteCommand(task):
    if task == "startup":
        ssh = paramiko.SSHClient()
        ssh.load_system_host_keys()
        ssh.connect('192.168.1.1', username='USER')
        ssh_stdin, ssh_stout, ssh_stderr = ssh.exec_command("/usr/bin/ether-wake -i br0 30:9c:23:44:AD:B0")
        ssh.close()
    elif task == "shutdown":
        ssh = paramiko.SSHClient()
        ssh.load_system_host_keys()
        ssh.connect('HOSTNAME', username='USER')
        ssh_stdin, ssh_stout, ssh_stderr = ssh.exec_command("shutdown -h now")
        ssh.close()

def  entryHashCheck(lastEntryNow):
     h = hashlib.md5()
     h.update(str(lastEntryNow))
     return h.hexdigest()

def main():
    lastEntryNow = querySpreadsheet(SPREADSHEET_ID,RANGE_NAME)
    localHashCheck(lastEntryNow)

main()