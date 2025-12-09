with Ada.Containers.Vectors;
with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure AoA_09_1 is
   type Number is range 0 .. 2 ** 63 - 1;

   type Point_Info is record
      X : Number;
      Y : Number;
   end record;

   package Point_Lists is new Ada.Containers.Vectors (Index_Type => Positive, Element_Type => Point_Info);

   Input   : Ada.Text_IO.File_Type;
   List    : Point_Lists.Vector;
   First   : Point_Info;
   Second  : Point_Info;
   Max     : Number     := 0;
begin -- AoA_09_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_09");

   Read_Points : loop
      exit Read_Points when Ada.Text_IO.End_Of_File (Input);

      One_Point : declare
         Line  : constant String  := Ada.Text_IO.Get_Line (Input);
         Comma : constant Natural := Ada.Strings.Fixed.Index (Line, ",");
      begin -- One_Point
         List.Append
            (New_Item => (X => Number'Value (Line (1 .. Comma - 1) ), Y => Number'Value (Line (Comma + 1 .. Line'Last) ) ) );
      end One_Point;
   end loop Read_Points;

   Ada.Text_IO.Close (File => Input);

   First_Corner : for I in 1 .. List.Last_Index - 1 loop
      First := List.Element (I);

      Second_Corner : for J in I + 1 .. List.Last_Index loop
         Second := List.Element (J);
         Max := Number'Max ( (abs (First.X - Second.X) + 1) * (abs (First.Y - Second.Y) + 1), Max);
      end loop Second_Corner;
   end loop First_Corner;

   Ada.Text_IO.Put_Line (Item => Max'Image);
end AoA_09_1;
