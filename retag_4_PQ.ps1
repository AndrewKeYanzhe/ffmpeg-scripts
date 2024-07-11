$folderPath = Split-Path -Parent $MyInvocation.MyCommand.Path

$files = Get-ChildItem -Path $folderPath -Filter "*.mp4" -File

foreach ($file in $files) {
    $inputFile = $file.FullName
    $outputFile = Join-Path -Path $folderPath -ChildPath ($file.BaseName + "_out.mp4")
    $newOutputFile = Join-Path -Path $folderPath -ChildPath ($file.BaseName + ".mp4")
    
    # Use ffprobe to check the current color primaries value
    $ffprobeCommand = 'ffprobe -v error -select_streams v:0 -show_entries stream=color_primaries -of default=noprint_wrappers=1:nokey=1 "{0}"' -f $inputFile
    $currentColorPrimaries = & cmd.exe /c $ffprobeCommand
    
    # Skip processing if color primaries are already set to 9
    if ($currentColorPrimaries -eq 'bt2020') {
        Write-Host "Skipped: $($file.Name) - Color primaries are already set to BT.2020"
        continue
    }
    
    # Process the file with FFmpeg
    $ffmpegCommand = 'ffmpeg -y -i "{0}" -codec copy -bsf:v hevc_metadata=colour_primaries=9,hevc_metadata=transfer_characteristics=16,hevc_metadata=matrix_coefficients=9 -color_primaries 9 -color_trc 16 -colorspace 9 "{1}"' -f $inputFile, $outputFile
    
    Start-Process -Wait -NoNewWindow -FilePath cmd.exe -ArgumentList "/c $ffmpegCommand"

    Remove-Item -Path $inputFile

    Rename-Item -Path $outputFile -NewName $newOutputFile

    Write-Host "Processed: $($file.Name)"
}

Write-Host "All files processed!"

pause
