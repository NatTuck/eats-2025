#!/bin/bash

ssh -t -L 8080:127.0.0.1:8080 kraken watch uptime
