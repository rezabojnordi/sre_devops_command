# Examples of ffmpeg

### Scale video, specify width and auto scale height:
```
ffmpeg -i input.mp4 -vf scale=320:-1 output.mp4
```

### Convert to x265:
```
ffmpeg -i input.mp4 -vcodec libx265 out.mp4
```

### Suitalbe convert for Telegram:
```
ffmpeg -i input.mp4 -vf scale=-1:720 -vcodec libx265 output.mp4
```

### Extract from 0 to 60 seconds:
```
ffmpeg -i source-file.foo -ss 0 -t 60 first-1-min.m4v
```
### Put watermark on a video x:y:
```
ffmpeg -i input.mp4 -i watermark.png -filter_complex "overlay=100:300" output.mp4
```
### Put watermark on a video bottom right:
```
ffmpeg -i input.mp4 -i watermark.png -filter_complex "overlay=main_w-overlay_w:main_h-overlay_h" output.mp4
# or
ffmpeg -i input.mp4 -i watermark.png -filter_complex "overlay=W-w:H-h" output.mp4
```


