# Raspberry Pi as Download Server

This is a small, but practical project on Raspberry Pi. I set the Raspberry Pi as a download server. It could be accessed by domain name. You can also upload the download files to Google drive automatically for backup. If you are from China and used Baidu Wanpan, this "server" can also move the files from Baidu to Google.
  
This is a simple instruction. You can find more detail in this [link](https://medium.com/@yuanyifang/download-server-on-raspberry-pi-c5b1050242d8)

It includes 5 modules:

### 1. Download function: Aria2 and AriaNg  
- Install Aria2

      sudo apt-get install aria2
      cd ~  
      wget https://github.com/YifangY/IoTProject2019/blob/master/aria2.conf
- Modify the parameters in aria2.conf, such as target folder and rpc-secret  
- Create session file

      mkdir /home/pi/.aria2/  
      touch /home/pi/.aria2/aria2.session
- Start Aria2 on boot: Add "aria2c --conf-path={aria2 configuration file} -D" to /etc/rc.local  
- Install Web GUI

      sudo apt-get install nginx  
      cd ~  
      wget https://github.com/mayswind/AriaNg/releases/download/1.1.0/AriaNg-1.1.0.zip  
      sudo unzip AriaNg-1.1.0.zip -d /var/www/html/ang  
- Access http://{IP of Raspberry Pi}/ang by browser. Input correct parameters in RPC

### 2. Domain name: Dynu.net
- Register new account and create new domain name on Dynu.net
- Set IP update task in crontab 

      crontab -e  

  Add this line in crontab(replace UUUUU and PPPPP with your username and password):  
  /5 * * * * echo url="https://api.dynu.com/nic/update?username=UUUUU&password=PPPPP" | curl -k -K -

### 3. Install rclone to connect Google drive
- Install rclone:

      curl https://rclone.org/install.sh | sudo bash
- Configure rclone to connect Google Drive

      rclone config

### 4. Auto upload script
- Download script:  

      cd ~  
      wget https://github.com/YifangY/IoTProject2019/blob/master/uploadtogoogle.sh  
      chmod +x uploadtogoogle.sh  
- Update parameter to match your system, such as REMOTENAME, REMOTEFOLDER, ArialocalFolder
- Run script every 5 minute 

      crontab -e  

  Add this line in crontab:  
  */5 * * * * /usr/bin/flock -xn /tmp/uploadtogoogle.lock -c '/home/pi/uploadtogoogle.sh'  

### 5. Optional: Baidupcs-web
If you need to transfer file from Baidu Wangpan to Google Drive, Baidupcs-web is a good Linux client to access Baidu Wangpan. Baidupcs-web bases on BaiduPCS-Go. You can find the latest release from this [link](https://github.com/liuzhuoling2011/baidupcs-web/releases).  

    wget https://github.com/liuzhuoling2011/baidupcs-web/releases/download/3.6.7/BaiduPCS-Go-3.6.7-linux-arm.zip  
    unzip BaiduPCS-Go-3.6.7-linux-arm.zip
There is only one binary file in zip which could be executed directly

    ./BaiduPCS-Go-3.6.7-linux-arm/BaiduPCS-Go  

Access http://{IP of Raspberry Pi}:5299 in browser  
