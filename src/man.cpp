#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>

#include <string>

#include "libbmp.h"

//
const uint16_t fbWidth = 800;
const uint16_t fbHeight = 480;


const int rOffset = 2;
const int gOffset = 1;
const int bOffset = 0;

uint8_t * buffer;

const char* devName = "/dev/fb0";
const char* rawFileName = "/run/fbdump";
const char* outputFileName = "/run/fb.bmp";

BmpImg bmp(fbWidth, fbHeight);	

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

	printf("buffer size : %u\r\n", bufferSize);
	buffer = new uint8_t [bufferSize];
	// clear
	memset(buffer, 0, bufferSize);

	// read from framebuffer into buffer
	read(fd, buffer, bufferSize);

	// write raw to file
	int ff = open(rawFileName, O_CREAT | O_WRONLY);
	if(ff != -1) {
		write(ff, buffer, bufferSize);
		close(ff);
	} else {
		printf("Failed to open target file\r\n");
		close(fd);
		return;
	}

	// copy to bmp
	int bufferPos;
	for(int y = 0; y < fbHeight; y++) 
	{
		for(int x = 0; x < fbWidth; x++)
		{
			bufferPos = (((y * fbWidth) + x) * 4);
			bmp.set_pixel(
				x, y, 
				buffer[bufferPos + rOffset], buffer[bufferPos + gOffset], buffer[bufferPos + bOffset]
			);
		}
	}

	bmp.write(std::string(outputFileName));

	delete[] buffer;

	close (fd);
}
