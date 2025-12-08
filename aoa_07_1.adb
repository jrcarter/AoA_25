with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure AoA_07_1 is
   Num_Columns : constant := 141;
   Num_Rows    : constant := 142;

   subtype Data_Row is String (1 .. Num_Columns);
   type Data_Matrix is array (1 .. Num_Rows) of Data_Row;

   Input   : Ada.Text_IO.File_Type;
   Data    : Data_Matrix;
   Start   : Natural;
   Sum     : Natural := 0;
begin -- AoA_07_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_07");

   Read_Data : for Row in Data'Range loop
      Data (Row) := Ada.Text_IO.Get_Line (Input);
   end loop Read_Data;

   Ada.Text_IO.Close (File => Input);
   Start := Ada.Strings.Fixed.Index (Data (1), "S");
   Data (1) (Start) := '|';

   Drop : for Row in 2 .. Data'Last loop
      Split : for Col in Data_Row'Range loop
         if Data (Row - 1) (Col) = '|' then
            if Data (Row) (Col) = '.' then
               Data (Row) (Col) := '|';
            elsif Data (Row) (Col) = '^' then
               Data (Row) (Col - 1) := '|';
               Data (Row) (Col + 1) := '|';
               Sum := Sum + 1;
            else -- '|' from a '^' in the previous column
               null;
            end if;
         end if;
      end loop Split;
   end loop Drop;

   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AoA_07_1;
