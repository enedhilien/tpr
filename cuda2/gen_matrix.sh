for i in {1..1048576}; do echo $RANDOM; done > A_1024x1024.txt
for i in {1..1048576}; do echo $RANDOM; done > B_1024x1024.txt

for i in {1..262144}; do echo $RANDOM; done > A_512x512.txt
for i in {1..262144}; do echo $RANDOM; done > B_512x512.txt
