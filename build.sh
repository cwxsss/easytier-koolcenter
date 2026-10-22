#!/bin/sh
set -e
echo "Packaging EasyTier for KoolCenter..."
tar -czvf easytier.tar.gz easytier/
md5sum easytier.tar.gz > easytier.tar.gz.md5
echo "Done!"
