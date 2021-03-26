#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>


//
const uint16_t fbWidth = 800;
const uint16_t fbHeight = 480;

uint8_t * buffer;

const char* devName = "/dev/fb0";


//
//
//
int main(void)
{
 int fd;
 
 if(-1 == (fd = open(devName, O_RDONLY)))
 {
 	printf("failed to open framebuffer\r\n");
 	exit(0);
 }
 
 uint32_t bufferSize = fbWidth * fbHeight * 4;
 printf("bytes : %u\r\n", bufferSize);
 
 buffer = new uint8_t [bufferSize];
 memset(buffer, 0, bufferSize);
 
 // read from framebuffer
 read(fd, buffer, bufferSize);
 
 // write to file
 int ff = open("/run/shot", O_CREAT | O_WRONLY);
 if(ff != -1) {
	 write(ff, buffer, bufferSize);
 	close(ff);
 } else 
 	printf("Failed to open target file\r\n");
 
 delete[] buffer;
 
 close (fd);
}
