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
--  MMCR -> General Purpose Bus Controller Registers                  --
--                                                                    --
--  reference: User's Manual Chapter 13,                              --
--             Register Set Manual Chapter 10                         --
------------------------------------------------------------------------

with Elan520.Basic_Types;

package Elan520.GP_Bus_Controller_Registers is

   --  # of available chip select signals
   type Chip_Selects is range 0 .. 7;

   --  type for signal offset, pulse width and recovery time
   type Cycle_Length is range 1 .. 256; --  biased representation

   for Cycle_Length'Size use 8;


   --  chipselect qualifier
   type CS_Qualifier is (None,
                         Write_Strobes,
                         Read_Strobes,
                         Both_Strobes);

   for CS_Qualifier use (None          => 2#00#,
                         Write_Strobes => 2#01#,
                         Read_Strobes  => 2#10#,
                         Both_Strobes  => 2#11#);

   for CS_Qualifier'Size use 2;


   --  (default) data width for chipselects
   type CS_Data_Width is (Byte, Word);

   for CS_Data_Width use (Byte => 2#0#,
                          Word => 2#1#);

   for CS_Data_Width'Size use 1;


   ---------------------------------------------------------------------
   -- GP Echo Mode (GPECHO)                                           --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset C00h                                                --
   ---------------------------------------------------------------------
   MMCR_OFFSET_GP_ECHO_MODE : constant := 16#C00#;
   GP_ECHO_MODE_SIZE        : constant := 8;

   type GP_Echo_Mode is
      record
         GP_Echo : Basic_Types.Positive_Bit;
      end record;

   for GP_Echo_Mode use
      record
         GP_Echo at 0 range 0 .. 0;
         --  bits 1 .. 7 are reserved
      end record;

   for GP_Echo_Mode'Size use GP_ECHO_MODE_SIZE;


   ---------------------------------------------------------------------
   -- GP Chip Select Data Width (GPCSDW)                              --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset C01h                                                --
   ---------------------------------------------------------------------
   MMCR_OFFSET_GP_CS_DATA_WIDTH : constant := 16#C01#;
   GP_CS_DATA_WIDTH_SIZE        : constant := 8;

   type GP_CS_Data_Width is array (Chip_Selects) of CS_Data_Width;
   pragma Pack (GP_CS_Data_Width);
   for GP_CS_Data_Width'Size use GP_CS_DATA_WIDTH_SIZE;


   ---------------------------------------------------------------------
   -- GP Chip Select Qualification (GPCSQUAL)                         --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset C02h                                                --
   ---------------------------------------------------------------------
   MMCR_OFFSET_GP_CS_QUALIFICATION : constant := 16#C02#;
   GP_CS_QUALIFICATION_SIZE        : constant := 16;

   type GP_CS_Qualification is array (Chip_Selects) of CS_Qualifier;
   pragma Pack (GP_CS_Qualification);
   for GP_CS_Qualification'Size use GP_CS_QUALIFICATION_SIZE;


   ---------------------------------------------------------------------
   -- GP Chip Select Recovery Time (GPCSRT)                           --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset C08h                                                --
   --                                                                 --
   -- GP Chip Select Pulse Width (GPCSPW)                             --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset C09h                                                --
   --                                                                 --
   -- GP Chip Select Offset (GPCSOFF)                                 --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset C0Ah                                                --
   --                                                                 --
   -- GP Read Pulse Width (GPRDW)                                     --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset C0Bh                                                --
   --                                                                 --
   -- GP Read Offset (GPRDOFF)                                        --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset C0Ch                                                --
   --                                                                 --
   -- GP Write Pulse Width (GPWRW)                                    --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset C0Dh                                                --
   --                                                                 --
   -- GP Write Offset (GPWROFF)                                       --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset C0Eh                                                --
   --                                                                 --
   -- GPALE Pulse Width (GPALEW)                                      --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset C0Fh                                                --
   --                                                                 --
   -- GPALE Offset (GPALEOFF)                                         --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset C10h                                                --
   ---------------------------------------------------------------------
   MMCR_OFFSET_GP_CS_RECOVERY_TIME  : constant := 16#C08#;
   MMCR_OFFSET_GP_CS_PULSE_WIDTH    : constant := 16#C09#;
   MMCR_OFFSET_GP_CS_OFFSET         : constant := 16#C0A#;
   MMCR_OFFSET_GP_READ_PULSE_WIDTH  : constant := 16#C0B#;
   MMCR_OFFSET_GP_READ_OFFSET       : constant := 16#C0C#;
   MMCR_OFFSET_GP_WRITE_PULSE_WIDTH : constant := 16#C0D#;
   MMCR_OFFSET_GP_WRITE_OFFSET      : constant := 16#C0E#;
   MMCR_OFFSET_GP_ALE_PULSE_WIDTH   : constant := 16#C0F#;
   MMCR_OFFSET_GP_ALE_OFFSET        : constant := 16#C10#;

   subtype GP_CS_Recovery_Time  is Cycle_Length;
   subtype GP_CS_Pulse_Width    is Cycle_Length;
   subtype GP_CS_Offset         is Cycle_Length;
   subtype GP_Read_Pulse_Width  is Cycle_Length;
   subtype GP_Read_Offset       is Cycle_Length;
   subtype GP_Write_Pulse_Width is Cycle_Length;
   subtype GP_Write_Offset      is Cycle_Length;
   subtype GP_ALE_Pulse_Width   is Cycle_Length;
   subtype GP_ALE_Offset        is Cycle_Length;

end Elan520.GP_Bus_Controller_Registers;
