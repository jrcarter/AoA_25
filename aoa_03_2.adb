with Ada.Text_IO;

procedure AoA_03_2 is
   type Joltage is mod 2 ** 64;

   Input : Ada.Text_IO.File_Type;
   Sum   : Joltage := 0;
begin -- AoA_03_2
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_03");

   All_Lines : loop
      exit All_Lines when Ada.Text_IO.End_Of_File (Input);

      One_Line : declare
         type Max_Info is record
            Max : Character;
            Idx : Positive;
         end record;

         procedure Max (Source : in String; Maximum : out Max_Info) with
            Pre => Source'Length > 0 and (for all C of Source => C in '1' .. '9');

         procedure Max (Source : in String; Maximum : out Max_Info) is
            -- Empty
         begin -- Max
            Maximum := (Max => Source (Source'First), Idx => Source'First);

            Check_All : for I in Source'First + 1 .. Source'Last loop
               if Source (I) > Maximum.Max then
                  Maximum := (Max => Source (I), Idx => I);
               end if;
            end loop Check_All;
         end Max;

         Num_Maxes : constant := 12;

         type Max_List is array (1 .. Num_Maxes) of Max_Info;

         Line : constant String := Ada.Text_IO.Get_Line (Input);

         Maxi : Max_List;
      begin -- One_Line
         Max (Source => Line (Line'First .. Line'Last - Num_Maxes + 1), Maximum => Maxi (1) );

         Rest : for I in 2 .. Maxi'Last loop
            Max (Source => Line (Maxi (I - 1).Idx + 1 .. Line'Last - Num_Maxes + I), Maximum => Maxi (I) );
         end loop Rest;

         Sum := Sum + Joltage'Value (Maxi (01).Max & Maxi (02).Max & Maxi (03).Max & Maxi (04).Max & Maxi (05).Max &
                                     Maxi (06).Max & Maxi (07).Max & Maxi (08).Max & Maxi (09).Max & Maxi (10).Max &
                                     Maxi (11).Max & Maxi (12).Max);
      end One_Line;
   end loop All_Lines;

   Ada.Text_IO.Close (File => Input);
   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AoA_03_2;
