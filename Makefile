.PHONY: create-detection

create-detection:
	bash run.sh "$(SOURCE)" "$(NAME)"

CLICKHOUSE_SQL = $(shell find . -name "*.sql" -not -empty | xargs grep -L '@')

.PHONY: chformat
chformat: $(CLICKHOUSE_SQL)
	for file in $^ ; do \
		echo $$file ; \
		docker run -i clickhouse/clickhouse-server clickhouse-format -n --query "$$(cat $$file)" > $$file ; \
	done
