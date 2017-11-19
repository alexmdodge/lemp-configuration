#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                         #
#                         Build                           #
#   Packs up the whole directory as a tar bar for easy    #
#     sharing between other servers and repositories.     #
#                                                         #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

echo "Packaging LEMP tools . . ."
name="lemp-configuration"

cd ..
tar -czf ./$name.tar.gz $name
mv $name.tar.gz $name
cd ./$name

echo "$name.tar.gz successfully created"