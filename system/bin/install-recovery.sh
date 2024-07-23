#!/system/bin/sh
  echo 1 > /sys/module/sec/parameters/recovery_done
if ! applypatch -c EMMC:/dev/recovery:7804928:6d49ad5b9c9dd7587bcd36da0525e11a9a9197d1; then
  applypatch -b /system/etc/recovery-resource.dat EMMC:/dev/bootimg:7092224:2c4b1337f07b195f4b5eaa64970574213d8cb584 EMMC:/dev/recovery 6d49ad5b9c9dd7587bcd36da0525e11a9a9197d1 7804928 2c4b1337f07b195f4b5eaa64970574213d8cb584:/system/recovery-from-boot.p && log -t recovery "Installing new recovery image: succeeded" || log -t recovery "Installing new recovery image: failed"
  if applypatch -c EMMC:/dev/recovery:7804928:6d49ad5b9c9dd7587bcd36da0525e11a9a9197d1; then
        echo 0 > /sys/module/sec/parameters/recovery_done
        log -t recovery "Install new recovery image completed"
        
  if applysig /system/etc/recovery.sig recovery; then
    sync
    log -t recovery "Apply recovery image signature completed"
  else
    log -t recovery "Apply recovery image signature fail!!"
  fi
  
  else
        echo 2 > /sys/module/sec/parameters/recovery_done
        log -t recovery "Install new recovery image not completed"
  fi
else
  log -t recovery "Recovery image already installed"
fi
