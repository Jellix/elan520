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
--  MMCR -> SDRAM Buffer Control Registers (DBCTL)                    --
------------------------------------------------------------------------

with Elan520.Basic_Types;

package Elan520.SDRAM_Buffer_Control is

   ---------------------------------------------------------------------
   -- SDRAM Buffer Control (DBCTL)                                    --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset 40h                                                 --
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   --  sub types for SDRAM_Buffer_Control

   --  water mark, unit is DWords
   type Write_Buffer_Watermark is (Twenty_Eight,
                                   Twenty_Four,
                                   Sixteen,
                                   Eight);
   for  Write_Buffer_Watermark use (Twenty_Eight => 2#00#,
                                    Twenty_Four  => 2#01#,
                                    Sixteen      => 2#10#,
                                    Eight        => 2#11#);
   for  Write_Buffer_Watermark'Size use 2;

   DEFAULT_WRITE_BUFFER_WATERMARK :
       constant Write_Buffer_Watermark := Twenty_Eight;

   ---------------------------------------------------------------------
   --  SDRAM Buffer Control at MMCR offset 16#40#
   ---------------------------------------------------------------------
   MMCR_OFFSET_SDRAM_BUFFER_CONTROL : constant := 16#40#;
   SDRAM_BUFFER_CONTROL_SIZE        : constant := 8;

   type SDRAM_Buffer_Control is
   record
      --  shall we use the Write Buffer at all?
      WB           : Basic_Types.Positive_Bit;
      --  writing an Enabled forces the write buffer to be flushed, a
      --  Disabled indicates that the flush cycle has been completed
      WB_Flush     : Basic_Types.Positive_Bit;
      --  the write buffer water mark
      WB_Watermark : Write_Buffer_Watermark;
      --  shall we enable the read ahead feature?
      --  should be disabled during RAM test or sizing on boot
      Read_Ahead   : Basic_Types.Positive_Bit;
   end record;

   for SDRAM_Buffer_Control use
   record
      WB           at 0 range 0 .. 0;
      WB_Flush     at 0 range 1 .. 1;
      WB_Watermark at 0 range 2 .. 3;
      Read_Ahead   at 0 range 4 .. 4;
      --  bits [5:7] are reserved
   end record;

   for SDRAM_Buffer_Control'Size use SDRAM_BUFFER_CONTROL_SIZE;

end Elan520.SDRAM_Buffer_Control;
