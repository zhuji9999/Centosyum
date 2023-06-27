#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export LANG=zh_CN.UTF-8

#Centos一键自动化配置yum软件源epel源，dns配置，ssh优化脚本 版权归95盾所有
#开发者：云南双翼鸟网络科技有限公司

function main(){
export Blue="\033[36m";Green="\033[32m";Red="\033[31m";Font="\033[0m";
export Success="                                   [${Green}  OK  ${Font}]";Load="       loading..."
export Info="${Green}[信息]${Font} ";Error="${Red}[错误]${Font}";Tip="${Blue}[注意]${Font} "
export XT=`cat /etc/redhat-release |grep -Eos '\b[0-9]+\S*\b' |cut -d'.' -f1`;
export HX=`cat /proc/cpuinfo | grep "core id" |wc -l`;
export G=`awk '/MemTotal/{printf("%1.f\n",$2/1024/1024)}' /proc/meminfo`
export W=`getconf LONG_BIT`;
export centos=`cat /etc/redhat-release`;
check_sys;
export IP=$(curl -s myip.ipip.net | awk -F ' ' '{print $2}' | awk -F '：' '{print $2}')
export tram=$( free -m | awk '/Mem/ {print $2}' )
clear
judge;
echo -e "
*******************************************************
*             Centos一键优化脚本                      *
***********************安装服务端**********************
* ${Green}0.${Font} 退出脚本                                         *
* ${Green}1.${Font} 一键更换阿里云yum源/EPEL源                       *
* ${Green}2.${Font} 一键修改DNS(144.144.144.144 8.8.8.8)             *
* ${Green}3.${Font} 一键优化SSH链接卡顿/慢                           *
* ${Green}4.${Font} 一键执行以上所有功能                             *
* ${Green}注意${Font} 建议输入4使用一键脚本执行优化                             *
*******************************************************
*              作者：云南双翼鸟网络科技有限公司                     *
*******************************************************
中央处理器:${Green} ${HX}核 ${Font}  操作系统:${Green} ${release} ${XT} ${W}位 ${Font}
系统内存:${Green} ${G}G/${tram}M ${Font}      本机IP:${Green} ${IP} ${Font}"
read -p "请输入相对应的序列号数字:" num
case "${num}" in
	0)
	clear
    echo -e "感谢使用！欢迎下次再来！"
	;;
	1)
	clear
	install_yum
	;;
	2)
	clear
	install_dns
	;;
	3)
	clear
	install_ssh
	;;
	4)
	clear
	install_quan
	;;	
esac
}

function check_sys(){
if [[ -f /etc/redhat-release ]]; then
	release="CentOS"
elif cat /etc/issue | grep -q -E -i "debian"; then
	release="Debian"
elif cat /etc/issue | grep -q -E -i "ubuntu"; then
	release="Ubuntu"
elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
	release="CentOS"
elif cat /proc/version | grep -q -E -i "debian"; then
	release="Debian"
elif cat /proc/version | grep -q -E -i "ubuntu"; then
	release="Ubuntu"
elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
	release="CentOS"
fi
}

function judge(){
if [[ $EUID != 0 ]];then
echo -e "\033[1m 当前不是ROOT账号，建议更换ROOT账号使用。\033[0m\n"
else
echo -e "\033[1m ROOT账号权限检查通过，祝你使用愉快！\033[0m\n"
sleep 1s
fi	
}

function install_wget(){
echo -e "${Info}正在安装wget ${Load}"
check_sys;
if [ "${release}" == "CentOS" ]; then
yum install -y wget >/dev/null 2>&1	
echo -e "${Tip}wget安装成功!   ${Success}"
sleep 1s 	
else
clear
echo -e "${Tip}wget安装失败!该脚本只支持Centos系统，不支持其他系统"
fi
}

function install_curl(){
echo -e "${Info}正在安装curl ${Load}"
check_sys;
if [ "${release}" == "CentOS" ]; then
yum install -y curl >/dev/null 2>&1
echo -e "${Tip}curl安装成功!   ${Success}"
sleep 1s 	 	
else
clear
echo -e "${Tip}curl安装失败!该脚本只支持Centos系统，不支持其他系统"
fi
}

