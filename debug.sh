#!/bin/bash

for script in `find ./ -name '*.sh'`
do
	bash -n "${script}"
done
