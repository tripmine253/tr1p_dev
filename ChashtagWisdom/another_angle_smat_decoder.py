def get_char(s):
    for x in s:
        yield x

msg = "Pewpewpewpew this be some 1337 haxor shit, custom ciphers and shit w00tz"
enc = ['^_^']*len(msg)*10

p = [1, 9, 2, 3, 7, 8, 6, 3, 9, 7] # this is going to be our shift table
pt = get_char(msg)
for i in range(0, len(msg)*10): #start a loop to build our message
    if not i%10: # i modulo 10, if no remainder its divisible by 10
        for k in range(len(p)):
            if k+i < len(enc): # bounds checking
                try:
                    pt_char = pt.next() # get a char to enc
                    make_ct = ord(pt_char)+p[k] # shift up by p[k]
                    enc[i+k] = chr(make_ct) # insert this into our array
                except StopIteration:
                    break


smat = ''.join(enc).replace('^_^','')
t = ''
for i in range(0,len(smat),10): # increment by 10
    for k in range(0,10): # for k in 0-9,
        if k+i < len(smat): # make sure we dont get an index error, by making sure we can actually get a index'd char
			get_char_ord = ord(smat[i+k]) # get a char from the list and get its ordinal value
			shift_char = get_char_ord-p[k] # shift the char based on position we are at now
			t += chr(shift_char) # make this back into a char

print "PT: " + msg
print "CT: " + smat
print "DEC: "+ t