function install_yum(){
clear
echo -e "${Info}正在更换yum源为阿里云源 ${Load}"
if [ "${XT}" == "5" ]; then
echo -e "${Info}检测当前系统为：${release} ${XT} 正在选择相对应文件"
curl -s http://mirrors.aliyun.com/repo/Centos-5.repo > /etc/yum.repos.d/CentOS-Base.repo
echo -e "${Tip}已更换为：阿里云${release} ${XT} yum源   ${Success}"
fi

if [ "${XT}" == "6" ]; then
echo -e "${Info}检测当前系统为：${release} ${XT} 正在选择相对应文件"
curl -s http://mirrors.aliyun.com/repo/Centos-6.repo > /etc/yum.repos.d/CentOS-Base.repo
echo -e "${Tip}已更换为：阿里云${release} ${XT} yum源   ${Success}"
fi

if [ "${XT}" == "7" ]; then
echo -e "${Info}检测当前系统为：${release} ${XT} 正在选择相对应文件"
curl -s http://mirrors.aliyun.com/repo/Centos-7.repo > /etc/yum.repos.d/CentOS-Base.repo
echo -e "${Tip}已更换为：阿里云${release} ${XT} yum源   ${Success}"
fi

if [ "${XT}" == "8" ]; then
echo -e "${Info}检测当前系统为：${release} ${XT} 正在选择相对应文件"
curl -s http://mirrors.aliyun.com/repo/Centos-8.repo > /etc/yum.repos.d/CentOS-Base.repo
echo -e "${Tip}已更换为：阿里云${release} ${XT} yum源   ${Success}"
fi

echo -e "${Info}正在更换EPEL源为阿里云源 ${Load}"
check_sys;
if [ "${release}" == "CentOS" ]; then
cd /etc/yum.repos.d/ 
yum install wget -y
yum list | grep epel-release -y
yum install epel-release -y
wget -O /etc/yum.repos.d/epel-7.repo http://mirrors.aliyun.com/repo/epel-7.repo >/dev/null 2>&1
echo -e "${Tip}EPEL源更换成功!   ${Success}"
sleep 1s 	 	
else
clear
echo -e "${Tip}EPEL更换失败!该脚本只支持Centos系统，不支持其他系统"
fi

echo -e "${Info}正在清除旧yum源缓存 ${Load}"
yum clean all >/dev/null 2>&1
echo -e "${Tip}清除旧yum源缓存成功!   ${Success}"
sleep 1s

echo -e "${Info}正在重建yum缓存 ${Load}"
yum makecache >/dev/null 2>&1
echo -e "${Tip}重建yum缓存成功!   ${Success}"
sleep 1s
echo -e "${Tip}脚本执行完毕   ${Success}"
echo -e "${Tip}输入y返回菜单,输入n退出脚本"
read -p "输入相对应的字母(y/n):" iyes 
if [[ $iyes == y ]];then
main;
else
clear
echo -e "感谢使用！欢迎下次再来！"
fi
}

function install_dns(){
clear
echo -e "${Info}正在更换DNS为：144.144.144.144 8.8.8.8 ${Load}"
echo -e "options timeout:1 attempts:1 rotate\nnameserver 114.114.114.114\nnameserver 8.8.8.8" >/etc/resolv.conf;
echo -e "${Tip}DNS修改成功！   ${Success}"
echo -e "${Tip}脚本执行完毕   ${Success}"
echo -e "${Tip}输入y返回菜单,输入n退出脚本"
read -p "输入相对应的字母(y/n):" iyes 
if [[ $iyes == y ]];then
main;
else
clear
echo -e "感谢使用！欢迎下次再来！"
fi
}

