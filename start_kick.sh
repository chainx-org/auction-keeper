#!/bin/bash

ETH_FROM=""
KEYSTORE=""
PASSWORD=""
LOG_DIR="./log"

while getopts ":f:k:p:i:" options; do
    case $options in
        f ) ETH_FROM=$OPTARG;;
        k ) 
            echo "Keystore path: $OPTARG"
            KEYSTORE=$OPTARG
            echo "Keystore: $KEYSTORE"
            ;;
        p ) 
            echo "Password path: $OPTARG"
            PASSWORD=$OPTARG
            echo "Password: $PASSWORD"
            ;;
        i )
            echo "Will kick ilks: $OPTARG" 
            ILKS=($(echo $OPTARG | tr "," " "))
            echo "Ilks: ${ILKS[0]}"
            ;;
        \? ) echo "Usage: start_kick.sh -f 0xB6B12aDA59a8Ac44Ded72e03693dd14614224349 -k keystore -p password -i ilk1,ilk2,ilk3"
             exit 1;;
        * ) echo "Usage: start_kick.sh -f 0xB6B12aDA59a8Ac44Ded72e03693dd14614224349 -k keystore -p password -i ilk1,ilk2,ilk3"
             exit 1;;
    esac
done

if [[ ! -e $LOG_DIR ]]; then
    mkdir $LOG_DIR
fi

echo "Start flapper kick..."

nohup ./bin/auction-keeper --network sherpax-testnet --eth-from "$ETH_FROM" --eth-key key_file="$KEYSTORE",pass_file="$PASSWORD" --type flap --from-block 920545 --kick-only > ./log/flap.log 2>&1 &

echo "Flapper kick started"

echo "Start flopper kick..."

nohup ./bin/auction-keeper --network sherpax-testnet --eth-from "$ETH_FROM" --eth-key key_file="$KEYSTORE",pass_file="$PASSWORD" --type flop --from-block 920545 --kick-only > ./log/flop.log 2>&1 &

echo "Flopper kick started"

for ilk in "${ILKS[@]}"; do
    echo "Start $ilk kick..."
    nohup ./bin/auction-keeper --network sherpax-testnet --eth-from "$ETH_FROM" --eth-key key_file="$KEYSTORE",pass_file="$PASSWORD" --type clip --from-block 920545 --kick-only --ilk "$ilk" > ./log/clip_"$ilk".log 2>&1 &
    echo "$ilk kick started"
done

echo "All done."