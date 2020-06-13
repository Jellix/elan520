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
--  MMCR -> Software Timer Registers implementation                   --
------------------------------------------------------------------------

package body Elan520.Software_Timer_Registers is

   function To_Microseconds (Timer_Read : in Timer)
     return Full_Microseconds is
   begin
      return USEC_IN_MSEC * Timer_Read.Ms_Cnt + Timer_Read.Us_Cnt;
   end To_Microseconds;
   pragma Pure_Function (To_Microseconds);

end Elan520.Software_Timer_Registers;