function install_ssh(){
clear
echo -e "${Info}正在优化SSH卡顿慢问题 ${Load}"
if [ "${XT}" == "6" ]; then
echo -e "${Info}检测当前系统为：${release} ${XT} 正在选择相对应文件"
rm -f /etc/ssh/sshd_config
echo -e "
#	$OpenBSD: sshd_config,v 1.80 2008/07/02 02:24:18 djm Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/bin:/usr/bin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options change a
# default value.

#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

# Disable legacy (protocol version 1) support in the server for new
# installations. In future the default will change to require explicit
# activation of protocol 1
Protocol 2

# HostKey for protocol version 1
#HostKey /etc/ssh/ssh_host_key
# HostKeys for protocol version 2
#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_dsa_key

# Lifetime and size of ephemeral version 1 server key
#KeyRegenerationInterval 1h
#ServerKeyBits 1024

# Logging
# obsoletes QuietMode and FascistLogging
#SyslogFacility AUTH
SyslogFacility AUTHPRIV
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin yes
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#RSAAuthentication yes
#PubkeyAuthentication yes
#AuthorizedKeysFile	.ssh/authorized_keys
#AuthorizedKeysCommand none
#AuthorizedKeysCommandRunAs nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#RhostsRSAAuthentication no
# similar for protocol version 2
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# RhostsRSAAuthentication and HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no
PasswordAuthentication yes

# Change to no to disable s/key passwords
#ChallengeResponseAuthentication yes
ChallengeResponseAuthentication no

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no

# Set this to 'yes' to enable PAM authentication, account processing, 
# and session processing. If this is enabled, PAM authentication will 
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
#UsePAM no
UsePAM yes

# Accept locale-related environment variables
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding no
X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#UseLogin no
#UsePrivilegeSeparation yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#ShowPatchLevel no
UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10
#PermitTunnel no
#ChrootDirectory none

# no default banner path
#Banner none

# override default of no subsystems
Subsystem	sftp	/usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	X11Forwarding no
#	AllowTcpForwarding no
#	ForceCommand cvs server
" >/etc/ssh/sshd_config;
   /etc/init.d/sshd restart
fi   
  
if [ "${XT}" == "7" ]; then
echo -e "${Info}检测当前系统为：${release} ${XT} 正在选择相对应文件"
rm -f /etc/ssh/sshd_config  
echo -e "#	$OpenBSD: sshd_config,v 1.100 2016/08/15 12:32:04 naddy Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
SyslogFacility AUTHPRIV
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin yes
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile	.ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no
PasswordAuthentication yes

# Change to no to disable s/key passwords
#ChallengeResponseAuthentication yes
ChallengeResponseAuthentication no

# Kerberos options
KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
GSSAPIAuthentication no
GSSAPICleanupCredentials no
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no
#GSSAPIEnablek5users no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
# WARNING: 'UsePAM no' is not supported in Red Hat Enterprise Linux and may cause several
# problems.
UsePAM yes

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#UseLogin no
#UsePrivilegeSeparation sandbox
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#ShowPatchLevel no
UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# Accept locale-related environment variables
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS

# override default of no subsystems
Subsystem	sftp	/usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	X11Forwarding no
#	AllowTcpForwarding no
#	PermitTTY no
#	ForceCommand cvs server
" >/etc/ssh/sshd_config;
systemctl restart sshd.service
fi  
   
echo -e "${Tip}当前${release} ${XT} 系统已优化SSH完成！   ${Success}"  
echo -e "${Tip}脚本执行完毕   ${Success}"
echo -e "${Tip}输入y返回菜单,输入n退出脚本"
read -p "输入相对应的字母(y/n):" iyes 
if [[ $iyes == y ]];then
main;
else
clear
echo -e "感谢使用！欢迎下次再来！"
fi 
}

