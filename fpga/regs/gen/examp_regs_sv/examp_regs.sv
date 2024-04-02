// Generated by PeakRDL-regblock - A free and open-source SystemVerilog generator
//  https://github.com/SystemRDL/PeakRDL-regblock

module examp_regs (
        input wire clk,
        input wire rst,

        axi4lite_intf.slave s_axil,

        input examp_regs_pkg::examp_regs__in_t hwif_in,
        output examp_regs_pkg::examp_regs__out_t hwif_out
    );

    //--------------------------------------------------------------------------
    // CPU Bus interface logic
    //--------------------------------------------------------------------------
    logic cpuif_req;
    logic cpuif_req_is_wr;
    logic [4:0] cpuif_addr;
    logic [31:0] cpuif_wr_data;
    logic [31:0] cpuif_wr_biten;
    logic cpuif_req_stall_wr;
    logic cpuif_req_stall_rd;

    logic cpuif_rd_ack;
    logic cpuif_rd_err;
    logic [31:0] cpuif_rd_data;

    logic cpuif_wr_ack;
    logic cpuif_wr_err;

    // Max Outstanding Transactions: 2
    logic [1:0] axil_n_in_flight;
    logic axil_prev_was_rd;
    logic axil_arvalid;
    logic [4:0] axil_araddr;
    logic axil_ar_accept;
    logic axil_awvalid;
    logic [4:0] axil_awaddr;
    logic axil_wvalid;
    logic [31:0] axil_wdata;
    logic [3:0] axil_wstrb;
    logic axil_aw_accept;
    logic axil_resp_acked;

    // Transaction request acceptance
    always_ff @(posedge clk) begin
        if(rst) begin
            axil_prev_was_rd <= '0;
            axil_arvalid <= '0;
            axil_araddr <= '0;
            axil_awvalid <= '0;
            axil_awaddr <= '0;
            axil_wvalid <= '0;
            axil_wdata <= '0;
            axil_wstrb <= '0;
            axil_n_in_flight <= '0;
        end else begin
            // AR* acceptance register
            if(axil_ar_accept) begin
                axil_prev_was_rd <= '1;
                axil_arvalid <= '0;
            end
            if(s_axil.ARVALID && s_axil.ARREADY) begin
                axil_arvalid <= '1;
                axil_araddr <= s_axil.ARADDR;
            end

            // AW* & W* acceptance registers
            if(axil_aw_accept) begin
                axil_prev_was_rd <= '0;
                axil_awvalid <= '0;
                axil_wvalid <= '0;
            end
            if(s_axil.AWVALID && s_axil.AWREADY) begin
                axil_awvalid <= '1;
                axil_awaddr <= s_axil.AWADDR;
            end
            if(s_axil.WVALID && s_axil.WREADY) begin
                axil_wvalid <= '1;
                axil_wdata <= s_axil.WDATA;
                axil_wstrb <= s_axil.WSTRB;
            end

            // Keep track of in-flight transactions
            if((axil_ar_accept || axil_aw_accept) && !axil_resp_acked) begin
                axil_n_in_flight <= axil_n_in_flight + 1'b1;
            end else if(!(axil_ar_accept || axil_aw_accept) && axil_resp_acked) begin
                axil_n_in_flight <= axil_n_in_flight - 1'b1;
            end
        end
    end

    always_comb begin
        s_axil.ARREADY = (!axil_arvalid || axil_ar_accept);
        s_axil.AWREADY = (!axil_awvalid || axil_aw_accept);
        s_axil.WREADY = (!axil_wvalid || axil_aw_accept);
    end

    // Request dispatch
    always_comb begin
        cpuif_wr_data = axil_wdata;
        for(int i=0; i<4; i++) begin
            cpuif_wr_biten[i*8 +: 8] = {8{axil_wstrb[i]}};
        end
        cpuif_req = '0;
        cpuif_req_is_wr = '0;
        cpuif_addr = '0;
        axil_ar_accept = '0;
        axil_aw_accept = '0;

        if(axil_n_in_flight < 2'd2) begin
            // Can safely issue more transactions without overwhelming response buffer
            if(axil_arvalid && !axil_prev_was_rd) begin
                cpuif_req = '1;
                cpuif_req_is_wr = '0;
                cpuif_addr = {axil_araddr[4:2], 2'b0};
                if(!cpuif_req_stall_rd) axil_ar_accept = '1;
            end else if(axil_awvalid && axil_wvalid) begin
                cpuif_req = '1;
                cpuif_req_is_wr = '1;
                cpuif_addr = {axil_awaddr[4:2], 2'b0};
                if(!cpuif_req_stall_wr) axil_aw_accept = '1;
            end else if(axil_arvalid) begin
                cpuif_req = '1;
                cpuif_req_is_wr = '0;
                cpuif_addr = {axil_araddr[4:2], 2'b0};
                if(!cpuif_req_stall_rd) axil_ar_accept = '1;
            end
        end
    end


    // AXI4-Lite Response Logic
    struct {
        logic is_wr;
        logic err;
        logic [31:0] rdata;
    } axil_resp_buffer[2];

    logic [1:0] axil_resp_wptr;
    logic [1:0] axil_resp_rptr;

    always_ff @(posedge clk) begin
        if(rst) begin
            for(int i=0; i<2; i++) begin
                axil_resp_buffer[i].is_wr <= '0;
                axil_resp_buffer[i].err <= '0;
                axil_resp_buffer[i].rdata <= '0;
            end
            axil_resp_wptr <= '0;
            axil_resp_rptr <= '0;
        end else begin
            // Store responses in buffer until AXI response channel accepts them
            if(cpuif_rd_ack || cpuif_wr_ack) begin
                if(cpuif_rd_ack) begin
                    axil_resp_buffer[axil_resp_wptr[0:0]].is_wr <= '0;
                    axil_resp_buffer[axil_resp_wptr[0:0]].err <= cpuif_rd_err;
                    axil_resp_buffer[axil_resp_wptr[0:0]].rdata <= cpuif_rd_data;

                end else if(cpuif_wr_ack) begin
                    axil_resp_buffer[axil_resp_wptr[0:0]].is_wr <= '1;
                    axil_resp_buffer[axil_resp_wptr[0:0]].err <= cpuif_wr_err;
                end
                axil_resp_wptr <= axil_resp_wptr + 1'b1;
            end

            // Advance read pointer when acknowledged
            if(axil_resp_acked) begin
                axil_resp_rptr <= axil_resp_rptr + 1'b1;
            end
        end
    end

    always_comb begin
        axil_resp_acked = '0;
        s_axil.BVALID = '0;
        s_axil.RVALID = '0;
        if(axil_resp_rptr != axil_resp_wptr) begin
            if(axil_resp_buffer[axil_resp_rptr[0:0]].is_wr) begin
                s_axil.BVALID = '1;
                if(s_axil.BREADY) axil_resp_acked = '1;
            end else begin
                s_axil.RVALID = '1;
                if(s_axil.RREADY) axil_resp_acked = '1;
            end
        end

        s_axil.RDATA = axil_resp_buffer[axil_resp_rptr[0:0]].rdata;
        if(axil_resp_buffer[axil_resp_rptr[0:0]].err) begin
            s_axil.BRESP = 2'b10;
            s_axil.RRESP = 2'b10;
        end else begin
            s_axil.BRESP = 2'b00;
            s_axil.RRESP = 2'b00;
        end
    end

    logic cpuif_req_masked;

    // Read & write latencies are balanced. Stalls not required
    assign cpuif_req_stall_rd = '0;
    assign cpuif_req_stall_wr = '0;
    assign cpuif_req_masked = cpuif_req
                            & !(!cpuif_req_is_wr & cpuif_req_stall_rd)
                            & !(cpuif_req_is_wr & cpuif_req_stall_wr);

    //--------------------------------------------------------------------------
    // Address Decode
    //--------------------------------------------------------------------------
    typedef struct {
        logic scratchpad;
        logic version;
        logic control;
        logic status;
        logic mixed[4];
    } decoded_reg_strb_t;
    decoded_reg_strb_t decoded_reg_strb;
    logic decoded_req;
    logic decoded_req_is_wr;
    logic [31:0] decoded_wr_data;
    logic [31:0] decoded_wr_biten;

    always_comb begin
        decoded_reg_strb.scratchpad = cpuif_req_masked & (cpuif_addr == 5'h0);
        decoded_reg_strb.version = cpuif_req_masked & (cpuif_addr == 5'h4);
        decoded_reg_strb.control = cpuif_req_masked & (cpuif_addr == 5'h8);
        decoded_reg_strb.status = cpuif_req_masked & (cpuif_addr == 5'hc);
        for(int i0=0; i0<4; i0++) begin
            decoded_reg_strb.mixed[i0] = cpuif_req_masked & (cpuif_addr == 5'h10 + i0*5'h4);
        end
    end

    // Pass down signals to next stage
    assign decoded_req = cpuif_req_masked;
    assign decoded_req_is_wr = cpuif_req_is_wr;
    assign decoded_wr_data = cpuif_wr_data;
    assign decoded_wr_biten = cpuif_wr_biten;

    //--------------------------------------------------------------------------
    // Field logic
    //--------------------------------------------------------------------------
    typedef struct {
        struct {
            struct {
                logic [31:0] next;
                logic load_next;
            } scratchpad;
        } scratchpad;
        struct {
            struct {
                logic next;
                logic load_next;
            } ctl0;
            struct {
                logic next;
                logic load_next;
            } ctl1;
        } control;
        struct {
            struct {
                logic [7:0] next;
                logic load_next;
                logic incrthreshold;
                logic overflow;
            } count0;
            struct {
                logic [7:0] next;
                logic load_next;
            } events;
        } mixed[4];
    } field_combo_t;
    field_combo_t field_combo;

    typedef struct {
        struct {
            struct {
                logic [31:0] value;
            } scratchpad;
        } scratchpad;
        struct {
            struct {
                logic value;
            } ctl0;
            struct {
                logic value;
            } ctl1;
        } control;
        struct {
            struct {
                logic [7:0] value;
            } count0;
            struct {
                logic [7:0] value;
            } events;
        } mixed[4];
    } field_storage_t;
    field_storage_t field_storage;

    // Field: examp_regs.scratchpad.scratchpad
    always_comb begin
        automatic logic [31:0] next_c;
        automatic logic load_next_c;
        next_c = field_storage.scratchpad.scratchpad.value;
        load_next_c = '0;
        if(decoded_reg_strb.scratchpad && decoded_req_is_wr) begin // SW write
            next_c = (field_storage.scratchpad.scratchpad.value & ~decoded_wr_biten[31:0]) | (decoded_wr_data[31:0] & decoded_wr_biten[31:0]);
            load_next_c = '1;
        end
        field_combo.scratchpad.scratchpad.next = next_c;
        field_combo.scratchpad.scratchpad.load_next = load_next_c;
    end
    always_ff @(posedge clk) begin
        if(rst) begin
            field_storage.scratchpad.scratchpad.value <= 32'h0;
        end else if(field_combo.scratchpad.scratchpad.load_next) begin
            field_storage.scratchpad.scratchpad.value <= field_combo.scratchpad.scratchpad.next;
        end
    end
    assign hwif_out.scratchpad.scratchpad.value = field_storage.scratchpad.scratchpad.value;
    // Field: examp_regs.control.ctl0
    always_comb begin
        automatic logic [0:0] next_c;
        automatic logic load_next_c;
        next_c = field_storage.control.ctl0.value;
        load_next_c = '0;
        if(decoded_reg_strb.control && decoded_req_is_wr) begin // SW write
            next_c = (field_storage.control.ctl0.value & ~decoded_wr_biten[0:0]) | (decoded_wr_data[0:0] & decoded_wr_biten[0:0]);
            load_next_c = '1;
        end
        field_combo.control.ctl0.next = next_c;
        field_combo.control.ctl0.load_next = load_next_c;
    end
    always_ff @(posedge clk) begin
        if(rst) begin
            field_storage.control.ctl0.value <= 1'h1;
        end else if(field_combo.control.ctl0.load_next) begin
            field_storage.control.ctl0.value <= field_combo.control.ctl0.next;
        end
    end
    assign hwif_out.control.ctl0.value = field_storage.control.ctl0.value;
    // Field: examp_regs.control.ctl1
    always_comb begin
        automatic logic [0:0] next_c;
        automatic logic load_next_c;
        next_c = field_storage.control.ctl1.value;
        load_next_c = '0;
        if(decoded_reg_strb.control && decoded_req_is_wr) begin // SW write
            next_c = (field_storage.control.ctl1.value & ~decoded_wr_biten[1:1]) | (decoded_wr_data[1:1] & decoded_wr_biten[1:1]);
            load_next_c = '1;
        end
        field_combo.control.ctl1.next = next_c;
        field_combo.control.ctl1.load_next = load_next_c;
    end
    always_ff @(posedge clk) begin
        if(rst) begin
            field_storage.control.ctl1.value <= 1'h1;
        end else if(field_combo.control.ctl1.load_next) begin
            field_storage.control.ctl1.value <= field_combo.control.ctl1.next;
        end
    end
    assign hwif_out.control.ctl1.value = field_storage.control.ctl1.value;
    for(genvar i0=0; i0<4; i0++) begin
        // Field: examp_regs.mixed[].count0
        always_comb begin
            automatic logic [7:0] next_c;
            automatic logic load_next_c;
            next_c = field_storage.mixed[i0].count0.value;
            load_next_c = '0;
        
            // HW Write
            next_c = hwif_in.mixed[i0].count0.next;
            load_next_c = '1;
            if(hwif_in.mixed[i0].count0.incr) begin // increment
                field_combo.mixed[i0].count0.overflow = (((9)'(next_c) + 8'h1) > 8'hff);
                next_c = next_c + 8'h1;
                load_next_c = '1;
            end else begin
                field_combo.mixed[i0].count0.overflow = '0;
            end
            field_combo.mixed[i0].count0.incrthreshold = (field_storage.mixed[i0].count0.value >= 8'hff);
            field_combo.mixed[i0].count0.next = next_c;
            field_combo.mixed[i0].count0.load_next = load_next_c;
        end
        always_ff @(posedge clk) begin
            if(rst) begin
                field_storage.mixed[i0].count0.value <= 8'h0;
            end else if(field_combo.mixed[i0].count0.load_next) begin
                field_storage.mixed[i0].count0.value <= field_combo.mixed[i0].count0.next;
            end
        end
        assign hwif_out.mixed[i0].count0.value = field_storage.mixed[i0].count0.value;
        // Field: examp_regs.mixed[].events
        always_comb begin
            automatic logic [7:0] next_c;
            automatic logic load_next_c;
            next_c = field_storage.mixed[i0].events.value;
            load_next_c = '0;
            if(hwif_in.mixed[i0].events.hwset) begin // HW Set
                next_c = '1;
                load_next_c = '1;
            end else if(decoded_reg_strb.mixed[i0] && !decoded_req_is_wr) begin // SW clear on read
                next_c = '0;
                load_next_c = '1;
            end else begin // HW Write
                next_c = hwif_in.mixed[i0].events.next;
                load_next_c = '1;
            end
            field_combo.mixed[i0].events.next = next_c;
            field_combo.mixed[i0].events.load_next = load_next_c;
        end
        always_ff @(posedge clk) begin
            if(rst) begin
                field_storage.mixed[i0].events.value <= 8'h0;
            end else if(field_combo.mixed[i0].events.load_next) begin
                field_storage.mixed[i0].events.value <= field_combo.mixed[i0].events.next;
            end
        end
    end

    //--------------------------------------------------------------------------
    // Write response
    //--------------------------------------------------------------------------
    assign cpuif_wr_ack = decoded_req & decoded_req_is_wr;
    // Writes are always granted with no error response
    assign cpuif_wr_err = '0;

    //--------------------------------------------------------------------------
    // Readback
    //--------------------------------------------------------------------------

    logic readback_err;
    logic readback_done;
    logic [31:0] readback_data;

    // Assign readback values to a flattened array
    logic [31:0] readback_array[8];
    assign readback_array[0][31:0] = (decoded_reg_strb.scratchpad && !decoded_req_is_wr) ? field_storage.scratchpad.scratchpad.value : '0;
    assign readback_array[1][15:0] = (decoded_reg_strb.version && !decoded_req_is_wr) ? hwif_in.version.minor.next : '0;
    assign readback_array[1][31:16] = (decoded_reg_strb.version && !decoded_req_is_wr) ? hwif_in.version.major.next : '0;
    assign readback_array[2][0:0] = (decoded_reg_strb.control && !decoded_req_is_wr) ? field_storage.control.ctl0.value : '0;
    assign readback_array[2][1:1] = (decoded_reg_strb.control && !decoded_req_is_wr) ? field_storage.control.ctl1.value : '0;
    assign readback_array[2][31:2] = '0;
    assign readback_array[3][0:0] = (decoded_reg_strb.status && !decoded_req_is_wr) ? hwif_in.status.sts0.next : '0;
    assign readback_array[3][1:1] = (decoded_reg_strb.status && !decoded_req_is_wr) ? hwif_in.status.sts1.next : '0;
    assign readback_array[3][31:2] = '0;
    for(genvar i0=0; i0<4; i0++) begin
        assign readback_array[i0*1 + 4][7:0] = (decoded_reg_strb.mixed[i0] && !decoded_req_is_wr) ? field_storage.mixed[i0].count0.value : '0;
        assign readback_array[i0*1 + 4][15:8] = (decoded_reg_strb.mixed[i0] && !decoded_req_is_wr) ? field_storage.mixed[i0].events.value : '0;
        assign readback_array[i0*1 + 4][31:16] = '0;
    end

    // Reduce the array
    always_comb begin
        automatic logic [31:0] readback_data_var;
        readback_done = decoded_req & ~decoded_req_is_wr;
        readback_err = '0;
        readback_data_var = '0;
        for(int i=0; i<8; i++) readback_data_var |= readback_array[i];
        readback_data = readback_data_var;
    end

    assign cpuif_rd_ack = readback_done;
    assign cpuif_rd_data = readback_data;
    assign cpuif_rd_err = readback_err;
endmodule