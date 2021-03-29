# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit rpm

DESCRIPTION="The full stack of chef-workstation"
HOMEPAGE="https://chef.sh"
SRC_URI="https://packages.chef.io/files/stable/chef-workstation/${PV}/el/8/chef-workstation-${PV}-1.el7.x86_64.rpm -> chef-workstation-${PV}-1.el7.x86_64.rpm"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* amd64"
IUSE="chef-workstation-app"
SLOT="0"

DEPEND="app-shells/bash"
RDEPEND="${DEPEND}"

src_unpack() {
  rpm_src_unpack ${A}
  mkdir -p "${S}"
}

src_install() {
  cp -pRP "${WORKDIR}"/opt "${D}"/ || die
  insinto / && doins -r / || die
  # todo: make exeption with installed chefdk, because there're conflict
 
  local binary
  binaries="chef-run berks chef chef-cli chef-analyze chef-apply chef-shell chef-solo chef-vault cookstyle delivery foodcritic inspec kitchen knife ohai push-apply pushy-client pushy-service-manager chef-client"

  dodir /usr/bin
  for binary in $binaries; do
    dosym /opt/chef-workstation/bin/$binary /usr/bin/$binary || die
  done

  if use chef-workstation-app; then
      dosym /opt/chef-workstation/components/chef-workstation-app/chef-workstation-app /usr/bin/chef-workstation-app || die
  fi
}