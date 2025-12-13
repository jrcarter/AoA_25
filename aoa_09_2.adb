with Ada.Containers.Vectors;
with Ada.Strings.Fixed;
with Ada.Text_IO;

procedure AoA_09_2 is
   type Number is range 0 .. 2 ** 63 - 1;

   type Point_Info is record
      X : Number;
      Y : Number;
   end record;

   package Point_Lists is new Ada.Containers.Vectors (Index_Type => Positive, Element_Type => Point_Info);

   Max_Coord : constant := 100_000;

   subtype Plot_Coord is Number range 1 .. Max_Coord;

   type Plot_Grid is array (Plot_Coord, Plot_Coord) of Boolean;

   procedure Flood (Plot : in out Plot_Grid; X : in Plot_Coord; Y : in Plot_Coord) with Pre => not Plot (X, Y);
   -- Flood fill of Plot starting at (X, Y)

   procedure Flood (Plot : in out Plot_Grid; X : in Plot_Coord; Y : in Plot_Coord) is
      Left  : Number;
      Right : Number;
   begin -- Flood
      Find_Left : for L in reverse 1 .. X - 1 loop
         if Plot (L, Y) then
            Left := L + 1;

            exit Find_Left;
         end if;
      end loop Find_Left;

      Find_Right : for R in X + 1 .. Max_Coord loop
         if Plot (R, Y) then
            Right := R - 1;

            exit Find_Right;
         end if;
      end loop Find_Right;

      Draw : for C in Left .. Right loop
         Plot (C, Y) := True;
      end loop Draw;

      if Y - 1 in Plot_Coord then
         Draw_Above : for C in Left .. Right loop
            if not Plot (C, Y - 1) then
               Flood (Plot => Plot, X => C, Y => Y - 1);
            end if;
         end loop Draw_Above;
      end if;

      if Y + 1 in Plot_Coord then
         Draw_Below : for C in Left .. Right loop
            if not Plot (C, Y + 1) then
               Flood (Plot => Plot, X => C, Y => Y + 1);
            end if;
         end loop Draw_Below;
      end if;
   end Flood;

   Input   : Ada.Text_IO.File_Type;
   List    : Point_Lists.Vector;
   First   : Point_Info := (others => Max_Coord + 1);
   Second  : Point_Info;
   Plot    : Plot_Grid := (others => (others => False) );
   Max     : Number     := 0;
begin -- AoA_09_2
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_09");

   Read_Points : loop
      exit Read_Points when Ada.Text_IO.End_Of_File (Input);

      One_Point : declare
         Line  : constant String  := Ada.Text_IO.Get_Line (Input);
         Comma : constant Natural := Ada.Strings.Fixed.Index (Line, ",");
      begin -- One_Point
         Second := (X => Number'Value (Line (1 .. Comma - 1) ), Y => Number'Value (Line (Comma + 1 .. Line'Last) ) );
         List.Append (New_Item => Second);

         if First.X in Plot_Coord then
            if First.X = Second.X then -- Vertical line
               Draw_Vertical : for Y in Number'Min (First.Y, Second.Y) .. Number'Max (First.Y, Second.Y) loop
                  Plot (First.X, Y) := True;
               end loop Draw_Vertical;
            else -- Horizontal line
               Draw_Horizontal : for X in Number'Min (First.X, Second.X) .. Number'Max (First.X, Second.X) loop
                  Plot (X, First.Y) := True;
               end loop Draw_Horizontal;
            end if;
         end if;

         First := Second;
      end One_Point;
   end loop Read_Points;

   Ada.Text_IO.Close (File => Input);

   Flood (Plot => Plot, X => 50_000, Y => 60_000);

   First_Corner : for I in 1 .. List.Last_Index - 1 loop
      First := List.Element (I);

      Second_Corner : for J in I + 1 .. List.Last_Index loop
         Second := List.Element (J);

         if (for all X in Number'Min (First.X, Second.X) .. Number'Max (First.X, Second.X) =>
                (for all Y in Number'Min (First.Y, Second.Y) .. Number'Max (First.Y, Second.Y) => Plot (X, Y) ) )
         then
            Max := Number'Max ( (abs (First.X - Second.X) + 1) * (abs (First.Y - Second.Y) + 1), Max);
         end if;
      end loop Second_Corner;
   end loop First_Corner;

   Ada.Text_IO.Put_Line (Item => Max'Image);
end AoA_09_2;
