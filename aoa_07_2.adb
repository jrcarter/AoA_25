with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure AoA_07_2 is
   type Number is mod 2 ** 64;

   Num_Columns : constant := 141;
   Num_Rows    : constant := 142;

   subtype Data_Row is String (1 .. Num_Columns);
   type Data_Matrix is array (1 .. Num_Rows) of Data_Row;

   type Beam_Count is array (1 .. Num_Columns) of Number;

   Input   : Ada.Text_IO.File_Type;
   Data    : Data_Matrix;
   Count   : Beam_Count := (others => 0);
   Start   : Natural;
   Sum     : Number := 0;
begin -- AoA_07_2
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_07");

   Read_Data : for Row in Data'Range loop
      Data (Row) := Ada.Text_IO.Get_Line (Input);
   end loop Read_Data;

   Ada.Text_IO.Close (File => Input);
   Start := Ada.Strings.Fixed.Index (Data (1), "S");
   Count (Start) := 1;

   All_Rows : for Row in 2 .. Data'Last loop
      Start := 0;

      All_Splits : loop
         Start := Ada.Strings.Fixed.Index (Data (Row), "^", Start + 1);

         exit All_Splits when Start not in Count'Range;

         Count (Start - 1) := Count (Start - 1) + Count (Start);
         Count (Start + 1) := Count (Start + 1) + Count (Start);
         Count (Start) := 0;
      end loop All_Splits;
   end loop All_Rows;

   Combine : for I in Count'Range loop
      Sum := Sum + Count (I);
   end loop Combine;

   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AoA_07_2;
