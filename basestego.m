clc;
clear all;
close all;

% read cover image
cover = input('enter cover image: ', 's');
x = imread(cover); % store image data

% process message
message = input('enter message text: ', 's');
base64Msg = matlab.net.base64encode(message); % encode to base64
binMsg = dec2bin(uint8(base64Msg), 8)'; % convert to 8-bit binary
binMsg = binMsg(:)'; % flatten to row vector
msgLen = length(binMsg);

% check image capacity
[M, N, C] = size(x);
totalPixels = M * N * C;
if msgLen + 16 > totalPixels % 16-bit header space
    error('message too large for image');
end

% add 16-bit length header
lenBin = dec2bin(msgLen, 16)';
lenBin = lenBin(:)';
binMsg = [lenBin, binMsg];

% embed message in lsb
flatImg = x(:);
savedPixels = flatImg; % backup original
for i = 1:length(binMsg)
    flatImg(i) = bitset(flatImg(i), 1, str2double(binMsg(i)));
end
S = reshape(flatImg, [M, N, C]);

% extraction process
% get 16-bit length first
extractedLenBits = arrayfun(@(px) bitget(px,1), flatImg(1:16), 'UniformOutput', false);
extractedLenBits = cellfun(@num2str, extractedLenBits, 'UniformOutput', false);
extractedLenBits = [extractedLenBits{:}];
extractedLen = bin2dec(extractedLenBits);

% extract message bits
extractedMsgBits = arrayfun(@(px) bitget(px,1), flatImg(17:16+extractedLen), 'UniformOutput', false);
extractedMsgBits = cellfun(@num2str, extractedMsgBits, 'UniformOutput', false);
extractedMsgBits = [extractedMsgBits{:}];

% validate and convert message
if mod(length(extractedMsgBits), 8) ~= 0
    error('message length not divisible by 8');
end
extractedBinMsg = reshape(extractedMsgBits, 8, [])';
extractedDec = bin2dec(extractedBinMsg);
extractedBase64 = char(extractedDec)';

% display results
disp('=== extraction results ===');
disp(['base64 encoded: ' extractedBase64]);
disp(['decoded message: "' matlab.net.base64decode(extractedBase64) '"']);

% show images
figure, imshow(x); title('original image');
figure, imshow(S); title('stego image');
imwrite(S, 'stego_image.jpg'); % save output
