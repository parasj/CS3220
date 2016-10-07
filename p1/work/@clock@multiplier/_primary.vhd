library verilog;
use verilog.vl_types.all;
entity ClockMultiplier is
    generic(
        multiple        : integer := 4
    );
    port(
        clkin           : in     vl_logic;
        clkoutport      : out    vl_logic;
        currentvalue    : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of multiple : constant is 1;
end ClockMultiplier;
