#!/bin/bash
echo "Updating AutoEnum..."
mkdir ../AutoEnumBackups
mv Scans ../AutoEnumBackups
mv Responder ../AutoEnumBackups
rm -r ../AutoEnum && cd ..
git clone https://github.com/barguppis/AutoEnum.git
cd AutoEnum && ls
echo "Done, be sure to refresh the directory in your terminal to see new files"
sleep 3
