.PHONY: bash
bash: ## appコンテナにbashで入る
	docker-compose run --rm app bash

.PHONY: down
down: ## コンテナを落とす
	docker-compose down

.PHONY: clean
clean: ## コンテナを落とす(volumeも)
	docker-compose down --volume

################################################################################
# Utility-Command help
################################################################################
.DEFAULT_GOAL := help


################################################################################
# CI
################################################################################
.PHONY: ci-ruby-3.0
ci-ruby-3.0: ## Ruby3.0でCI
	docker-compose run --rm --file docker-compose.ci.yaml ruby-3.0 bash -c 'bundle install && bundle exec rake'

.PHONY: ci-ruby-2.7
ci-ruby-2.7: ## Ruby2.7でCI
	docker-compose run --rm --file docker-compose.ci.yaml ruby-2.7 bash -c 'bundle install && bundle exec rake'

.PHONY: ci-ruby-2.6
ci-ruby-2.6: ## Ruby2.6でCI
	docker-compose run --rm --file docker-compose.ci.yaml ruby-2.6 bash -c 'bundle install && bundle exec rake'

################################################################################
# マクロ
################################################################################
# Makefileの中身を抽出してhelpとして1行で出す
# $(1): Makefile名
define help
  grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(1) \
  | grep --invert-match "## non-help" \
  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
endef
################################################################################
# タスク
################################################################################
.PHONY: help
help: ## Make タスク一覧
	@echo '######################################################################'
	@echo '# Makeタスク一覧'
	@echo '# $$ make XXX'
	@echo '# or'
	@echo '# $$ make XXX --dry-run'
	@echo '######################################################################'
	@echo $(MAKEFILE_LIST) \
	| tr ' ' '\n' \
	| xargs -I {included-makefile} $(call help,{included-makefile})
