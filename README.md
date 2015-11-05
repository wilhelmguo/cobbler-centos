#Centos7安装cobbler
##安装之前的一点说明
注意！**如果要看手动安装步骤请看：manual-install.md文档**
自动安装步骤：
###执行autoinstall.sh 
执行该命令需要输入6个参数：
  **SERVER_IP**:指定本机内网卡的IP地址  **必填**  
  **DHCP_RANGE**：指定批量装机需要获取的IP地址段  **必填**  
  **ROOT_PASSWORD**：指定批量装机后系统默认的root密码  **必填**  
  **DHCP_SUBNET**：指定DHCP的网段  **必填**  
  **DHCP_ROUTER**：指定DHCP的网管  **必填**   
  **DHCP_DNS**：指定DHCP的DNS地址  **必填**  
### 导入镜像到cobbler
把需要导入的镜像iso文件放到/opt/iso 文件夹下，执行import-iso.sh自动导入镜像！
OK！！！就是这么简单
