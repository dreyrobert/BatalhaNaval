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
        perdeu : out std_logic;
        teste: out std_logic_vector(3 downto 0)
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
    signal codificacao : std_logic_vector(3 downto 0);
begin
    process(reset, clock)
            variable A : std_logic;
            variable B : std_logic;
            variable C : std_logic;
            variable D : std_logic;
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

                    A := (not entradas(1) and entradas(3)) or (entradas(0) and entradas(1) and not entradas(2)) or (not entradas(0) and not entradas(1) and not entradas(2)) or (not entradas(0) and entradas(1) and entradas(2) and not entradas(3));

                    B := (not entradas(2) and not entradas(3)) or (not entradas(0) and not entradas(1) and entradas(2)) or (entradas(0) and entradas(1) and not entradas(2)) or (entradas(0) and entradas(1) and not entradas(3));

                    C := (not entradas(0) and not entradas(2) and not entradas(3)) or (not entradas(0) and not entradas(1) and entradas(3)) or ( entradas(0) and entradas(2) and entradas(3)) or (entradas(0) and not entradas(1) and not entradas(3));

                    D := (entradas(1) and not entradas(2) and not entradas(3)) or (entradas(0) and not entradas(1) and entradas(3)) or (not entradas(0) and not entradas(1) and not entradas(3)) or (entradas(0) and not entradas(1) and entradas(2)) or (not entradas(0) and entradas(1) and entradas(2) and entradas(3));

                    teste(3) <= A;
                    teste(2) <= B;
                    teste(1) <= C;
                    teste(0) <= D;

                    if (pos_primeiroNavio(3) = A and pos_primeiroNavio(2) = B and pos_primeiroNavio(1) = C and pos_primeiroNavio(0) = D) then
                        primeiroNavioAtingido <= '1';
                        naviosPosicionados(0) <= '0';
                    elsif (pos_segundoNavio(3) = A and pos_segundoNavio(2) = B and pos_segundoNavio(1) = C and pos_segundoNavio(0) = D) then
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
