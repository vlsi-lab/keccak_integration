///////////////////////////////////////////////////////////////
// Author: Petr Bardonek ibardonek@fit.vut.cz
// Language: SystemVerilog
// Description: This class represents UVM sequence base for DUT/DUV.
///////////////////////////////////////////////////////////////
class keccak_sequence extends uvm_sequence #(keccak_transaction);

    // registration of object tools
    `uvm_object_utils( keccak_sequence )

    // local shortcut to transaction type
    typedef REQ seq_item_t;
    // member attributes, equivalent with interface input ports
    rand logic default_rst_n;
    rand logic default_start;
    rand logic [1599:0] default_din;

    // the only item handle that is reused for all transactions
    seq_item_t item;

    // Constructor - creates new instance of this class
    function new( string name = "keccak_sequence" );
        super.new( name );
        // create item using the factory
        item = seq_item_t::type_id::create( "item" );
    endfunction: new

    // create_and_finish_item - start single item, set default values and finish it
    protected task create_and_finish_item();
        // blocks until the sequencer grants the sequence access to the driver
        start_item( item );
        // prepare item to be used (assign default data)
        item.rst_n = default_rst_n;
        item.start = default_start;
        item.din = default_din;
        // block until the driver has completed its side of the transfer protocol
        finish_item( item );
    endtask: create_and_finish_item

    task set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;
        default_start = '0;
        default_din = '0;
    endtask: set_default_inputs

endclass: keccak_sequence

// This class represents UVM sequence reseting the DUT/DUV.
class keccak_sequence_reset extends keccak_sequence;

    // registration of object tools
    `uvm_object_utils( keccak_sequence_reset )

    // Constructor - creates new instance of this class
    function new( string name = "keccak_sequence_reset" );
        super.new( name );
    endfunction: new

    // body - implements behavior of the reset sequence (unidirectional)
    task body();
        set_default_inputs();
        // set reset values, randomize() cannot be used here
        default_rst_n = RST_ACT_LEVEL;
        create_and_finish_item();
        create_and_finish_item();

        default_rst_n = ~RST_ACT_LEVEL;
        create_and_finish_item();
        create_and_finish_item();

    endtask: body

endclass: keccak_sequence_reset


