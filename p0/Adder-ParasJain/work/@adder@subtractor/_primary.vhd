library verilog;
use verilog.vl_types.all;
entity AdderSubtractor is
    port(
        SW              : in     vl_logic_vector(8 downto 0);
        LEDR            : out    vl_logic_vector(4 downto 0);
        HEX0            : out    vl_logic_vector(6 downto 0);
        HEX2            : out    vl_logic_vector(6 downto 0);
        HEX4            : out    vl_logic_vector(6 downto 0)
    );
end AdderSubtractor;
