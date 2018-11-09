#Usage startTime
printf "Flow Throughput\n\n" | tee -a overallTP.txt

python tp-new.py --startTime=12 --destIp 10.0.6.2 N-7-0.pcap plotmeTP/TP-A.plotme plotmeTPP/TP-A.plotme A | tee -a overallTP.txt
python tp-new.py --startTime=12 --destIp 10.0.7.2 N-8-0.pcap plotmeTP/TP-B.plotme plotmeTPP/TP-B.plotme B | tee -a overallTP.txt
python tp-new.py --startTime=12 --destIp 10.0.8.2 N-9-0.pcap plotmeTP/TP-C.plotme plotmeTPP/TP-C.plotme C | tee -a overallTP.txt
python tp-new.py --startTime=12 --destIp 10.0.9.2 N-10-0.pcap plotmeTP/TP-D.plotme plotmeTPP/TP-D.plotme D | tee -a overallTP.txt
python tp-new.py --startTime=12 --destIp 10.0.10.2 N-11-0.pcap plotmeTP/TP-E.plotme plotmeTPP/TP-E.plotme E | tee -a overallTP.txt

cp gnuplotscript plotmeTP
cp perflowgnuplot plotmeTP
cd plotmeTP
awk  '{$1 = $1-10}1' OFS=' ' TP-A.plotme  > TP-A_1.plotme
awk  '{$1 = $1-10}1' OFS=' ' TP-B.plotme  > TP-B_1.plotme
awk  '{$1 = $1-10}1' OFS=' ' TP-C.plotme  > TP-C_1.plotme
awk  '{$1 = $1-10}1' OFS=' ' TP-D.plotme  > TP-D_1.plotme
awk  '{$1 = $1-10}1' OFS=' ' TP-E.plotme  > TP-E_1.plotme
gnuplot gnuplotscript
gnuplot perflowgnuplot
cd ..

cp gnuplotscriptPackets plotmeTPP
cd plotmeTPP
awk  '{$1 = $1-10}1' OFS=' ' TP-A.plotme  > TP-A_1.plotme
awk  '{$1 = $1-10}1' OFS=' ' TP-B.plotme  > TP-B_1.plotme
awk  '{$1 = $1-10}1' OFS=' ' TP-C.plotme  > TP-C_1.plotme
awk  '{$1 = $1-10}1' OFS=' ' TP-D.plotme  > TP-D_1.plotme
awk  '{$1 = $1-10}1' OFS=' ' TP-E.plotme  > TP-E_1.plotme
gnuplot gnuplotscriptPackets
cd ..

printf "\nRouter Throughput\n\n" | tee -a overallTP.txt

python tp-new.py --startTime=2 N-0-0.pcap plotmeRouterTP/TP-R1.plotme plotmeRouterTPP/TP-R1.plotme R1 | tee -a overallTP.txt

cp gnuplotscriptRouters plotmeRouterTP
cd plotmeRouterTP
gnuplot gnuplotscriptRouters
cd ..

cp gnuplotscriptRoutersPackets plotmeRouterTPP
cd plotmeRouterTPP
gnuplot gnuplotscriptRoutersPackets
cd ..

mkdir -p ../Graphs
cp plotmeRouterTP/*.png ../Graphs/
cp plotmeRouterTPP/*.png ../Graphs/
cp plotmeTP/*.png ../Graphs/
cp plotmeTPP/*.png ../Graphs/
cp overallTP.txt ../Graphs/

#Cwnd plot
cp gnuplotscriptQ ../

cd ../queueTraces/
echo "Queue 1" > QueueStatsAfter2sec.txt
drops=`awk '{if ($1 >= 12) print $0}' drop-0.plotme | wc -l`
marks=`awk '{if ($1 >= 12) print $0}' mark-0.plotme | wc -l`
echo -e  "$drops Drops, $marks Marks\n" >> QueueStatsAfter2sec.txt
cp QueueStatsAfter2sec.txt ../Graphs/

cd ..
awk  '{$1 = $1-10}1' OFS=' ' queue-size.plotme  > queue-size_1.plotme
gnuplot gnuplotscriptQ
cp queueSize.png Graphs/
cp queueStats.txt Graphs/
cp config.txt Graphs/

cd ../../../utils
python gfc_dumbbell_parse_cwnd.py 10 20 0.05
python gfc_dumbbell_versus.py
