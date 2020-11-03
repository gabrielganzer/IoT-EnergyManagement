TARGET = dpm_simulator
CC = gcc
CFLAGS = -Wall
INCDIR = "."

.PHONY: default clean docs

default: $(TARGET)

SOURCES = $(wildcard src/*.c)
OBJECTS = $(patsubst %.c, %.o, $(SOURCES))
HEADERS = $(wildcard $(INCDIR)/*.h)

%.o: %.c $(TARGET).c $(HEADERS)
	$(CC) $(CFLAGS) -I$(INCDIR) -c $< -o $@

$(TARGET): $(OBJECTS) $(TARGET).o
	$(CC) $(TARGET).o $(OBJECTS) $(CFLAGS) -I$(INCDIR) -o $@

docs: Doxyfile $(HEADERS) $(wildcard src/*.c)
	doxygen $<

clean:
	-rm -f src/*.o
	-rm -f $(TARGET).o
	-rm -f $(TARGET)
