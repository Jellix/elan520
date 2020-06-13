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
--  MMCR -> General-Purpose Timer Registers                           --
--                                                                    --
--  reference: User's Manual Chapter 17,                              --
--             Register Set Manual Chapter 14                         --
------------------------------------------------------------------------

with Elan520.Basic_Types;

package Elan520.GP_Timer_Registers is

   ---------------------------------------------------------------------
   -- GP Timers Status (GPTMRSTA)                                     --
   -- Memory Mapped, Read/Write(!)                                    --
   -- MMCR Offset C70h                                                --
   -- NOTE: writing  a  1  (True) to the register resets (clears) the --
   --       appropriate bit                                           --
   ---------------------------------------------------------------------
   MMCR_OFFSET_STATUS : constant := 16#C70#;
   STATUS_SIZE        : constant := 8;

   type Status is
      record
         T0_Int_Sta : Boolean;
         T1_Int_Sta : Boolean;
         T2_Int_Sta : Boolean;
      end record;

   for Status use
      record
         T0_Int_Sta at 0 range 0 .. 0;
         T1_Int_Sta at 0 range 1 .. 1;
         T2_Int_Sta at 0 range 2 .. 2;
         --  bits 3 .. 7 are reserved
      end record;

   for Status'Size use STATUS_SIZE;


   --  type used for clock source and retrigger mode selections
   --  bits [4:2]
   --  RTG  PSC_SEL EXT_CLK   clock mode
   --    0        0       0   Internal, cpu clock, gated
   --    0        0       1   External
   --    0        1       0   Internal, prescaled, gated
   --    0        1       1   N/A (same as 001)
   --    1        0       0   Internal, cpu clock, retriggered
   --    1        0       1   N/A (same as 001)
   --    1        1       0   internal, prescaled, retriggered
   --    1        1       1   N/A (same as 001)
   type Clock_Source is (Internal_Gated,
                         External,
                         Prescaled_Gated,
                         Internal_Retriggered,
                         Prescaled_Retriggered);

   for Clock_Source use (Internal_Gated        => 2#000#,
                         External              => 2#001#,
                         Prescaled_Gated       => 2#010#,
                         Internal_Retriggered  => 2#100#,
                         Prescaled_Retriggered => 2#110#);

   for Clock_Source'Size use 3;

   --  type used for the enable bits (ENB, P_ENB_WR)
   --  bits [15:14]
   type Enable_Set is (Dont_Care, Disable, Enable);

   for Enable_Set use (Dont_Care => 2#00#,
                       Disable   => 2#01#,
                       Enable    => 2#11#);

   for Enable_Set'Size use 2;

   ---------------------------------------------------------------------
   -- GP Timer Mode/Control (GPTMRxCTL)                               --
   -- Memory Mapped, Read/Write(!)                                    --
   -- MMCR Offset C72h (GP Timer 0)                                   --
   --             C7Ah (GP Timer 1)                                   --
   ---------------------------------------------------------------------
   MMCR_OFFSET_T0_CONTROL : constant := 16#C72#;
   MMCR_OFFSET_T1_CONTROL : constant := 16#C7A#;
   CONTROL_SIZE           : constant := 16;

   type Control is
      record
         Continuous_Mode   : Basic_Types.Positive_Bit;
         Alternate_Compare : Basic_Types.Positive_Bit;
         --  this combines RTG, EXT_CLK and PSC_SEL bits
         Clock_Mode        : Clock_Source;
         Max_Count_Reached : Boolean;
         Max_Count_In_Use  : Boolean;
         Interrupt         : Basic_Types.Positive_Bit;
         Enable_Mode       : Enable_Set;
      end record;

   for Control use
      record
         Continuous_Mode   at 0 range  0 ..  0;
         Alternate_Compare at 0 range  1 ..  1;
         Clock_Mode        at 0 range  2 ..  4;
         Max_Count_Reached at 0 range  5 ..  5;
         --  bits [11:6] are reserved
         Max_Count_In_Use  at 0 range 12 .. 12;
         Interrupt         at 0 range 13 .. 13;
         Enable_Mode       at 0 range 14 .. 15;
      end record;


   ---------------------------------------------------------------------
   -- GP Timer 2 Mode/Control (GPTMR2CTL)                             --
   -- Memory Mapped, Read/Write(!)                                    --
   -- MMCR Offset C82h                                                --
   ---------------------------------------------------------------------
   MMCR_OFFSET_T2_CONTROL : constant := 16#C82#;
   T2_CONTROL_SIZE        : constant := CONTROL_SIZE;

   type Control_2 is
      record
         Continuous_Mode   : Basic_Types.Positive_Bit;
         Max_Count_Reached : Boolean;
         Interrupt         : Basic_Types.Positive_Bit;
         Enable_Mode       : Enable_Set;
      end record;

   for Control_2 use
      record
         Continuous_Mode   at 0 range  0 ..  0;
         --  bits [4:1] are reserved
         Max_Count_Reached at 0 range  5 ..  5;
         --  bits [12:6] are reserved
         Interrupt         at 0 range 13 .. 13;
         Enable_Mode       at 0 range 14 .. 15;
      end record;


   --  type used for all count registers
   type Count is range 0 .. 65535;
   for Count'Size use 16;

   ---------------------------------------------------------------------
   -- GP Count/Maxcount Compare registers                             --
   -- Memory Mapped, Read/Write                                       --
   -- MMCR Offset C74h, (Timer 0 Count, GPTMR0CNT)                    --
   --             C76h, (Timer 0 Maxcount Compare A, GPTMR0MAXCMPA)   --
   --             C78h, (Timer 0 Maxcount Compare B, GPTMR0MAXCMPB)   --
   --             C7Ch, (Timer 1 Count, GPTMR1CNT)                    --
   --             C7Eh, (Timer 1 Maxcount Compare A, GPTMR1MAXCMPA)   --
   --             C80h, (Timer 1 Maxcount Compare A, GPTMR1MAXCMPB)   --
   --             C84h, (Timer 2 Count, GPTMR2CNT)                    --
   --             C86h, (Timer 2 Maxcount Compare A, GPTMR2MAXCMPA)   --
   ---------------------------------------------------------------------
   MMCR_OFFSET_T0_COUNT : constant := 16#C74#;
   MMCR_OFFSET_T0_MAX_A : constant := 16#C76#;
   MMCR_OFFSET_T0_MAX_B : constant := 16#C78#;
   MMCR_OFFSET_T1_COUNT : constant := 16#C7C#;
   MMCR_OFFSET_T1_MAX_A : constant := 16#C7E#;
   MMCR_OFFSET_T1_MAX_B : constant := 16#C80#;
   MMCR_OFFSET_T2_COUNT : constant := 16#C84#;
   MMCR_OFFSET_T2_MAX_A : constant := 16#C86#;

end Elan520.GP_Timer_Registers;
