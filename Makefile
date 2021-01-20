.phony: all clean

ifeq ($(ERL_EI_INCLUDE_DIR),)
	ERL_ROOT_DIR = $(shell erl -eval "io:format(\"~s~n\", [code:root_dir()])" -s init stop -noshell)
	ifeq ($(ERL_ROOT_DIR),)
		$(error Could not find the Erlang installation. Check to see that 'erl' is in your PATH)
	endif
	ERL_EI_INCLUDE_DIR = "$(ERL_ROOT_DIR)/usr/include"
	ERL_EI_LIBDIR = "$(ERL_ROOT_DIR)/usr/lib"
endif

# Set Erlang-specific compile and linker flags
ERL_CFLAGS ?= -I$(ERL_EI_INCLUDE_DIR)
ERL_LDFLAGS ?= -L$(ERL_EI_LIBDIR)

NIF_LDFLAGS = -shared $(LDFLAGS)
PORT_LDFLAGS = $(LDFLAGS)
CFLAGS ?= -std=c11 -Ofast -Wall -Wextra -Wno-unused-parameter

ifeq ($(CROSSCOMPILE),)
	ifneq ($(OS),Windows_NT)
		NIF_LDFLAGS += -fPIC
		CFLAGS += -fPIC

		ifeq ($(shell uname),Darwin)
			NIF_LDFLAGS += -dynamiclib -undefined dynamic_lookup
		endif
	endif
endif

# NIF=priv/libnif.so
PORT=priv/via_port

C_SRCS := c_src/kernel.c c_src/via_port.c # c_src/libnif.c 
C_OBJS := $(C_SRCS:c_src/%.c=obj/%.o)
C_DEPS := $(C_SRCS:c_src/%.c=obj/%.d)

$(warning CV_CFLAGS = $(CV_CFLAGS))
$(warning CV_LDFLAGS = $(CV_LDFLAGS))
$(warning C_OBJS = $(C_OBJS))
$(warning C_DEPS = $(C_DEPS))

OLD_SHELL := $(SHELL)
SHELL = $(warning [Making: $@] [Dependencies: $^] [Changed: $?])$(OLD_SHELL)

all: priv obj $(PORT) # $(NIF)


priv:
	mkdir -p priv

obj:
	mkdir -p obj

$(PORT): obj/via_port.o obj/kernel.o
	$(CC) -o $@ $^ $(PORT_LDFLAGS)

$(NIF): obj/libnif.o obj/kernel.o
	$(CC) -o $@ $^ $(ERL_LDFLAGS) $(NIF_LDFLAGS)

$(C_DEPS): obj/%.d: c_src/%.c
	$(CC) $(ERL_CFLAGS) $(CFLAGS) $< -MM -MP -MF $@

$(C_OBJS): obj/%.o: c_src/%.c obj/%.d
	$(CC) -c $(ERL_CFLAGS) $(CFLAGS) -o $@ $<

include $(shell ls $(C_DEPS) 2>/dev/null)

clean:
	$(RM) $(NIF) obj/*
