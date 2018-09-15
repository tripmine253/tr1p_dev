#!/bin/bash
for y in *;do echo -n "${y,,}"; printf "\t\t${y^^}\n" ;done
