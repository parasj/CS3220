force -freeze /Project2/clk 1 0, 0 10 -repeat 20
force -freeze /Project2/reset 1 0, 0 45
force -deposit /Project2/KEY 4'b1111
force -deposit /Project2/SW 9'b0 0
mem load -i test/programs/Test2.mif.mem /Project2/instMem/data
mem load -i test/programs/Test2.mif.mem /Project2/datamem/data