#!/usr/bin/env python
import os
import requests
import json
oAuth_token = ''
oAuth_scope = 'files:read'
channelList = {'general':'','random':'','ctf':''}
slackAPI = 'https://slack.com/api/'
method = 'files.list'
listQTY = 100
pageQTY = 1
prettyOutput = 1
def genSlack_URI(method, token, channel, count, page, pretty):
        methodArgs = '?token=' + str(oAuth_token) + '&channel=' + str(channelList[channel]) + '&count=' + str(listQTY) + '&page=' + str(pageQTY) + '&pretty=' + str(prettyOutput)
        URI = slackAPI + method + methodArgs
        return URI

URI = genSlack_URI(method, oAuth_token, "general", listQTY, pageQTY, prettyOutput)
r = requests.get(URI)
downloadables = []
def fetchDownloadLinks(reply):
    slackData = json.loads(reply)
    for f in slackData["files"]:
        downloadables.append(f["permalink"])

fetchDownloadLinks(r.text)
for x in downloadables:
    print(x)



