#!/usr/bin/bash
for x in $(du -ba | sort -n | awk '{print $2}');do du -h $x;done
