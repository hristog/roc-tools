check:
	roc check ./package/main.roc

format:
	roc format .

test:
	ROC=`which roc` ci/run-tests.sh

