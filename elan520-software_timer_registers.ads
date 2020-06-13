------------------------------------------------------------------------
--  Copyright (C) 2005-2020 by <ada.rocks@jlfencey.com>               --
--                                                                    --
--  This work is free. You can redistribute it and/or modify it under --
--  the terms of the Do What The Fuck You Want To Public License,     --
--  Version 2, as published by Sam Hocevar. See the LICENSE file for  --
--  more details.                                                     --
------------------------------------------------------------------------
pragma License (Unrestricted);

------------------------------------------------------------------------
--  AMD Élan(tm) SC 520 embedded microprocessor                       --
--  MMCR -> Software Timer Registers                                  --
--                                                                    --
--  reference: User's Manual Chapter 18,                              --
--             Register Set Manual Chapter 15                         --
------------------------------------------------------------------------

package Elan520.Software_Timer_Registers is

   USEC_IN_MSEC : constant := 1_000;

   --  used in counter register stuff
   subtype Milliseconds is Integer range 0 .. 2**16 - 1;
   subtype Microseconds is Integer range 0 .. USEC_IN_MSEC - 1;

   --  maximum value which can be read (65535ms + 999us)
   subtype Full_Microseconds is Integer range
     0 .. USEC_IN_MSEC * Milliseconds'Last + Microseconds'Last;

   --  used in configuration register (timer calibration)
   type Base_Frequency is (MHz_33_333, MHz_33_000);
   for Base_Frequency use (MHz_33_333 => 2#0#,
                           MHz_33_000 => 2#1#);

   ---------------------------------------------------------------------
   -- Software Timer Millisecond Count (SWTMRMILLI)                   --
   -- Memory Mapped, Read Only                                        --
   -- MMCR Offset C60h                                                --
   --                                                                 --
   -- Software Timer Microsecond Count (SWTMRMICRO)                   --
   -- Memory Mapped, Read Only                                        --
   -- MMCR Offset C62h                                                --
   ---------------------------------------------------------------------
   --  because  it  would  be  quite  stupid  to  declare both registers
   --  independent  from  each  other (which would force us to read each
   --  single  register individually which does not make sense unless we
   --  care about the timing of _internal_ processor bus cycles), let us
   --  declare the type as if this would be one single (32-bit-)register
   --  only
   --  this easily makes sure that with each reading a correct result is
   --  delivered (see note on side effect next)
   --  SIDEEFFECT: the  milliseconds  counter Ms_Cnt is reset to zero on
   --              reads
   MMCR_OFFSET_TIMER : constant := 16#C60#;
   TIMER_SIZE        : constant := 32;

   type Timer is
      record
         --  milliseconds counter (read first)
         Ms_Cnt : Milliseconds;
         --  microseconds counter (latched when Ms_Cnt is read)
         Us_Cnt : Microseconds;
      end record;

   for Timer use
      record
         Ms_Cnt at 0 range  0 .. 15;  --  at MMCR + 16#C60#
         Us_Cnt at 0 range 16 .. 25;  --  at MMCR + 16#C62#
         --  bits 26 .. 31 are reserved
      end record;

   for Timer'Size use TIMER_SIZE;


   ---------------------------------------------------------------------
   -- Software Timer Configuration (SWTMRCFG)                         --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset C64h                                                --
   ---------------------------------------------------------------------
   MMCR_OFFSET_CONFIGURATION : constant := 16#C64#;
   CONFIGURATION_SIZE        : constant := 8;

   type Configuration is
      record
         Xtal_Freq : Base_Frequency;
      end record;

   for Configuration use
      record
         Xtal_Freq at 0 range 0 .. 0;
         --  bits 1 .. 7 are reserved
      end record;

   for Configuration'Size use CONFIGURATION_SIZE;

   function To_Microseconds (Timer_Read : in Timer)
     return Full_Microseconds;
   pragma Pure_Function (To_Microseconds);

end Elan520.Software_Timer_Registers;
