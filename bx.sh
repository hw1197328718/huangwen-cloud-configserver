
#!/bin/sh

bx_path="/data/baixun"
download_path="https://cdndown.kd0518.com/download/install"
client_jar="cdn-client.jar"
client_path=$download_path"/"$client_jar
java_ver="17"
install_finish="Complete"
install_ready="already"


process_ret=`ps -ef |grep $client_jar |grep -v "grep" |wc -l`
#echo $process_ret
if [ $process_ret != 0 ]; then
	echo 'the current process already exists'
	exit
fi


user_id=$1
if [ "$user_id" = '' ]; then
	echo "input parameter error,please contact customer service"
 	exit
fi


echo "start create file directory =>>>  $bx_path ...... "
if [ ! -d $bx_path ]; then
	mkdir -p $bx_path
fi
echo -e "file directory finish ...... \n\n"

echo $user_id > $bx_path"/"userId.txt

echo "install softwares ...... "
	echo "curl install ...... "
	yum -y install curl

	echo "JDK 17 ...... "
	yum -y install java-17-openjdk

echo -e "install softwares finish ...... \n\n"


echo "donwload client JAR package ...... "
echo $client_path
if [ ! -f "$bx_path""/""$client_jar" ]; then
	tmp_param=0
	while [ 0 == $tmp_param ] 
	do
        	curl -C - -O $client_path 2>&1 | tee curl.out
	        ret=`cat curl.out | awk 'END {print $(NF-9)}'`
		echo -e "download:"$ret"%\n"
		if [ $ret == 100  ]; then
        	        tmp_param=1
	        else
			echo -e "\n\nThe network is unstable, please wait patiently ...... "
		fi
	done
	mv $client_jar $bx_path
fi
echo -e "client JAR package download finish ...... \n\n"


echo "run client JAR package ...... "
if [ ! -f "$bx_path""/""$client_jar" ]; then
	echo $client_jar"  file does not exist"
	exit
fi

cd $bx_path
nohup java -jar $client_jar $user_id >/dev/null 2>&1 &
echo -e "run client JAR package finish ...... \n\n"


echo "install complete ...... "
