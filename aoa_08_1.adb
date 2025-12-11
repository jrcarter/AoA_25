with Ada.Containers.Vectors;
with Ada.Strings.Fixed;
with Ada.Text_IO;
with PragmARC.Sorting.Quick;

procedure AoA_08_1 is
   type Number is range 0 .. 2 ** 63 - 1;

   type Point_Info is record
      X : Number;
      Y : Number;
      Z : Number;
   end record;

   function Distance (Left : in Point_Info; Right : in Point_Info) return Number is
      ( (Left.X - Right.X) ** 2 + (Left.Y - Right.Y) ** 2 + (Left.Z - Right.Z) ** 2);

   Num_Points : constant := 1000;

   subtype Point_ID is Integer range 1 .. Num_Points;

   type Point_List is array (Point_ID) of Point_Info;

   List : Point_List; -- Constant after initialization

   type Circuit_Map is array (Point_ID) of Point_ID;

   type Count_Base is array (Positive range <>) of Number;
   subtype Count_Map is Count_Base (Point_ID);

   package Quick_Sort is new PragmARC.Sorting.Quick (Element => Number, Index => Positive, Sort_Set => Count_Base, "<" => ">");

   type Distance_Info is record
      P1   : Point_ID;
      P2   : Point_ID;
      Dist : Number; -- The squared distance between List (P1) and List (P2)
   end record;

   function "<" (Left : in Distance_Info; Right : in Distance_Info) return Boolean is
      (Left.Dist < Right.Dist);

   package Distance_Lists is new Ada.Containers.Vectors (Index_Type => Positive, Element_Type => Distance_Info);
   package Sorting is new Distance_Lists.Generic_Sorting;

   Input : Ada.Text_IO.File_Type;
   Dist  : Distance_Lists.Vector;
   Map   : Circuit_Map; -- Map (I) is the circuit of which List (I) is a member
   Value : Distance_Info;
   Count : Count_Map := (others => 0); -- Count (i) is the number of points in circuit I
begin -- AoA_08_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_08");

   Read_Points : for ID in List'Range loop
      One_Point : declare
         Line   : constant String  := Ada.Text_IO.Get_Line (Input);
         Comma1 : constant Natural := Ada.Strings.Fixed.Index (Line, ",");
         Comma2 : constant Natural := Ada.Strings.Fixed.Index (Line, ",", Comma1 + 1);
      begin -- One_Point
         List (ID) := (X => Number'Value (Line (1 .. Comma1 - 1) ),
                       Y => Number'Value (Line (Comma1 + 1 .. Comma2 - 1) ),
                       Z => Number'Value (Line (Comma2 + 1 .. Line'Last) ) );
      end One_Point;
   end loop Read_Points;

   Ada.Text_IO.Close (File => Input);
   Dist.Reserve_Capacity (Capacity => 499_500); -- Number of unique pairs of points

   First_Distance : for I in 1 .. List'Last - 1 loop
      Second_Distance : for J in I + 1 .. List'Last loop
         Dist.Append (New_Item => (P1 => I, P2 => J, Dist => Distance (List (I), List (J) ) ) );
      end loop Second_Distance;
   end loop First_Distance;

   Sorting.Sort (Container => Dist);

   Init_Map : for I in Map'Range loop
      Map (I) := I; -- Initially each point is the only member of the circuit with its ID
   end loop Init_Map;

   Build_Circuits : for I in 1 .. 1000 loop
      Value := Dist.Element (I);

      Join : for J in Map'Range loop
         if J /= Value.P2 and Map (J) = Map (Value.P2) then
            Map (J) := Map (Value.P1);
         end if;
      end loop Join;

      Map (Value.P2) := Map (Value.P1);
   end loop Build_Circuits;

   Count_Circuits : for I in Count'range loop
      All_Maps : for J in Map'Range loop
         if I = Map (J) then
            Count (I) := Count (I) + 1;
         end if;
      end loop All_Maps;
   end loop Count_Circuits;

   Quick_Sort.Sort_Sequential (Set => Count);

   Ada.Text_IO.Put_Line (Item => Number'Image (Count (1) * Count (2) * Count (3) ) );
end AoA_08_1;
