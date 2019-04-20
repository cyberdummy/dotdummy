#!/bin/bash

shopt -s nullglob

for f in ~/.mutt/mailboxes/*.mb.muttrc
do
    cat $f
done
