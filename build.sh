#!/bin/bash

##
# Packs up directory as a tar bar for easy upload to the
# new server instance
##

echo "Updating tooling tarball . . ."
name="lemp-instance-config"

cd ..
tar -czf ./$name.tar.gz $name
mv $name.tar.gz $name
cd ./$name