function [mesh,ID,header,media]=gprmax3g(name);

% GPRMAX3G  Read binary data representing the numerical grid used by 'GprMax3D' 
%          (Copyright A. Giannopoulos, 1997, 2002) simulator for ground probing radar.
%
%           [mesh,ID,header,media] = gprmax3g( 'filename' )
%           filename is the name of the binary format file.
%
%           mesh is an NX x NY x NZ matrix which contains an identification number 
%           for each Yee cell in the model which is its medium identifier
%
%           ID is a structure containing a media identification number for
%           each of the electric field edges of a Yee cell. They are:
%
%           ID.ex(NX,NY+1,NZ+1), ID.ey(NX+1,NY,NZ+1), ID.ez(NX+1,NY+1,NZ);
%
%           header is a structure with fields:
%               header.title
%               header.dx
%               header.dy
%               header.dz
%               header.dt
%               header.nx
%               header.ny
%               header.nz
%               header.iterations
%           media is a structure with fields:
%               media.num (is the number of different media in the model)
%               media.type (contains the string identifier for each medium) 
%           
%           This file will work for Versions 1.5 and 2.0
%
%              media.type(1)='pec' and media.type(2)=free_space are always set
%
%           Copyright: Antonis Giannopoulos, 2003, 2005  This file can be distributed freely.



FTVER15=30155;
FTVER20=30205;
SMALL=0;
BIG=0;
if(nargin==0)
error('GPRMAX3G requires at least one argument');
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
% If you are here you have a valid file. Unless someone is playing a but joke !!
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
 word='long';
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
        header.iterations=fread(fid,1,real);
        header.dx=fread(fid,1,real);
        header.dy=fread(fid,1,real);
        header.dz=fread(fid,1,real);
        header.dt=fread(fid,1,real);
        header.nx=fread(fid,1,word);
        header.ny=fread(fid,1,word);
        header.nz=fread(fid,1,word);

        media.num=fread(fid,1,word);
        mesh=ones(header.nx,header.ny,header.nz);
        ID=0;
        for i=1:media.num
            temp=fread(fid,MEDIALENGTH,'char');
            media.type(i,:)=setstr(temp');
        end;
        for i=1:header.nx
            temp=fread(fid,[header.nz header.ny],word);
            mesh(i,:,:)=temp';
        end

        ID.ex=zeros(header.nx,header.ny+1,header.nz+1);
        ID.ey=zeros(header.nx+1,header.ny,header.nz+1);
        ID.ez=zeros(header.nx+1,header.ny+1,header.nz);
        for i=1:header.nx
            temp=fread(fid,[header.nz+1 header.ny+1],word);
            ID.ex(i,:,:)=temp';
        end
        for i=1:header.nx+1
            temp=fread(fid,[header.nz+1 header.ny],word);
            ID.ey(i,:,:)=temp';
        end
        for i=1:header.nx+1
            temp=fread(fid,[header.nz header.ny+1],word);
            ID.ez(i,:,:)=temp';
        end
        
    otherwise
        disp(['This is not a GprMax3D geometry file. It may be a data file']);
end

fclose(fid);

