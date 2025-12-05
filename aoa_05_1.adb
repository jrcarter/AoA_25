with Ada.Containers.Vectors;
with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure AoA_05_1 is
   type Ingredient_ID is mod 2 ** 64;

   type ID_Range is record
      Low  : Ingredient_ID;
      High : Ingredient_ID;
   end record;

   package Range_Lists is new Ada.Containers.Vectors (Index_Type => Positive, Element_Type => ID_Range);

   Input : Ada.Text_IO.File_Type;
   List  : Range_Lists.Vector;
   Fresh : Boolean;
   Span  : ID_Range;
   Sum   : Natural := 0;
begin -- AoA_05_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_05");

   Read_Ranges : loop
      One_Range : declare
         Line : constant String  := Ada.Text_IO.Get_Line (Input);
         Dash : constant Natural := Ada.Strings.Fixed.Index (Line, "-");
      begin -- One_Range
         exit Read_Ranges when Line = "";

         List.Append (New_Item => (Low  => Ingredient_ID'Value (Line (Line'First .. Dash - 1) ),
                                   High => Ingredient_ID'Value (Line (Dash + 1 .. Line'Last) ) ) );
      end One_Range;
   end loop Read_Ranges;

   All_Ingredients : loop
      exit All_Ingredients when Ada.Text_IO.End_Of_File (Input);

      One_Ingredient : declare
         ID : constant Ingredient_ID := Ingredient_ID'Value (Ada.Text_IO.Get_Line (Input) );
      begin -- One_Ingredient
         Fresh := False;

         Check_Ranges : for I in 1 .. List.Last_Index loop
            Span := List.Element (I);
            Fresh := Fresh or ID in Span.Low .. Span.High;

            exit Check_Ranges when Fresh;
         end loop Check_Ranges;

         if Fresh then
            Sum := Sum + 1;
         end if;
      end One_Ingredient;
   end loop All_Ingredients;

   Ada.Text_IO.Close (File => Input);
   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AoA_05_1;
