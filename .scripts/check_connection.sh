HOST=fedoraproject.org

ping -c1 $HOST 1>/dev/null 2>/dev/null
SUCCESS=$?

if [ $SUCCESS -eq 0 ]
then
    echo "<fc=#afa193></fc>"
else
    echo "<fc=#212121></fc>"
fi
