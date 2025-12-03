with Ada.Text_IO;

procedure AoA_03_1 is
   type Joltage is mod 2 ** 64;

   Input : Ada.Text_IO.File_Type;
   Sum   : Joltage := 0;
begin -- AoA_03_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_03");

   All_Lines : loop
      exit All_Lines when Ada.Text_IO.End_Of_File (Input);

      One_Line : declare
         procedure Max (Source : in String; Maximum : out Character; Index : out Positive) with
            Pre => Source'Length > 0 and (for all C of Source => C in '1' .. '9');

         procedure Max (Source : in String; Maximum : out Character; Index : out Positive) is
            -- Empty
         begin -- Max
            Maximum := Source (Source'First);
            Index := Source'First;

            Check_All : for I in Source'First + 1 .. Source'Last loop
               if Source (I) > Maximum then
                  Maximum := Source (I);
                  Index := I;
               end if;
            end loop Check_All;
         end Max;

         Line : constant String := Ada.Text_IO.Get_Line (Input);

         L_Max : Character;
         L_Idx : Positive;
         R_Max : Character;
         R_Idx : Positive;
      begin -- One_Line
         Max (Source => Line (Line'First .. Line'Last - 1), Maximum => L_Max, Index => L_Idx);
         Max (Source => Line (L_Idx + 1 .. Line'Last), Maximum => R_Max, Index => R_Idx);
         Sum := Sum + Joltage'Value (L_Max & R_Max);
      end One_Line;
   end loop All_Lines;

   Ada.Text_IO.Close (File => Input);
   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AoA_03_1;
