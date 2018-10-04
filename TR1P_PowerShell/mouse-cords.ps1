$Runspacehash = [hashtable]::Synchronized(@{})
$Runspacehash.host = $Host
$Runspacehash.runspace = [RunspaceFactory]::CreateRunspace()
$Runspacehash.runspace.ApartmentState = “STA”
$Runspacehash.runspace.ThreadOptions = “ReuseThread”
$Runspacehash.runspace.Open() 
$Runspacehash.psCmd = {Add-Type -AssemblyName PresentationCore,PresentationFramework,WindowsBase,System.Windows.Forms}.GetPowerShell() 
$Runspacehash.runspace.SessionStateProxy.SetVariable("Runspacehash",$Runspacehash)
$Runspacehash.psCmd.Runspace = $Runspacehash.runspace 
$Runspacehash.Handle = $Runspacehash.psCmd.AddScript({ 

    #Build the GUI
    [xml]$xaml = @"
    <Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        x:Name="Window" WindowStartupLocation = "CenterScreen"
        Width = "80" Height = "50" ShowInTaskbar = "False" ResizeMode = "NoResize"
        Topmost = "True" WindowStyle = "None" AllowsTransparency="True" Background="Transparent">  
        <Border BorderBrush="{x:Null}" BorderThickness="1" Height="50" Width="80" HorizontalAlignment="Left" 
        CornerRadius="15" VerticalAlignment="Top" Name="Border">        
        <Border.Background>
            <LinearGradientBrush StartPoint='0,0' EndPoint='0,1'>
                <LinearGradientBrush.GradientStops> <GradientStop Color='#C4CBD8' Offset='0' /> <GradientStop Color='#E6EAF5' Offset='0.2' /> 
                <GradientStop Color='#CFD7E2' Offset='0.9' /> <GradientStop Color='#C4CBD8' Offset='1' /> </LinearGradientBrush.GradientStops>
            </LinearGradientBrush>
        </Border.Background> 
            <Grid ShowGridLines='False'>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="*"/>
                </Grid.ColumnDefinitions>
                <Grid.RowDefinitions>
                    <RowDefinition Height = '*'/>
                    <RowDefinition Height = '*'/>
                </Grid.RowDefinitions>
                <Label x:Name='X_lbl' Tag = 'X' Grid.Column = '0' Grid.Row = '0' FontWeight = 'Bold'
                HorizontalContentAlignment="Center">
                <TextBlock TextDecorations="Underline" 
                    Text="{Binding Path=Tag, 
                    RelativeSource={RelativeSource Mode=FindAncestor,
                    AncestorType={x:Type Label}}}"/>
                </Label>
                <Label x:Name='Y_lbl' Tag = 'Y' Grid.Column = '1' Grid.Row = '0' FontWeight = 'Bold'
                HorizontalContentAlignment="Center">
                <TextBlock TextDecorations="Underline" 
                    Text="{Binding Path=Tag, 
                    RelativeSource={RelativeSource Mode=FindAncestor,
                    AncestorType={x:Type Label}}}"/>
                </Label>
                <Label x:Name='X_data_lbl' Grid.Column = '0' Grid.Row = '1' FontWeight = 'Bold'
                HorizontalContentAlignment="Center" />
                <Label x:Name='Y_data_lbl' Grid.Column = '1' Grid.Row = '1' FontWeight = 'Bold'
                HorizontalContentAlignment="Center" />
            </Grid>
        </Border>
    </Window>
"@
 
    $reader=(New-Object System.Xml.XmlNodeReader $xaml)
    $Window=[Windows.Markup.XamlReader]::Load( $reader )

    #region Connect to Controls
    $xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]") | ForEach {
        New-Variable -Name $_.Name -Value $Window.FindName($_.Name) -Force -ErrorAction SilentlyContinue -Scope Script
    }
    #endregion Connect to Controls
    #Events
    $Window.Add_SourceInitialized({
        #Create Timer object
        Write-Verbose "Creating timer object"
        $Script:timer = new-object System.Windows.Threading.DispatcherTimer 
        #Fire off every 1 minutes
        Write-Verbose "Adding 1 minute interval to timer object"
        $timer.Interval = [TimeSpan]"0:0:0.01"
        #Add event per tick
        Write-Verbose "Adding Tick Event to timer object"
        $timer.Add_Tick({
            $Mouse = [System.Windows.Forms.Cursor]::Position
            $X_data_lbl.Content = $Mouse.x
            $Y_data_lbl.Content = $Mouse.y    
        })
        #Start timer
        Write-Verbose "Starting Timer"
        $timer.Start()
        If (-NOT $timer.IsEnabled) {
            $Window.Close()
        }
    }) 
    $Window.Add_Closed({
        $Script:Timer.Stop()    
        [gc]::Collect()
        [gc]::WaitForPendingFinalizers()    
    })
    $Window.Add_MouseRightButtonUp({
        $This.close()
    })
    $Window.Add_MouseLeftButtonDown({
        $This.DragMove()
    })

    [void]$Window.ShowDialog()
}).BeginInvoke()
