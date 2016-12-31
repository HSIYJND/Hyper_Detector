% Author : Jacory Gao
function writeENVIImg(filename, img, format)
% write envi standard format images, only support bsq format and can't
% specify header offset.
% pamameters:
%   filename  :  output file path.
%   img       :  image variable.
%   format    :  format string

expectedFormats = { 'uint8', 'int16','int32', 'float32'};
parser = inputParser;
addRequired(parser, 'filename');
addRequired(parser, 'img');
addRequired(parser, 'format', @(x) any(validatestring(x, expectedFormats)));
parse( parser, filename, img, format);

basename = strsplit(filename, '.');
if size( basename ) == 1
    hdrpath = strjoin( [basename, '.hdr'], '');
else
    hdrpath = strjoin( [basename(1:end-1), '.hdr'], '');
end
hdrfile = fopen(hdrpath, 'w');


[lines, samples, bandCount] = size(img);

switch format
    case 'uint8'
        dataType = 1;
    case 'int16'
        dataType = 2;
    case 'int32'
        dataType = 3;
    case 'float32'
        dataType = 4;
    otherwise
        dataType = 4;
end

fprintf(hdrfile, '%s\n', 'ENVI description = { matlab writeENVIImg function }');
fprintf(hdrfile, '%s\n', ['samples = ', int2str(samples)]);
fprintf(hdrfile, '%s\n', ['lines = ', int2str(lines)]);
fprintf(hdrfile, '%s\n', ['bands = ', int2str(bandCount)]);
fprintf(hdrfile, '%s\n', 'header offset = 0');
fprintf(hdrfile, '%s\n', 'file type = ENVI Standard');
fprintf(hdrfile, '%s\n', ['data type = ', int2str(dataType)]);
fprintf(hdrfile, '%s\n', 'interleave = bsq');

fclose(hdrfile);

outfile = fopen(filename, 'w');
img = permute(img, [2,1,3]);
fwrite(outfile, img, format);
fclose(outfile);

end