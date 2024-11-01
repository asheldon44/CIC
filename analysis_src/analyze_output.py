from vcdvcd import VCDVCD
import numpy as np
import matplotlib.pyplot as plt

def twos_complement_to_signed_int(bit_string):
    # Determine if the bit string is negative
    if bit_string[0] == '1':
        # Calculate the two's complement
        inverted_bits = ''.join('1' if b == '0' else '0' for b in bit_string)
        signed_int = -1 * (int(inverted_bits, 2) + 1)
    else:
        signed_int = int(bit_string, 2)
    return signed_int

def binary_to_unsigned_int(bit_string):
    return int(bit_string, 2)

def sign_extend(bit_string, new_length):
    current_length = len(bit_string)
    if current_length >= new_length:
        return bit_string
    sign_bit = bit_string[0]
    extension = sign_bit * (new_length - current_length)
    return extension + bit_string

vcd = VCDVCD('./data/signals.vcd')

out = vcd['CIC_tb.d_out[23:0]']
tv = out.tv

time = [float(row[0])*float(vcd.timescale["timescale"]) for row in tv]
data = [row[1] for row in tv]

data = ['0' if element == 'x' else element for element in data]
data = [element for element in data]
data_int = [float(binary_to_unsigned_int(element))/float(2**17) for element in data]
#data_int = [twos_complement_to_signed_int(element) for element in data]

plt.plot(time,data_int)
plt.show()