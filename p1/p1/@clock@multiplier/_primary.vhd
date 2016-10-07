library verilog;
use verilog.vl_types.all;
entity ClockMultiplier is
    port(
        clkin           : in     vl_logic;
        multiple        : in     vl_logic_vector(31 downto 0);
        clkoutport      : out    vl_logic;
        currentvalue    : out    vl_logic
    );
end ClockMultiplier;
