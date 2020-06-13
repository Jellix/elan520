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
--  MMCR -> SDRAM Controller Registers                                --
--                                                                    --
--  reference: Register Set Manual Chapter 7                          --
------------------------------------------------------------------------

with Elan520.Basic_Types;

package Elan520.SDRAM_Controller_Registers is

   ---------------------------------------------------------------------
   -- SDRAM Control (DRCCTL)                                          --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset 10h                                                 --
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   --  sub types for SDRAM_Control
   type Operation_Mode_Select is (Normal,
                                  NOP_Command,
                                  All_Banks_Precharge,
                                  Load_Mode_Register,
                                  Auto_Refresh);
   for  Operation_Mode_Select use (Normal              => 2#000#,
                                   NOP_Command         => 2#001#,
                                   All_Banks_Precharge => 2#010#,
                                   Load_Mode_Register  => 2#100#,
                                   Auto_Refresh        => 2#101#);
   for  Operation_Mode_Select'Size use 3;

   DEFAULT_OPERATION_MODE_SELECT :
       constant Operation_Mode_Select := Normal;

   --  unit is 7.8 microseconds
   type Refresh_Request_Speed is range 1 .. 4;
   for  Refresh_Request_Speed'Size use 2;

   DEFAULT_REFRESH_REQUEST_SPEED : constant Refresh_Request_Speed := 2;

   ---------------------------------------------------------------------
   --  SDRAM Control at MMCR offset 16#10#
   ---------------------------------------------------------------------
   MMCR_OFFSET_SDRAM_CONTROL : constant := 16#10#;
   SDRAM_CONTROL_SIZE        : constant := 8;

   type SDRAM_Control is
      record
         Op_Mode_Sel : Operation_Mode_Select;
         Rfsh        : Basic_Types.Positive_Bit;
         Rfsh_Spd    : Refresh_Request_Speed;
         Wb_Tst      : Basic_Types.Positive_Bit;
      end record;

   for SDRAM_Control use
      record
         Op_Mode_Sel at 0 range 0 .. 2;
         Rfsh        at 0 range 3 .. 3;
         Rfsh_Spd    at 0 range 4 .. 5;
         --  bit 6 is reserved
         Wb_Tst      at 0 range 7 .. 7;
      end record;

   for SDRAM_Control'Size use SDRAM_CONTROL_SIZE;

   ---------------------------------------------------------------------
   -- SDRAM Timing Control (DRCTMCTL)                                 --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset 12h                                                 --
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   --  subtypes for SDRAM Timing Contol
   type RAS_CAS_Delay is range 2 .. 4;
   for  RAS_CAS_Delay'Size use 2;
   DEFAULT_RAS_CAS_DELAY : constant RAS_CAS_Delay := 4;

   type RAS_Precharge_Delay is (Two_Cycles,  Three_Cycles,
                                Four_Cycles, Six_Cycles);
   for  RAS_Precharge_Delay use (Two_Cycles   => 2#00#,
                                 Three_Cycles => 2#01#,
                                 Four_Cycles  => 2#10#,
                                 Six_Cycles   => 2#11#);
   for  RAS_Precharge_Delay'Size use 2;
   DEFAULT_RAS_PRECHARGE_DELAY :
       constant RAS_Precharge_Delay := Four_Cycles;

   type CAS_Latency is range 2 .. 3;
   for  CAS_Latency'Size use 1;
   DEFAULT_CAS_LATENCY : constant CAS_Latency := 3;

   ---------------------------------------------------------------------
   --  SDRAM Timing Control at MMCR offset 16#12#
   ---------------------------------------------------------------------
   MMCR_OFFSET_SDRAM_TIMING_CONTROL : constant := 16#12#;
   SDRAM_TIMING_CONTROL_SIZE        : constant := 8;

   type SDRAM_Timing_Control is
      record
         Ras_Cas_Dly  : RAS_CAS_Delay;
         Ras_Pchg_Dly : RAS_Precharge_Delay;
         Cas_Lat      : CAS_Latency;
      end record;

   for SDRAM_Timing_Control use
      record
         Ras_Cas_Dly  at 0 range 0 .. 1;
         Ras_Pchg_Dly at 0 range 2 .. 3;
         Cas_Lat      at 0 range 4 .. 4;
         --  bits 5-7 are reserved
      end record;
   for SDRAM_Timing_Control'Size use SDRAM_TIMING_CONTROL_SIZE;

   ---------------------------------------------------------------------
   -- SDRAM Bank Configuration (DRCCFG)                               --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset 14h                                                 --
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   --  subtypes for SDRAM Bank Configuration
   type Bank_Count is (Two_Bank_Device, Four_Bank_Device);
   for  Bank_Count use (Two_Bank_Device  => 0,
                        Four_Bank_Device => 1);
   for  Bank_Count'Size use 1;

   type Column_Address_Width is range 8 .. 11;
   for  Column_Address_Width'Size use 2;

   type Bank_Descriptor is
      record
         Col_Width : Column_Address_Width;
         Bnk_Cnt   : Bank_Count;
      end record;
   for Bank_Descriptor use
      record
         Col_Width at 0 range 0 .. 1;
         --  bit 2 is reserved
         Bnk_Cnt   at 0 range 3 .. 3;
      end record;
   for Bank_Descriptor'Size use 4;

   ---------------------------------------------------------------------
   --  SDRAM Bank Configuration at MMCR offset 16#14#
   ---------------------------------------------------------------------
   MMCR_OFFSET_SDRAM_BANK_CONFIGURATION : constant := 16#14#;
   SDRAM_BANK_CONFIGURATION_SIZE        : constant := 16;

   type SDRAM_Bank_Configuration is
      record
         Bnk0 : Bank_Descriptor;
         Bnk1 : Bank_Descriptor;
         Bnk2 : Bank_Descriptor;
         Bnk3 : Bank_Descriptor;
      end record;

   for SDRAM_Bank_Configuration use
      record
         Bnk0 at 0 range  0 ..  3;
         Bnk1 at 0 range  4 ..  7;
         Bnk2 at 0 range  8 .. 11;
         Bnk3 at 0 range 12 .. 15;
      end record;

   for SDRAM_Bank_Configuration'Size use SDRAM_BANK_CONFIGURATION_SIZE;

   ---------------------------------------------------------------------
   -- SDRAM Bank 0 - 3 Ending Address (DRCBENDADR)                    --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset 18h                                                 --
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   --  subtypes for SDRAM Bank Ending Address
   type Ending_Address is range 0 .. 2**7 - 1;

   type Ending_Address_Descriptor is
      record
         End_Address : Ending_Address;
         Bnk         : Basic_Types.Positive_Bit;
      end record;

   for Ending_Address_Descriptor use
      record
         End_Address at 0 range 0 .. 6;
         Bnk         at 0 range 7 .. 7;
      end record;
   for Ending_Address_Descriptor'Size use 8;

   ---------------------------------------------------------------------
   --  SDRAM Bank Ending Address at MMCR offset 16#18#
   ---------------------------------------------------------------------
   MMCR_OFFSET_SDRAM_BANK_ENDING_ADDRESS : constant := 16#18#;
   SDRAM_BANK_ENDING_ADDRESS_SIZE        : constant := 32;

   type SDRAM_Bank_Ending_Address is
      record
         Bnk0 : Ending_Address_Descriptor;
         Bnk1 : Ending_Address_Descriptor;
         Bnk2 : Ending_Address_Descriptor;
         Bnk3 : Ending_Address_Descriptor;
      end record;

   for SDRAM_Bank_Ending_Address use
      record
         Bnk0 at 0 range  0 ..  7;
         Bnk1 at 0 range  8 .. 15;
         Bnk2 at 0 range 16 .. 23;
         Bnk3 at 0 range 24 .. 31;
      end record;

   for SDRAM_Bank_Ending_Address'Size use
       SDRAM_BANK_ENDING_ADDRESS_SIZE;

   ---------------------------------------------------------------------
   -- ECC Control (ECCCTL)                                            --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset 20h                                                 --
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   --  ECC Control at MMCR offset 16#20#
   ---------------------------------------------------------------------
   MMCR_OFFSET_ECC_CONTROL : constant := 16#20#;
   ECC_CONTROL_SIZE        : constant := 8;

   type ECC_Control is
      record
         ECC_All              : Basic_Types.Positive_Bit;
         Single_Bit_Interrupt : Basic_Types.Positive_Bit;
         Multi_Bit_Interrupt  : Basic_Types.Positive_Bit;
      end record;

   for ECC_Control use
      record
         ECC_All              at 0 range 0 .. 0;
         Single_Bit_Interrupt at 0 range 1 .. 1;
         Multi_Bit_Interrupt  at 0 range 2 .. 2;
         --  bits 3 to 7 are reserved
      end record;

   for ECC_Control'Size use ECC_CONTROL_SIZE;

   ---------------------------------------------------------------------
   -- ECC Status (ECCSTA)                                             --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset 21h                                                 --
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   --  ECC Status at MMCR offset 16#21#
   ---------------------------------------------------------------------
   MMCR_OFFSET_ECC_STATUS : constant := 16#21#;
   ECC_STATUS_SIZE        : constant := 8;

   type ECC_Status is
      record
         Single_Bit_Error : Basic_Types.Positive_Bit;
         Multi_Bit_Error  : Basic_Types.Positive_Bit;
      end record;

   for ECC_Status use
      record
         Single_Bit_Error at 0 range 0 .. 0;
         Multi_Bit_Error  at 0 range 1 .. 1;
         --  bits 2 to 7 are reserved
      end record;

   for ECC_Status'Size use ECC_STATUS_SIZE;

   ---------------------------------------------------------------------
   -- ECC Check Bit Position (ECCCKBPOS)                              --
   -- Memory Mapped, Read Only                                        --
   -- MMCR Offset 22h                                                 --
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   --  ECC Status at MMCR offset 16#22#
   ---------------------------------------------------------------------
   MMCR_OFFSET_ECC_CHECK_BIT_POSITION : constant := 16#22#;
   ECC_CHECK_BIT_POSITION_SIZE        : constant := 8;

   type ECC_Check_Bit_Position is range 0 .. 38;
   for  ECC_Check_Bit_Position'Size use ECC_CHECK_BIT_POSITION_SIZE;

   ---------------------------------------------------------------------
   -- ECC Check Code Test (ECCCKTEST)                                 --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset 23h                                                 --
   ---------------------------------------------------------------------

   ---------------------------------------------------------------------
   --  subtypes for ECC Check Code Test
   type Forced_ECC_Check_Bits is range 0 .. 2**7 - 1;

   ---------------------------------------------------------------------
   --  ECC Check Code Test at MMCR offset 16#23#
   ---------------------------------------------------------------------
   MMCR_OFFSET_ECC_CHECK_CODE_TEST : constant := 16#23#;
   ECC_CHECK_CODE_TEST_SIZE        : constant := 8;

   type ECC_Check_Code_Test is
      record
         Force_Bad_ECC_Check_Bits : Forced_ECC_Check_Bits;
         Bad_Check                : Basic_Types.Positive_Bit;
      end record;

   for ECC_Check_Code_Test use
      record
         Force_Bad_ECC_Check_Bits at 0 range 0 .. 6;
         Bad_Check                at 0 range 7 .. 7;
      end record;

   for ECC_Check_Code_Test'Size use ECC_CHECK_CODE_TEST_SIZE;

   ---------------------------------------------------------------------
   --  subtypes for error addresses (single & multi-bit)
   type Error_Address is range 0 .. 2**26 - 1;

   ---------------------------------------------------------------------
   -- ECC Single-Bit Error Address (ECCSBADD)                         --
   -- Memory Mapped, Read Only                                        --
   -- MMCR Offset 24h                                                 --
   ---------------------------------------------------------------------
   MMCR_OFFSET_ECC_SINGLE_BIT_ERROR_ADDRESS : constant := 16#24#;
   ECC_SINGLE_BIT_ERROR_ADDRESS_SIZE        : constant := 32;

   type ECC_Single_Bit_Error_Address is
      record
         SB_Addr : Error_Address;
      end record;

   for ECC_Single_Bit_Error_Address use
      record
         SB_Addr at 0 range 2 .. 27;
      end record;

   ---------------------------------------------------------------------
   -- ECC Multi-Bit Error Address (ECCMBADD)                          --
   -- Memory Mapped, Read Only                                        --
   -- MMCR Offset 28h                                                 --
   ---------------------------------------------------------------------
   MMCR_OFFSET_ECC_MULTI_BIT_ERROR_ADDRESS : constant := 16#28#;
   ECC_MULTI_BIT_ERROR_ADDRESS_SIZE        : constant := 32;

   type ECC_Multi_Bit_Error_Address is
      record
         MB_Addr : Error_Address;
      end record;

   for ECC_Multi_Bit_Error_Address use
      record
         MB_Addr at 0 range 2 .. 27;
      end record;

end Elan520.SDRAM_Controller_Registers;