class keccak_sequence_basic extends keccak_sequence;

    // registration of object tools
    `uvm_object_utils( keccak_sequence_basic )

    // Constructor - creates new instance of this class
    function new( string name = "keccak_sequence_basic" );
        super.new( name );
    endfunction: new

    // body - implements behavior of the reset sequence (unidirectional)
    task body();
        // Start of the first permutatoin
        // Permutation, the start is one clk cycle earlier than the input is taken
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;
        default_start = 1;
        default_din[31:0] = 'h7369C667;
        default_din[63:32] = 'hEC4AFF51;
        default_din[95:64] = 'hABBACD29;
        default_din[127:96] = 'h00000010;
        default_din[1023:992] = 'h80000000;

        create_and_finish_item();
        create_and_finish_item();
        // After permutation starts, when new value is set with start, the keccak is locked.
        // It keeps doing permutation of the first start occured on the input.
        // It unlocks, allows new permutation one clk cycle after the result of the started one is presented on the ouput.
        default_din = 'h0;
        create_and_finish_item();
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;

        for (int i = 0; i < 15; i++) begin
            create_and_finish_item();
        end

        // Another start, keccak is locked, it keeps doing permutation already started one
        default_start = 1;
        default_din[31:0] = 'h7369C667;
        default_din[63:32] = 'hEC4AFF51;
        default_din[95:64] = 'hABBACD29;
        default_din[127:96] = 'h00000010;
        default_din[1023:992] = 'h80000000;

        create_and_finish_item();
        create_and_finish_item();
        default_din = 'h0;
        create_and_finish_item();
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;

        // During this loop, the first permutation finishes
        for (int i = 0; i < 25; i++) begin
            create_and_finish_item();
        end

        // Start of the second permutation
        default_start = 1;
        create_and_finish_item();
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;
        default_din[31:0] = 'h7369C667;
        default_din[63:32] = 'hEC4AFF51;
        default_din[95:64] = 'hABBACD29;
        default_din[127:96] = 'h00000010;
        default_din[1023:992] = 'h80000000;
        create_and_finish_item();
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;

        for (int i = 0; i < 25; i++) begin
            create_and_finish_item();
        end

        // Start of the third permutation
        default_start = 1;
        create_and_finish_item();
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;
        default_din[31:0] = 'h7369C667;
        default_din[63:32] = 'hEC4AFF51;
        default_din[95:64] = 'hABBACD29;
        default_din[127:96] = 'h00000010;
        default_din[1023:992] = 'h80000000;
        create_and_finish_item();
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;

        for (int i = 0; i < 23; i++) begin
            create_and_finish_item();
        end

        // Set of start at the same clk cycle as keccak presents result of the third permutation on the output (signalled by keccak_intr == 1)
        // The new permutation does not start!!!
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;
        default_start = 1;
        create_and_finish_item();
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;
        default_din[31:0] = 'h7369C667;
        default_din[63:32] = 'hEC4AFF51;
        default_din[95:64] = 'hABBACD29;
        default_din[127:96] = 'h00000010;
        default_din[1023:992] = 'h80000000;
        create_and_finish_item();
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;
        create_and_finish_item();

        for (int i = 0; i < 25; i++) begin
            create_and_finish_item();
        end

        // Start of the fourth permutation
        default_start = 1;
        create_and_finish_item();
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;
        default_din[31:0] = 'h7369C667;
        default_din[63:32] = 'hEC4AFF51;
        default_din[95:64] = 'hABBACD29;
        default_din[127:96] = 'h00000010;
        default_din[1023:992] = 'h80000000;
        create_and_finish_item();
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;

        for (int i = 0; i < 24; i++) begin
            create_and_finish_item();
        end

        // Set of start of the fifth permutation one clk cycle after keccak presents result of the fourth permutation
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;
        default_start = 1;
        create_and_finish_item();
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;
        default_din[31:0] = 'h7369C667;
        default_din[63:32] = 'hEC4AFF51;
        default_din[95:64] = 'hABBACD29;
        default_din[127:96] = 'h00000010;
        default_din[1023:992] = 'h80000000;
        create_and_finish_item();
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;
        create_and_finish_item();

        for (int i = 0; i < 25; i++) begin
            create_and_finish_item();
        end

        // For functional coverage
        // reset in the same clock cycle the permutation is finished
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;
        default_start = 1;
        create_and_finish_item();
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;
        default_din[31:0] = 'h7369C667;
        default_din[63:32] = 'hEC4AFF51;
        default_din[95:64] = 'hABBACD29;
        default_din[127:96] = 'h00000010;
        default_din[1023:992] = 'h80000000;
        create_and_finish_item();
        set_default_inputs();

        for (int i = 0; i < 23; i++) begin
            create_and_finish_item();
        end

        set_default_inputs();
        default_rst_n = RST_ACT_LEVEL;
        create_and_finish_item();

        // reset and start in the same clock cycle the permutation is finished
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;
        default_start = 1;
        create_and_finish_item();
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;
        default_din[31:0] = 'h7369C667;
        default_din[63:32] = 'hEC4AFF51;
        default_din[95:64] = 'hABBACD29;
        default_din[127:96] = 'h00000010;
        default_din[1023:992] = 'h80000000;
        create_and_finish_item();
        set_default_inputs();

        for (int i = 0; i < 23; i++) begin
            create_and_finish_item();
        end

        set_default_inputs();
        default_rst_n = RST_ACT_LEVEL;
        default_start = 1;
        create_and_finish_item();

        // End of basic sequence
        set_default_inputs();
        default_rst_n = ~RST_ACT_LEVEL;
        create_and_finish_item();

    endtask: body

endclass: keccak_sequence_basic


class keccak_seq_rand extends keccak_sequence;

    // registration of object tools
    `uvm_object_utils( keccak_seq_rand )

    constraint const_RST
    {
        default_rst_n dist{
            RST_ACT_LEVEL := 5,
            ~RST_ACT_LEVEL := 95
        };
    }

    constraint const_start
    {
        default_start dist{
            START := 60,
            ~START := 40
        };
    }

    constraint const_din
    {
        default_din dist{
            ZERO := 25,
            ONE := 25,
            MAX := 25,
            [LOW:HIGH] :/ 25
        };
    }

    // Constructor - creates new instance of this class
    function new( string name = "keccak_seq_rand" );
        super.new( name );
    endfunction: new

    // body - implements behavior of the reset sequence (unidirectional)
    task body();
        // initialize PRNG
        this.srandom( SEED );
        repeat ( TRANSACTION_COUNT ) begin
          if ( !this.randomize() ) begin
            `uvm_error( "body:", "Failed to randomize!" )
          end
          create_and_finish_item();
        end
    endtask: body

endclass: keccak_seq_rand