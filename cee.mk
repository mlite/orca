CC		  := gcc
OBJDIR	:= obj
LIBDIR	:= lib

SRC			:= $(wildcard discord-*.c curl-websocket.c settings.c json-scanf.c jscon-common.c)
_OBJS		:= $(patsubst %.c, %.o, $(SRC))
OBJS 		:= $(addprefix $(OBJDIR)/, $(_OBJS))

LIBDISCORD_CFLAGS	:= -I./
LIBDISCORD_LDFLAGS	:=  -L./$(LIBDIR) -ldiscord -lcurl

LIBDISCORD_LDFLAGS += -lbearssl -static

LIBS_CFLAGS		:= $(LIBDISCORD_CFLAGS)
LIBS_LDFLAGS	:= $(LIBDISCORD_LDFLAGS)

LIBDISCORD_SLIB	:= $(LIBDIR)/libdiscord.a

CFLAGS := -Wall -Wextra -pedantic -std=c11 -O0 -g -DLIBDISCORD_DEBUG 


CFLAGS += -D_DEFAULT_SOURCE

PREFIX ?= /usr/local

.PHONY : all mkdir install clean purge

all : mkdir $(OBJS) $(LIBDISCORD_SLIB)

mkdir :
	echo "mkdir"
	mkdir -p $(OBJDIR) $(LIBDIR)

echo-bot : all echo-bot.c
	$(CC) $(CFLAGS) $(LIBS_CFLAGS) \
		echo-bot.c -o echo-bot.exe $(LIBS_LDFLAGS)

$(OBJDIR)/discord-%.o : discord-%.c
	$(CC) $(CFLAGS) $(LIBS_CFLAGS) -c -o $@ $<
$(OBJDIR)/settings.o : settings.c
	$(CC) $(CFLAGS) $(LIBS_CFLAGS) -c -o $@ $<
$(OBJDIR)/json-scanf.o : json-scanf.c
	$(CC) $(CFLAGS) $(LIBS_CFLAGS) -c -o $@ $<
$(OBJDIR)/jscon-common.o : jscon-common.c
	$(CC) $(CFLAGS) $(LIBS_CFLAGS) -c -o $@ $<
$(OBJDIR)/curl-websocket.o : curl-websocket.c
	$(CC) $(CFLAGS) $(LIBS_CFLAGS) \
		-U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=1 -c -o $@ $<

$(LIBDISCORD_SLIB) : $(OBJS)
	$(AR) -cvq $@ $(OBJS)

clean :
	rm -rf $(OBJDIR) $(LIBDIR) *.exe 

purge : clean
	rm -rf $(LIBDIR)