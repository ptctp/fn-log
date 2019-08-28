#!/bin/bash
bcc=build-check-coverage
if [ ! -d "./$bcc" ]; then
  mkdir $bcc
fi
cd $bcc
cmake -DENABLE_GCOV=TRUE .. 
make -j4
cd ..

cd bin
ts=`find ./ -maxdepth 1 -executable -type f |egrep -v "log" | grep "test_"`
for t in $ts ;
do
  echo begin test $t 
  $t
  if [ $? -eq 0 ]; then
    echo test $t success.
  else
    echo test $t failed
    exit $?
  fi

done
cd ..

echo 
echo 
echo 
echo "all success "
echo 
echo 
echo 
lcov --capture --initial --directory ./ --output-file $bcc/coverage.info
lcov --no-checksum --directory ./ --capture --output-file $bcc/coverage.info
genhtml --highlight --legend --output-directory $bcc/report $bcc/coverage.info

