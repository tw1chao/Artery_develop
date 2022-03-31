# export SHELL = cmd.exe
##############################################################################
# @file		: Makefile
# @brief	: makefile user defined
# @author	: yingchao
# @Update	: 2022-03-22
##############################################################################

#######################################
# Build Operating System environment (Linux/win/mac)
#######################################
OS = mac

#######################################
# Define Variable & Current PATH
#######################################

SUBDIR := Project

CURRENT_DIR = $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
# CURRENT_DIR = ../		# if make version are under 3.81 

#######################################
# Define Variable & Tool & Directory
#######################################
mk_noprint_dir := --no-print-directory
# JOB := -j2

export MAKE := make
export TARGET ?= Project
export BUILD_DIR ?= build

BUILDSUBDIR := $(SUBDIR:%=build-%)
CLEANSUBDIR := $(SUBDIR:%=clean-%)

USERCODEDIR := User

ifeq "$(OS)" "win"
echo_param = -e
endif


# mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
# CURRENT_DIR := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

#######################################
# Setup CLI Variable flags (SWD/COMx/USBx)
#######################################
PORT := SWD
ADDR := 0x08000000
VERIFY := --verify

OpenOCD_PATH  = OpenOCD_artery/bin

Scripts_PATH  = ./OpenOCD_artery/scripts
INTERFACE_CFG = interface/atlink.cfg
TARGET_CFG 	  = target/at32f415xx.cfg

#######################################
# GCC print float Variable
#######################################

# PRINT_FLOAT = -u _printf_float


######################################
# User's Source
######################################
# C sources
export USER_C_SOURCES = \
# $(CURRENT_DIR)/$(USERCODEDIR)/Src/syscalls.c \
# $(CURRENT_DIR)/$(USERCODEDIR)/Src/usr_gpio.c \
# $(CURRENT_DIR)/$(USERCODEDIR)/Src/usr_uart.c \
# $(CURRENT_DIR)/$(USERCODEDIR)/Src/usr_spi.c \
# $(CURRENT_DIR)/$(USERCODEDIR)/Src/usr_prot.c \
# $(CURRENT_DIR)/$(USERCODEDIR)/Src/usr_system.c \
# $(CURRENT_DIR)/$(USERCODEDIR)/Src/dev_flash.c \
# $(CURRENT_DIR)/$(USERCODEDIR)/Src/key_process.c 

# C includes
export USER_C_INCLUDES = \
$(CURRENT_DIR)/$(USERCODEDIR)/Inc 


#######################################
# flash download and verify
#######################################

OPENOCD_FLASH = --search $(Scripts_PATH) \
				--file $(INTERFACE_CFG) \
				--file $(TARGET_CFG) \
				--command init \
				--command "flash write_image erase $(SUBDIR)/$(BUILD_DIR)/$(TARGET).bin" \
				--command "program $(SUBDIR)/$(BUILD_DIR)/$(TARGET).bin exit 0x08000000" \
				--command exit


install:
	@echo $(echo_param) "\033[43;30m USE OpenOCD Bootload to MCU \033[0m"
ifdef OpenOCD_PATH
	$(OpenOCD_PATH)/openocd $(OPENOCD_FLASH)
else
	openocd $(OPENOCD_FLASH)
endif

#######################################
# firmware start
#######################################
OPENOCD_START = --search $(Scripts_PATH) \
				--file $(INTERFACE_CFG) \
				--file $(TARGET_CFG) \
				--command init \
				--command "reset run" \
				--command shutdown

run:
	@echo $(echo_param) "\033[42;37m OpenOCD PROGRAM Running \033[0m"
ifdef OpenOCD_PATH
	$(OpenOCD_PATH)/openocd $(OPENOCD_START)
else
	openocd $(OPENOCD_START)
endif


#######################################
# firmware restart
#######################################
reset: run
# ifeq "$(PORT)" "SWD" # check port is SWD
# 	STM32_Programmer_CLI --connect port=$(PORT) -rst
# else
# 	@echo $(echo_param) "\033[1m The following commands are available only with the JTAG/SWD debug port. \033[0m"
# 	@echo $(echo_param) "\033[1m check the document page 58/93 : www.st.com/resource/en/user_manual/dm00403500-stm32cubeprogrammer-software-description-stmicroelectronics.pdf \033[0m"
# endif

rst: reset

#######################################
# firmware Erase
#######################################
erase:
	@echo $(echo_param) "\033[1m Command Not Found \033[0m"

#######################################
# compile & flash download & start
#######################################
ZENBU: \
	all \
	install \
	go

change2EN:
	@chcp 437

change2TW:
	@chcp 950

all: $(BUILDSUBDIR)

$(BUILDSUBDIR):
	@echo $(echo_param) "\033[1;47;31m  =====> $(@:build-%=%) \033[0m"
	@$(MAKE) -C $(@:build-%=%) $(JOB) $(mk_noprint_dir)
	@echo $(echo_param) "\033[1;47;31m  <===== $(@:build-%=%) \033[0m"


#######################################
# clean up
#######################################
clean: $(CLEANSUBDIR)

$(CLEANSUBDIR):
	@echo $(echo_param) "\033[1;33;7m Clean ===============> $(@:clean-%=%)'s build \033[0m"
	@$(MAKE) -C $(@:clean-%=%) clean $(mk_noprint_dir)
	@echo $(echo_param) "\033[1;33m build folder is cleaned <==== $(@:clean-%=%) \033[0m"


# ZENBU will now be the target that is run if "make" is executed and no target is specified.
.DEFAULT_GOAL := ZENBU

.PHONY: ZENBU install go reset all


#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

# *** EOF ***


