with Ada.Containers.Vectors;
with Ada.Strings.Fixed;
with Ada.Text_IO;
with PragmARC.Line_Fields;
with PragmARC.Conversions.Unbounded_Strings;

procedure AoA_06_1 is
   type Number is mod 2 ** 64;
   type Operand_List is array (1 .. 4) of Number; -- Each Prob has 4 operands

   package Problem_Lists is new Ada.Containers.Vectors (Index_Type => Positive, Element_Type => Operand_List);

   Input : Ada.Text_IO.File_Type;
   List  : Problem_Lists.Vector;
   Prob  : Operand_List;
   Func  : PragmARC.Line_Fields.Field_List;
   Ans   : Number;
   Sum   : Number := 0;

   use PragmARC.Conversions.Unbounded_Strings;
begin -- AoA_06_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_06");

   First_Operand : declare
      Operand : constant PragmARC.Line_Fields.Field_List := PragmARC.Line_Fields.Parsed (Ada.Text_IO.Get_Line (Input) );
   begin -- First_Operand
      All_Probs : for I in 1 .. Operand.Last_Index loop
         List.Append (New_Item => (1 => Number'Value (+Operand.Element (I) ), others => 0) );
      end loop All_Probs;
   end First_Operand;

   Remaining_Operands : for I in 2 .. 4 loop
      One_Operand : declare
         Operand : constant PragmARC.Line_Fields.Field_List := PragmARC.Line_Fields.Parsed (Ada.Text_IO.Get_Line (Input) );
      begin -- One_Operand
         All_Operands : for J in 1 .. List.Last_Index loop
            Prob := List.Element (J);
            Prob (I) := Number'Value (+Operand.Element (J) );
            List.Replace_Element (Index => J, New_Item => Prob);
         end loop All_Operands;
      end One_Operand;
   end loop Remaining_Operands;

   Func := PragmARC.Line_Fields.Parsed (Ada.Text_IO.Get_Line (Input) );
   Ada.Text_IO.Close (File => Input);

   All_Problems : for I in 1 .. List.Last_Index loop
      Prob := List.Element (I);

      if +Func.Element (I) = "+" then
         Ans := 0;

         Add_All : for J in Prob'Range loop
            Ans := Ans + Prob (J);
         end loop Add_All;
      else -- "*"
         Ans := 1;

         Mult_All : for J in Prob'Range loop
            Ans := Ans * Prob (J);
         end loop Mult_All;
      end if;

      Sum := Sum + Ans;
   end loop All_Problems;

   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AoA_06_1;
