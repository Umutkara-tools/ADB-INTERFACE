#!/bin/bash
clear
cd ..
depourl=$(cat .git/config |grep url |awk '{print $3}')
depoadi=$(basename $depourl)
tarih=$(cat README.md |grep ncelleme |awk {'print $2'})
#################### GÜNCELLEME TARİHİ EKLEME ####################
if [[ $1 == güncelle ]];then
	echo
	echo
	echo
	printf "\e[33m SON GÜNCELLEME TARİHİ \e[31m>\e[0m $tarih"
	echo
	echo
	echo
	ytarih=$(date +%d.%m.%G)
	printf "\e[32mYENİ GÜNCELLEME TARİHİ \e[31m>\e[0m $ytarih"
	echo
	echo
	echo
	sed -ie "s/$tarih/$ytarih/g" README.md
	printf "\e[32m[*]\e[0m TARİH GÜNCELLENDİ "
	echo
	echo
	echo
	rm README.mde
	exit

fi
menu () {
#################### OTOMATİK GÜNCEKLEME ####################
otomatik_guncelleme() {
guncelleme=$(curl -s "$depourl" |grep -o $tarih)
if [ "$guncelleme" = "$tarih" ];then
	echo

else
	kontrol=$(curl -s "$depourl" |grep -o not-found |wc -w)
	if [[ $kontrol == 0 ]];then
		echo
	else
		echo
		echo
		echo
		printf "\e[31m[!]\e[0m$depoadi GÜNCELLEME YAPILAMIYOR \e[31m!!!\e[0m"
		echo
		echo
		echo
		echo
		sleep 2
		printf "\e[31m[!]\e[0m $depoadi DEPOSU BULUNAMADI \e[31m!!!\e[0m"
		echo
		echo
		exit
	fi

	echo
	echo
	echo
	printf "\e[32m[*]\e[0m $depoadi GÜNCELLENİYOR "
	echo
	echo
	echo
	sleep 2
	echo -e "$depourl\n$depoadi" > .depo.txt
	rm -rf *
	rm -rf .git
	depourl=$(sed -n 1p .depo.txt)
	depoadi=$(sed -n 2p .depo.txt)
	git clone $depourl
	cd $depoadi
	mv * ../
	mv .git ../
	cd ..
	rm -rf $depoadi
	tool=$(sed -n 1p README.md)
	PID=$(ps aux |grep "bash $tool.sh" |grep -v grep |grep -v index |awk '{print $2}')
	kill -9 $PID
	clear
	echo
	echo
	echo
	printf "\e[32m[✓]\e[97m $depoadi GÜNCELLENDİ "
	rm .depo.txt
	echo
	echo
	echo
	printf "
	\e[33m
	$(pwd)
	\e[0m"
	echo
	echo
	echo
	ls
	echo
	echo
	echo
	exit
fi
}
int_test=$(curl -s "$depourl" |wc -l)
if [[ $int_test -gt 0 ]];then
	otomatik_guncelleme
else
	echo
	echo
	echo
	printf "\e[31m[!]\e[97m İNTERNET BAĞLANTINIZI KONTROL EDİN.."
	echo
	echo
	echo
fi
}
gitkontrol=$(pwd)
if [[ -a $gitkontrol/.git/config ]];then
	menu
fi

