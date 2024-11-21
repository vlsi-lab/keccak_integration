///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: Represents the golden model of the processor used to predict results of the Keccak component.
///////////////////////////////////////////////////////////////
class keccak_gm extends uvm_subscriber #(keccak_transaction);

    // registration of component tools
    `uvm_component_utils( keccak_gm )

    // analysis port for outside components to access transactions from the monitor
    uvm_analysis_port #(keccak_transaction) keccak_analysis_port;

    // static local variables accesible by waveform
    static logic [1599:0] dout;
    static logic status_d;
    static logic status_de;
    static logic keccak_intr;

    // auxiliar variables
    typedef enum {IDLE, COMP, WAIT, DONE} stateGM_e;
    static logic [1599:0] result;
    static int cnt;
    static stateGM_e curr_st, next_st;
    static keccak_transaction gmOut;

    // base name prefix for created transactions
    string m_name = "gold_keccak";

    // Constructor - creates new instance of this class
    function new( string name = "m_keccak_gm_h", uvm_component parent = null );
        super.new( name, parent );
    endfunction: new

    // Build - instantiates child components
    function void build_phase( uvm_phase phase );
        super.build_phase( phase );
        keccak_analysis_port = new( "keccak_analysis_port", this );
        gmOut = keccak_transaction::type_id::create( $sformatf("%0s: %0t", "gmOut", $time) );
        gmOut.dout = '0;
        gmOut.status_d = '0;
        gmOut.status_de = '0;
        gmOut.keccak_intr = '0;
    endfunction: build_phase

    // Connect - create interconnection between child components
    function void connect_phase( uvm_phase phase );
        super.connect_phase( phase );
    endfunction: connect_phase

    // Write - get all transactions from driver for computing predictions
    function void write( T t );
        keccak_transaction out_t;

        out_t = keccak_transaction::type_id::create(
        $sformatf("%0s: %0t", m_name, $time) );

        out_t.copy(t);

        // predict outputs
        predict( out_t );

        // support function for displaying data in wave
        wave_display_support_func(out_t);

        // send predicted outputs to scoreboard
        keccak_analysis_port.write(out_t);
    endfunction: write

    // Keccak round constants
    logic [63:0] KeccakF_RoundConstants[NROUNDS] = {
        64'h0000000000000001,
        64'h0000000000008082,
        64'h800000000000808a,
        64'h8000000080008000,
        64'h000000000000808b,
        64'h0000000080000001,
        64'h8000000080008081,
        64'h8000000000008009,
        64'h000000000000008a,
        64'h0000000000000088,
        64'h0000000080008009,
        64'h000000008000000a,
        64'h000000008000808b,
        64'h800000000000008b,
        64'h8000000000008089,
        64'h8000000000008003,
        64'h8000000000008002,
        64'h8000000000000080,
        64'h000000000000800a,
        64'h800000008000000a,
        64'h8000000080008081,
        64'h8000000000008080,
        64'h0000000080000001,
        64'h8000000080008008
    };

    function automatic logic [63:0] ROL(input logic [63:0] a, input int offset);
        return (a << offset) | (a >> (64 - offset));
        // This is how they implement it, it works BUT this is not how rotate left should be...
        // return (((a) << (offset)) ^ ((a) >> (64 - (offset))));
    endfunction

    function void keccakPermutation(input logic [1599:0] din, output logic [1599:0] dout);
        logic [63:0] state[25];

        logic [63:0] Aba, Abe, Abi, Abo, Abu;
        logic [63:0] Aga, Age, Agi, Ago, Agu;
        logic [63:0] Aka, Ake, Aki, Ako, Aku;
        logic [63:0] Ama, Ame, Ami, Amo, Amu;
        logic [63:0] Asa, Ase, Asi, Aso, Asu;
        logic [63:0] BCa, BCe, BCi, BCo, BCu;
        logic [63:0] Da, De, Di, Do, Du;
        logic [63:0] Eba, Ebe, Ebi, Ebo, Ebu;
        logic [63:0] Ega, Ege, Egi, Ego, Egu;
        logic [63:0] Eka, Eke, Eki, Eko, Eku;
        logic [63:0] Ema, Eme, Emi, Emo, Emu;
        logic [63:0] Esa, Ese, Esi, Eso, Esu;

        // Split the input signal into 64-bit segments
        for (int i = 0; i < 25; i++) begin
            state[i] = din[i*64 +: 64]; // Extract 64 bits
        end

        Aba = state[0];
        Abe = state[1];
        Abi = state[2];
        Abo = state[3];
        Abu = state[4];
        Aga = state[5];
        Age = state[6];
        Agi = state[7];
        Ago = state[8];
        Agu = state[9];
        Aka = state[10];
        Ake = state[11];
        Aki = state[12];
        Ako = state[13];
        Aku = state[14];
        Ama = state[15];
        Ame = state[16];
        Ami = state[17];
        Amo = state[18];
        Amu = state[19];
        Asa = state[20];
        Ase = state[21];
        Asi = state[22];
        Aso = state[23];
        Asu = state[24];

        for (int round = 0; round < NROUNDS; round += 2) begin
            //    prepareTheta
            BCa = Aba ^ Aga ^ Aka ^ Ama ^ Asa;
            BCe = Abe ^ Age ^ Ake ^ Ame ^ Ase;
            BCi = Abi ^ Agi ^ Aki ^ Ami ^ Asi;
            BCo = Abo ^ Ago ^ Ako ^ Amo ^ Aso;
            BCu = Abu ^ Agu ^ Aku ^ Amu ^ Asu;

            // thetaRhoPiChiIotaPrepareTheta(round  , A, E)
            Da = BCu ^ ROL(BCe, 1);
            De = BCa ^ ROL(BCi, 1);
            Di = BCe ^ ROL(BCo, 1);
            Do = BCi ^ ROL(BCu, 1);
            Du = BCo ^ ROL(BCa, 1);

            Aba ^= Da;
            BCa = Aba;
            Age ^= De;
            BCe = ROL(Age, 44);
            Aki ^= Di;
            BCi = ROL(Aki, 43);
            Amo ^= Do;
            BCo = ROL(Amo, 21);
            Asu ^= Du;
            BCu = ROL(Asu, 14);
            Eba = BCa ^ ((~BCe) & BCi);
            Eba ^= KeccakF_RoundConstants[round];
            Ebe = BCe ^ ((~BCi) & BCo);
            Ebi = BCi ^ ((~BCo) & BCu);
            Ebo = BCo ^ ((~BCu) & BCa);
            Ebu = BCu ^ ((~BCa) & BCe);

            Abo ^= Do;
            BCa = ROL(Abo, 28);
            Agu ^= Du;
            BCe = ROL(Agu, 20);
            Aka ^= Da;
            BCi = ROL(Aka, 3);
            Ame ^= De;
            BCo = ROL(Ame, 45);
            Asi ^= Di;
            BCu = ROL(Asi, 61);
            Ega = BCa ^ ((~BCe) & BCi);
            Ege = BCe ^ ((~BCi) & BCo);
            Egi = BCi ^ ((~BCo) & BCu);
            Ego = BCo ^ ((~BCu) & BCa);
            Egu = BCu ^ ((~BCa) & BCe);

            Abe ^= De;
            BCa = ROL(Abe, 1);
            Agi ^= Di;
            BCe = ROL(Agi, 6);
            Ako ^= Do;
            BCi = ROL(Ako, 25);
            Amu ^= Du;
            BCo = ROL(Amu, 8);
            Asa ^= Da;
            BCu = ROL(Asa, 18);
            Eka = BCa ^ ((~BCe) & BCi);
            Eke = BCe ^ ((~BCi) & BCo);
            Eki = BCi ^ ((~BCo) & BCu);
            Eko = BCo ^ ((~BCu) & BCa);
            Eku = BCu ^ ((~BCa) & BCe);

            Abu ^= Du;
            BCa = ROL(Abu, 27);
            Aga ^= Da;
            BCe = ROL(Aga, 36);
            Ake ^= De;
            BCi = ROL(Ake, 10);
            Ami ^= Di;
            BCo = ROL(Ami, 15);
            Aso ^= Do;
            BCu = ROL(Aso, 56);
            Ema = BCa ^ ((~BCe) & BCi);
            Eme = BCe ^ ((~BCi) & BCo);
            Emi = BCi ^ ((~BCo) & BCu);
            Emo = BCo ^ ((~BCu) & BCa);
            Emu = BCu ^ ((~BCa) & BCe);

            Abi ^= Di;
            BCa = ROL(Abi, 62);
            Ago ^= Do;
            BCe = ROL(Ago, 55);
            Aku ^= Du;
            BCi = ROL(Aku, 39);
            Ama ^= Da;
            BCo = ROL(Ama, 41);
            Ase ^= De;
            BCu = ROL(Ase, 2);
            Esa = BCa ^ ((~BCe) & BCi);
            Ese = BCe ^ ((~BCi) & BCo);
            Esi = BCi ^ ((~BCo) & BCu);
            Eso = BCo ^ ((~BCu) & BCa);
            Esu = BCu ^ ((~BCa) & BCe);

            //    prepareTheta
            BCa = Eba ^ Ega ^ Eka ^ Ema ^ Esa;
            BCe = Ebe ^ Ege ^ Eke ^ Eme ^ Ese;
            BCi = Ebi ^ Egi ^ Eki ^ Emi ^ Esi;
            BCo = Ebo ^ Ego ^ Eko ^ Emo ^ Eso;
            BCu = Ebu ^ Egu ^ Eku ^ Emu ^ Esu;

            // thetaRhoPiChiIotaPrepareTheta(round+1, E, A)
            Da = BCu ^ ROL(BCe, 1);
            De = BCa ^ ROL(BCi, 1);
            Di = BCe ^ ROL(BCo, 1);
            Do = BCi ^ ROL(BCu, 1);
            Du = BCo ^ ROL(BCa, 1);

            Eba ^= Da;
            BCa = Eba;
            Ege ^= De;
            BCe = ROL(Ege, 44);
            Eki ^= Di;
            BCi = ROL(Eki, 43);
            Emo ^= Do;
            BCo = ROL(Emo, 21);
            Esu ^= Du;
            BCu = ROL(Esu, 14);
            Aba = BCa ^ ((~BCe) & BCi);
            Aba ^= KeccakF_RoundConstants[round + 1];
            Abe = BCe ^ ((~BCi) & BCo);
            Abi = BCi ^ ((~BCo) & BCu);
            Abo = BCo ^ ((~BCu) & BCa);
            Abu = BCu ^ ((~BCa) & BCe);

            Ebo ^= Do;
            BCa = ROL(Ebo, 28);
            Egu ^= Du;
            BCe = ROL(Egu, 20);
            Eka ^= Da;
            BCi = ROL(Eka, 3);
            Eme ^= De;
            BCo = ROL(Eme, 45);
            Esi ^= Di;
            BCu = ROL(Esi, 61);
            Aga = BCa ^ ((~BCe) & BCi);
            Age = BCe ^ ((~BCi) & BCo);
            Agi = BCi ^ ((~BCo) & BCu);
            Ago = BCo ^ ((~BCu) & BCa);
            Agu = BCu ^ ((~BCa) & BCe);

            Ebe ^= De;
            BCa = ROL(Ebe, 1);
            Egi ^= Di;
            BCe = ROL(Egi, 6);
            Eko ^= Do;
            BCi = ROL(Eko, 25);
            Emu ^= Du;
            BCo = ROL(Emu, 8);
            Esa ^= Da;
            BCu = ROL(Esa, 18);
            Aka = BCa ^ ((~BCe) & BCi);
            Ake = BCe ^ ((~BCi) & BCo);
            Aki = BCi ^ ((~BCo) & BCu);
            Ako = BCo ^ ((~BCu) & BCa);
            Aku = BCu ^ ((~BCa) & BCe);

            Ebu ^= Du;
            BCa = ROL(Ebu, 27);
            Ega ^= Da;
            BCe = ROL(Ega, 36);
            Eke ^= De;
            BCi = ROL(Eke, 10);
            Emi ^= Di;
            BCo = ROL(Emi, 15);
            Eso ^= Do;
            BCu = ROL(Eso, 56);
            Ama = BCa ^ ((~BCe) & BCi);
            Ame = BCe ^ ((~BCi) & BCo);
            Ami = BCi ^ ((~BCo) & BCu);
            Amo = BCo ^ ((~BCu) & BCa);
            Amu = BCu ^ ((~BCa) & BCe);

            Ebi ^= Di;
            BCa = ROL(Ebi, 62);
            Ego ^= Do;
            BCe = ROL(Ego, 55);
            Eku ^= Du;
            BCi = ROL(Eku, 39);
            Ema ^= Da;
            BCo = ROL(Ema, 41);
            Ese ^= De;
            BCu = ROL(Ese, 2);
            Asa = BCa ^ ((~BCe) & BCi);
            Ase = BCe ^ ((~BCi) & BCo);
            Asi = BCi ^ ((~BCo) & BCu);
            Aso = BCo ^ ((~BCu) & BCa);
            Asu = BCu ^ ((~BCa) & BCe);
        end

        state[0] = Aba;
        state[1] = Abe;
        state[2] = Abi;
        state[3] = Abo;
        state[4] = Abu;
        state[5] = Aga;
        state[6] = Age;
        state[7] = Agi;
        state[8] = Ago;
        state[9] = Agu;
        state[10] = Aka;
        state[11] = Ake;
        state[12] = Aki;
        state[13] = Ako;
        state[14] = Aku;
        state[15] = Ama;
        state[16] = Ame;
        state[17] = Ami;
        state[18] = Amo;
        state[19] = Amu;
        state[20] = Asa;
        state[21] = Ase;
        state[22] = Asi;
        state[23] = Aso;
        state[24] = Asu;

        // Concatenate 64-bit segments into output signal
        for (int i = 0; i < 25; i++) begin
            dout[i*64 +: 64] = state[i];
        end
    endfunction

    // implements behavior of the golden model
    local function automatic void predict( keccak_transaction t );
        gmOut.keccak_intr = '0;

        if (curr_st == IDLE) begin
            if (t.start == 1) begin
                next_st = COMP;
            end
        end else if (curr_st == COMP) begin
            keccakPermutation(t.din, result);
            cnt = 0;
            gmOut.dout = 0;
            gmOut.status_d = 0;
            gmOut.status_de = 0;
            next_st = WAIT;
        end else if (curr_st == WAIT) begin
            cnt++;
            if (cnt == 23) begin
                next_st = DONE;
            end
        end else if (curr_st == DONE) begin
            gmOut.keccak_intr = 1;
            gmOut.status_d = 1;
            gmOut.status_de = 1;
            gmOut.dout = result;
            next_st = IDLE;
        end

        if (t.rst_n == RST_ACT_LEVEL) begin
            gmOut.dout = 0;
            next_st = IDLE;
        end

        curr_st = next_st;

        t.dout = gmOut.dout;
        t.status_d = gmOut.status_d;
        t.status_de = gmOut.status_de;
        t.keccak_intr = gmOut.keccak_intr;

    endfunction: predict

    local function void set_default_outputs( keccak_transaction t );
        t.dout = '0;
        t.status_d = '0;
        t.status_de = '0;
        t.keccak_intr = '0;
    endfunction: set_default_outputs

    local function automatic void wave_display_support_func( keccak_transaction t );
        dout = t.dout;
        status_d = t.status_d;
        status_de = t.status_de;
        keccak_intr = t.keccak_intr;
    endfunction: wave_display_support_func

endclass: keccak_gm
