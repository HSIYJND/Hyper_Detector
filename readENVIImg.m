function [Image_Cube, lines, samples, bandCount, datatype] = readENVIImg( filepath );
    % 读取envi软件的img通用裸数据格式高光谱图像到matlab环境中
    % filepath: 高光谱图像文件路径
    % 返回值：[Image_Cube, lines, samples, bandCount, datatype]
    
    %% read header file
    basename = strsplit(filepath, '.');
    if size( basename ) == 1
        hdrpath = strjoin( [basename, '.hdr'], '');
    else
        hdrpath = strjoin( [basename(1:end-1), '.hdr'], '');
    end
    fid = fopen( hdrpath, 'r' );
    
    linestr = '';
    
    samples = 0;
    lines = 0;
    bandCount = 0;
    datatype = 0;
    
    while ~feof(fid)
        linestr = fgetl(fid);
        linearr = strsplit(linestr, '=');
        if  strcmp(strtrim(linearr(1)), 'samples')
            samples = str2double( cell2mat( strtrim( linearr(2) ) ) );
        elseif strcmp(strtrim(linearr(1)), 'lines')
            lines = str2double( cell2mat( strtrim( linearr(2) ) ) );
        elseif strcmp(strtrim(linearr(1)), 'bands')
            bandCount = str2double( cell2mat( strtrim( linearr(2) ) ) );
        elseif strcmp(strtrim(linearr(1)), 'data type')
            datatype = str2double( cell2mat( strtrim( linearr(2) ) ) );
        end
    end
    fclose(fid);
    
    if samples == 0 || lines == 0 || bandCount == 0 || datatype == 0
        error('read hdr file error.');
    end
    
    %% read image file
    fid = fopen(filepath,'r');
    switch datatype
        case 1                       % 字节，8位
            PixData = fread(fid, 'uint8');
            len = length( PixData );
            if len ~= samples * lines * bandCount
                error('读入图像有误，数据大小不符合！');
            end
            Image_Cube = reshape(PixData,[samples,lines,bandCount]);
        case 2                       % 字节，16位
            PixData = fread(fid,'int16'); % 按字节形式读入
            len = length( PixData );
            if len ~= samples * lines * bandCount
                error('读入图像有误，数据大小不符合！');
            end
            Image_Cube = reshape(PixData,[samples,lines,bandCount]);
        case 3                       % 字节，32位
            PixData = fread(fid,'int32');
            len = length( PixData );
            if len ~= samples * lines * bandCount
                error('读入图像有误，数据大小不符合！');
            end
            Image_Cube = reshape(PixData,[samples,lines,bandCount]);
        case 4                       % 浮点，32位
            PixData = fread(fid,'float32');
            len = length( PixData );
            if len ~= samples * lines * bandCount
                error('读入图像有误，数据大小不符合！');
            end
            Image_Cube = reshape(PixData,[samples,lines,bandCount]);
        otherwise
            error('data type is wrong.');
    end
    Image_Cube = permute(Image_Cube,[2 1 3]);
end