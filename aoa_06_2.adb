with Ada.Text_IO;

procedure AoA_06_2 is
   type Number is mod 2 ** 64;

   Num_Columns : constant := 3732;
   Num_Rows    : constant :=    5;

   subtype Data_Row is String (1 .. Num_Columns);
   type Data_Matrix is array (1 .. Num_Rows) of Data_Row;

   subtype Rotated_Row is String (1 .. Num_Rows);
   type Rotated_Matrix is array (1 .. Num_Columns) of Rotated_Row;

   type Operand_List is array (1 .. 4) of Number;

   Input   : Ada.Text_IO.File_Type;
   Data    : Data_Matrix;
   Rotated : Rotated_Matrix;
   Row     : Positive;
   Operand : Operand_List;
   Last_Op : Positive;
   Ans     : Number;
   Sum     : Number := 0;
begin -- AoA_06_2
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_06");

   Read_Data : for Row in Data'Range loop
      Data (Row) := Ada.Text_IO.Get_Line (Input);
   end loop Read_Data;

   Ada.Text_IO.Close (File => Input);

   Rotate_Columns : for Col in reverse Data_Row'Range loop -- Rotate Data 90 degrees counterclockwise
      Rotate_Rows : for Row in Data'Range loop
         Rotated (Num_Columns - Col + 1) (Row) := Data (Row) (Col);
      end loop Rotate_Rows;
   end loop Rotate_Columns;

   Row := 1;

   All_Problems : loop
      exit All_Problems when Row not in Rotated'Range;

      if Rotated (Row) = Rotated_Row'(others => ' ') then
      --  Ada.Text_IO.Put_Line("skipping blank line");
         Row := Row + 1;
      else
         All_Ops : for J in Operand'Range loop
         --  Ada.Text_IO.Put_Line("processing "&Rotated(Row));
            Operand (J) := Number'Value (Rotated (Row) (1 .. Num_Rows - 1) );
            Row := Row + 1;

            if Rotated (Row - 1) (Num_Rows) /= ' ' then
               Last_Op := J;

               exit All_Ops;
            end if;
         end loop All_Ops;

         if Rotated (Row - 1) (Num_Rows) = '+' then
         --  Ada.Text_IO.Put_Line("   add");
            Ans := 0;

            Add_All : for J in 1 .. Last_Op loop
               Ans := Ans + Operand (J);
            end loop Add_All;
         else -- "*"
         --  Ada.Text_IO.Put_Line("   mult");
            Ans := 1;

            Mult_All : for J in 1 .. Last_Op loop
               Ans := Ans * Operand (J);
            end loop Mult_All;
         end if;

         Sum := Sum + Ans;
      end if;
   end loop All_Problems;

   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AoA_06_2;
