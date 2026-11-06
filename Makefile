# Makefile for Windows (MinGW, mingw32-make) and Linux (make)
#
#   make                 build anomaly_detection
#   make validation      build validate_smith (validation against Smith 2002)
#   make run             build and run anomaly_detection with ARGS
#   make run ARGS="300 20480 input"
#   make clean           remove AnomalyDetection.o and the executables
#
# Layout: include/AnomalyDetection.h, src/AnomalyDetection.c (C core),
#         anomaly_detection.cpp (driver), validate_smith.cpp (validation)

ifeq ($(OS),Windows_NT)
    EXE     = .exe
    LDFLAGS = -static-libgcc -static-libstdc++
else
    EXE     =
    LDFLAGS =
endif

ifneq ($(findstring mingw32-make,$(MAKE)),)
    SHELL      := cmd.exe
    CLEAN       = del /q /f AnomalyDetection.o anomaly_detection.exe validate_smith.exe 2>nul
    RUN         = .\anomaly_detection.exe
else
    CLEAN       = rm -f AnomalyDetection.o anomaly_detection validate_smith
    RUN         = ./anomaly_detection
endif

CC       = gcc
CXX      = g++
OPT      = -O2
CFLAGS   = -std=c11 -Wall $(OPT) -Iinclude
CXXFLAGS = -std=c++17 -Wall $(OPT) -Iinclude
LDLIBS   = -lm

ARGS ?= 600 20480 input

CORE = AnomalyDetection.o

all: anomaly_detection$(EXE)

anomaly_detection$(EXE): anomaly_detection.cpp $(CORE) include/AnomalyDetection.h
	$(CXX) $(CXXFLAGS) $(LDFLAGS) anomaly_detection.cpp $(CORE) -o $@ $(LDLIBS)

validate_smith$(EXE): validate_smith.cpp $(CORE) include/AnomalyDetection.h
	$(CXX) $(CXXFLAGS) $(LDFLAGS) validate_smith.cpp $(CORE) -o $@ $(LDLIBS)

$(CORE): src/AnomalyDetection.c include/AnomalyDetection.h
	$(CC) $(CFLAGS) -c src/AnomalyDetection.c -o $@

validation: validate_smith$(EXE)

run: anomaly_detection$(EXE)
	$(RUN) $(ARGS)

clean:
	-@$(CLEAN)

.PHONY: all validation run clean