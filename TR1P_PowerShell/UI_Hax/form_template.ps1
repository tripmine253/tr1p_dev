#Generated Form Function
function GenerateForm {

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
#endregion

#region Generated Form Objects
$form1 = New-Object System.Windows.Forms.Form
$comboVoice = New-Object System.Windows.Forms.ComboBox
$textSpeak = New-Object System.Windows.Forms.TextBox
$label1 = New-Object System.Windows.Forms.Label
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
#endregion Generated Form Objects

#----------------------------------------------
#Generated Event Script Blocks
#----------------------------------------------
#Provide Custom Code for events specified in PrimalForms.
[System.Collections.ArrayList]$global:RateListItems = "-10","-9","-8","-7","-6","-5","-4","-3","-2","-1","0","1","2","3","4","5","6","7","8","9","10"
[System.Collections.ArrayList]$global:VolumeListItems = "0","05","10","15","20","25","30","35","40","45","50","55","60","65","70","75","80","85","90","95","100"

$Voice = New-Object -com SAPI.SpVoice

$buttonSpeak = { 
    $Voice.Voice = $Voice.GetVoices().Item($comboVoice.SelectedIndex)
    $Voice.Rate = $comboRate.SelectedItem 
    $Voice.Volume = $comboVol.SelectedItem
    $Text2Speak = $textSpeak.Text
    [void] $Voice.Speak($Text2Speak)
    }

$OnLoadForm_StateCorrection = { 
    #Correct the initial state of the form to prevent the .Net maximized form issue
    $form1.WindowState = $InitialFormWindowState }

#----------------------------------------------
#region Generated Form Code

# Form
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 215
$System_Drawing_Size.Width = 546
$form1.ClientSize = $System_Drawing_Size
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$form1.Name = "form1"
$form1.Text = "Text2Speech Demo"
$form1.BackColor = "LightGray"

# Volume ComboBox
$comboVol.DataBindings.DefaultDataSourceUpdateMode = 0
$comboVol.FormattingEnabled = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 375
$System_Drawing_Point.Y = 123
$comboVol.Location = $System_Drawing_Point
$comboVol.Name = "comboBoxVol"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 21
$System_Drawing_Size.Width = 121
$comboVol.Size = $System_Drawing_Size
$comboVol.TabIndex = 5
# Add items to Combo box
$items = $global:VolumeListItems
ForEach ($item in $items) {
    $comboVol.items.add($item) }
$comboVol.SelectedIndex = 20;
$form1.Controls.Add($comboVol)

# Speak Button
$Speakbutton.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 316
$System_Drawing_Point.Y = 177
$Speakbutton.Location = $System_Drawing_Point
$Speakbutton.Name = "Speakbutton"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 75
$Speakbutton.Size = $System_Drawing_Size
$Speakbutton.TabIndex = 1
$Speakbutton.Text = "Speak"
$Speakbutton.UseVisualStyleBackColor = $True
$Speakbutton.add_Click($buttonSpeak)
$form1.Controls.Add($Speakbutton)

# TextBox
$textSpeak.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 44
$System_Drawing_Point.Y = 63
$textSpeak.Location = $System_Drawing_Point
$textSpeak.Name = "textSpeak"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 20
$System_Drawing_Size.Width = 452
$textSpeak.Size = $System_Drawing_Size
$textSpeak.TabIndex = 0
$textSpeak.add_Click($textboxSpeak)
$form1.Controls.Add($textSpeak)

# Label2 Text
$label2.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 44
$System_Drawing_Point.Y = 34
$label2.Location = $System_Drawing_Point
$label2.Name = "label2"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 100
$label2.Size = $System_Drawing_Size
$label2.TabIndex = 7
$label2.Text = "Text"
$label2.TextAlign = 256
$form1.Controls.Add($label2)

# Label1 Title
$label1.DataBindings.DefaultDataSourceUpdateMode = 0
$label1.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",9.75,1,3,1)
$label1.ForeColor = [System.Drawing.Color]::FromArgb(255,64,64,64)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 139
$System_Drawing_Point.Y = 9
$label1.Location = $System_Drawing_Point
$label1.Name = "label1"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Height = 23
$System_Drawing_Size.Width = 252
$label1.Size = $System_Drawing_Size
$label1.TabIndex = 6
$label1.Text = "Text2Speech Demo"
$label1.TextAlign = 32
$form1.Controls.Add($label1)

#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $form1.WindowState
#Init the OnLoad event to correct the initial state of the form
$form1.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$form1.ShowDialog()| Out-Null

} #End Function

#Call the Function
GenerateForm
