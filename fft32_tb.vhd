-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "03/06/2024 12:46:07"
                                                            
-- Vhdl Test Bench template for design  :  dtft
-- 
-- Simulation tool : ModelSim (VHDL)

LIBRARY work;  USE work.n_bits_int.ALL;
LIBRARY ieee;  USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_signed.ALL;
USE std.textio.ALL;

entity fft32_tb is

end entity;

architecture fft_arch of fft32_tb is
	-- constants                                                 
	-- signals  
	SIGNAL	clk    : STD_LOGIC := '0';    -- Clock abd reset
	SIGNAL	reset  : STD_LOGIC := '0';
	SIGNAL	xr_in  : S16;          -- Real  input
	SIGNAL	xi_in  : S16 := 0;	  -- Imag Input
	SIGNAL	fft_valid    : STD_LOGIC:= '0';   -- FFT output is valid
	SIGNAL	fftr, ffti   : S16;         -- Rel and img. output
	SIGNAL	rcount_o     : U9;          -- Bitreverse index counter
	SIGNAL xr_out, xi_out : ARRAY0_7S16; -- First 8 reg.files
   SIGNAL stage_o, gcount_o : U9;          -- Stage and group count
	SIGNAL	i1_o, i2_o   : U9;          -- (Dual) data index
	SIGNAL	k1_o, k2_o   : U9;          -- Index offset
	SIGNAL	w_o, dw_o    : U9;          -- Cos/Sin (increment) angle
	SIGNAL			wo     : U9;
	
	component fft32 is
		PORT (clk, reset   : IN STD_LOGIC;    -- Clock abd reset
				xr_in, xi_in : IN S16;          -- Real and img. input
				fft_valid    : OUT STD_LOGIC;   -- FFT output is valid
				fftr, ffti   : OUT S16;         -- Rel and img. output
				rcount_o     : OUT U9;          -- Bitreverse index counter
			 xr_out, xi_out : OUT ARRAY0_7S16; -- First 8 reg.files
		 stage_o, gcount_o : OUT U9;          -- Stage and group count
				i1_o, i2_o   : OUT U9;          -- (Dual) data index
				k1_o, k2_o   : OUT U9;          -- Index offset
				w_o, dw_o    : OUT U9;          -- Cos/Sin (increment) angle
						wo     : OUT U9);
	end component;
	
	FILE  f: text OPEN read_mode IS "input_x.txt";
	FILE fo: text OPEN write_mode IS "fft_result.txt";
	
begin

	i1 : fft32
		PORT MAP (
	-- list connections between master ports and signals
		clk => clk,
		fft_valid => fft_valid,
		reset => reset,
		xr_in => xr_in,
		xi_in => xi_in,
		xr_out => xr_out,
		xi_out => xi_out,
		rcount_o => rcount_o,
		stage_o => stage_o, gcount_o => gcount_o,
		i1_o => i1_o, i2_o => i2_o,
		w_o => w_o, dw_o =>dw_o,
		wo => wo);
		
		reset <= '1' AFTER 1 ns, '0' AFTER 25 ns;
	
	init : PROCESS                                               
	-- variable declarations 
			VARIABLE l: LINE;
			VARIABLE x_r: S16;
			VARIABLE i: INTEGER:= 0;
			VARIABLE str: CHARACTER;                                    
	BEGIN                                                        
		 WAIT FOR 12 ns;
			clk <= '1';
			IF (not ENDFILE(f)) THEN
			  readline(f, l);
			  read(l, x_r); --read x;
			  xr_in <= x_r AFTER 6 ns;
			ELSE
			  xr_in <= 0 AFTER 6 ns;
			END IF;

			IF (fft_valid = '1') THEN
			  FOR i IN 0 TO 7 LOOP
				 write(l, xr_out(i)); write(l, ','); write(l, xi_out(i));
				 writeline(fo, l);
			  END LOOP;
			END IF;

			WAIT FOR 12 ns;
			clk <= '0';                                                                     
	END PROCESS init; 

end architecture;