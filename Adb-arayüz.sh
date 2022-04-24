#!/bin/bash
###
if [[ $1 == güncelle ]];then
	cd files
	#bash güncelleme.sh güncelle
	exit
fi
kontrol=$(which adb |wc -l)
if [[ $kontrol == 0 ]];then
	echo
	echo
	echo
	printf "\e[32m[*]\e[0m ADB KURULUMU YAPILIYOR"
	echo
	echo
	echo
	cp files/adb $PREFIX/bin/
	chmod 777 $PREFIX/bin/adb

fi
#################### MENÜ ####################
cd files
#bash güncelleme.sh
bash banner.sh
menu() {
echo
printf "\e[97m
[0] \e[33mADB İP BUL\e[97m

[1] \e[32mBAĞLANTI KUR\e[97m

[2] \e[32mTÜM BAĞLANTILARI SİL\e[97m

[3] \e[32mSHELL\e[97m

[4] \e[32mEKRAN RESMİ AL\e[97m

[5] \e[32mEKRAN VİDEOSU AL\e[97m

[6] \e[32mDOSYA AL\e[97m

[7] \e[32mDOSYA GÖNDER\e[97m

\e[31m[X] \e[97mÇIKIŞ\e[97m


"
echo
echo
read -e -p $'\e[31m───────[ \e[97mSEÇENEK GİRİNİZ\e[31m ]───────►  \e[0m' secim
if [ $secim == 1 ];then
	echo
	echo
	echo
	kontrol=$(cat history.txt |wc -l)
	if [[ $kontrol == 0 ]];then
		echo
	else
		adb devices -l
	fi
	while :
	do
		echo
		history -r history.txt
		history -s $ip
		printf "\e[0mMENÜYE DÖNMEK İÇİN \e[31m> \e[0mGERİ"
		echo
		echo
		echo
		read -e -p $' \e[32mİP GİRİNİZ \e[31m>>\e[0m ' ip
		echo "$ip" >> history.txt
		if [[ $ip == .. || $ip == geri || $ip == GERİ ]];then
			cd ..
			bash Adb-arayüz.sh
		fi
		echo
		echo
		echo
		adb connect $ip
		adb devices -l
		echo
		echo
		echo
	done
	exit
elif [ $secim == 2 ];then
	echo
	echo
	adb kill-server
	rm history.txt
	touch history.txt
	echo
	echo
	echo
	printf "\e[31m[*]\e[32m TÜM BAĞLANAN İP ADRESLERİ SİLİNDİ \e[31m! "
	echo
	echo
	echo
	menu
	exit
elif [ $secim == 3 ];then
	clear
	echo
	echo
	echo
	adb shell
	clear
	menu
	exit
elif [ $secim == 4 ];then
	clear
	echo
	echo
	echo
	read -p $' \e[32mRESMİN KAYDEDİLECEĞİ KONUM \e[31m>>\e[0m ' konum
	echo
	read -p $' \e[32mKAYDEDİLECEK RESMİN ADINI GİRİNİZ \e[31m>>\e[0m ' ad
	echo
	echo
	echo
	adb exec-out screencap -p > $konum/$ad.png
	cd $konum
	xdg-open $ad.png
	menu
	exit
elif [ $secim == 5 ];then
	clear
	echo
	echo
	echo
	read -p $' \e[32mVİDEONUN KAYDEDİLECEĞİ KONUM \e[31m>>\e[0m ' konum
	echo
	read -p $' \e[32mVİDEONUN KAYDEDİLECEĞİ SANİYE \e[31m>>\e[0m ' saniye
	echo
	read -p $' \e[32mKAYDEDİLECEK VİDEONUN ADINI GİRİNİZ \e[31m>>\e[0m ' ad
	echo
	echo
	echo
	adb shell screenrecord --time-limit $saniye /sdcard/$ad.mp4 && adb pull /sdcard/$ad.mp4 $konum && adb shell rm /sdcard/$ad.mp4
	cd $konum
	xdg-open $ad.mp4
	menu
	exit
elif [ $secim == 6 ];then
	clear
	echo
	echo
	echo
	read -p $' \e[32mDOSYANIN ALINACAĞI KONUM \e[31m>>\e[0m ' konum
	echo
	read -p $' \e[32mALINACAK DOSYA \e[31m>>\e[0m ' dosya
	echo
	read -p $' \e[32mDOSYANIN KAYDEDİLECEĞİ KONUM \e[31m>>\e[0m ' konum2
	echo
	echo
	echo
	adb pull $konum/$dosya $konum2
	cd $konum2
	ls
	echo
	echo
	echo
	echo
	read -p $'\e[32m DEVAM ETMEK İÇİN ENTER >>\e[0m ' cikis
	clear
	menu
	exit
elif [ $secim == 7 ];then
	clear
	echo
	echo
	echo
	read -p $' \e[32mDOSYANIN KONUMU \e[31m>>\e[0m ' konum
	echo
	read -p $' \e[32mGÖNDERİLECEK DOSYA \e[31m>>\e[0m ' dosya
	echo
	read -p $' \e[32mDOSYANIN GÖNDERİLECEĞİ KONUM \e[31m>>\e[0m ' konum2
	echo
	echo
	echo
	adb push $konum/$dosya $konum2
	echo
	echo
	echo
	echo
	read -p $'\e[32m DEVAM ETMEK İÇİN ENTER >>\e[0m ' cikis
	clear
	menu
	exit
elif [[ $secim == 0 ]];then
	echo
	echo
	echo
	adbip=$(curl -s "https://www.shodan.io/search?query=Android+debug+bridge" |grep host |awk -F'host/' '{print $NF}' |awk -F'"' '{print $NF}' |tr -d '"<>/a')
	if [[ -n $adbip ]];then
		printf "\e[33m[*]\e[97m SHODAN.İO | ANDROİD DEBUG BRİDGE"
		echo
		echo
		echo
		sleep 0.5
		printf "\e[32m$adbip\e[97m"
		echo
		echo
		echo
		sleep 1
		menu
		exit
	fi
	printf "\e[33m[*]\e[97m SHODAN.İO | ANDROİD DEBUG BRİDGE"
	echo
	echo
	echo
	sleep 0.5
	printf "\e[33m[*]\e[97m GÜNLÜK ARAMA LİMİTİNE ULAŞILDI.."
	echo
	echo
	echo
	sleep 0.5
	printf "\e[33m[*]\e[97m VPN KULLANARAK İŞLEME DEVAM EDİLEBİLİR"
	echo
	echo
	echo
	sleep 1
	menu
	exit
elif [[ $secim == x || $secim == X ]];then
	echo
	echo
	echo
	printf "\e[31m[!]\e[0m ÇIKIŞ YAPILDI "
	echo
	echo
	echo
elif [[ $secim == g || $secim == G  || $secim == .. ]];then
	hacking
elif [[ $secim == y || $secim == Y ]];then
	cd ..
	bash Adb-arayüz.sh
elif [[ $secim == d || $secim == D ]];then
	cd ..
	vim Adb-arayüz.sh
	menu
	exit
else
	echo
	echo
	echo
	printf "\e[31m[!]\e[0m HATALI SEÇİM "
	echo
	echo
	echo
	sleep 2
	cd ..
	bash Adb-arayüz.sh
fi
}
menu
