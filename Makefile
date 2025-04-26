NAME = script.elementum.jackett
GIT = git
# will give you v2.5.0-1 from v2.5.0-1-gbb084b0
GIT_VERSION = $(shell $(GIT) describe --tags --match "v*" | cut -d '-' -f1-2)
GIT_COMMIT_DATE=$(shell $(GIT) log -1 --pretty=format:'%ad' --date=short)
# Remove 'v' character from VER_BY_TAG
VER=$(shell echo "$(GIT_VERSION)" | cut -c 2-)

ZIP = zip
ZIP_SUFFIX = zip
ZIP_FILE = $(NAME)-$(VER).$(ZIP_SUFFIX)

BUILD_BASE = build
BUILD_DIR = $(BUILD_BASE)/$(NAME)

all: clean deps-prod locales zip

.PHONY: build-prod
build-prod: clean deps-prod $(ZIP_FILE)

.PHONY: deps-prod
deps-prod: clean deps-prod $(ZIP_FILE)
	@poetry install --no-dev

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

deps-dev:
	@poetry install

$(BUILD_BASE)/$(ZIP_FILE): previous_tag=$(shell $(GIT) tag -l | sort -u -r -V | head -n2 | tail -n1)
$(BUILD_BASE)/$(ZIP_FILE): $(BUILD_DIR) locales
	$(GIT) archive --format tar --worktree-attributes HEAD | tar -xvf - -C $(BUILD_DIR)
	@echo "Generating addon.xml"
	$(GIT) log $(previous_tag)...HEAD --no-merges --pretty=format:' - %s' --reverse | \
		poetry run ./scripts/update-version.py $(VER) $(GIT_COMMIT_DATE) - > $(BUILD_DIR)/addon.xml
	poetry export -f requirements.txt | \
		poetry run pip install \
			--requirement /dev/stdin \
			--target $(BUILD_DIR)/resources/libs \
			--progress-bar off
	find $(BUILD_DIR) -iname "*.egg-info" -or -iname "*.pyo" -or -iname "*.pyc" -or -iname "*.dist-info" -or -iname "__pycache__" | xargs rm -rf
	cd $(BUILD_BASE) && $(ZIP) -r $(ZIP_FILE) $(NAME)

.PHONY: zip
zip: $(BUILD_BASE)/$(ZIP_FILE)

clean:
	rm -f $(BUILD_BASE)/$(ZIP_FILE)
	rm -rf $(BUILD_DIR)

locales:
	scripts/xgettext_merge.sh
