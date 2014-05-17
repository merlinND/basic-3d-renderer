function softMap = diamondSquare( heightMap, n, initialRatio )
%DIAMONDSQUARE Apply n diamond-square passes
%
% Arguments:
% - heightMap: the height map
% - n: number of passes to apply
% - initialRatio: the amount of entropy to add (will decrease at each pass)
%
% Returns:
% - softMap: a softened heightMap
	softMap = heightMap;
	ratio = initialRatio;
	for i = 1:n
		softMap = diamondSquarePass(softMap, ratio);
		ratio = ratio / 2;
	end;
end

function [ softMap ] = diamondSquarePass( heightMap, noiseRatio )
%DIAMONDSQUAREPASS Fractal interpolation made to soften an height map
%
% Arguments:
% - heightMap: the height map
% - noiseRatio: the amount of entropy to add
%
% Returns:
% - softMap: a softened heightMap

	originSize = size(heightMap);
	softMap = zeros(2 * originSize(1) -1, 2 * originSize(2) - 1);
	noiseAmplitude = (max(max(heightMap)) - min(min(heightMap))) * noiseRatio;
	endSize = size(softMap);

	% copy existing
	for i = 1:originSize(1)
		for j=1:originSize(2)
			softMap(1 + 2 * (i - 1), 1 + 2 * (j - 1)) = heightMap(i, j);
		end
	end

	% diamond pass
	for i = 1:originSize(1)-1 % TODO: refactor that (get rid of cI, cJ)
		cI = 2 * i;
		for j=1:originSize(2)-1
			cJ = 2 * j;

			sum = softMap(cI - 1, cJ - 1);
			sum = softMap(cI - 1, cJ + 1) + sum;
			sum = softMap(cI - 1, cJ + 1) + sum;
			sum = softMap(cI + 1, cJ + 1) + sum;

			noise = noiseAmplitude * (rand(1) - 0.5);

			softMap(cI, cJ) = sum / 4 + noise;
		end
	end



	% square pass
	for i = 1:endSize(1) % TODO: refactor that (get rid of cI, cJ)
		if mod(i, 2) == 0 % TODO: find a better way to achieve that
			oddLine = 0;
		else
			oddLine = 1;
		end
		cI = i;
		for j = 1:originSize(2)-oddLine

			cJ =  1 + oddLine + 2 * (j - 1);

			sum = 0;
			count = 0;
			if cI > 1
				sum = softMap(cI - 1, cJ) + sum;
				count = count + 1;
			end
			if cJ > 1
				sum = softMap(cI, cJ - 1) + sum;
				count = count + 1;
			end
			if cI < originSize(1)-1
				sum = softMap(cI + 1, cJ) + sum;
				count = count + 1;
			end
			if cJ < originSize(2)-1
				sum = softMap(cI, cJ + 1) + sum;
				count = count + 1;
			end

			noise = noiseAmplitude * (rand(1) - 0.5);

			softMap(cI, cJ) = sum / count + noise;
		end
	end

end
