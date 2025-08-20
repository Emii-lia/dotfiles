#!/bin/zsh

if [ ! -f .fortune.record ] || [ "$(cat .fortune.record)" != "$(date +%Y-%m-%d)" ];
then
	date +%Y-%m-%d > .fortune.record
	fortune > .todays
fi

cat .todays
