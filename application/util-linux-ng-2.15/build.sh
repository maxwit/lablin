./configure \
	--prefix=/usr \
	--exec-prefix=/ \
	--sysconfdir=/etc \
	--enable-login-utils \
	--enable-login-chown-vcs \
	--with-fsprobe=builtin \
	--without-pam \
	--disable-wall \
	--disable-require-password \
	|| exit 1

# sed -i 's/4755/755/' mount/Makefile

make && \
make install || exit 1

echo "root::0:0:root:/root:/bin/bash" > /etc/passwd

