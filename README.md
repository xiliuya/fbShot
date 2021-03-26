# fbShot
Framebuffer screenshot

Takes a screenshot from a frame buffer at /dev/fb0 on an embedded platform  
Writes a raw image to /run/fbdump  
Saves image as 32 bit bmp to /run/fb.bmp

frambuffer has a fixed resolution of 800x480 32bpp


uses library from https://github.com/marc-q/libbmp.git for writing bmp format file.