# Changelog

All notable changes to this project will be documented in this file.

### [1.6.2](https://github.com/djangoheads/terraform-kubernetes-django/compare/v1.6.1...v1.6.2) (2024-01-30)


### Bug Fixes

* deployment & service port naming ([d893e69](https://github.com/djangoheads/terraform-kubernetes-django/commit/d893e6920ef41eb68404fdb28b53a7976d8a6c44))

### [1.6.1](https://github.com/djangoheads/terraform-kubernetes-django/compare/v1.6.0...v1.6.1) (2024-01-30)


### Bug Fixes

* deployment port opening ([039e228](https://github.com/djangoheads/terraform-kubernetes-django/commit/039e2280422e4962ae28984071c61ec8a965ec27))

## [1.6.0](https://github.com/djangoheads/terraform-kubernetes-django/compare/v1.5.2...v1.6.0) (2024-01-28)


### Features

* Significant changes in the deployment configuration - Kubernetes volume refactoring. ([6c304c7](https://github.com/djangoheads/terraform-kubernetes-django/commit/6c304c75ac2ac8e404dda0a0330ab8e338f3f16b))

### [1.5.2](https://github.com/djangoheads/terraform-kubernetes-django/compare/v1.5.1...v1.5.2) (2024-01-27)


### Bug Fixes

* probes variables ([09927cc](https://github.com/djangoheads/terraform-kubernetes-django/commit/09927ccbd78d5af61a30105bbf0f30705a9b7d88))

### [1.5.1](https://github.com/djangoheads/terraform-kubernetes-django/compare/v1.5.0...v1.5.1) (2024-01-27)


### Bug Fixes

* autoscaler optional setup, extend probes values ([f28121f](https://github.com/djangoheads/terraform-kubernetes-django/commit/f28121f08fbd33a3528f690afe661c943ef7a5fd))

## [1.5.0](https://github.com/djangoheads/terraform-kubernetes-django/compare/v1.4.1...v1.5.0) (2024-01-18)


### Features

* refactored structure ([42258ee](https://github.com/djangoheads/terraform-kubernetes-django/commit/42258ee641b06da134348bd954c9b474df2c9d55))

### [1.4.1](https://github.com/djangoheads/terraform-kubernetes-django/compare/v1.4.0...v1.4.1) (2023-12-07)


### Bug Fixes

* server to job typo ([412baf5](https://github.com/djangoheads/terraform-kubernetes-django/commit/412baf5f9f4885fb4f4fe80db2b746a731e25382))

## [1.4.0](https://github.com/djangoheads/terraform-kubernetes-django/compare/v1.3.0...v1.4.0) (2023-12-07)


### Features

* Create simple ingress.tf ([6b84204](https://github.com/djangoheads/terraform-kubernetes-django/commit/6b842047237c4e050ecf58485a146b49f0269d27))

## [1.3.0](https://github.com/djangoheads/terraform-kubernetes-django/compare/v1.2.1...v1.3.0) (2023-12-07)


### Features

* **doc:** Update README.md ([4a536c7](https://github.com/djangoheads/terraform-kubernetes-django/commit/4a536c7a08549a56b8a7c0106ab7e1968d989943))
* Update main.tf ([0c4622e](https://github.com/djangoheads/terraform-kubernetes-django/commit/0c4622e87b8c5375e867899866e4788ac24d4c85))
* Update README.md ([f8ef88e](https://github.com/djangoheads/terraform-kubernetes-django/commit/f8ef88e300074bbf9f361815d1cf8c806990a10d))

### [1.2.1](https://github.com/djangoheads/terraform-kubernetes-django/compare/v1.2.0...v1.2.1) (2023-05-21)


### Bug Fixes

* Terraform formating, added initial autoscaler ([3fc5baf](https://github.com/djangoheads/terraform-kubernetes-django/commit/3fc5bafafb2315d2ee6629ba16383fb32eaca16c))

## [1.2.0](https://github.com/djangoheads/terraform-kubernetes-django/compare/v1.1.1...v1.2.0) (2023-05-21)


### Features

* Add ingress as a separate role for the model ([050632f](https://github.com/djangoheads/terraform-kubernetes-django/commit/050632f929c991c101615b3a915b9783742980a7))

### [1.1.1](https://github.com/djangoheads/terraform-kubernetes-django/compare/v1.1.0...v1.1.1) (2023-05-20)


### Bug Fixes

* changelog.md ([b3ead05](https://github.com/djangoheads/terraform-kubernetes-django/commit/b3ead05794840d957464cfcbbdcbd79619d6ebea))
* Cleanup from Replit ([052e7b0](https://github.com/djangoheads/terraform-kubernetes-django/commit/052e7b09cc7343519ebd33853cacdc24aa3442bb))
* examples ([eb774d1](https://github.com/djangoheads/terraform-kubernetes-django/commit/eb774d1609995deb4b8561c2108aa1146b6442de))

## [1.1.0](https://github.com/djangoheads/terraform-kubernetes-django/compare/v1.0.0...v1.1.0) (2023-05-20)


### Features

* Add worker and celery Example ([93f94d2](https://github.com/djangoheads/terraform-kubernetes-django/commit/93f94d22ff82bc55c67d5d62bd6177855d677708))
* Reorg resource naming ([b2e654f](https://github.com/djangoheads/terraform-kubernetes-django/commit/b2e654f59999a5ea6ecca2af8b18f8821d2bdf35))

## 1.0.0 (2023-05-20)


### Features

* **pencil:** Initial configuration ([ce56cab](https://github.com/djangoheads/terraform/commit/ce56cabf45422ef89314fc04d939124704d085b9))


### Bug Fixes

* **pencil:** Access token for release ([1eac6ec](https://github.com/djangoheads/terraform/commit/1eac6ec9fbb67d1cef6dcc518b59bcde96f368a4))
* **pencil:** GitHub Action Dispatching rules ([4d1d38e](https://github.com/djangoheads/terraform/commit/4d1d38e46c98dc3a0aeccc343890702269558435))
* **pencil:** Remove GitHub Action Token for release in workflow configuration ([0f88735](https://github.com/djangoheads/terraform/commit/0f887351e2f3e329bc7b4803cbb14ab34c087840))
* **pencil:** replit.nix ([96ee7e8](https://github.com/djangoheads/terraform/commit/96ee7e8209002cd2944f3e1363333d4e97674b8b))
* **pencil:** Workflow folder structure ([71544ba](https://github.com/djangoheads/terraform/commit/71544baa1b391013d5b9d555045c08157ae43ebd))
