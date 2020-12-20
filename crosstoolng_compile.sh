cd crosstool-ng
git checkout crosstool-ng-1.24.0
./bootstrap
./configure --enable-local
make
sudo make install
