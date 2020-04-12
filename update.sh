#!/bin/bash
echo "Updating AutoEnum..."
cd ..
rm -r AutoEnum
git clone https://github.com/barguppis/AutoEnum.git
cd ..
sleep 1
cd AutoEnum
echo "Done."
sleep 3
