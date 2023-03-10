#
# Cross Platform Makefile
# Compatible with MSYS2/MINGW, Ubuntu 14.04.1 and Mac OS X
#
# You will need SDL2 (http://www.libsdl.org):
# Linux:
#   apt-get install libsdl2-dev
# Mac OS X:
#   brew install sdl2
# MSYS2:
#   pacman -S mingw-w64-i686-SDL2
#

#CXX = g++
#CXX = clang++

EXE = 
SOURCES = $(wildcard src/*.cpp)
OBJS = $(patsubst src/%.cpp,build/%.o,$(SOURCES))
UNAME_S := $(shell uname -s)

CXXFLAGS = -std=c++17 -Iinclude -w
CXXFLAGS += -g -Wall -Wformat
LIBS =
DEL_CMD =
##---------------------------------------------------------------------
## BUILD FLAGS PER PLATFORM
##---------------------------------------------------------------------

ifeq ($(UNAME_S), Linux) #LINUX
	ECHO_MESSAGE = "Linux"
	LIBS += -lGL -ldl -lSDL2 -lSDL2_ttf -lSDL2_image -lSDL2_mixer

	DEL_CMD += "rm"
	EXE = build/game

	CXXFLAGS += -I/usr/include/
	CFLAGS = $(CXXFLAGS)
endif

ifeq ($(UNAME_S), Darwin) #APPLE
	ECHO_MESSAGE = "Mac OS X"
	LIBS += -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo `sdl2-config --libs`
	LIBS += -L/usr/local/lib -L/opt/local/lib

	CXXFLAGS += `sdl2-config --cflags`
	CXXFLAGS += -I/usr/local/include -I/opt/local/include
	CFLAGS = $(CXXFLAGS)
endif

ifeq ($(OS), Windows_NT)
	ECHO_MESSAGE = "MinGW"
	LIBS += -lgdi32 -lopengl32 -limm32 -LC:/msys64/mingw64/lib -lmingw32 -mwindows -lSDL2main -lSDL2 -lSDL2_image -lSDL2_ttf -lSDL2_mixer -lmingw32 -mwindows -mconsole -lm -luser32 -lgdi32 -lwinmm -limm32 -lole32 -loleaut32 -lversion -luuid -ladvapi32 -lsetupapi -lshell32 -ldinput8

	DEL_CMD += "del"
	EXE = build/game.exe

	CXXFLAGS += -IC:/msys64/mingw64/include/SDL2 -Dmain=SDL_main
	CFLAGS = $(CXXFLAGS)
endif

##---------------------------------------------------------------------
## BUILD RULES
##---------------------------------------------------------------------
build/%.o:%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

build/%.o:src/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

build/%.o:$(IMGUI_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

build/%.o:$(IMGUI_DIR)/backends/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

all: $(EXE)
	@echo Build complete for $(ECHO_MESSAGE)

$(EXE): $(OBJS)
	$(CXX) -o $@ $^ $(CXXFLAGS) $(LIBS)

clean:
	$(DEL_CMD) $(EXE) $(OBJS)
