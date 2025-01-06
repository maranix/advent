#!/usr/bin/env bash

ENTRYPOINT="./bin/advent_cli.dart"
OUTDIR="../advent"

dart compile exe $ENTRYPOINT -o $OUTDIR
