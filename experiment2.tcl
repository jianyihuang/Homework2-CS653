#Create a simulator object
set ns [new Simulator]

#Open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} {
        global ns nf
        $ns flush-trace
	#Close the trace file
        close $nf
	#Execute nam on the trace file
        exec nam out.nam &
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
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n5 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail
$ns duplex-link $n3 $n4 1Mb 10ms DropTail
$ns duplex-link $n3 $n6 1Mb 10ms DropTail



#set up a TCP connection from node 1 to node 4
set tcp0 [new Agent/TCP/Reno]
$tcp0 set class_ 2
$ns attach-agent $n1 $tcp0
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp0 $sink
$tcp0 set fid_ 1

#set up a FTP over TCP connection
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set type_ FTP

#set up a TCP connection from node 5 to node 6
set tcp1 [new Agent/TCP/Reno]
$tcp1 set class_ 2
$ns attach-agent $n5 $tcp1
set sink [new Agent/TCPSink]
$ns attach-agent $n6 $sink
$ns connect $tcp1 $sink
$tcp1 set fid_ 1

#set up a FTP over TCP connection
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP

#set the topology
$ns duplex-link-op $n1 $n2 orient right-down
$ns duplex-link-op $n5 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right
$ns duplex-link-op $n3 $n4 orient right-up
$ns duplex-link-op $n3 $n6 orient right-down

$ns at 0.5 "$ftp0 start"
$ns at 4.5 "$ftp0 stop"
$ns at 0.5 "$ftp1 start"
$ns at 4.5 "$ftp1 stop"

#Call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"

#Run the simulation
$ns run
