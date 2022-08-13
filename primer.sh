#!/usr/bin/env bash

source ~//dotfiles/.commands/text
echo $(text invert)
echo '                                                                                '
echo ' :<mac primer>                                                                 '
echo '                                                                                '
echo $(text)
echo 'Requesting root access…'
sudo -v; while true; do sudo -n true; sleep 60; kill -0 \"$$\" || exit; done 2>/dev/null &
echo $(text invert)
echo '                                                                                '
echo ' :<install apps>                                                               '
echo '                                                                                '
echo $(text)
chmod +x ~//apps/install.sh
~//apps/install.sh
echo $(text invert)
echo '                                                                                '
echo ' :<install dotfiles>                                                           '
echo '                                                                                '
echo $(text)
chmod +x ~//dotfiles/install.sh
~//dotfiles/install.sh
echo $(text invert)
echo '                                                                                '
echo ' :<install preferences>                                                        '
echo '                                                                                '
echo $(text)
~//dock
~//preferences
