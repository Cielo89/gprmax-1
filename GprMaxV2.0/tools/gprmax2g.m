function [mesh,header,media]=gprmax2g(name);

% GPRMAX2G  Read binary data representing the numerical grid used by 'GprMax2D' 
%           simulator for ground probing radar.
%
%           [mesh,header,media] = gprmax2g( 'filename' )
%           filename is the name of the binary format file.
%
%           mesh is an M x N matrix which contains the identification number for 
%           each region with different electrical properties. 
%
%           PLEASE NOTE: mesh IS STORED AS A 2 BYTE INTEGER IN THE LATEST 
%                        GPRMAX2D VERSION AND NOT AS AN UNSIGNED CHAR
%
%           M (the number of rows) is the number of Yee cells in the y direction. 
%           N (the number of rows) is the number of Yee cells in the x direction. 
%           
%           header is a structure with fields:
%               header.title
%               header.dx
%               header.dy
%               header.dt
%               header.nx
%               header.ny
%           media is a structure with fields:
%               media.num (is the number of different media in the model)
%
%
%           PLEASE NOTE: media.num  IS STORED AS A 2 BYTE INTEGER IN THE LATEST 
%                        GPRMAX2D VERSION AND NOT AS AN UNSIGNED CHAR
%
%               media.type (contains the string identifier for each medium) 
%           
%           media.type(1)='pec' and media.type(2)=free_space are always set
%
%           This file will work for versions 1.5 and 2.0
%
%   	    Copyright: Antonis Giannopoulos, 2003, 2005  This file can be distributed freely.


% NEW GprMax2D version
FTVER15=20155;
FTVER20=20205;
SMALL=0;
BIG=0;
if(nargin==0)
error('GPRMAX2G requires at least one argument');
end;

if(nargin==1)
type='native';
end;

if(isstr(name)~=1)
error('First argument is not a filename');
end;

fid=fopen(name,'rb');
if(fid==-1)
error(['Can not open =',name]);
end;


ECHECK1=fread(fid,1,'char');
if(strcmp(setstr(dec2hex(ECHECK1)),'2B')==1 )
 SMALL=0;
 BIG=1;
end;
if(strcmp(setstr(dec2hex(ECHECK1)),'67')==1 ) 
 SMALL=1;
 BIG=0;
end;
ECHECK2=fread(fid,1,'char');
if(BIG==1)
 if(strcmp(setstr(dec2hex(ECHECK2)),'67') == 0)
 error(['This is not a GprMax2D/3D file.']);
 end;
end;
if(SMALL==1)
 if(strcmp(setstr(dec2hex(ECHECK2)),'2B') == 0)
 error(['This is not a GprMax2D/3D file.']);
 end;
end;

% Close and open again to make sure you will read it properly.
fclose(fid);
if(SMALL==1)
fid=fopen(name,'rb','ieee-le');
end;
if(BIG==1)
fid=fopen(name,'rb','ieee-be');
end;
% Read Endian again but no check !
temp=fread(fid,1,'short');
% Read type of file
FileType=fread(fid,1,'short');
SWORD=fread(fid,1,'short');
SREAL=fread(fid,1,'short');
TITLELENGTH=fread(fid,1,'short');
SOURCELENGTH=fread(fid,1,'short');
MEDIALENGTH=fread(fid,1,'short');
RESERVED=fread(fid,2,'char');
if(SWORD==2)
 word='short';
end;
if(SWORD==4)
 word='short';
end;
if(SREAL==4)
 real='float';
end;
if(SREAL==8)
 real='double';
end;

switch FileType

    case {FTVER15, FTVER20}
        header.title=fread(fid,TITLELENGTH,'char');
        header.title=setstr(header.title');
        iterations=fread(fid,1,real);
        header.dx=fread(fid,1,real);
        header.dy=fread(fid,1,real);
        header.dt=fread(fid,1,real);
        header.nx=fread(fid,1,word);
        header.ny=fread(fid,1,word);
        media.num=fread(fid,1,word);
        for i=1:media.num
            temp=fread(fid,MEDIALENGTH,'char');
            media.type(i,:)=setstr(temp');
        end;
        mesh=fread(fid,[header.ny header.nx],word);
        
    otherwise
        error(['This is not a GprMax2D geometry file. It may be a data file']);
end

fclose(fid);

