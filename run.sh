#!/bin/bash
source activate fastai
export SHELL=/bin/bash
rm -rf /storage/lost+found

jupyter lab --ip=0.0.0.0 --no-browser --allow-root
