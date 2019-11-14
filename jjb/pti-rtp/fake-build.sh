echo "FAKE BUILD STARTS!"
fakedir="${dir}/prj_oran-inf/tmp-glibc/deploy/images/intel-x86-64"
mkdir -p $fakedir
fake="$fakedir/oran-image-inf-host-intel-x86-64.iso"
touch $fake
ls -l $fake
echo "FAKE BUILD ENDS!"
