------------------------------------------------------------------------
--  Copyright (C) 2004-2020 by <ada.rocks@jlfencey.com>               --
--                                                                    --
--  This work is free. You can redistribute it and/or modify it under --
--  the terms of the Do What The Fuck You Want To Public License,     --
--  Version 2, as published by Sam Hocevar. See the LICENSE file for  --
--  more details.                                                     --
------------------------------------------------------------------------
pragma License (Unrestricted);

------------------------------------------------------------------------
--  AMD Élan(tm) SC 520 embedded microprocessor                       --
--  MMCR -> CPU Registers                                             --
--                                                                    --
--  reference: Register Set Manual, Chapter 4                         --
------------------------------------------------------------------------

package Elan520.CPU_Registers is

   ---------------------------------------------------------------------
   -- Elan(tm) SC520 Microcontroller Revision Id (REVID)              --
   -- Memory Mapped, Read only                                        --
   -- MMCR Offset 00h                                                 --
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   --  sub types for Revision_Id
   type CPU_Id   is range 0 .. 2**8 - 1;
   type Stepping is range 0 .. 2**4 - 1;

   --  the  only  known  constant  so  far, anything  else is an unknown
   --  processor type, check out http://www.amd.com for further types
   PRODUCT_ID_ELAN_520 : constant CPU_Id := 2#0000_0000#;

   ---------------------------------------------------------------------
   --  Revision ID at MMCR offset 16#00#
   ---------------------------------------------------------------------
   MMCR_OFFSET_REVISION_ID : constant := 16#00#;
   REVISION_ID_SIZE        : constant := 16;

   type Revision_Id is
      record
         Minor_Step : Stepping;
         Major_Step : Stepping;
         Product_Id : CPU_Id;
      end record;

   for Revision_Id use
      record
         Minor_Step at 0 range 0 ..  3;
         Major_Step at 0 range 4 ..  7;
         Product_Id at 0 range 8 .. 15;
      end record;

   for Revision_Id'Size use REVISION_ID_SIZE;

   ---------------------------------------------------------------------
   -- Am5x86(r) CPU Control (CPUCTL)                                  --
   -- Memory-Mapped, Read/Write                                       --
   -- MMCR Offset 02h                                                 --
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   --  sub types for CPU control register
   type CPU_Clock_Speed is  (MHz_100, MHz_133);
   for  CPU_Clock_Speed use (MHz_100 => 2#01#, MHz_133 => 2#10#);
   for  CPU_Clock_Speed'Size use 2;

   DEFAULT_CPU_CLOCK_SPEED : constant CPU_Clock_Speed := MHz_100;

   type Cache_Write_Mode is  (Write_Back, Write_Through);
   for  Cache_Write_Mode use (Write_Back    => 0,
                              Write_Through => 1);
   for  Cache_Write_Mode'Size use 1;

   DEFAULT_CACHE_WRITE_MODE :
       constant Cache_Write_Mode := Write_Through;

   ---------------------------------------------------------------------
   --  CPU Control at MMCR offset 16#02#
   ---------------------------------------------------------------------
   MMCR_OFFSET_CPU_CONTROL : constant := 16#02#;
   CPU_CONTROL_SIZE        : constant := 8;

   type CPU_Control is
      record
         Cpu_Clk_Spd   : CPU_Clock_Speed;
         Cache_Wr_Mode : Cache_Write_Mode;
      end record;

   for CPU_Control use
      record
         CPU_Clk_Spd   at 0 range 0 .. 1;
         Cache_Wr_Mode at 0 range 4 .. 4;
      end record;

   for CPU_Control'Size use CPU_CONTROL_SIZE;

end Elan520.CPU_Registers;
