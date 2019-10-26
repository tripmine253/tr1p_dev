import ctypes
import sys
import wave
import os


BE_CONFIG_MP3, BE_CONFIG_LAME = (0, 256)
BE_ERR_SUCCESSFUL, BE_ERR_INVALID_FORMAT, BE_ERR_INVALID_FORMAT_PARAMETERS, \
      BE_ERR_NO_MORE_HANDLES, BE_ERR_INVALID_HANDLE, BE_ERR_BUFFER_TOO_SMALL = range(6)

BE_MAX_HOMEPAGE = 128
BE_MP3_MODE_STEREO, BE_MP3_MODE_JSTEREO, BE_MP3_MODE_DUALCHANNEL, BE_MP3_MODE_MONO = range(4)
MPEG2, MPEG1 = range(2)

CURRENT_STRUCT_VERSION = 1
#CURRENT_STRUCT_SIZE ctypes.sizeof(BE_CONFIG)    # is currently 331 bytes

VBR_METHOD_NONE,  VBR_METHOD_DEFAULT, VBR_METHOD_OLD, VBR_METHOD_NEW, VBR_METHOD_MTRH, VBR_METHOD_ABR = range(-1, 5)
LQP_PHONE, LQP_SW, LQP_AM, LQP_FM, LQP_VOICE, LQP_RADIO, LQP_TAPE, LQP_HIFI, LQP_CD, LQP_STUDIO = [x * 1000 for x in range(1, 11)]

class BE_VERSION(ctypes.Structure):
    _fields_ = [
        ('byDLLMajorVersion', ctypes.c_byte),  # BladeEnc DLL Version number
        ('byDLLMinorVersion', ctypes.c_byte),
        ('byMajorVersion', ctypes.c_byte),    # BladeEnc Engine Version Number
        ('byMinorVersion', ctypes.c_byte),
        ('byDay', ctypes.c_byte),             # DLL Release date
        ('byMonth', ctypes.c_byte),
        ('wYear', ctypes.c_short),
        ('zHomepage', ctypes.c_char * 129),    # BladeEnc Homepage URL
        ('byAlphaLevel', ctypes.c_byte),
        ('byBetaLevel', ctypes.c_byte),
        ('byMMXEnabled', ctypes.c_byte),
        ('btReserved', ctypes.c_byte * 125)                
    ]
    _pack_ = 1


class BE_CONFIG(ctypes.Structure):
    _fields_ = [
        ('dwConfig', ctypes.c_ulong),          # BE_CONFIG_XXXXX, Currently only BE_CONFIG_MP3 is supported
        ('dwStructVersion', ctypes.c_ulong),   
        ('dwStructSize', ctypes.c_ulong),
        ('dwSampleRate', ctypes.c_ulong),      # SAMPLERATE OF INPUT FILE
        ('dwReSampleRate', ctypes.c_ulong),    # DOWNSAMPLERATE, 0=ENCODER DECIDES 
        ('nMode', ctypes.c_long),              # BE_MP3_MODE_STEREO, BE_MP3_MODE_DUALCHANNEL, BE_MP3_MODE_MONO
        ('dwBitrate', ctypes.c_ulong),         # CBR bitrate, VBR min bitrate
        ('dwMaxBitrate', ctypes.c_ulong),      # CBR ignored, VBR Max bitrate
        ('nPreset', ctypes.c_long),            # Quality preset, use one of the settings of the LAME_QUALITY_PRESET enum
        ('dwMpegVersion', ctypes.c_ulong),     # FUTURE USE, MPEG-1 OR MPEG-2
        ('dwPsyModel', ctypes.c_ulong),        # FUTURE USE, SET TO 0
        ('dwEmphasis', ctypes.c_ulong),        # FUTURE USE, SET TO 0
    
        # BIT STREAM SETTINGS
        ('bPrivate', ctypes.c_long),           # Set Private Bit (True/FALSE)
        ('bCRC', ctypes.c_long),               # Insert CRC (True/FALSE)
        ('bCopyright', ctypes.c_long),         # Set Copyright Bit (True/FALSE)
        ('bOriginal', ctypes.c_long),          # Set Original Bit (True/FALSE)
        
        # VBR STUFF
        
        ('bWriteVBRHeader', ctypes.c_long),    # WRITE XING VBR HEADER (True/FALSE)
        ('bEnableVBR', ctypes.c_long),         # USE VBR ENCODING (True/FALSE)
        ('nVBRQuality', ctypes.c_int),         # VBR QUALITY 0..9
        ('dwVbrAbr_bps', ctypes.c_ulong),      # Use ABR instead of nVBRQuality
        
        ('nVbrMethod', ctypes.c_int),        
        ('bNoRes', ctypes.c_long),             # bool Disable Bit reservoir (True/FALSE)
    
        # MISC SETTINGS
        ('bStrictIso', ctypes.c_long),         # Use strict ISO encoding rules (True/FALSE)
        ('nQuality', ctypes.c_ushort),         # Quality Setting, HIGH BYTE should be NOT LOW byte, otherwhise quality=5
    
        # FUTURE USE, SET TO 0, align Structure to 331 bytes
        ('btReserved', ctypes.c_byte * (255 - 4*4 - 2 ) )
    ]

    _packed_ = 1

