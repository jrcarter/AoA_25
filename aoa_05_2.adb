with Ada.Containers.Vectors;
with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure AoA_05_2 is
   type Ingredient_ID is mod 2 ** 64;
   type Count_Value is new Ingredient_ID;

   type ID_Range is record
      Active : Boolean;
      Low    : Ingredient_ID;
      High   : Ingredient_ID;
   end record;

   package Range_Lists is new Ada.Containers.Vectors (Index_Type => Positive, Element_Type => ID_Range);

   Input : Ada.Text_IO.File_Type;
   Found : Boolean;
   Low   : Ingredient_ID;
   High  : Ingredient_ID;
   Span1 : ID_Range;
   Span2 : ID_Range;
   List  : Range_Lists.Vector;
   Count : Count_Value := 0;
begin -- AoA_05_2
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_05");

   Read_Ranges : loop
      One_Range : declare
         Line : constant String  := Ada.Text_IO.Get_Line (Input);
         Dash : constant Natural := Ada.Strings.Fixed.Index (Line, "-");
      begin -- One_Range
         exit Read_Ranges when Line = "";

         Low  := Ingredient_ID'Value (Line (Line'First .. Dash - 1) );
         High := Ingredient_ID'Value (Line (Dash + 1 .. Line'Last) );
         List.Append (New_Item => (Active => True, Low  => Low, High => High) );
      end One_Range;
   end loop Read_Ranges;

   Ada.Text_IO.Close (File => Input);

   Merge : loop
      Found := False;

      Pass1 : for I in 1 .. List.Last_Index loop
         Span1 := List.Element (I);

         if Span1.Active then
            Pass2 : for J in 1 .. List.Last_Index loop
               if I /= J then
                  Span2 := List.Element (J);

                  if Span2.Active then
                     if Span2.Low in Span1.Low .. Span1.High then
                        Span1.High := Ingredient_ID'Max (Span1.High, Span2.High);
                        Span2.Active := False;
                        Found := True;
                     end if;

                     if Span2.High in Span1.Low .. Span1.High then
                        Span1.Low := Ingredient_ID'Min (Span1.Low, Span2.Low);
                        Span2.Active := False;
                        Found := True;
                     end if;

                     if Found then
                        List.Replace_Element (Index => I, New_Item => Span1);
                        List.Replace_Element (Index => J, New_Item => Span2);
                     end if;
                  end if;
               end if;
            end loop Pass2;
         end if;
      end loop Pass1;

      exit Merge when not Found;
   end loop Merge;

   Count_Ranges : for I in 1 .. List.Last_Index loop
      Span1 := List.Element (I);

      if Span1.Active then
         Count := Count + Count_Value (Span1.High - Span1.Low + 1);
      end if;
   end loop Count_Ranges;

   Ada.Text_IO.Put_Line (Item => Count'Image);
end AoA_05_2;
