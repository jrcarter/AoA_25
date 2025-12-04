with Ada.Text_IO;

procedure AoA_04_1 is
   Map_Size : constant := 136; -- The map is 136 symbols square

   subtype Map_Row is String (1 .. Map_Size + 2); -- First and last surround map with '.'
   type Map_Layout is array (1 .. Map_Size + 2) of Map_Row;   -- "

   Input : Ada.Text_IO.File_Type;
   Map   : Map_Layout := (others => (others => '.') );
   Count : Natural;
   Sum   : Natural := 0;
begin -- AoA_04_1
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "input_04");

   All_Lines : for Row in Map'First + 1 .. Map'Last - 1 loop
      Map (Row) (Map (Row)'First + 1 .. Map (Row)'Last - 1) := Ada.Text_IO.Get_Line (Input);
   end loop All_Lines;

   Ada.Text_IO.Close (File => Input);

   All_Rows : for Row in Map'First + 1 .. Map'Last - 1 loop
      All_Cols : for Col in Map (Row)'First + 1 .. Map (Row)'Last - 1 loop
         if Map (Row) (Col) = '@' then -- Count the neighbors of (Row, Col)
            Count := 0;

            All_Y : for Y in Row - 1 .. Row + 1 loop
               All_X : for X in Col - 1 .. Col + 1 loop
                  if (Row /= Y or Col /= X) and Map (Y) (X) = '@' then
                     Count := Count + 1;
                  end if;
               end loop All_X;
            end loop All_Y;

            if Count < 4 then -- This roll can be accessed
               Sum := Sum + 1;
            end if;
         end if;
      end loop All_Cols;
   end loop All_Rows;

   Ada.Text_IO.Put_Line (Item => Sum'Image);
end AoA_04_1;
