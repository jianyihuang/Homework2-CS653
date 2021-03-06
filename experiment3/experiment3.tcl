#Create a simulator object
set ns [new Simulator]

#Define different colors for data flows (for NAM)
$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green

#Open the nam trace file
#set nf [open out.nam w]
#$ns namtrace-all $nf

#Open the trace file (start)
set tf [open experiment3.tr w]
$ns trace-all $tf

#Define a 'finish' procedure
proc finish {} {
        global ns tf
        $ns flush-trace
	#Close the trace file
        close $tf
	#Execute nam on the trace file
        exit 0
}

#Create two nodes
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

#Create a duplex link between the nodes
$ns duplex-link $n1 $n2 10Mb 10ms RED
$ns duplex-link $n2 $n5 10Mb 10ms RED
$ns duplex-link $n2 $n3 10Mb 10ms RED
$ns duplex-link $n3 $n4 10Mb 10ms RED
$ns duplex-link $n3 $n6 10Mb 10ms RED

#Create a UDP agent and attach it to node n2
set udp0 [new Agent/UDP]
$ns attach-agent $n5 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n6 $null0
$ns connect $udp0 $null0
$udp0 set fid_ 3

# Create a CBR traffic source and attach it to udp0
set cbr0 [new Application/Traffic/CBR]
#$cbr0 set packetSize_ 500
#$cbr0 set interval_ 0.005
#$cbr0 set packet_size_ 2000
$cbr0 set rate_ 9Mb
$cbr0 attach-agent $udp0
$cbr0 set type_ CBR


#set up a TCP connection from node 1 to node 4
set tcp [new Agent/TCP/Reno]
$tcp set class_ 1
$ns attach-agent $n1 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

#set up a FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP


$ns duplex-link-op $n1 $n2 orient right-down
$ns duplex-link-op $n5 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n4 orient right-up
$ns duplex-link-op $n3 $n6 orient right-down

$ns at 1.5 "$cbr0 start"
$ns at 10.0 "$cbr0 stop"
$ns at 0.0 "$ftp start"
$ns at 10.0 "$ftp stop"

proc plotWindow {tcpSource outfile} {
   global ns

   set now [$ns now]
   set cwnd [$tcpSource set cwnd_]

###Print TIME CWND   for  gnuplot to plot progressing on CWND
   puts  $outfile  "$now $cwnd"

   $ns at [expr $now+0.1] "plotWindow $tcpSource  $outfile"
}

set outfile [open  "renodrop.csv"  w]


$ns  at  0.0  "plotWindow $tcp  $outfile"

#Call the finish procedure after 5 seconds of simulation time
$ns at 11.0 "finish"

#Run the simulation
$ns run
