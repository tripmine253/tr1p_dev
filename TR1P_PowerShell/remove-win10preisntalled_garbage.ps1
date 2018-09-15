# Remove Pre-Installed Garbage
# 8/12/2018
# Home Lab
#############################
# Tr1p Post Build Config Task
#############################
# all installed crap
$softwareList = Get-AppxPackage | select Name
# crap I didn't want
$shitlist = "Microsoft.Windows.PeopleExperienceHost     
Microsoft.Wallet                           
Microsoft.Messaging                        
Microsoft.ZuneMusic                        
Microsoft.Advertising.Xaml                 
Microsoft.MicrosoftSolitaireCollection     
Microsoft.StorePurchaseApp                 
Microsoft.XboxSpeechToTextOverlay          
Microsoft.BingWeather                      
Microsoft.WindowsAlarms                    
Microsoft.WindowsStore                     
Microsoft.ZuneVideo                        
microsoft.windowscommunicationsapps        
Microsoft.Windows.Photos                   
Microsoft.Getstarted                       
Microsoft.WindowsMaps                      
Microsoft.OneConnect                       
Microsoft.People                           
Microsoft.MicrosoftOfficeHub               
828B5831.HiddenCityMysteryofShadows        
A278AB0D.DragonManiaLegends                
Nordcurrent.CookingFever                   
Microsoft.MinecraftUWP                     
king.com.CandyCrushSodaSaga"

$copyPasta = @()
foreach ($item in $shitlist.Split("`n")){$removeit = $item.Replace(" ",""); if ($item.Length -ge 2){$removeAppxCommand = "Get-AppxPackage -Name $removeit | Remove-AppxPackage";$copyPasta+=$removeAppxCommand;Write-Host $removeAppxCommand}}

Write-Host "`n If you`'re happy with that, use above or do something fancy with `$copyPasta `n"