#lame = cdll.lame_enc
lame =  ctypes.WinDLL('C:\\Users\\Instructor\\Desktop\\0x539\\lame_enc.dll')
#version = BE_VERSION()
#print version.zHomepage
#lame.beVersion(ctypes.byref(version))  
#print version.byDay, version.byMonth


samplesPerChunk = ctypes.c_ulong()
mp3BufSize = ctypes.c_ulong()
mp3Bytes = ctypes.c_ulong()
stream = ctypes.c_int()


wavFile = wave.open('test.wav', 'rb')
mp3File = open('test.mp3', 'wb')

beConfig = BE_CONFIG()

beConfig.dwConfig = BE_CONFIG_LAME
beConfig.dwStructVersion    = 1
beConfig.dwStructSize       = ctypes.sizeof(beConfig)    
beConfig.dwSampleRate       = wavFile.getframerate() # INPUT FREQUENCY
beConfig.dwReSampleRate     = 0                    # LET ENCODER DECIDE

nChannels = wavFile.getnchannels()
if nChannels == 1:
    beConfig.nMode              = BE_MP3_MODE_MONO
else:
    beConfig.nMode              = BE_MP3_MODE_STEREO
    
beConfig.dwBitrate          = 128                  # MINIMUM BIT RATE
beConfig.dwMaxBitrate       = 320                  # MAXIMUM BIT RATE
beConfig.nPreset            = LQP_CD               # QUALITY PRESET SETTING
beConfig.dwMpegVersion      = MPEG1               # MPEG VERSION (I or II)
beConfig.dwPsyModel         = 0                    # USE DEFAULT PSYCHOACOUSTIC MODEL
beConfig.dwEmphasis         = 0                    # NO EMPHASIS TURNED ON


beConfig.bPrivate           = True                # SET PRIVATE FLAG
beConfig.bCRC               = True                # INSERT CRC
beConfig.bCopyright         = False                # SET COPYRIGHT FLAG
beConfig.bOriginal          = True                 # SET ORIGINAL FLAG

beConfig.bWriteVBRHeader    = True                # YES, WRITE THE XING VBR HEADER
beConfig.bEnableVBR         = True                # USE VBR

beConfig.nVBRQuality        = 5                    # SET VBR QUALITY
#beConfig.dwVbrAbr_bps       = 100                 # Average bit rate - if specified, used instead of quality
beConfig.nVBRMethod = VBR_METHOD_DEFAULT
beConfig.bNoRes             = False                 # No Bit reservoir
beConfig.bStrictIso         = True
beConfig.nQuality = 5


err = lame.beInitStream(ctypes.byref(beConfig), ctypes.byref(samplesPerChunk), ctypes.byref(mp3BufSize), ctypes.byref(stream))

if err:
    print('Error', err)
    sys.exit(0)

mp3Buf = ctypes.create_string_buffer(mp3BufSize.value)


# Using the python wave module we need to read in frame units
# it seems a reasonable assumption that lame chunks will always start/end on frame boundaries
# and so the frames per chunk should always be integer

bytesPerSample = wavFile.getsampwidth()
samplesPerFrame = nChannels
framesPerChunk = samplesPerChunk.value / samplesPerFrame
assert samplesPerChunk.value % samplesPerFrame == 0

#print 'bytes per sample=', bytesPerSample, 'samples per chunk=', samplesPerChunk.value, 'samplesPerFrame', samplesPerFrame, 'frames per chunk', framesPerChunk
while(True):
    wavStr = wavFile.readframes(framesPerChunk)
    
    #print samplesPerChunk.value,  len(wavStr)

    if wavStr == '':
        err = lame.beDeinitStream(stream, mp3Buf, ctypes.byref(mp3Bytes))
        if not err and mp3Bytes != 0:
            mp3File.write(mp3Buf[0:mp3Bytes.value])        
        break
    
    wavBuf = ctypes.create_string_buffer(wavStr, samplesPerChunk.value*bytesPerSample)
    err = lame.beEncodeChunk(stream, len(wavStr) / bytesPerSample, wavBuf, mp3Buf, ctypes.byref(mp3Bytes) )
    
    if err:
        break
    
    mp3File.write(mp3Buf[0:mp3Bytes.value])
    
lame.beCloseStream(stream)
mp3File.close()
wavFile.close()

lame.beWriteVBRHeader('C:/Users/Paul/Desktop/libmp3lame-3.98.2/test.mp3')