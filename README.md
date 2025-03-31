# Base46_Steganography
- simple lsb steganography implementation in matlab

## Features
- hides messages in image lsbs (least significant bits)
- uses base64 encoding for message safety
- includes length header for proper extraction
- shows before/after image comparison

## how to use
1. run the script in matlab
2. enter cover image path when prompted
3. enter secret message text
4. view results:
   - extracted base64 message
   - decoded text
   - image comparison figures
5. stego image saves as `stego_image.jpg`

## notes
- works best with png images (lossless)
- jpeg may corrupt hidden data due to compression
- includes 16-bit length header
- shows ascii values of base64-encoded message for verification
