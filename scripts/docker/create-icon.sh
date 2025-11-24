# Create icon-1024.ico from icon-1024.png


docker run --entrypoint=magick -v ./assets/img/icons:/imgs dpokidov/imagemagick \
 -size 1024x1024 /imgs/icon-1024.png \
 -define icon:auto-resize=256,128,64,48,32,16 icon-1024.ico


