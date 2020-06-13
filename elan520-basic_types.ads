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
--  Basic (bit) types                                                 --
------------------------------------------------------------------------

package Elan520.Basic_Types is

   --  we  want  positive  logic  in  either case, so define appropriate
   --  types to map logical 0/1 to their respective physical 0/1's
   type Positive_Bit is (Disable, Enable);
   for  Positive_Bit use (Disable => 0, Enable => 1);
   for  Positive_Bit'Size use 1;

   type Negative_Bit is (Enable, Disable);
   for  Negative_Bit use (Enable => 0, Disable => 1);
   for  Negative_Bit'Size use 1;

end Elan520.Basic_Types;
