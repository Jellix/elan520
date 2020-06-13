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
--  MMCR -> Programmable Address Region Registers (PAR)               --
------------------------------------------------------------------------

with Elan520.Basic_Types;

package Elan520.Programmable_Address_Region is

   --  type for Target of definition in a programmable address region
   type Window_Target is  (Window_Disabled,  -- no memory window
                           GP_Bus_IO,        -- GP bus I/O access
                           GP_Bus_Memory,    -- GP bus memory access
                           PCI_Bus,          -- access to PCI bus
                           Boot_CS,          -- Boot ROM ChipSelect
                           Rom_CS_1,         -- Rom Area 1 Chipselect
                           Rom_CS_2,         -- Rom Area 2 Chipselect
                           SD_Ram);          -- SDRAM type access
   --  its hardware representation
   for  Window_Target use (Window_Disabled => 2#000#,
                           GP_Bus_IO       => 2#001#,
                           GP_Bus_Memory   => 2#010#,
                           PCI_Bus         => 2#011#,
                           Boot_CS         => 2#100#,
                           Rom_CS_1        => 2#101#,
                           Rom_CS_2        => 2#110#,
                           SD_Ram          => 2#111#);
   for Window_Target'Size use 3;

   --  the ATTR bits in the PAR register when type is memory
   type Memory_Attribute is
      record
         Write_Protected : Basic_Types.Positive_Bit;
         Cacheable       : Basic_Types.Negative_Bit;
         Executable      : Basic_Types.Negative_Bit;
      end record;
   --  its hardware representation
   for Memory_Attribute use
      record
         Write_Protected at 0 range 0 .. 0;
         Cacheable       at 0 range 1 .. 1;
         Executable      at 0 range 2 .. 2;
      end record;
   for Memory_Attribute'Size use 3;

   --  the ATTR bits in the PAR register when type is I/O
   --  just raises the GP_IO_CS signals 0 through 7
   type Chip_Select_Signal is range 0 .. 7;
   for  Chip_Select_Signal'Size use 3;

   type Page_Size is  (Four_Ki_Byte, Sixty_Four_Ki_Byte);
   for  Page_Size use (Four_Ki_Byte       => 0,
                       Sixty_Four_Ki_Byte => 1);
   for  Page_Size'Size use 1;

   --  IO pages, granularity is 1 byte, size max. 512 bytes
   type IO_Page_Start_Address is range 0 .. 2**16 - 1;
   type IO_Page_Region_Size   is range 1 .. 2**9;

   type IO_Page is
      record
         Start_Address : IO_Page_Start_Address;
         Region_Size   : IO_Page_Region_Size;
      end record;
   --  its hardware representation
   for IO_Page use
      record
         Start_Address at 0 range  0 .. 15;
         Region_Size   at 0 range 16 .. 24;
      end record;
   for IO_Page'Size use 25;

   --  "small" memory pages (128 * 4 Ki => 512 KiBytes)
   type Mem_Page_4Ki_Start_Address is range 0 .. 2**18 - 1;
   type Mem_Page_4Ki_Region_Size   is range 1 .. 2**7;

   type Mem_Page_4Ki is
      record
         --  start  address  in 4 Ki blocks (means, the value here reflects
         --  address lines A12 - A29 (18 bits))
         Start_Address : Mem_Page_4Ki_Start_Address;
         --  size of region in 4K blocks (7 bits => 128 max.)
         Region_Size   : Mem_Page_4Ki_Region_Size;
      end record;
   --  its hardware representation
   for Mem_Page_4Ki use
      record
         Start_Address at 0 range  0 .. 17;
         Region_Size   at 0 range 18 .. 24;
      end record;
   for Mem_Page_4Ki'Size use 25;

   --  "large" memory pages (2048 * 64 Ki => max. 128 MiBytes)
   type Mem_Page_64Ki_Start_Address is range 0 .. 2**14 - 1;
   type Mem_Page_64Ki_Region_Size   is range 1 .. 2**11;

   type Mem_Page_64Ki is
      record
         --  start  address in 64 Ki blocks (means, the value here reflects
         --  A16 - A29 (14 bits))
         Start_Address : Mem_Page_64Ki_Start_Address;
         Region_Size   : Mem_Page_64Ki_Region_Size;
      end record;
   --  its hardware representation
   for Mem_Page_64Ki use
      record
         Start_Address at 0 range  0 .. 13;
         Region_Size   at 0 range 14 .. 24;
      end record;
   for Mem_Page_64Ki'Size use 25;

   --  type for a programmable address region register
   type Programmable_Address_Region (
       Target : Window_Target := Window_Disabled;
       Pg_Sz  : Page_Size     := Four_Ki_Byte) is
      record
         case Target is
            when Window_Disabled =>
               null;
            when GP_Bus_IO | PCI_Bus =>
               IO_Attr        : Chip_Select_Signal;
               Sz_St_Addr_IO  : IO_Page;
            when GP_Bus_Memory | Boot_CS | Rom_CS_1 | Rom_CS_2 | SD_Ram =>
               Mem_Attr : Memory_Attribute;

               case Pg_Sz is
                  when Four_Ki_Byte =>
                     Sz_St_Addr_4Ki  : Mem_Page_4Ki;
                  when Sixty_Four_Ki_Byte =>
                     Sz_St_Addr_64Ki : Mem_Page_64Ki;
               end case;
         end case;
      end record;
   --  its hardware representation
   PROGRAMMABLE_ADDRESS_REGION_SIZE : constant := 32;
   for Programmable_Address_Region use
      record
         --  discriminants
         Target          at 0 range 29 .. 31;
         Pg_Sz           at 0 range 25 .. 25;
         --  variable parts depending on discriminants
         --  I/O type memory regions
         IO_Attr         at 0 range 26 .. 28;
         Sz_St_Addr_IO   at 0 range  0 .. 24;
         --  memory type memory regions
         Mem_Attr        at 0 range 26 .. 28;
         Sz_St_Addr_4Ki  at 0 range  0 .. 24;
         Sz_St_Addr_64Ki at 0 range  0 .. 24;
      end record;
   for Programmable_Address_Region'Size use
       PROGRAMMABLE_ADDRESS_REGION_SIZE;
   pragma Atomic (Programmable_Address_Region);

   PAR_ENTRIES          : constant := 16;
   PAR_INFO_SIZE        : constant := PAR_ENTRIES *
                                      PROGRAMMABLE_ADDRESS_REGION_SIZE;
   MMCR_OFFSET_PAR_INFO : constant := 16#88#;
   type PAR_Info is
       array (0 .. PAR_ENTRIES - 1) of Programmable_Address_Region;
   for  PAR_Info'Size use PAR_INFO_SIZE;

end Elan520.Programmable_Address_Region;