function install_quan(){
clear
echo -e "${Info}正在更换DNS为：144.144.144.144 8.8.8.8 ${Load}"
echo -e "options timeout:1 attempts:1 rotate\nnameserver 114.114.114.114\nnameserver 8.8.8.8" >/etc/resolv.conf;
echo -e "${Tip}DNS修改成功！   ${Success}"
sleep 1s

echo -e "${Info}正在更换yum源为阿里云源 ${Load}"
if [ "${XT}" == "5" ]; then
echo -e "${Info}检测当前系统为：${release} ${XT} 正在选择相对应文件"
curl -s http://mirrors.aliyun.com/repo/Centos-5.repo > /etc/yum.repos.d/CentOS-Base.repo
echo -e "${Tip}已更换为：阿里云${release} ${XT} yum源   ${Success}"
fi

if [ "${XT}" == "6" ]; then
echo -e "${Info}检测当前系统为：${release} ${XT} 正在选择相对应文件"
curl -s http://mirrors.aliyun.com/repo/Centos-6.repo > /etc/yum.repos.d/CentOS-Base.repo
echo -e "${Tip}已更换为：阿里云${release} ${XT} yum源   ${Success}"
fi

if [ "${XT}" == "7" ]; then
echo -e "${Info}检测当前系统为：${release} ${XT} 正在选择相对应文件"
curl -s http://mirrors.aliyun.com/repo/Centos-7.repo > /etc/yum.repos.d/CentOS-Base.repo
echo -e "${Tip}已更换为：阿里云${release} ${XT} yum源   ${Success}"
fi

if [ "${XT}" == "8" ]; then
echo -e "${Info}检测当前系统为：${release} ${XT} 正在选择相对应文件"
curl -s http://mirrors.aliyun.com/repo/Centos-8.repo > /etc/yum.repos.d/CentOS-Base.repo
echo -e "${Tip}已更换为：阿里云${release} ${XT} yum源   ${Success}"
fi

echo -e "${Info}正在更换EPEL源为阿里云源 ${Load}"
check_sys;
if [ "${release}" == "CentOS" ]; then
cd /etc/yum.repos.d/ 
yum install wget -y
yum list | grep epel-release -y
yum install epel-release -y
wget -O /etc/yum.repos.d/epel-7.repo http://mirrors.aliyun.com/repo/epel-7.repo >/dev/null 2>&1
echo -e "${Tip}EPEL源更换成功!   ${Success}"
sleep 1s 	 	
else
clear
echo -e "${Tip}EPEL更换失败!该脚本只支持Centos系统，不支持其他系统"
fi

echo -e "${Info}正在清除旧yum源缓存 ${Load}"
yum clean all >/dev/null 2>&1
echo -e "${Tip}清除旧yum源缓存成功!   ${Success}"
sleep 1s

echo -e "${Info}正在重建yum缓存 ${Load}"
yum makecache >/dev/null 2>&1
echo -e "${Tip}重建yum缓存成功!   ${Success}"
sleep 1s

echo -e "${Info}正在优化SSH卡顿慢问题 ${Load}"
if [ "${XT}" == "6" ]; then
echo -e "${Info}检测当前系统为：${release} ${XT} 正在选择相对应文件"
rm -f /etc/ssh/sshd_config
echo -e "
#	$OpenBSD: sshd_config,v 1.80 2008/07/02 02:24:18 djm Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/bin:/usr/bin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options change a
# default value.

#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

# Disable legacy (protocol version 1) support in the server for new
# installations. In future the default will change to require explicit
# activation of protocol 1
Protocol 2

# HostKey for protocol version 1
#HostKey /etc/ssh/ssh_host_key
# HostKeys for protocol version 2
#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_dsa_key

# Lifetime and size of ephemeral version 1 server key
#KeyRegenerationInterval 1h
#ServerKeyBits 1024

# Logging
# obsoletes QuietMode and FascistLogging
#SyslogFacility AUTH
SyslogFacility AUTHPRIV
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin yes
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#RSAAuthentication yes
#PubkeyAuthentication yes
#AuthorizedKeysFile	.ssh/authorized_keys
#AuthorizedKeysCommand none
#AuthorizedKeysCommandRunAs nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#RhostsRSAAuthentication no
# similar for protocol version 2
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# RhostsRSAAuthentication and HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no
PasswordAuthentication yes

# Change to no to disable s/key passwords
#ChallengeResponseAuthentication yes
ChallengeResponseAuthentication no

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
GSSAPIAuthentication no
#GSSAPICleanupCredentials yes
GSSAPICleanupCredentials yes
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no

# Set this to 'yes' to enable PAM authentication, account processing, 
# and session processing. If this is enabled, PAM authentication will 
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
#UsePAM no
UsePAM yes

# Accept locale-related environment variables
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding no
X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#UseLogin no
#UsePrivilegeSeparation yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#ShowPatchLevel no
UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10
#PermitTunnel no
#ChrootDirectory none

# no default banner path
#Banner none

# override default of no subsystems
Subsystem	sftp	/usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	X11Forwarding no
#	AllowTcpForwarding no
#	ForceCommand cvs server
" >/etc/ssh/sshd_config;
   /etc/init.d/sshd restart
fi   
  
if [ "${XT}" == "7" ]; then
echo -e "${Info}检测当前系统为：${release} ${XT} 正在选择相对应文件"
rm -f /etc/ssh/sshd_config  
echo -e "#	$OpenBSD: sshd_config,v 1.100 2016/08/15 12:32:04 naddy Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/local/bin:/usr/bin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

# If you want to change the port on a SELinux system, you have to tell
# SELinux about this change.
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
#
#Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_dsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
SyslogFacility AUTHPRIV
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin yes
#StrictModes yes
#MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes

# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile	.ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
#PasswordAuthentication yes
#PermitEmptyPasswords no
PasswordAuthentication yes

# Change to no to disable s/key passwords
#ChallengeResponseAuthentication yes
ChallengeResponseAuthentication no

# Kerberos options
KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no
#KerberosUseKuserok yes

# GSSAPI options
GSSAPIAuthentication no
GSSAPICleanupCredentials no
#GSSAPIStrictAcceptorCheck yes
#GSSAPIKeyExchange no
#GSSAPIEnablek5users no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the ChallengeResponseAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via ChallengeResponseAuthentication may bypass
# the setting of "PermitRootLogin without-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and ChallengeResponseAuthentication to 'no'.
# WARNING: 'UsePAM no' is not supported in Red Hat Enterprise Linux and may cause several
# problems.
UsePAM yes

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
#PrintMotd yes
#PrintLastLog yes
#TCPKeepAlive yes
#UseLogin no
#UsePrivilegeSeparation sandbox
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#ShowPatchLevel no
UseDNS no
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory none
#VersionAddendum none

# no default banner path
#Banner none

# Accept locale-related environment variables
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS

# override default of no subsystems
Subsystem	sftp	/usr/libexec/openssh/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	X11Forwarding no
#	AllowTcpForwarding no
#	PermitTTY no
#	ForceCommand cvs server
" >/etc/ssh/sshd_config;
systemctl restart sshd.service
fi  
 
echo -e "${Tip}当前${release} ${XT} 系统已优化SSH完成！   ${Success}"  
echo -e "${Tip}脚本执行完毕   ${Success}"
echo -e "${Tip}输入y返回菜单,输入n退出脚本"
read -p "输入相对应的字母(y/n):" iyes 
if [[ $iyes == y ]];then
main;
else
clear
echo -e "感谢使用！欢迎下次再来！"
fi
}
main
