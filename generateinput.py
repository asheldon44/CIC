import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import butter, filtfilt

# Parameters
fs = 16e6  # Sampling frequency (16 MHz)
f = 100e3  # Sine wave frequency (100 kHz)
duration = 1e-3  # Duration of the signal (1 ms)

# Time array
t = np.arange(0, duration, 1/fs)

# Generate sine wave
sine_wave = 0.5 * np.sin(2 * np.pi * f * t) + 0.5

# Delta-Sigma Modulation
integrator = 0
bitstream = []

for sample in sine_wave:
    integrator += sample - (bitstream[-1] if bitstream else 0.5)
    bit = 1 if integrator >= 0 else 0
    bitstream.append(bit)
    integrator -= bit

# Convert bitstream to numpy array
bitstream = np.array(bitstream)

# Write bitstream to a text file
with open('bitstream.txt', 'w') as f:
    for bit in bitstream:
        f.write(f"{bit}\n")

# Demodulation using low-pass filter
def low_pass_filter(data, cutoff, fs, order=5):
    nyquist = 0.5 * fs
    normal_cutoff = cutoff / nyquist
    b, a = butter(order, normal_cutoff, btype='low', analog=False)
    y = filtfilt(b, a, data)
    return y

cutoff_frequency = 500e3  # Cutoff frequency for the low-pass filter
demodulated = 2*low_pass_filter(bitstream, cutoff_frequency, fs)

# Plot the sine wave, bitstream, and demodulated signal
plt.figure(figsize=(10, 8))
plt.subplot(3, 1, 1)
plt.plot(t, sine_wave)
plt.title('Original Sine Wave')

plt.subplot(3, 1, 2)
plt.plot(t, bitstream)
plt.title('Delta-Sigma Bitstream')

plt.subplot(3, 1, 3)
plt.plot(t, demodulated)
plt.title('Demodulated Signal')

plt.tight_layout()
plt.show()