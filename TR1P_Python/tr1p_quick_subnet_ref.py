#!/usr/bin/env python
import math

ipv4t=[128, 192, 224, 240, 248, 252, 254]
ablock=[]
[ablock.append(y) for y in range(1,8,1)]
bblock=[]
[bblock.append(y) for y in range(9,16,1)]
cblock=[]
[cblock.append(y) for y in range(17,24,1)]
dblock=[]
[dblock.append(y) for y in range(25,32,1)]
eblock=[]
[eblock.append(y) for y in range(32,40,1)]
print("TIM's IPV4 Table")
print()
print("	OCTET-1	OCTET-2	OCTET-3	OCTET-4")
print()
print("0		8	16	24")
print("MASK	CIDR	CIDR	CIDR	CIDR")
print("""
{0}	/{7}	/{14}	/{21}	/{28}
{1}	/{8}	/{15}	/{22}	/{29}
{2}	/{9}	/{16}	/{23}	/{30}
{3}	/{10}	/{17}	/{24}	/{31}
{4}	/{11}	/{18}	/{25}	/{32}
{5}	/{12}	/{19}	/{26}	/{33}
{6}	/{13}	/{20}	/{27}	/{34}
""".format(ipv4t[0],ipv4t[1],ipv4t[2],ipv4t[3],ipv4t[4],ipv4t[5],ipv4t[6],ablock[0],ablock[1],ablock[2],ablock[3],ablock[4],ablock[5],ablock[6],bblock[0],bblock[1],bblock[2],bblock[3],bblock[4],bblock[5],bblock[6],cblock[0],cblock[1],cblock[2],cblock[3],cblock[4],cblock[5],cblock[6],dblock[0],dblock[1],dblock[2],dblock[3],dblock[4],dblock[5],dblock[6],eblock[0],eblock[1],eblock[2],eblock[3],eblock[4],eblock[5],eblock[6]))

print("255	8	16	24	32")
print("MASK	CIDR	CIDR	CIDR	CIDR")
print()
print("INCREMENT = 256 - MASK")
print()
print("HOSTS = (32-CIDR)^2=2")
print()
print("	HOSTS + 2")
for x in range(1,17,1):
  print(math.floor(math.pow(2, x)))