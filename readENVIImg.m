function [Image_Cube, lines, samples, bandCount, datatype] = readENVIImg( filepath );
    % ��ȡenvi�����imgͨ�������ݸ�ʽ�߹���ͼ��matlab������
    % filepath: �߹���ͼ���ļ�·��
    % ����ֵ��[Image_Cube, lines, samples, bandCount, datatype]
    
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
        case 1                       % �ֽڣ�8λ
            PixData = fread(fid, 'uint8');
            len = length( PixData );
            if len ~= samples * lines * bandCount
                error('����ͼ���������ݴ�С�����ϣ�');
            end
            Image_Cube = reshape(PixData,[samples,lines,bandCount]);
        case 2                       % �ֽڣ�16λ
            PixData = fread(fid,'int16'); % ���ֽ���ʽ����
            len = length( PixData );
            if len ~= samples * lines * bandCount
                error('����ͼ���������ݴ�С�����ϣ�');
            end
            Image_Cube = reshape(PixData,[samples,lines,bandCount]);
        case 3                       % �ֽڣ�32λ
            PixData = fread(fid,'int32');
            len = length( PixData );
            if len ~= samples * lines * bandCount
                error('����ͼ���������ݴ�С�����ϣ�');
            end
            Image_Cube = reshape(PixData,[samples,lines,bandCount]);
        case 4                       % ���㣬32λ
            PixData = fread(fid,'float32');
            len = length( PixData );
            if len ~= samples * lines * bandCount
                error('����ͼ���������ݴ�С�����ϣ�');
            end
            Image_Cube = reshape(PixData,[samples,lines,bandCount]);
        otherwise
            error('data type is wrong.');
    end
    Image_Cube = permute(Image_Cube,[2 1 3]);
end