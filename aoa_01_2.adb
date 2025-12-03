with Ada.Text_IO;

procedure AoA_01_2 is
   type Dial_Number is mod 100;

   Input : Ada.Text_IO.File_Type;
   Dial  : Dial_Number := 50;
   Count : Natural     :=  0;
begin -- AoA_01_2
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_01");

   All_Lines : loop
      exit All_Lines when Ada.Text_IO.End_Of_File (Input);

      One_Line : declare
         Line : constant String := Ada.Text_IO.Get_Line (Input);
      begin -- One_Line
         All_Clicks : for Click in 1 .. Integer'Value (Line (Line'First + 1 .. Line'Last) ) loop
            Dial := Dial + (if Line (Line'First) = 'R' then 1 else -1);

            if Dial = 0 then
               Count := Count + 1;
            end if;
         end loop All_Clicks;
      end One_Line;
   end loop All_Lines;

   Ada.Text_IO.Close (File => Input);
   Ada.Text_IO.Put_Line (Item => Count'Image);
end AoA_01_2;
