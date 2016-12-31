% Author : Jacory Gao
function resultImg = hyperDetector( imgCube, methodName, varargin )
% hyperspectral target detection algorithms
% the result image is a 1 band and value ranges in [0,1] gray scale image.
% pamameters:
%   imgCube : the image cube array, 3 dimensions, formated in
%               [line * sample * bandCount]
%   targetSpec : (Optional) target spectral used to detect specific target
%                 of interset.
%   backgroundSpec : (Optional) background spectral used to specify the
%                   background in the image.
%   methodNmae : the method name used to detect.
%   now support algorithms:
%       known_target_method: CEM AMF ACE
%       anomaly_method: RXD LPTD UTD RXD-UTD RXD-LPTD
%       known_backgournd_and_target_method: OSP LSOSP

%% check and parse input arguments.
parser = inputParser;

addRequired(parser, 'imgCube');

known_target_method = {'CEM','AMF','ACE','ECDHyT', 'ED', 'SAM', 'NCLS', 'FCLS'};
anomaly_method =  {'RXD', 'LPTD', 'UTD', 'RXD-UTD', 'RXD-LPTD'};
known_backgournd_and_target_method = {'OSP', 'LSOSP', 'KLSOSP'};

expectedMethods = { 'CEM','AMF','ACE','ECDHyT', 'ED', 'SAM', 'NCLS', 'FCLS', ...
    'RXD', 'LPTD', 'UTD', 'RXD-UTD', 'RXD-LPTD', ...
    'OSP', 'LSOSP', 'KLSOSP' };
addRequired(parser, 'methodName', @(x) any(validatestring(x, expectedMethods)));

default_targetSpec = zeros(1,1);
default_backgroundSpec = zeros(1,1);
addOptional(parser, 'targetSpec', default_targetSpec, @ismatrix);
addOptional(parser, 'backgroundSpec', default_backgroundSpec, @ismatrix);
parse( parser, imgCube, methodName, varargin{:} );

[width, height, bandCount] = size( imgCube );
targetSpec = parser.Results.targetSpec;
backgroundSpec = parser.Results.backgroundSpec;

% check if the priori spectrum match the image cube dimension
[tarSize, ~] = size( targetSpec );
[backgroundSize, ~] = size( backgroundSpec );

if ismember(methodName, known_target_method)...
        && (tarSize ~= bandCount || tarSize == 1)
    error('There is no prior spectral, or the spectral and image cube are not match.');
elseif ismember(methodName, known_backgournd_and_target_method)...
        && (tarSize ~= bandCount || tarSize == 1)...
        && (backgroundSize ~= bandCount || backgroundSize == 1)
    error('There is no prior spectral, or the spectral and image cube are not match.');
end

%% algorithm part
pixelCount = width * height;  % total pixel count of single image band
% convert the image cube to a vector
imageVector = reshape(imgCube, [pixelCount, bandCount]);

