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
--  Memory Mapped Configuration Registers (MMCR)                      --
------------------------------------------------------------------------

with System.Storage_Elements; -- we need address conversions

with Elan520.CPU_Registers;
with Elan520.GP_Bus_Controller_Registers;
with Elan520.GP_Timer_Registers;
with Elan520.Programmable_Address_Region;
with Elan520.Registers;
with Elan520.Reset_Generation_Registers;
with Elan520.SDRAM_Controller_Registers;
with Elan520.SDRAM_Buffer_Control;
with Elan520.Software_Timer_Registers;

package Elan520.MMCR is

   use type System.Storage_Elements.Integer_Address;

   MMCR_BASE : constant System.Storage_Elements.Integer_Address
     := 16#FFFE_F000#;

   ---------------------------------------------------------------------
   -- CHAPTER 2 - System Address Mapping Registers ---------------------
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   Add_Dec_Ctl : Registers.Address_Decode_Control;

   pragma Atomic (Add_Dec_Ctl);
   pragma Import (Convention => Assembler, Entity => Add_Dec_Ctl);

   for Add_Dec_Ctl'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + Registers.MMCR_OFFSET_ADDRESS_DECODE_CONTROL);

   ---------------------------------------------------------------------
   PAR : Programmable_Address_Region.PAR_Info;

   --  pragma Atomic_Components (PAR);
   pragma Volatile (PAR);
   pragma Import (Convention => Assembler, Entity => PAR);

   for PAR'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + Programmable_Address_Region.MMCR_OFFSET_PAR_INFO);


   ---------------------------------------------------------------------
   -- CHAPTER 3 - Reset Generation Registers ---------------------------
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   Sys_Info : Reset_Generation_Registers.System_Board_Information;

   pragma Atomic (Sys_Info);
   pragma Import (Convention => Assembler, Entity => Sys_Info);

   for Sys_Info'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + Reset_Generation_Registers.MMCR_OFFSET_SYS_INFO);

   ---------------------------------------------------------------------
   Res_Cfg : Reset_Generation_Registers.Reset_Configuration;

   pragma Atomic (Res_Cfg);
   pragma Import (Convention => Assembler, Entity => Res_Cfg);

   for Res_Cfg'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + Reset_Generation_Registers.MMCR_OFFSET_RES_CFG);

   ---------------------------------------------------------------------
   Res_Sta : Reset_Generation_Registers.Reset_Status;

   pragma Atomic (Res_Sta);
   pragma Import (Convention => Assembler, Entity => Res_Sta);

   for Res_Sta'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + Reset_Generation_Registers.MMCR_OFFSET_RES_STA);


   ---------------------------------------------------------------------
   -- CHAPTER 4 - Am5x86 CPU MMCR Registers ----------------------------
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   Rev_Id : CPU_Registers.Revision_Id;

   pragma Atomic (Rev_Id);
   pragma Import (Convention => Assembler, Entity => Rev_Id);

   for Rev_Id'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + CPU_Registers.MMCR_OFFSET_REVISION_ID);

   ---------------------------------------------------------------------
   CPU_Ctl : CPU_Registers.CPU_Control;

   pragma Atomic (CPU_Ctl);
   pragma Import (Convention => Assembler, Entity => CPU_Ctl);

   for CPU_Ctl'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + CPU_Registers.MMCR_OFFSET_CPU_CONTROL);


   ---------------------------------------------------------------------
   -- CHAPTER 7 - SDRAM Controller Registers ---------------------------
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   DRC_Ctl : SDRAM_Controller_Registers.SDRAM_Control;

   pragma Atomic (DRC_Ctl);
   pragma Import (Convention => Assembler, Entity => DRC_Ctl);

   for DRC_Ctl'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            SDRAM_Controller_Registers.MMCR_OFFSET_SDRAM_CONTROL);

   ---------------------------------------------------------------------
   DRC_Tm_Ctl : SDRAM_Controller_Registers.SDRAM_Timing_Control;

   pragma Atomic (DRC_Tm_Ctl);
   pragma Import (Convention => Assembler, Entity => DRC_Tm_Ctl);

   for DRC_Tm_Ctl'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            SDRAM_Controller_Registers.
              MMCR_OFFSET_SDRAM_TIMING_CONTROL);

   ---------------------------------------------------------------------
   DRC_Cfg : SDRAM_Controller_Registers.SDRAM_Bank_Configuration;

   pragma Atomic (DRC_Cfg);
   pragma Import (Convention => Assembler, Entity => DRC_Cfg);

   for DRC_Cfg'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            SDRAM_Controller_Registers.
              MMCR_OFFSET_SDRAM_BANK_CONFIGURATION);

   ---------------------------------------------------------------------
   DRC_B_End_Adr : SDRAM_Controller_Registers.SDRAM_Bank_Ending_Address;

   pragma Atomic (DRC_B_End_Adr);
   pragma Import (Convention => Assembler, Entity => DRC_B_End_Adr);

   for DRC_B_End_Adr'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            SDRAM_Controller_Registers.
              MMCR_OFFSET_SDRAM_BANK_ENDING_ADDRESS);

   ---------------------------------------------------------------------
   ECC_Ctl : SDRAM_Controller_Registers.ECC_Control;

   pragma Atomic (ECC_Ctl);
   pragma Import (Convention => Assembler, Entity => ECC_Ctl);

   for ECC_Ctl'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + SDRAM_Controller_Registers.MMCR_OFFSET_ECC_CONTROL);

   ---------------------------------------------------------------------
   ECC_Sta : SDRAM_Controller_Registers.ECC_Status;

   pragma Atomic (ECC_Sta);
   pragma Import (Convention => Assembler, Entity => ECC_Sta);

   for ECC_Sta'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + SDRAM_Controller_Registers.MMCR_OFFSET_ECC_STATUS);

   ---------------------------------------------------------------------
   ECC_Ck_B_Pos : SDRAM_Controller_Registers.ECC_Check_Bit_Position;

   pragma Atomic (ECC_Ck_B_Pos);
   pragma Import (Convention => Assembler, Entity => ECC_Ck_B_Pos);

   for ECC_Ck_B_Pos'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            SDRAM_Controller_Registers.
              MMCR_OFFSET_ECC_CHECK_BIT_POSITION);

   ---------------------------------------------------------------------
   ECC_Ck_Test : SDRAM_Controller_Registers.ECC_Check_Code_Test;

   pragma Atomic (ECC_Ck_Test);
   pragma Import (Convention => Assembler, Entity => ECC_Ck_Test);

   for ECC_Ck_Test'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            SDRAM_Controller_Registers.MMCR_OFFSET_ECC_CHECK_CODE_TEST);

   ---------------------------------------------------------------------
   ECC_SB_Add : SDRAM_Controller_Registers.ECC_Single_Bit_Error_Address;

   pragma Atomic (ECC_SB_Add);
   pragma Import (Convention => Assembler, Entity => ECC_SB_Add);

   for ECC_SB_Add'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            SDRAM_Controller_Registers.
              MMCR_OFFSET_ECC_SINGLE_BIT_ERROR_ADDRESS);

   ---------------------------------------------------------------------
   ECC_MB_Add : SDRAM_Controller_Registers.ECC_Multi_Bit_Error_Address;

   pragma Atomic (ECC_MB_Add);
   pragma Import (Convention => Assembler, Entity => ECC_MB_Add);

   for ECC_MB_Add'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            SDRAM_Controller_Registers.
              MMCR_OFFSET_ECC_MULTI_BIT_ERROR_ADDRESS);


   ---------------------------------------------------------------------
   -- CHAPTER 8 - Write Buffer and Read Buffer Registers ---------------
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   DB_Ctl : SDRAM_Buffer_Control.SDRAM_Buffer_Control;

   pragma Atomic (DB_Ctl);
   pragma Import (Convention => Assembler, Entity => DB_Ctl);

   for DB_Ctl'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            SDRAM_Buffer_Control.MMCR_OFFSET_SDRAM_BUFFER_CONTROL);


   ---------------------------------------------------------------------
   -- CHAPTER 10 - General-Purpose Bus Controller Registers ------------
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   GP_Echo : GP_Bus_Controller_Registers.GP_Echo_Mode;

   pragma Atomic (GP_Echo);
   pragma Import (Convention => Assembler, Entity => GP_Echo);

   for GP_Echo'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            GP_Bus_Controller_Registers.MMCR_OFFSET_GP_ECHO_MODE);

   ---------------------------------------------------------------------
   GP_CS_Dw : GP_Bus_Controller_Registers.GP_CS_Data_Width;

   pragma Atomic (GP_CS_Dw);
   pragma Import (Convention => Assembler, Entity => GP_CS_Dw);

   for GP_CS_Dw'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            GP_Bus_Controller_Registers.MMCR_OFFSET_GP_CS_DATA_WIDTH);

   ---------------------------------------------------------------------
   GP_CS_Qual : GP_Bus_Controller_Registers.GP_CS_Qualification;

   pragma Atomic (GP_CS_Qual);
   pragma Import (Convention => Assembler, Entity => GP_CS_Qual);

   for GP_CS_Qual'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            GP_Bus_Controller_Registers.
              MMCR_OFFSET_GP_CS_QUALIFICATION);

   ---------------------------------------------------------------------
   GP_CS_Rt : GP_Bus_Controller_Registers.GP_CS_Recovery_Time;

   pragma Atomic (GP_CS_Rt);
   pragma Import (Convention => Assembler, Entity => GP_CS_Rt);

   for GP_CS_Rt'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            GP_Bus_Controller_Registers.
              MMCR_OFFSET_GP_CS_RECOVERY_TIME);

   ---------------------------------------------------------------------
   GP_CS_Pw : GP_Bus_Controller_Registers.GP_CS_Pulse_Width;

   pragma Atomic (GP_CS_Pw);
   pragma Import (Convention => Assembler, Entity => GP_CS_Pw);

   for GP_CS_Pw'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            GP_Bus_Controller_Registers.MMCR_OFFSET_GP_CS_PULSE_WIDTH);

   ---------------------------------------------------------------------
   GP_CS_Off : GP_Bus_Controller_Registers.GP_CS_Offset;

   pragma Atomic (GP_CS_Off);
   pragma Import (Convention => Assembler, Entity => GP_CS_Off);

   for GP_CS_Off'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            GP_Bus_Controller_Registers.MMCR_OFFSET_GP_CS_OFFSET);

   ---------------------------------------------------------------------
   GP_Rd_W : GP_Bus_Controller_Registers.GP_Read_Pulse_Width;

   pragma Atomic (GP_Rd_W);
   pragma Import (Convention => Assembler, Entity => GP_Rd_W);

   for GP_Rd_W'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            GP_Bus_Controller_Registers.
              MMCR_OFFSET_GP_READ_PULSE_WIDTH);

   ---------------------------------------------------------------------
   GP_Rd_Off : GP_Bus_Controller_Registers.GP_Read_Offset;

   pragma Atomic (GP_Rd_Off);
   pragma Import (Convention => Assembler, Entity => GP_Rd_Off);

   for GP_Rd_Off'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
           GP_Bus_Controller_Registers.MMCR_OFFSET_GP_READ_OFFSET);

   ---------------------------------------------------------------------
   GP_Wr_W : GP_Bus_Controller_Registers.GP_Write_Pulse_Width;

   pragma Atomic (GP_Wr_W);
   pragma Import (Convention => Assembler, Entity => GP_Wr_W);

   for GP_Wr_W'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            GP_Bus_Controller_Registers.
              MMCR_OFFSET_GP_WRITE_PULSE_WIDTH);

   ---------------------------------------------------------------------
   GP_Wr_Off : GP_Bus_Controller_Registers.GP_Write_Offset;

   pragma Atomic (GP_Wr_Off);
   pragma Import (Convention => Assembler, Entity => GP_Wr_Off);

   for GP_Wr_Off'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            GP_Bus_Controller_Registers.MMCR_OFFSET_GP_WRITE_OFFSET);

   ---------------------------------------------------------------------
   GP_Ale_W : GP_Bus_Controller_Registers.GP_ALE_Pulse_Width;

   pragma Atomic (GP_Ale_W);
   pragma Import (Convention => Assembler, Entity => GP_Ale_W);

   for GP_Ale_W'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            GP_Bus_Controller_Registers.MMCR_OFFSET_GP_ALE_PULSE_WIDTH);

   ---------------------------------------------------------------------
   GP_Ale_Off : GP_Bus_Controller_Registers.GP_ALE_Offset;

   pragma Atomic (GP_Ale_Off);
   pragma Import (Convention => Assembler, Entity => GP_Ale_Off);

   for GP_Ale_Off'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE +
            GP_Bus_Controller_Registers.MMCR_OFFSET_GP_ALE_OFFSET);


   ---------------------------------------------------------------------
   -- CHAPTER 14 - General Purpose Timer Registers ---------------------
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   GP_Tmr_Sta : GP_Timer_Registers.Status;

   pragma Atomic (GP_Tmr_Sta);
   pragma Import (Convention => Assembler, Entity => GP_Tmr_Sta);

   for GP_Tmr_Sta'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + GP_Timer_Registers.MMCR_OFFSET_STATUS);

   ---------------------------------------------------------------------
   GP_Tmr_0_Ctl : GP_Timer_Registers.Control;

   pragma Atomic (GP_Tmr_0_Ctl);
   pragma Import (Convention => Assembler, Entity => GP_Tmr_0_Ctl);

   for GP_Tmr_0_Ctl'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + GP_Timer_Registers.MMCR_OFFSET_T0_CONTROL);

   ---------------------------------------------------------------------
   GP_Tmr_0_Cnt : GP_Timer_Registers.Count;

   pragma Atomic (GP_Tmr_0_Cnt);
   pragma Import (Convention => Assembler, Entity => GP_Tmr_0_Cnt);

   for GP_Tmr_0_Cnt'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + GP_Timer_Registers.MMCR_OFFSET_T0_COUNT);


   ---------------------------------------------------------------------
   GP_Tmr_0_Max_Cmp_A : GP_Timer_Registers.Count;

   pragma Atomic (GP_Tmr_0_Max_Cmp_A);
   pragma Import (Convention => Assembler,
                  Entity     => GP_Tmr_0_Max_Cmp_A);

   for GP_Tmr_0_Max_Cmp_A'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + GP_Timer_Registers.MMCR_OFFSET_T0_MAX_A);


   ---------------------------------------------------------------------
   GP_Tmr_0_Max_Cmp_B : GP_Timer_Registers.Count;

   pragma Atomic (GP_Tmr_0_Max_Cmp_B);
   pragma Import (Convention => Assembler,
                  Entity     => GP_Tmr_0_Max_Cmp_B);

   for GP_Tmr_0_Max_Cmp_B'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + GP_Timer_Registers.MMCR_OFFSET_T0_MAX_B);


   ---------------------------------------------------------------------
   GP_Tmr_1_Ctl : GP_Timer_Registers.Control;

   pragma Atomic (GP_Tmr_1_Ctl);
   pragma Import (Convention => Assembler, Entity => GP_Tmr_1_Ctl);

   for GP_Tmr_1_Ctl'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + GP_Timer_Registers.MMCR_OFFSET_T1_CONTROL);

   ---------------------------------------------------------------------
   GP_Tmr_1_Cnt : GP_Timer_Registers.Count;

   pragma Atomic (GP_Tmr_1_Cnt);
   pragma Import (Convention => Assembler, Entity => GP_Tmr_1_Cnt);

   for GP_Tmr_1_Cnt'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + GP_Timer_Registers.MMCR_OFFSET_T1_COUNT);


   ---------------------------------------------------------------------
   GP_Tmr_1_Max_Cmp_A : GP_Timer_Registers.Count;

   pragma Atomic (GP_Tmr_1_Max_Cmp_A);
   pragma Import (Convention => Assembler,
                  Entity     => GP_Tmr_1_Max_Cmp_A);

   for GP_Tmr_1_Max_Cmp_A'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + GP_Timer_Registers.MMCR_OFFSET_T1_MAX_A);


   ---------------------------------------------------------------------
   GP_Tmr_1_Max_Cmp_B : GP_Timer_Registers.Count;

   pragma Atomic (GP_Tmr_1_Max_Cmp_B);
   pragma Import (Convention => Assembler,
                  Entity     => GP_Tmr_1_Max_Cmp_B);

   for GP_Tmr_1_Max_Cmp_B'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + GP_Timer_Registers.MMCR_OFFSET_T1_MAX_B);


   ---------------------------------------------------------------------
   GP_Tmr_2_Ctl : GP_Timer_Registers.Control_2;

   pragma Atomic (GP_Tmr_2_Ctl);
   pragma Import (Convention => Assembler, Entity => GP_Tmr_2_Ctl);

   for GP_Tmr_2_Ctl'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + GP_Timer_Registers.MMCR_OFFSET_T2_CONTROL);

   ---------------------------------------------------------------------
   GP_Tmr_2_Cnt : GP_Timer_Registers.Count;

   pragma Atomic (GP_Tmr_2_Cnt);
   pragma Import (Convention => Assembler, Entity => GP_Tmr_2_Cnt);

   for GP_Tmr_2_Cnt'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + GP_Timer_Registers.MMCR_OFFSET_T2_COUNT);


   ---------------------------------------------------------------------
   GP_Tmr_2_Max_Cmp_A : GP_Timer_Registers.Count;

   pragma Atomic (GP_Tmr_2_Max_Cmp_A);
   pragma Import (Convention => Assembler,
                  Entity     => GP_Tmr_2_Max_Cmp_A);

   for GP_Tmr_2_Max_Cmp_A'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + GP_Timer_Registers.MMCR_OFFSET_T2_MAX_A);


   ---------------------------------------------------------------------
   -- CHAPTER 15 - Software Timer Registers ----------------------------
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   Sw_Timer : Software_Timer_Registers.Timer;

   pragma Atomic (Sw_Timer);
   pragma Import (Convention => Assembler, Entity => Sw_Timer);

   for Sw_Timer'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + Software_Timer_Registers.MMCR_OFFSET_TIMER);

   ---------------------------------------------------------------------
   Sw_Tmr_Cfg : Software_Timer_Registers.Configuration;

   pragma Atomic (Sw_Tmr_Cfg);
   pragma Import (Convention => Assembler, Entity => Sw_Tmr_Cfg);

   for Sw_Tmr_Cfg'Address use
     System.Storage_Elements.To_Address
       (MMCR_BASE + Software_Timer_Registers.MMCR_OFFSET_CONFIGURATION);


end Elan520.MMCR;
