library verilog;
use verilog.vl_types.all;
entity ClockDivider is
    generic(
        multiple        : integer := 25000000
    );
    port(
        clkin           : in     vl_logic;
        clkoutport      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of multiple : constant is 1;
end ClockDivider;
