#!/bin/sh
#よく分からんけど効かない...qsub以外では無効??→  #$ -cwd

cd "$(dirname "$0")"

echo "↓↓↓Enter Git Commit Comment!↓↓↓"
read COMMENT_RAW
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
echo "COMMENT = $COMMENT"


#build page
echo "\n"
hugo

#Show Address
echo "\n"
echo "↓↓↓Your Page's URL"
grep "baseURL = \"*\"" config.toml | grep -o "https://.*\.github\.io/"


#do git push
echo "\n"
git add .
git commit -m "$COMMENT"
git push