% matched filter
resultImg = zeros(width, height);
switch methodName
    case 'ED'
        for i = 1 : pixelCount
            resultImg(i) = sum(((targetSpec - imageVector(i, :)').^2).^0.5);
        end
        resultImg = -resultImg;
    case 'SAM'
        for i = 1 : pixelCount
            resultImg(i) = (targetSpec' * imageVector(i, :)') / ...
                ( norm(targetSpec) * norm(imageVector(i,:)) );
        end
    case 'CEM'
        RInv = calCorrMat( imageVector ); % correlation matrix
        temp = RInv * targetSpec;
        w = temp / (targetSpec' *  temp);
        for i = 1 : pixelCount
            resultImg(i) = w' * imageVector(i, :)';
        end
    case 'AMF'
        RInv = calCorrMat( imageVector ); % correlation matrix
        w = RInv * targetSpec * inv(targetSpec' * RInv * targetSpec)...
            * targetSpec' * RInv;
        for i = 1 : pixelCount
            resultImg(i) = imageVector(i, :) * w * imageVector(i, :)';
        end
    case 'ACE'
        RInv = calCorrMat( imageVector ); % correlation matrix
        w = RInv * targetSpec * inv( targetSpec' * RInv * targetSpec )...
            * targetSpec' * RInv;
        for i = 1 : pixelCount
            resultImg(i) = imageVector(i, :) * w * imageVector(i, :)'...
                / (imageVector(i, :) * RInv * imageVector(i, :)');
        end
    case 'ECDHyT'
        Cinv = calCovMat( imageVector ); % correlation matrix
        u = mean(imageVector)';
        for i = 1 : pixelCount
            x = imageVector(i, :)';
            resultImg(i) = [(x - u)' * Cinv * (x - u)]^(1/2) - ...
                [(x - targetSpec)' * Cinv * (x - targetSpec)]^(1/2);
        end
    case 'RXD'
        Cinv = calCovMat( imageVector );
        u = mean( imageVector );
        for i = 1 : pixelCount
            temp = imageVector(i, :) -  u;
            resultImg(i) = temp * Cinv * temp';
        end
    case 'LPTD'
        Rinv = calCorrMat( imageVector );
        L = ones( bandCount, 1);
        w = L' * Rinv;
        for i = 1 : pixelCount
            resultImg(i) = w * imageVector(i, :)';
        end
    case 'UTD'
        Cinv = calCovMat( imageVector );
        L = ones( bandCount, 1);
        u = mean( imageVector )';
        w = (L - u)' * Cinv;
        for i = 1 : pixelCount
            resultImg(i) = w * (imageVector(i, :)' - u);
        end
    case 'RXD-UTD'
        Cinv = calCovMat( imageVector );
        L = ones( bandCount, 1);
        u = mean( imageVector )';
        for i = 1 : pixelCount
            resultImg(i) = (imageVector(i, :)' - L)' * Cinv * (imageVector(i, :)' - u);
        end
    case 'RXD-LPTD'
        Cinv = calCovMat( imageVector );
        L = ones( bandCount, 1);
        for i = 1 : pixelCount
            resultImg(i) = (imageVector(i, :)' - L)' * Cinv * imageVector(i, :)';
        end
    case 'OSP'
        P = eye( bandCount ) - backgroundSpec * pinv( backgroundSpec );
        temp = targetSpec'* P * imageVector';
        resultImg = reshape(temp, [width, height]);
    case 'LSOSP'
        P = eye( bandCount ) - backgroundSpec * pinv( backgroundSpec );
        temp = ( targetSpec' * P * targetSpec ) \ ...
            ( targetSpec' * P * imageVector' );
        resultImg = reshape(temp, [width, height]);
    case 'FCLS'
        [~, endMemberNum ] = size( targetSpec );
        if endMemberNum <= 1
            warning('Only 1 end member, cannot compute constrained, result maybe invalid');
        end
        resultImg = FCLS_v2(imgCube, targetSpec, 0.000001);
    case 'NCLS'
        [~, endMemberNum ] = size( targetSpec );
        if endMemberNum <= 1
            warning('Only 1 end member, cannot compute constrained, result maybe invalid');
        end
        resultImg = zeros(width, height, endMemberNum);
        for i = 1 : width
            for j = 1 : height
                imageVector = permute(imgCube(i,j,:), [3, 2, 1]);
                tmp = NCLS(imageVector, targetSpec, 0.000001);
                resultImg(i,j,:) = tmp';
            end
        end
    otherwise
        error('method name maybe invalid, please check out.');
end

% resultImg = mat2gray( resultImg ); % set the result values into [0, 1] range
end

%% --------------- sub functions ------------------------
% calculate the correlation matrix and it's reverse
function [Rinv, R] = calCorrMat( imageVector )
[pixelCount, bandCount] = size( imageVector );
% 关联系数矩阵 R
R = 1/pixelCount * (imageVector' * imageVector);

% 求取特征值对角矩阵和特征向量矩阵
[ve,va] = eig(R);
Eigenva = diag(va);%求取特征值组成的向量，按从小到大排列
rate = 0.9999;%该参数可调
Sumva = rate * sum( Eigenva );%按总和0.99999比例大小取舍特征值
i = bandCount + 1;
Countva = 0;%累计特征值的和

while Countva < Sumva
    i = i - 1;
    if i < 1
        error('something wrong...');
    end
    Countva = Countva + Eigenva(i);
end

VR = ve(:, i:bandCount);
VA = va(i:bandCount, i:bandCount);
Rinv = VR * inv(VA) * VR';
end

% calculate the covariance matrix and it's reverse
function [Cinv, C] = calCovMat( imageVector )
bandCount = size( imageVector, 2 );
C = cov(imageVector);
% 求取特征值对角矩阵和特征向量矩阵
[ve,va] = eig(C);
Eigenva = diag(va);%求取特征值组成的向量，按从小到大排列
rate = 0.9999;%该参数可调
Sumva = rate * sum( Eigenva );%按总和0.99999比例大小取舍特征值
i = bandCount + 1;
Countva = 0;%累计特征值的和

while Countva < Sumva
    i = i - 1;
    if i < 1
        error('something wrong...');
    end
    Countva = Countva + Eigenva(i);
end

VC = ve(:, i:bandCount);
VA = va(i:bandCount, i:bandCount);
Cinv = VC * inv(VA) * VC';
end

% Fully Constrain Least-Squares(FCLS) abundances estimate
function results = FCLS_v2(image, M, tol)
% Algoritm name:      Fully Constrain Least-Squares(FCLS) abundances estimate
% Authors:            Chein-I Chang and Daniel Heinz
% Category:           least squares-based filter
% Inputs:             reflectance or radiance cube, complete target knowledge
% Assumptions:        complete prior target knowledge required
% Operating bands:    VNIR through LWIR
% Maturity:           mature/operational
% Effectiveness:      high
% Implementation:     simple,easy to use, real time

%parameters:
%   image:      image of size [X,Y,Z]
%	M:          endmember matrix of size [Z,p]
%	tol:		NCLS tolerance, e.g. -1e-6

%output:
%	results:    resulting abundance map of size [X,Y,p]

[x,y,z] = size(image);
num_p = size(M, 2);
results = zeros(x, y, num_p);
for i = 1 : x
    for j = 1 : y
        r = reshape(image(i,j,:), z, 1);
        delta = 1 / (10*max(max(M)));
        s = [delta.*r; 1];
        N = [delta.*M; ones(1, num_p)];
        
        [ab] = NCLS(s, N, tol);
        ab = reshape(ab, [1, 1, num_p]);
        results(i, j, :) = ab;
    end
end
end

% non-negativity least squares(NCLS)
function [abundance] = NCLS(x, MatrixZ, tol)
% Algoritm name:      non-negativity least squares(NCLS)
% Authors:            Chein-I Chang and Daniel Heinz
% Category:           unsupervised least squares-based filter
% Inputs:             reflectance or radiance cube
% Assumptions:        complete prior target knowledge required
% Operating bands:    VNIR through LWIR
% Maturity:           mature/operational
% Effectiveness:      high
% Implementation:     simple,easy to use, real time

%parameters:
%	MatrixZ:	the signatures of endmembers. It is of size[bands p]
%	r1:		the [bandCount*1] signature whose abundance is to be estimated

%output:
%	abundance:	the abundance of each material in r1. It is of size[p 1]

M = size(MatrixZ, 2);
R = zeros(M, 1);
P = ones(M, 1);
invMtM = (MatrixZ' * MatrixZ)^(-1);
Alpha_Is = invMtM * MatrixZ' * x;
Alpha_ncls = Alpha_Is;
min_Alpha_ncls = min( Alpha_ncls );
j = 0;
while(min_Alpha_ncls<-tol && j<500)
    j = j + 1;
    for II = 1 : M
        if((Alpha_ncls(II)<0) && P(II)==1)
            R(II) = 1;
            P(II) = 0;
        end
    end
    S = R;
    
    goto_step6 = 1;
    counter = 0;
    while(goto_step6 == 1)
        index_for_Lamda = find( R==1 );
        Alpha_R = Alpha_Is( index_for_Lamda );
        Sai = invMtM( index_for_Lamda, index_for_Lamda );
        
        inv_Sai = (Sai)^(-1);
        Lamda = inv_Sai * Alpha_R;
        
        [max_Lamda, index_Max_Lamda] = max(Lamda);
        counter = counter + 1;
        if(max_Lamda<=0 || counter == 200)
            break;
        end
        
        temp_i = inv_Sai;
        temp_i(1,:) = inv_Sai(index_Max_Lamda, :);
        if index_Max_Lamda > 1
            temp_i(2:index_Max_Lamda, :) = inv_Sai(1:index_Max_Lamda-1, :);
        end
        inv_Sai_ex = temp_i;
        inv_Sai_ex(:,1) = temp_i(:, index_Max_Lamda);
        if index_Max_Lamda > 1
            inv_Sai_ex(:, 2:index_Max_Lamda) = temp_i(:, 1:index_Max_Lamda-1);
        end
        inv_Sai_next = inv_Sai_ex(2:end, 2:end) - inv_Sai_ex(2:end, 1) * inv_Sai_ex(1, 2:end)/inv_Sai_ex(1, 1);
        P(index_for_Lamda(index_Max_Lamda)) = 1;
        R(index_for_Lamda(index_Max_Lamda)) = 0;
        index_for_Lamda(index_Max_Lamda) = [];
        
        Alpha_R = Alpha_Is(index_for_Lamda);
        Lamda = inv_Sai_next * Alpha_R;
        
        Phai_column = invMtM(:, index_for_Lamda);
        
        if (size(Phai_column,2) ~= 0)
            Alpha_s = Alpha_Is - Phai_column * Lamda;
        else
            Alpha_s = Alpha_Is;
        end
        
        goto_step6 = 0;
        
        for II = 1 : M
            if((S(II)==1) && (Alpha_s(II)<0))
                R(II) = 1;
                P(II) = 0;
                goto_step6 = 1;
            end
        end
    end
    
    index_for_Phai = find(R==1);
    Phai_column = invMtM(:, index_for_Phai);
    
    if(size(Phai_column,2) ~= 0)
        Alpha_ncls = Alpha_Is - Phai_column * Lamda;
    else
        Alpha_ncls = Alpha_Is;
    end
    
    min_Alpha_ncls = min(Alpha_ncls);
end
abundance = zeros(M, 1);
for II = 1 : M
    if(Alpha_ncls(II)>0)
        abundance(II) = Alpha_ncls(II);
    end
end
end










