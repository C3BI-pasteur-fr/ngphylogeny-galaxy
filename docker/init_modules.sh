MODULE_PACKAGES="/packages"
MODULE_FILES="/usr/share/modules/modulefiles/"

while IFS="	" read -r name version image commands remainder
do
    mkdir -p $MODULE_PACKAGES/$name/$version
    singularity pull --name tmp.img $image
    mv tmp.img $MODULE_PACKAGES/$name/$version/${name}.img
    for c in $(echo $commands | sed "s/,/ /g")
    do
	echo "#!/bin/sh\nsingularity exec $MODULE_PACKAGES/$name/$version/${name}.img $c \${1+\"\$@\"}\n" > $MODULE_PACKAGES/$name/$version/$c
	chmod +x $MODULE_PACKAGES/$name/$version/$c
    done
    mkdir -p $MODULE_FILES/$name/
    cat > $MODULE_FILES/$name/$version <<EOF
#%Module1.0
proc ModulesHelp { } {
global dotversion
 
puts stderr "\t$name $version"
}
 
module-whatis "$name $version"
prepend-path PATH $MODULE_PACKAGES/$name/$version/
EOF

done < "package_list.txt"

# Install Parallel in Module
wget ftp://ftp.gnu.org/gnu/parallel/parallel-20170122.tar.bz2
tar -xjvf parallel-20170122.tar.bz2
cd parallel-20170122
./configure --prefix=$MODULE_PACKAGES/parallel/20170122
make
make install
cd ..
rm -rf parallel-20170122.tar.bz2 parallel-20170122
mkdir -p $MODULE_FILES/parallel
cat > $MODULE_FILES/parallel/20170122 <<EOF
#%Module1.0
proc ModulesHelp { } {
global dotversion
 
puts stderr "\t$name $version"
}
 
module-whatis "$name $version"
prepend-path PATH $MODULE_PACKAGES/parallel/20170122/bin/
EOF
