echo `pwd`
sum=$(ls -l x_size/*.csv | wc -l)
echo $sum
paste -d" " x_size/*.csv | nawk -v -F ";" s="$sum" '{
    for(i=0;i<=s-1;i++)
    {
        t1 = 5+(i*6)
        temp1 = temp1 + $t1
    }
    print $1"; "temp1/s"
    temp1=0
}'
