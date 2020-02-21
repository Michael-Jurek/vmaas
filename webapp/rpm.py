"""
Module contains class for returning RPM names to given SRPM and Product Family (e.g. openssl, rhel-7)
"""

import re
from cache import REPO_LABEL


class RpmAPI:
    """Main /rpms API class"""

    def __init__(self, cache):
        self.cache = cache

    def _productfamilly_to_process(self, product):
        """Returns list of available repo_ids to given product familly."""
        repos = [label for label in self.cache.repolabel2ids
                 if re.match(product+".*", label)]
        repo_ids = []
        for repo in repos:
            repo_ids.extend(self.cache.repolabel2ids[repo])
        return repo_ids, repos

    def _packageid2name(self, pkg_id_list):
        """For given list of pkg_ids returns list of package names"""
        package_names = []
        for pkg_id in pkg_id_list:
            pkg_name = self.cache.pkg_id2pkg_name_id[pkg_id]
            if pkg_name not in package_names:
                package_names.append(pkg_name)
        return package_names

    def process_list(self, api_version, data):  # pylint: disable=unused-argument
        """
        This method returns RPM names for given SRPM name and Product Family.

        :param data: data from api - srpm name and product familly

        :returns: list of rpm names for given product familly
        """
        srpm = data.get('srpm', None)
        product = data.get('product_familly', None)
        response = {}

        if not srpm or not product:
            return response

        if srpm in self.cache.packagename2id:
            pkg_ids = self.cache.pkg_name2pkg_id[srpm]
            src_pkg_ids = [p_id for p_id in pkg_ids if p_id in self.cache.src_pkg_id2pkg_ids]
            rpms = {}
            for src_pkg_id in src_pkg_ids:
                rpms.setdefault(src_pkg_id, []).extend(self.cache.src_pkg_id2pkg_ids[src_pkg_id])
            repo_ids, repo_labels = self._productfamilly_to_process(product)

            repo_ids_with_pkg_ids = {}
            for repo_id in repo_ids:
                # if pkg_id in pkg_ids2repos and repo_id in pkg_ids2repos[pkg_id]:
                packages = []
                for pkg in rpms.values():
                    packages.extend(pkg)
                repo_ids_with_pkg_ids.setdefault(self.cache.repo_detail[repo_id][REPO_LABEL], []).extend(
                    p_id for p_id in packages if repo_id in self.cache.pkgid2repoids[p_id])

            for repo in repo_labels:
                if repo_ids_with_pkg_ids[repo]:
                    response[repo] = self._packageid2name(repo_ids_with_pkg_ids[repo])
        return response
