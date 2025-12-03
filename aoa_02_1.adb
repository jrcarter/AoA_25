with Ada.Strings.Fixed;
with Ada.Text_IO;
with PragmARC.Images;
with PragmARC.Line_Fields;
with PragmARC.Conversions.Unbounded_Strings;

procedure AoA_02_1 is
   type ID_Number is mod 2 ** 64;

   function Image is new PragmARC.Images.Modular_Image (Number => ID_Number);

   Input : Ada.Text_IO.File_Type;
   Sum   : ID_Number := 0;

   use PragmARC.Conversions.Unbounded_Strings;
begin -- AoA_02_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_02");

   All_Lines : loop
      exit All_Lines when Ada.Text_IO.End_Of_File (Input);

      One_Line : declare
         Field : constant PragmARC.Line_Fields.Field_List := PragmARC.Line_Fields.Parsed (Ada.Text_IO.Get_Line (Input), ',');
      begin -- One_Line
         All_Pairs : for I in 1 .. Field.Last_Index loop
            One_Pair : declare
               Pair  : constant String    := +Field.Element (I);
               Dash  : constant Natural   := Ada.Strings.Fixed.Index (Pair, "-");
               Start : constant ID_Number := ID_Number'Value (Pair (Pair'First .. Dash - 1) );
               Stop  : constant ID_Number := ID_Number'Value (Pair (Dash + 1 .. Pair'Last) );
            begin -- One_Pair
               All_IDs : for ID in Start .. Stop loop
                  One_ID : declare
                     Img : constant String := Image (ID);
                  begin -- One_ID
                     if Img'Length rem 2 = 0 and
                        Img (Img'First .. Img'First + Img'Length / 2 - 1) = Img (Img'First + Img'Length / 2 .. Img'Last)
                     then -- This is an invalid ID
                        Sum := Sum + ID;
                     end if;
                  end One_ID;
               end loop All_IDs;
            end One_Pair;
         end loop All_Pairs;
      end One_Line;
   end loop All_Lines;

   Ada.Text_IO.Close (File => Input);
   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AoA_02_1;
