#!/bin/bash

MARKDOWN_FILES_CHANGED=`(git diff --name-only $TRAVIS_COMMIT_RANGE || true) | grep .md`

echo "Running spelling check for files:"
echo $MARKDOWN_FILES_CHANGED

if [ -z "$MARKDOWN_FILES_CHANGED" ]
then
    echo -e "No markdown file to check."

    exit 0;
fi

# cat all markdown files that changed
TEXT_CONTENT_WITHOUT_METADATA=`cat $(echo "$MARKDOWN_FILES_CHANGED" | sed -E ':a;N;$!ba;s/\n/ /g')`
# remove metadata tags
TEXT_CONTENT_WITHOUT_METADATA=`echo "$TEXT_CONTENT_WITHOUT_METADATA" | grep -v -E '^(layout:|permalink:|date:|date_gmt:|authors:|categories:|tags:|cover:)(.*)'`
# remove { } attributes
TEXT_CONTENT_WITHOUT_METADATA=`echo "$TEXT_CONTENT_WITHOUT_METADATA" | sed -E 's/\{:([^\}]+)\}//g'`
# remove html
TEXT_CONTENT_WITHOUT_METADATA=`echo "$TEXT_CONTENT_WITHOUT_METADATA" | sed -E 's/<([^<]+)>//g'`
# remove code blocks
TEXT_CONTENT_WITHOUT_METADATA=`echo "$TEXT_CONTENT_WITHOUT_METADATA" | sed  -n '/^\`\`\`/,/^\`\`\`/ !p'`
# remove links
TEXT_CONTENT_WITHOUT_METADATA=`echo "$TEXT_CONTENT_WITHOUT_METADATA" | sed -E 's/http(s)?:\/\/([^ ]+)//g'`

MISSPELLED=`echo "$TEXT_CONTENT_WITHOUT_METADATA" | aspell --lang=en --encoding=utf-8 --personal=./localDictionary.en.pws list | sort -u`

NB_MISSPELLED=`echo "$MISSPELLED" | wc -l`

if [ "$NB_MISSPELLED" -gt 0 ]
then
    echo -e "Words that might be misspelled, please check:"
    MISSPELLED=`echo "$MISSPELLED" | sed -E ':a;N;$!ba;s/\n/, /g'`
    echo "$MISSPELLED"
    COMMENT="$NB_MISSPELLED words might be misspelled, please check them: $MISSPELLED"
    exit 1;
else
    COMMENT="No spelling errors, congratulations!"
    echo -e "$COMMENT"
    exit 0;
fi
