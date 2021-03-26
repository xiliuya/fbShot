TARGET_EXEC ?= fbShot

MOD ?= 1

BR_OUT_PATH ?= /home/jef/Work/CM3/br-fam001_output

ifeq ($(MOD), 1)
TARGET_USE = TARGET_USE_SDL=1
endif

ifeq ($(MOD), 2)
TARGET_USE = TARGET_USE_FB=1
endif

ifeq ($(MOD), 3)
TARGET_USE = TARGET_USE_FB=1
endif


ifeq ($(TARGET_USE), TARGET_USE_SDL=1)
INC_TARGET = -I/usr/include/freetype2
LDFLAGS_TARGET = -lSDL2 
endif

ifeq ($(TARGET_USE), TARGET_USE_FB=1)

ifeq ($(MOD), 2)
LDFLAGS_TARGET = 
CC = arm-linux-gnueabihf-gcc
CXX = arm-linux-gnueabihf-g++
endif

ifeq ($(MOD), 3)
LDFLAGS_TARGET = 
INC_TARGET = -I$(BR_OUT_PATH)/staging/usr/include/freetype2
CC = arm-buildroot-linux-gnueabihf-gcc
CXX = arm-buildroot-linux-gnueabihf-g++
endif

endif

QUIET = @

BUILD_DIR ?= ./build
SRC_DIRS ?= ./src

SRCS := $(shell find $(SRC_DIRS) -name *.cpp -or -name *.c -or -name *.s)
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

INC_DIRS := $(shell find $(SRC_DIRS) -type d)
INC_FLAGS := $(addprefix -I,$(INC_DIRS)) $(INC_TARGET)

CPPFLAGS ?= $(INC_FLAGS) -MMD -MP -g -D$(TARGET_USE) 

LDFLAGS ?= $(LDFLAGS_TARGET) -lm -lpthread -lstdc++ -lsupc++ 

$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	@echo "linking ..."
	$(QUIET) $(CC) $(OBJS) -o $@ $(LDFLAGS)	
	@echo "copy output ./"
	$(QUIET) cp $(BUILD_DIR)/fbShot app/fbShot

# assembly
$(BUILD_DIR)/%.s.o: %.s
	@echo $<
	$(QUIET) $(MKDIR_P) $(dir $@)
	$(QUIET) $(AS) $(ASFLAGS) -c $< -o $@

# c source
$(BUILD_DIR)/%.c.o: %.c
	@echo $<
	$(QUIET) $(MKDIR_P) $(dir $@)
	$(QUIET) $(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# c++ source
$(BUILD_DIR)/%.cpp.o: %.cpp
	@echo $<
	$(QUIET) $(MKDIR_P) $(dir $@)
	$(QUIET) $(CXX) $(CPPFLAGS) -std=c++0x -pthread $(CXXFLAGS) -c $< -o $@ 


.PHONY: clean

clean:
	@echo "cleaning ....."
	$(RM) -r $(BUILD_DIR)

-include $(DEPS)

MKDIR_P ?= mkdir -p
