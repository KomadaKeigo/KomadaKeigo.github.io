#!/bin/sh
#よく分からんけど効かない...qsub以外では無効??→  #$ -cwd

cd "$(dirname "$0")"

function ask_yes_no {
    while true; do
        echo -n "$* [y/n]: "
        read ANS
        case $ANS in
            [Yy]|"yes")
                return 0
                ;;  
            [Nn]|"no")
                return 1
                ;;
            *)
                echo "y or n"
                ;;
        esac
    done
}

#Wait Input and Ask y/n
while :
do
    echo "↓↓↓Enter Git Commit Comment!↓↓↓"
    read COMMENT_RAW
    #echo "\n"
    echo "COMMENT = \"$COMMENT_RAW\""

    if ask_yes_no "Is It OK?"; then
        #echo "Yes"
        break
    #else
        #echo "No"
    fi

done
#echo "Raw Comment = $COMMENT_RAW"

#Delete Spaces from Input
#tr -d string stringみたいな使い方はできないんすねー
COMMENT_SPACES_TRIMMED=`echo $COMMENT_RAW | tr -d ' 　'`

if [ -z "$COMMENT_SPACES_TRIMMED" ]; then
    echo "It's Empty Comment"
    TIME_STAMP=`date "+%Y/%m/%d %H:%M:%S"`
    COMMENT=`echo "commit at $TIME_STAMP"`
else
    COMMENT=$COMMENT_RAW
fi
echo "\n"
echo "COMMENT = \"$COMMENT\""



#build page
echo "\n"
hugo

#do git push
echo "\n"
git add .
git commit -m "$COMMENT"
git push

#Show Address
echo "\n"
echo "↓↓↓Your Page's URL"
grep "baseURL = \"*\"" config.toml | grep -o "https://.*\.github\.io/"
