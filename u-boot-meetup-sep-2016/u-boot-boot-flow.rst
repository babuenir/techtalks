:title: U-Boot Boot Flow - Under the hood
:author: BabuSubashChandar C
:skip-help: true
:data-transition-duration: 1500
:css: boot-flow.css


Introduction to boot sequence of an embedded target, then some insight
on the various function calls happening in U-Boot.

----

.. raw:: html

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">

:data-scale: 20
:id: title

**U-Boot Boot Flow** - Under the hood
=====================================

BabuSubashChandar C

babusubashchandar@zilogic.com

----

:data-scale: 1
:data-x: r4000
:data-y: r1800
:id: boot-flow

Typical Boot flow
=================


.. image:: typical-boot-flow.png


----


:data-x: r1200
:id: boot-methods

Boot Methods
============

* Bootloader from various locations (flash devices, sdcard, etc.)
* Kernel from various locations (flash, network, sdcard, usb, etc.)
* Filesystem from various locations (flash, network, sdcard, usb, etc.)

-----

:data-x: r1200
:data-y: r-1200
:id: parched-of-resources

Parched of Resources
====================

* Applications need memory management or Scheduling.
* Kernel requires timer & memory to operate.
* **Bootloader** loads Kernel with required resources.

----

:data-x: r0
:data-y: r-1200
:id: imnot-thirsty

I'm not thirsty
===============

.. code:: c

   #include <stdio.h>
   void main() {
       printf("helloworld");
   }

* Even a simple c program, requires a lot of setup to be done in
  prior.
* Setup stack |right| initialize global data |right| initialize read-only data.

.. |right| unicode:: 0x27BD .. right sign

----

:data-x: r1200
:data-y: r0
:id: ftf

First Things First
==================

* On POR, processor goes to RomBoot code.
* Looks for various options to get primary bootloader.
* Now primary bootloader loads U-Boot.

----

:data-x: r1200
:data-y: 2000
:data-next-step: starthere

:id: treasurehunt

Treasure Hunt
=============

.. image:: pirate.png

Here, map is the **Treasure** mate!!

----

:data-x: r1000
:data-y: r2400
:id: map

.. image:: u-boot-background.png
    :width: 1024
    :height: 764
    :align: center

----

:data-x: r-250
:data-y: r240
:data-scale: 0.15
:id: starthere

Start
=====

* Clears out icache, dcache and mmu tables if any.

arch/<arch>/cpu/soc/start.S |right| reset.

----

:data-x: r0
:data-y: r-200
:id: runtime-setup

Runtime setup
=============

* Setup the c runtime dependencies.
* Run lowlevel_init if any.
* Initialize the resources one by one.
* Calls board_init_f_alloc_reserve.

arch/arm/lib/crt0.S

----

:data-x: r5
:data-y: r-260
:id: common-init

Common initialization
=====================

* Sets up stack.
* Sets up global data.
* Sets up local data.
* Shows boot progress.

common/init/board_init.c

----

:data-x: r200
:data-y: r130
:id: init-seq

Initializations in Sequence
===========================

* A sequence of functions will be called one by one.
* Boot stage at this level will be marked.

common/board_f.c

----

:data-x: r160
:data-y: r70
:id: soc-init

SoC initialization
==================

* Initialize hardware timer.
* Initialize flash device with environment setup.
* Check for integrity of environment.

arch/<arch>/cpu/<soc-family>/<soc>.c

----

:data-x: r180
:data-y: r-180
:id: board-init

Board initialization
====================

* Common board related informations.
* CPU and CPU revision information.
* Information about the U-Boot itself.

common/board_f.c

arch/<arch>/cpu/<soc>/cpuinfo.c

board/<vendor>/<board>/<board>.c

----

:data-x: r200
:data-y: r20
:id: driver-init

Driver initialization
=====================

* Initialize serial device.
* Initialize console output.
* Initialize network device.

drivers/<device>/<device>.c

common/console.c

----

:data-x: r-460
:data-y: r360
:id: ram-init

RAM initialization
==================

* As per SoC memory map, DRAM will be initialized.
* U-Boot stores its global and local data in DRAM.
* Preserves the data store in memory from modifications.
* Configures the size of each area in stack.
* Displays the information about DRAM.

arch/<arch>/cpu/<soc>/<soc>.c
common/board_f.c

----

:data-x: r320
:data-y: r40
:id: autoboot

AutoBoot
========

* Attempts autoboot using bootcmd configured in environment.
* Gets the Image to memory.
* Finds the OS type.
* Consolidates the environment and global data to be passed. Places
  them in memory.
* Boots the OS; Jumps to OS. Control is no more available in U-Boot.

common/bootm.c

----

:data-x: r600
:data-y: r0
:id: calltrace

Detailed Calltrace
==================

* **reset** - arch/arm/cpu/pxa/start.S
* **cpu_init_crit** - arch/arm/cpu/pxa/start.S
* **board_init_f_alloc_reserve** - common/init/board_init.c
* **board_init_f_init_reserve** - common/init/board_init.c
* **show_boot_progress** - common/init/board_init.c
* **mark_bootstage** - common/board_f.c
* **initcall_run_list** - lib/initcall.c
* **timer_init** - arch/arm/cpu/pxa/timer.c
* **env_init** - common/env_flash.c
* **crc32_no_comp** - lib/crc32.c

----

Detailed Calltrace (contd.)
===========================

* **serial_init** - drivers/serial/serial.c
* **console_init_f** - common/console.c
* **dram_init** - board/gumstix/verdex/verdex.c
* **pxa2xx_dram_init** - arch/arm/cpu/pxa/pxa2xx.c
* **setup_machine** - common/board_f.c
* **setup_dram_config** - common/board_f.c
* **dram_init_banksize** - common/board_f.c
* **show_dram_config** - common/board_f.c
* **reloc_fdt** - common/board_f.c
* **setup_reloc** - common/board_f.c

----

Detailed Calltrace (contd.)
===========================

* **load_env** - common/bootm.c
* **autoboot** - common/bootm.c
* **do_bootm** - common/bootm.c
* **do_bootm_states** - common/bootm.c
* **bootm_find_os** - common/bootm.c
* **bootm_load_os** - common/bootm.c
* **boot_relocate_fdt** - common/bootm.c
* **boot_selected_os** - common/bootm.c

----


:data-x: r600
:data-y: r100

**Questions**
=============

----

:id: references
:data-x: r600
:data-y: r100

References
==========

* http://www.slideshare.net/HouchengLin/uboot-startup-sequence
* http://www.denx.de/wiki/pub/U-Boot/SummitELCE2015/U-Boot_startup_sequence.pdf
* Reading the source is healthy - http://git.denx.de/?p=u-boot.git

----

:id: followme
:data-x: r600


**Follow me**
=============

.. raw:: html

    <div class="followme">
    <table border=0 align="center">
    <tr><td>
    <i class="fa fa-linkedin-square"></i></td><td><p>&nbsp;&nbsp;babuenir</p></td></tr>
    <tr><td><i class="fa fa-twitter"></i><td><p>&nbsp;&nbsp;@babuenir</p></td></tr>
    <tr><td><i class="fa fa-github"></i><td><p>&nbsp;&nbsp;babuenir</p></td></tr></table></div>
