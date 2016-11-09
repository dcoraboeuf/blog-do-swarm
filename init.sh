#!/bin/bash

rm -f do-key*
ssh-keygen -t rsa -f ./do-key -N ""
