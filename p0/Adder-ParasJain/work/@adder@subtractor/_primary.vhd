library verilog;
use verilog.vl_types.all;
entity AdderSubtractor is
    port(
        SW              : in     vl_logic_vector(8 downto 0);
        LEDR            : out    vl_logic_vector(4 downto 0)
    );
end AdderSubtractor;
