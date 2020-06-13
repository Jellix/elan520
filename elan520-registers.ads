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
--  Definitions for the AMD Elan 520 embedded Microprozessor          --
------------------------------------------------------------------------

with Elan520.Basic_Types;

package Elan520.Registers is

   --  type for Address_Decode_Register IO_Hole_Dest
   type ISA_Space_Destination is  (External_GP, PCI_Bus);
   for  ISA_Space_Destination use (External_GP => 0, PCI_Bus => 1);

   --  contents of the address control register at 16#80# of the MMCR
   type Address_Decode_Control is
      record
         UART1        : Basic_Types.Negative_Bit;
         UART2        : Basic_Types.Negative_Bit;
         RTC          : Basic_Types.Negative_Bit;
         IO_Hole_Dest : ISA_Space_Destination;
         WPV_Int      : Basic_Types.Positive_Bit;
      end record;

   ADDRESS_DECODE_CONTROL_SIZE        : constant := 8;
   MMCR_OFFSET_ADDRESS_DECODE_CONTROL : constant := 16#80#;

   for Address_Decode_Control use
      record
         UART1        at 0 range 0 .. 0;
         UART2        at 0 range 1 .. 1;
         RTC          at 0 range 2 .. 2;
         --  bit 3 is reserved
         IO_Hole_Dest at 0 range 4 .. 4;
         --  bit 5 & 6 are reserved
         WPV_Int      at 0 range 7 .. 7;
      end record;
   for Address_Decode_Control'Size use ADDRESS_DECODE_CONTROL_SIZE;

end Elan520.Registers;
