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
--  MMCR -> Reset Generation Registers                                --
--                                                                    --
--  reference: Register Set Manual Chapter 4                          --
------------------------------------------------------------------------

with Elan520.Basic_Types;

package Elan520.Reset_Generation_Registers is

   ---------------------------------------------------------------------
   -- System Board Information (SYSINFO)                              --
   -- Memory Mapped, Read Only                                        --
   -- MMCR Offset D70h                                                --
   ---------------------------------------------------------------------
   MMCR_OFFSET_SYS_INFO : constant := 16#D70#;
   SYS_INFO_SIZE        : constant := 8;

   type System_Board_Information is mod 2**8;
   for System_Board_Information'Size use SYS_INFO_SIZE;

   ---------------------------------------------------------------------
   -- Reset Configuration (RESCFG)                                    --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset D72h                                                --
   ---------------------------------------------------------------------
   MMCR_OFFSET_RES_CFG : constant := 16#D72#;
   RES_CFG_SIZE        : constant := 8;

   type Reset_Configuration is
      record
         Sys_Rst     : Basic_Types.Positive_Bit;
         GP_Rst      : Basic_Types.Positive_Bit;
         Prg_Rst_Enb : Basic_Types.Positive_Bit;
         ICE_On_Rst  : Basic_Types.Positive_Bit;
      end record;

   for Reset_Configuration use
      record
         Sys_Rst     at 0 range 0 .. 0;
         GP_Rst      at 0 range 1 .. 1;
         Prg_Rst_Enb at 0 range 2 .. 2;
         ICE_On_Rst  at 0 range 3 .. 3;
         --  bits 4 .. 7 are reserved
      end record;

   for Reset_Configuration'Size use RES_CFG_SIZE;

   ---------------------------------------------------------------------
   -- Reset Status (RESSTA)                                           --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset D74h                                                --
   ---------------------------------------------------------------------
   MMCR_OFFSET_RES_STA : constant := 16#D74#;
   RES_STA_SIZE        : constant := 8;

   type Reset_Status is
      record
         Pwr_Good_Det : Basic_Types.Positive_Bit;
         Prg_Rst_Det  : Basic_Types.Positive_Bit;
         SD_Rst_Det   : Basic_Types.Positive_Bit;
         WDT_Rst_Det  : Basic_Types.Positive_Bit;
         ICE_S_Rst    : Basic_Types.Positive_Bit;
         ICE_H_Rst    : Basic_Types.Positive_Bit;
         SCP_Rst_Det  : Basic_Types.Positive_Bit;
      end record;

   for Reset_Status use
      record
         Pwr_Good_Det at 0 range 0 .. 0;
         Prg_Rst_Det  at 0 range 1 .. 1;
         SD_Rst_Det   at 0 range 2 .. 2;
         WDT_Rst_Det  at 0 range 3 .. 3;
         ICE_S_Rst    at 0 range 4 .. 4;
         ICE_H_Rst    at 0 range 5 .. 5;
         SCP_Rst_Det  at 0 range 6 .. 6;
         --  bit 7 is reserved;
      end record;

   for Reset_Status'Size use RES_STA_SIZE;

end Elan520.Reset_Generation_Registers;
