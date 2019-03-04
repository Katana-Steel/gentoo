# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 xdg

DESCRIPTION="A program for drawing beautiful mathematically-based images known as fractals"
HOMEPAGE="http://edyoung.github.io/gnofract4d/"
SRC_URI="https://github.com/edyoung/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+help video"

COMMON_DEPEND="
	media-libs/libpng:0=
	virtual/jpeg:0"
RDEPEND="${COMMON_DEPEND}
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
	video? ( media-video/ffmpeg[vpx,zlib] )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	help? ( app-text/docbook-xsl-stylesheets
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-libs/libxslt
		x11-libs/gtk+:3[introspection] )"

PATCHES=(
	"${FILESDIR}"/${P}-xsl.patch
)

python_compile_all() {
	if use help; then
		ln -s "${BUILD_DIR}"/lib/fract4d/*.so fract4d/ || die
		"${EPYTHON}" createdocs.py || die
	fi
}

python_install_all() {
	distutils-r1_python_install_all
	rm -rf "${ED%/}"/usr/share/doc/${PN} || die
	use help || rm -rf "${ED%/}"/usr/share/gnome/help/${PN} || die
}
