#!/usr/bin/env bash

fmt -w 120 README.md > README_tmp.md
cat README_tmp.md > README.md
rm README_tmp.md
