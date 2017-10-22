#!/usr/bin/env python

trace_file = []
with open("experiment3.tr") as f:
    trace_file = f.readlines()

interval = 0.5
time = 0

cbr_src_addr = "4.0"
cbr_dest_addr = "5.0"
cbr_from_node = "4"
cbr_to_node = "5"
cbr_start_time = 0
cbr_end_time = 0
cbr_int_recvsize = 0
cbr_tot_recvsize = 0

tcp_src_addr = "0.0"
tcp_dest_addr = "3.0"
tcp_from_node = "0"
tcp_to_node = "3"
tcp_start_time = 0
tcp_end_time = 0
tcp_int_recvsize = 0
tcp_tot_recvsize = 0


CBR_throughput_data = []
TCP_throughput_data = []
CBR_latency_data = []
TCP_latency_data = []
CBR_latency_dict = {}
TCP_latency_dict = {}


for trace in trace_file:
    tr = trace.split()

    if float(tr[1]) - time <= interval:
        if tr[0] == 'r'and tr[3] == cbr_to_node and tr[8] == cbr_src_addr and tr[9] == cbr_dest_addr and tr[4] == "cbr":
            cbr_int_recvsize += int(tr[5])
            cbr_tot_recvsize += int(tr[5])
        if tr[0] == 'r' and tr[3] == tcp_to_node and tr[8] == tcp_src_addr and tr[9] == tcp_dest_addr and tr[4] == "tcp":
            tcp_int_recvsize += int(tr[5])
            tcp_tot_recvsize += int(tr[5])

        if tr[0] == '-' and tr[2] == cbr_from_node and tr[3] == '1' and tr[8] == cbr_src_addr and tr[9] == cbr_dest_addr and tr[4] == "cbr":

        if tr[0] == '-' and tr[2] == tcp_from_node and tr[3] == '1' and tr[8] == tcp_src_addr and tr[9] == tcp_dest_addr and tr[4] == "tcp":

    else:
        cbr_throughput = 0.000008*(cbr_int_recvsize/interval)
        CBR_data.append("{},{}".format(time, cbr_throughput))
        tcp_throughput = 0.000008*(tcp_int_recvsize/interval)
        TCP_data.append("{},{}".format(time, tcp_throughput))

        time += interval

        if tr[0] == 'r' and tr[3] == cbr_to_node and tr[8] == cbr_src_addr and tr[9] == cbr_dest_addr and tr[4] == "cbr":
            cbr_int_recvsize = int(tr[5])
            cbr_tot_recvsize += int(tr[5])
        else:
            cbr_int_recvsize = 0

        if tr[0] == 'r' and tr[3] == tcp_to_node and tr[8] == tcp_src_addr and tr[9] == cbr_dest_addr and tr[4] == "tcp":
            tcp_int_recvsize = int(tr[5])
            tcp_tot_recvsize += int(tr[5])
        else:
            tcp_int_recvsize = 0

        #while float(tr[1]) - time > interval:
            #print time +  "0.0\n"
            #time += interval


cbr_throughput = 0.000008*(cbr_int_recvsize/interval)
CBR_data.append("{},{}".format(time, cbr_throughput))
tcp_throughput = 0.000008*(tcp_int_recvsize/interval)
TCP_data.append("{},{}".format(time, tcp_throughput))
time += interval

with open("CBR_output.csv", 'w') as cbrf:
    cbrf.write("\n".join(CBR_data))

with open("TCP_output.csv", 'w') as tcpf:
    tcpf.write("\n".join(TCP_data))

avg_cbr_throughput = 0.000008*(cbr_tot_recvsize/time)
print "Avg CBR throughput {} to {} = {} Mbits/sec".format(cbr_src_addr, cbr_dest_addr, avg_cbr_throughput)
avg_tcp_throughput = 0.000008*(tcp_tot_recvsize/time)
print "Avg TCP throughput {} to {} = {} Mbits/sec".format(tcp_src_addr, tcp_dest_addr, avg_tcp_throughput)
