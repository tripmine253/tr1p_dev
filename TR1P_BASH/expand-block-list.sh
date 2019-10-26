# ##############################################
# Custom blacklist
# ##############################################

pihole -b cdn.adfront.org tag.medialytics.com med.heyzap.com notify.bugsnag.com rt.applovin.com ns.zdbb.net omaze.com traffic.adxprts.com ads.exoclick.com adclickservice.com 2468.go2cloud.org d1lp05q4sghme9.cloudfront.net 4-edge-chat.facebook.com pleasedontslaymy.download cdn11.pleasedontslaymy.download engine.phn.doublepimp.com media.trafficjunky.net fbcdn-profile-a.akamaihd.net cf2.vuze.com tlootas.org badtopwitch.work eventtracking.omarsys.com almoraffiliates-api.omarsys.com www.sunnyplayer.com cdn.engine.spotscenered.info sunnyplayer-frontapi.cherrytech.com mh.tlootas.org spotscenered.info 

# ##############################################
# Whitelist of domains (twitter, spotify, ...)
# ##############################################

# Clean out - to be sure
# echo "" | sudo tee /etc/pihole/whitelist.txt > /dev/null
# pihole -g

pihole -w raw.githubusercontent.com mirror1.malwaredomains.com sysctl.org zeustracker.abuse.ch s3.amazonaws.com hosts-file.net spclient.wg.spotify.com udm.scorecardresearch.com analytics.twitter.com adaway.org v.firebog.net mirror.cedia.org.ec www.malwaredomainlist.com bitbucket.org openphish.com ransomwaretracker.abuse.ch github.com thepiratebay.org apple.com appleid.apple.com pornhub.com opensubtitles.org angryip.org imgur.com prod.imgur.map.fastlylb.net m.imgur.com 


# ##############################################
# Pi-Hole's block lists
# ##############################################

echo "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://mirror1.malwaredomains.com/files/justdomains" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "http://sysctl.org/cameleon/hosts" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://hosts-file.net/ad_servers.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null

##Thanks to https://wally3k.github.io
echo "https://adaway.org/hosts.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://v.firebog.net/hosts/AdguardDNS.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://hosts-file.net/ad_servers.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://v.firebog.net/hosts/Easylist.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://raw.githubusercontent.com/StevenBlack/hosts/master/data/SpotifyAds/hosts" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://raw.githubusercontent.com/StevenBlack/hosts/master/data/UncheckyAds/hosts" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://v.firebog.net/hosts/Airelle-trc.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://v.firebog.net/hosts/Easyprivacy.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://v.firebog.net/hosts/Prigent-Ads.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://raw.githubusercontent.com/quidsup/notrack/master/trackers.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://raw.githubusercontent.com/StevenBlack/hosts/master/data/add.2o7Net/hosts" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://raw.githubusercontent.com/StevenBlack/hosts/master/data/tyzbit/hosts" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://v.firebog.net/hosts/static/SamsungSmart.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://v.firebog.net/hosts/Airelle-hrsk.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://s3.amazonaws.com/lists.disconnect.me/simple_malvertising.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://mirror1.malwaredomains.com/files/justdomains" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://hosts-file.net/exp.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://hosts-file.net/emd.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://hosts-file.net/psh.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://mirror.cedia.org.ec/malwaredomains/immortal_domains.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://www.malwaredomainlist.com/hostslist/hosts.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://bitbucket.org/ethanr/dns-blacklists/raw/8575c9f96e5b4a1308f2f12394abd86d0927a4a0/bad_lists/Mandiant_APT1_Report_Appendix_D.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://openphish.com/feed.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://v.firebog.net/hosts/Prigent-Malware.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://v.firebog.net/hosts/Prigent-Phishing.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://raw.githubusercontent.com/quidsup/notrack/master/malicious-sites.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://ransomwaretracker.abuse.ch/downloads/RW_DOMBL.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://v.firebog.net/hosts/Shalla-mal.txt" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://raw.githubusercontent.com/StevenBlack/hosts/master/data/add.Risk/hosts" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://github.com/chadmayfield/pihole-blocklists/raw/master/lists/pi_blocklist_porn_all.list" | sudo tee -a /etc/pihole/adlists.list > /dev/null
echo "https://raw.githubusercontent.com/chadmayfield/pihole-blocklists/master/lists/pi_blocklist_porn_top1m.list" | sudo tee -a /etc/pihole/adlists.list > /dev/null

pihole -g
