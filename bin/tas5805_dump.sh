if [ $# != 4 ] ;then
  echo "USAGE: $0 BookStart BookEnd PageStart PageEnd"
  echo " e.g.: $0 0 10 0 10"
  exit 1;
fi
book=$1;
page=$3;
blen=$2;
plen=$4;
echo "now start tas5805 regs dump"
echo "book: $book-$blen, page: $page-$plen"
while [ $book -le $blen ]
do
  page=$3;
  while [ $page -le $plen ]
  do
    echo $book:$page >  /sys/class/xiaomi-speaker/AMP/book_page
    cat /sys/class/xiaomi-speaker/AMP/dsp_regs
    echo " "
    page=`expr $page + 1 `
  done
  book=`expr $book + 1 `
done
