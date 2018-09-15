# Tr1p notes:
# I basically took this to improve on it's use cases.
# anti-ocr, pixel search stuff.
# I can't remember all the .Net stuff because I rarely use it.

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
 function GenerateRandomImage ([int] $width,[int] $height,$filename)
 {
     $random = New-Object System.Random
     $color = [System.Drawing.Color]::White
     $image = New-Object System.Drawing.Bitmap($width, $height)
     [System.Drawing.Graphics]::FromImage($image).FillRectangle((New-Object System.Drawing.SolidBrush($color)), 0, 0, $width, $height)

     $graphics = [System.Drawing.Graphics]::FromImage($image)
     $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality

     $start = New-Object System.Drawing.Point
     $c1 = New-Object System.Drawing.Point
     $c2 = New-Object System.Drawing.Point
     $end = New-Object System.Drawing.Point

     for ($i = 2; $i -lt $random.Next(50); $i++)
     {
         $start.X = $random.Next(0, $width)
         $start.Y = $random.Next(0, $height)
         $c1.X = $random.Next(0, $width)
         $c1.Y = $random.Next(0, $height)
         $c2.X = $random.Next(0, $width)
         $c2.Y = $random.Next(0, $height)
         $end.X = $random.Next(0, $width)
         $end.Y = $random.Next(0, $height)
         $p = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb($random.Next(0, 255), $random.Next(0, 255), $random.Next(0, 255)), $random.Next(5))             
         $graphics.DrawBezier($p, $start, $c1, $c2, $end)       
     }
    
     for ($i = 2; $i -lt $random.Next(70); $i++)
     {
         try
         {
             $style = [System.Enum]::Parse([System.Drawing.FontStyle], ([System.Drawing.FontStyle] | gm –static –membertype Property |Get-Random).Name)
             $graphics.DrawString([System.Web.Security.Membership]::GeneratePassword($random.Next(3,20),2), (New-Object System.Drawing.Font(([System.Drawing.FontFamily]::Families |Get-Random), $random.Next(4,20),$style)), (New-Object system.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($random.Next(255),$random.Next(255),$random.Next(255)))),$random.Next(0, $width), $random.Next(0, $height))           
         }
         catch{}
     }   
     try
     {
         $qualityParam = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100)
         $jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |Where-Object {$_.MimeType -eq "image/jpeg"}
         $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)-Property @{Param = $qualityParam}       
         $image.Save($filename, $jpegCodec, $encoderParams);
     }
     catch [Exception]
     {
         try 
         {
             $qualityParam = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 100)
             $jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |Where-Object {$_.MimeType -eq "image/jpeg"}
             $encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)-Property @{Param = $qualityParam}       
             $image.Save($filename, $jpegCodec, $encoderParams);
         }
         catch [Exception]
         {
             $_.Exception.ToString()
         }
     }   
 }