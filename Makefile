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

.PHONY: disable-detections
disable-detections:
	@find detections -name "*.yaml" | while read -r file; do \
		if ! grep -q '^disabled:' "$$file"; then \
			echo "Adding disabled: true to $$file"; \
			printf 'disabled: true\n' | cat - "$$file" > "$$file.tmp" && mv "$$file.tmp" "$$file"; \
		fi; \
	done
	@echo "Done. All detections now have disabled: true."
