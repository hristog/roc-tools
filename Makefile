check:
	roc check ./package/main.roc

format:
	roc format .

test:
	ROC=`which roc` ci/run-tests.sh

docs:
	roc docs ./package/main.roc
	find generated-docs/ -type f -name '*.html' -exec sed -i "s/\(href\|src\)=\"\//\1=\"\/docs\/roc-tools\//g" {} +

