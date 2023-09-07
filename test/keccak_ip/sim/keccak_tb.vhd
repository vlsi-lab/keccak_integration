library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

  
entity keccak_tb is
end keccak_tb;

architecture structure of keccak_tb is

-- CONSTANTS --
constant D_WIDTH : integer := 1600;
constant D_KECCAK_WIDTH : integer := 64;
constant clk_period : time := 20 ns; 

-- SIGNALS --
signal clk, start_i : std_logic := '0';
signal rst_n, dout_valid_keccak, din_valid_keccak : std_logic;
signal din_i : std_logic_vector (D_WIDTH-1 downto 0) := (others => '0');
signal dout_o : std_logic_vector (D_WIDTH-1 downto 0);
signal din_keccak, dout_keccak : std_logic_vector (D_KECCAK_WIDTH-1 downto 0); 
signal buffer_full, last_block_keccak, ready_keccak, start_keccak : std_logic;
signal status : std_logic;

file file_VECTORS : text;
file file_RESULTS : text open write_mode is "output_results.txt";

-- COMPONENTS --
component keccak_cu 
    port (
      clk_i                     : in std_logic;
      rst_ni                    : in std_logic;
      start_i                   : in std_logic;
      ready_keccak_i            : in std_logic;
      din_i                     : in std_logic_vector(D_WIDTH-1 downto 0);
      dout_keccak_i             : in std_logic_vector(D_KECCAK_WIDTH-1 downto 0);
      dout_valid_keccak_i       : in std_logic;
      start_keccak_o            : out std_logic;
      last_block_keccak_o       : out std_logic;     
      dout_o                    : out std_logic_vector (D_WIDTH-1 downto 0);
      din_keccak_o              : out std_logic_vector(D_KECCAK_WIDTH-1 downto 0);
      din_valid_keccak_o        : out std_logic;
      status                    : out std_logic
      );
end component; 

component keccak is
  port (
    clk     	: in  std_logic;
    rst_n   	: in  std_logic;
    start 	: in std_logic;
    din     	: in  std_logic_vector(63 downto 0);
    din_valid	: in std_logic;
    buffer_full	: out std_logic;
    last_block	: in std_logic;    
    ready	: out std_logic;
    dout    	: out std_logic_vector(63 downto 0);
    dout_valid 	: out std_logic
      );
end component; 


begin      
    
  CU : keccak_cu port map (
    clk,
    rst_n,
    start_i,
    ready_keccak,
    din_i,
    dout_keccak,
    dout_valid_keccak,
    start_keccak,
    last_block_keccak, 
    dout_o,
    din_keccak,
    din_valid_keccak,
    status);

  DATAPATH : keccak port map (
    clk,
    rst_n,
    start_keccak,
    din_keccak,
    din_valid_keccak,
    buffer_full,
    last_block_keccak,
    ready_keccak,
    dout_keccak,
    dout_valid_keccak );

  -- PROCEDURE THAT READS INPUT VALUES FROM FILE (64 bits written in HEX) --
  read_input : process
    variable v_ILINE            : line;
    variable input_value        : std_logic_vector (63 downto 0);
    variable cnt                : natural := 1;

    begin

      file_open(file_VECTORS, "input_vectors.txt", read_mode);

      while not endfile(file_VECTORS) loop
        readline(file_VECTORS, v_ILINE);
        hread(v_ILINE, input_value);
        din_i((D_KECCAK_WIDTH*cnt)-1 downto D_KECCAK_WIDTH*(cnt-1)) <= input_value;
        cnt := cnt+1;
      end loop;

      file_close(file_VECTORS);
      wait ;
      
  end process;
  
  -- CLOCK PROCESS
  clk_process: process
    begin
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
  end process; 

  -- STIMULUS PROCESS
  stim_process : process
    begin
       wait for 10 ns;
      rst_n <= '0';
      wait for 40 ns;
      rst_n <= '1';
      wait for 10 ns;
      start_i <= '1';
      wait for 100 ns;
      start_i <= '0';
      wait;     
    end process;

-- PROCEDURE THAT WRITES OUTPUT VALUES TO FILE (64 bits written in HEX) --
  write_results : process
    variable v_OLINE            : line;
    variable count              : natural := 1;
    variable v_TIME             : time := 0 ns;
    
    -- sarebbe figo farlo fare nel loop per il simualtion time 

    begin
      wait on dout_valid_keccak;
      report "dout valid changed";
      while ( dout_valid_keccak = '1') loop
        if (rising_edge(clk)) then 
          hwrite(v_OLINE, dout_o((D_KECCAK_WIDTH*count)-1 downto D_KECCAK_WIDTH*(count-1)), right, D_KECCAK_WIDTH);
          writeline(file_RESULTS, v_OLINE);
          count := count+1;
          wait on clk; 
          if (count = 26) then
             report "closing file";
             --v_TIME := now - v_TIME;
             file_close(file_RESULTS);
             wait;
          end if;
          else 
            wait on clk; --to make sure it does not stuck in an infinite loop
        end if; 
      end loop;  
  end process;
  
    
end structure; 

