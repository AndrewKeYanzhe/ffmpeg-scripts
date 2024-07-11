retag_4_PQ.ps1 is a Windows powershell script that retags all videos within a folder with PQ Rec2020 tags so that they are recognised as HDR videos. No re-encode is done, so quality is preserved

specific ffmpeg command used:

```
ffmpeg -y -i <input> -codec copy -bsf:v hevc_metadata=colour_primaries=9,hevc_metadata=transfer_characteristics=16,hevc_metadata=matrix_coefficients=9 -color_primaries 9 -color_trc 16 -colorspace 9 <output>
```
