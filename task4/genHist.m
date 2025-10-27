function [ outHist ] = genHist( image )
% The GENHIST function generates a histogram for the given image.
% The image is an height x width x 3  matrix with values ranging from 0 to 255.
% The resulting histogram should be a row vector of fixed length.

    % --- Parameters for testing (for part c) ---
    
    % Change 'numBins' to test different bin widths
    numBins = 16; 
    
    % Change 'valMin' and 'valMax' to test different ranges
    valMin = 0;
    valMax = 256; % Use 256 to include 255 in the last bin
    
    % Define constant bin edges
    edges = linspace(valMin, valMax, numBins + 1);

    % --- Solution for part (b) ---

    % Extract the R, G, and B channels
    R = image(:,:,1);
    G = image(:,:,2);
    B = image(:,:,3);

    % Calculate histograms for each channel
    [histR] = histcounts(R(:), edges);
    [histG] = histcounts(G(:), edges);
    [histB] = histcounts(B(:), edges);

    % Normalize each histogram individually
    % This makes the descriptor robust to changes in image size or total brightness.
    if sum(histR) > 0, histR_norm = histR / sum(histR); else, histR_norm = zeros(1, numBins); end
    if sum(histG) > 0, histG_norm = histG / sum(histG); else, histG_norm = zeros(1, numBins); end
    if sum(histB) > 0, histB_norm = histB / sum(histB); else, histB_norm = zeros(1, numBins); end

    % Concatenate all 3 normalized histograms into one long row vector
    % The final length will be 3 * numBins (e.g., 3 * 16 = 48)
    outHist = [histR_norm, histG_norm, histB_norm];
    
end