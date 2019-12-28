#  ___________________________________________________________________________
# ! File: makefile - skywalker.rom, Amiga ROM by skywalker                    !
# ! Author: Skywalker a.k.a. J.Karlsson <j.karlsson@retrocoder.se>            !
# ! Copyright: (C) 2019 Skywalker All rights reserved.                        !
# !___________________________________________________________________________!

# VBCC compiler config file
VCCONF=bin.cfg

# Detect OS
ifneq ($(OS),Windows_NT)
    OS := $(shell uname -s)
endif

# Program data
PROGNAME =skywalker.rom
PROGVER  ='0.0.1'
#GITHASH  =$(shell git log | grep -s "commit [0-9a-z]" | cut -c8-47)
BUILDTIME=$(shell date -u +"%F %_H:%M:%S (UTC)")

# Tools
CC=vc +$(VCCONF)
AS=vc +$(VCCONF)
LD=D:/jorgen/Source/projects/python/amiga-tools/aromld.py
#ifeq ($(OS), Linux)
#    UAE=fs-uae
    MKDIR=mkdir -p
    RM=rm -rf
    COPY=cp
#else
#    UAE=winuae
#    MKDIR=echo Create dir
#    RM=del /Q /P
#    COPY=copy
#endif
CD=cd
ECHO=echo
ADF=xdftool

# Directory structure
SRC=src/
INC=inc/
LIB=lib/
AST=assets/
BLD=build/
OBJ=$(BLD)obj/
BIN=$(BLD)bin/
TSTAST=test/
TSTDIR=$(BLD)test/

# Test setup
# Installation directory
INSTDIR="C:/Users/Public/Documents/Amiga Files/WinUAE/"
DISC=$(PROGNAME).adf

# Test command
ifeq ($(OS), Linux)
     UAE=fs-uae
else
     UAE=winuae
endif
TSTCMD=$(UAE) -0 "$(PWD)/$(TSTDIR)$(DISC)" -G

# Disble warnings
# warning 163: #pragma used
DONTWARN+=-dontwarn=163

# Optimization level
OPT=

# Flags
CPPFLAGS=-I$(INC) -DNO_PRAGMAS
CFLAGS=$(DONTWARN) $(OPT)
ASFLAGS=
LDFLAGS=--quiet #--large

# Source files (anything in the src directory)
SOURCES=$(wildcard $(SRC)*)

# Binary files (exe/objs/libs)
PROG=$(PROGNAME)
OBJS=$(subst $(SRC),$(OBJ),$(addsuffix .o,$(basename $(SOURCES))))
LIBS=

# Targets
.PHONY: all install clean $(PROG)
all: $(PROG) install

install: $(BIN)$(PROG)
	@$(ECHO) "Installing $^ into $(INSTDIR)"
	@$(COPY) $(BIN)$(PROG) $(INSTDIR)

# Test targets
#test: $(DISC) | $(TSTDIR)
#	@$(ECHO) "Running $(TSTCMD)"
#	@$(CD) $(TSTDIR); $(TSTCMD) &

#$(DISC): $(TSTDIR)$(DISC)
#$(TSTDIR)$(DISC): $(PROG) | $(TSTDIR)
#	@$(ECHO) "Creating test disc"
#	@$(COPY) $(BIN)$(PROG) $(TSTDIR)
#	@$(CD) $(TSTDIR); $(PWD)/$(TSTAST)make_disc.sh $(DISC) $(PWD)/$(TSTAST)

# "Link" target
$(PROG): $(BIN)$(PROG)

$(BIN)$(PROG): $(OBJS) | $(BIN)
	@$(ECHO) "Linking $^ into ROM file $@"
	@$(LD) $(LDFLAGS) -o $@ $^ $(LIBS)

# Object files
$(OBJ)%.o: $(SRC)%.c | $(OBJ)
	@$(ECHO) "Compiling $^ into $@"
	@$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

$(OBJ)%.o: $(SRC)%.s | $(OBJ)
	@$(ECHO) "Assembling $^ into $@"
	@$(AS) $(ASFLAGS) $(CPPFLAGS) -c -o $@ $<

$(OBJ)%.o: $(SRC)%.S | $(OBJ)
	@$(ECHO) "Assembling $^ into $@"
	@$(AS) $(ASFLAGS) $(CPPFLAGS) -c -o $@ $<

$(OBJ)%.o: $(SRC)%.asm | $(OBJ)
	@$(ECHO) "Assembling $^ into $@"
	@$(AS) $(ASFLAGS) $(CPPFLAGS) -c -o $@ $<

$(OBJ)%.o: $(SRC)%.ASM | $(OBJ)
	@$(ECHO) "Assembling $^ into $@"
	@$(AS) $(ASFLAGS) $(CPPFLAGS) -c -o $@ $<

$(OBJ)%.o: $(SRC)%.a | $(OBJ)
	@$(ECHO) "Assembling $^ into $@"
	@$(AS) $(ASFLAGS) $(CPPFLAGS) -c -o $@ $<

# Cleanup
clean:
	@$(ECHO) "Cleaning up"
	@$(RM) $(BLD) *~ $(SRC)*~ $(INC)*~ $(AST)*~ $(TSTAST)*~

# Create directory structure
$(OBJ):
	@$(MKDIR) $(OBJ)

$(BIN):
	@$(MKDIR) $(BIN)

$(TSTDIR):
	@$(MKDIR) $(TSTDIR)

#  ___________________________________________________________________________
# ! License:                                                                  !
# ! This program is free software: you can redistribute it and/or modify      !
# ! it under the terms of the GNU General Public License version 2 as         !
# ! published by the Free Software Foundation.                                !
# !                                                                           !
# ! This program is distributed in the hope that it will be useful,           !
# ! but WITHOUT ANY WARRANTY; without even the implied warranty of            !
# ! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             !
# ! GNU General Public License for more details.                              !
# !                                                                           !
# ! You should have received a copy of the GNU General Public License         !
# ! along with this program. If not, see <http://www.gnu.org/licenses/>       !
# ! or write to the Free Software Foundation, Inc.,                           !
# ! 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.               !
# !___________________________________________________________________________!
