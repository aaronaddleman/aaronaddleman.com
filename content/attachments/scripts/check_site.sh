WGET=`which wget`
${WGET} --spider -e robots=off -r -p http://aaronaddleman.com 2>&1 | mail -s "Spider results for aaronaddleman.com" aaronaddleman@gmail.com