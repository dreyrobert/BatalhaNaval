library ieee;
use ieee.std_logic_1164.all;

entity batalhaNaval is
    port (
        clock : in std_logic;
        reset : in std_logic;
        entradas : in std_logic_vector(3 downto 0);

        naviosPosicionados : out std_logic_vector(1 downto 0);
        vidas: out std_logic_vector(5 downto 0);
        ganhou : out std_logic;
        perdeu : out std_logic
    );
end batalhaNaval;

architecture arch of batalhaNaval is
    type tipoEstado is (primeiroNavio, segundoNavio, jogadas, fimJogo);
    signal y : tipoEstado;
    signal pos_primeiroNavio : std_logic_vector(3 downto 0);
    signal pos_segundoNavio : std_logic_vector(3 downto 0);
    signal tentativas : integer range 0 to 6 := 0;
    signal primeiroNavioAtingido : std_logic := '0';
    signal segundoNavioAtingido : std_logic := '0';
begin
    process(reset, clock)
    begin
        if reset = '1' then
            y <= primeiroNavio;
            tentativas <= 0;
            vidas <= (others => '1');
            ganhou <= '0';
            perdeu <= '0';
            primeiroNavioAtingido <= '0';
            segundoNavioAtingido <= '0';
            naviosPosicionados <= (others => '0');
        elsif primeiroNavioAtingido = '1' and segundoNavioAtingido = '1' then
            ganhou <= '1';
            y <= fimJogo;
        elsif tentativas = 6 then
            perdeu <= '1';
            y <= fimJogo;
        elsif rising_edge(clock) then
            case y is
                when primeiroNavio =>
                    pos_primeiroNavio <= entradas;
                    naviosPosicionados(0) <= '1';
                    y <= segundoNavio;
                when segundoNavio =>
                    if entradas /=  pos_primeiroNavio then
                        vidas <= (others => '1');
                        pos_segundoNavio <= entradas;
                        naviosPosicionados(1) <= '1';
                        y <= jogadas;
                    else
                        y <= segundoNavio;
                    end if;
                when jogadas =>
                    if entradas = pos_primeiroNavio then
                        primeiroNavioAtingido <= '1';
                        naviosPosicionados(0) <= '0';
                    elsif entradas = pos_segundoNavio then
                        segundoNavioAtingido <= '1';
                        naviosPosicionados(1) <= '0';
                    else
                        vidas(tentativas) <= '0';
                    end if;
                when fimJogo =>
                    -- Nada a fazer aqui, o jogo acabou.
                when others =>
                    y <= primeiroNavio;
            end case;
        end if;
    end process;
end arch;
