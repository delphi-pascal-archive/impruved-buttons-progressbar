unit but;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Math;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

PROCEDURE knopkaX(i:tImage;cw:integer);
var
s: pbytearray;
c,xnn,xkk,dxy,dy,n,d,dd,dx,x,y,x1,x2,x3,xn,xk,d1,d3,d2,c1,c2,c3,h,w:integer;
yk: boolean;
begin
w:=i.width; h:=i.height;
with i.canvas do begin
d1:=getBValue(cw);
d2:=getGValue(cw);
d3:=getRValue(cw);
//d3:=$60;d2:=$C0;d1:=$FF;
i.transparent:=true;
i.picture.bitmap.pixelformat:=pf24bit;
for y:=0 to h-1 do begin
s:=i.picture.bitmap.scanline[y];
x1:=0;
dy:=abs(y-h div 2);
yk:=(y=0)or(y=h-1);

//скругление углов
if y<2   then begin xn:=2-y; xk:=w+y-3 end else
if y>h-3 then begin xn:=y-h+3; xk:=w-y+h-4 end
         else begin xn:=0; xk:=w-1 end;

xkk:=xk-h div 2;
xnn:=xn+h div 2;
for x:=0 to w-1 do begin
  if (x>=xn) and (x<=xk) then begin
//расстояние до края
    if x=xn    then dx:=16{24}    else
    if x=xk    then dx:=12{20}    else
    if yk      then dx:=8{16}    else
    if x<=xnn  then dx:=xnn-x else
    if x>=xkk  then dx:=x-xkk else dx:=0;

    dxy:=trunc(power(sqr(dx)+sqr(dy),0.73));
    if y<h div 2 then dec(dxy,4);
    c:=d1-dxy; if c<0 then c:=0;if c>255 then c:=255; s[x1]:=c; inc(x1);
    c:=d2-dxy; if c<0 then c:=0;if c>255 then c:=255; s[x1]:=c; inc(x1);
    c:=d3-dxy; if c<0 then c:=0;if c>255 then c:=255; s[x1]:=c; inc(x1);
  end
  else inc(x1,3);

end;
end;
end;
end;

PROCEDURE knopkaS(i:tImage;cw:integer);
type
tm=array[0..100{макс.высота},0..200{ширина},1..3] of byte;
var
z:array[1..3] of integer;
cr,r,v,q,xx,yy,j,h4,h6,h8,x,y,h,w:integer;
yk: boolean;
m,f :^tm;

begin
w:=i.width;
h:=i.height;
getMem(m,sizeOf(tm));getMem(f,sizeOf(tm));

with i.canvas do begin
//if enabled then begin
i.transparent:=true;
i.picture.bitmap.pixelformat:=pf24bit;
//сохранение фона
for y:=0 to h-1 do move(i.picture.bitmap.ScanLine[y]^,f^[y,0,1],w*3);
//цвет рамки потемнее
cr:=RGB(getRvalue(cw) div 8,getGvalue(cw) div 8,getBvalue(cw) div 8);
pen.color:=cr;
brush.color:=pen.color;
fillRect(rect(0,0,w,h));
brush.color:=cw;
pen.width:=1;
roundRect(0,0,w,h,10,10);

for y:=0 to h-1 do move(i.picture.bitmap.ScanLine[y]^,m^[y,0,1],w*3);
//блик
h6:=h div 6; h4:=h div 4; h8:=h div 8;
for x:=h4+2 to w-h4-2 do
for j:=1 to 3 do begin
for v:=0 to 3 do begin
//сверху
  r:=m^[h6+v+1,x,j]+(4-v)*24{44}; if r>$FF then r:=$FF;
  m^[h6+v+1,x,j]:=r;
//снизу
  if v>2 then m^[h-h6-v+2,x,j]:=$FF;
end;
end;

//размытие
for y:=0 to h-1 do begin
for x:=0 to w-1 do
if ((y<>h6+1)and(y<>h6+2))or(x<=h4+5)or(x>=w-h4-5) then
if rgb(m^[y,x,3],m^[y,x,2],m^[y,x,1])=cr then
  for j:=1 to 3 do m^[y,x,j]:=f^[y,x,j]
  else begin
    q:=0; z[1]:=0; z[2]:=0; z[3]:=0;
    for yy:=y-2 to y+2 do
    for xx:=x-2 to x+2 do
    if (yy>=0)and(yy<h) and (xx>=0)and(xx<w) then begin
      for j:=1 to 3 do inc(z[j],m^[yy,xx,j]);
      inc(q);
    end;
    for j:=1 to 3 do m^[y,x,j]:=z[j] div q;
  end;
  move(m^[y,0,1],i.picture.bitmap.ScanLine[y]^,w*3);
end;
freeMem(m);freeMem(f);
end;
end;

PROCEDURE knopka(i:tImage; cw:integer; caption:string; enabled:boolean);
var w,h:integer;
begin
if enabled then knopkaX(i,cw);
w:=i.width;
h:=i.height;
setBKmode(i.canvas.Handle,Transparent);
with i.canvas do begin
if enabled then font.color:=$FFFFFE else font.color:=$0;
textOut((w-textWidth(Caption))div 2, (h-textHeight(Caption))div 2, Caption);
end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
 knopka(Image1,235,'Run',true);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 knopkas(Image3,205);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
 knopkax(Image4,235);
end;

PROCEDURE POLOSKA(i:tImage;P,MAX:integer);
var
s: pbytearray;
k,n,xx,yy,x1,x2,x3,d3,d2,d1,c1,c2,c3,h,w,cb:integer;
st:string[8];
c: boolean;
begin
w:=i.width; h:=i.height;
if p>max then p:=max;
with i.canvas do begin
st:='  '+intToStr(p*100 div max)+'%  ';
font.color:=$FF0000; font.style:=[fsBold];
textOut((w-textWidth(st)) div 2,(h-textHeight(st)) div 2,st);
n:=w*p div max;
d1:=$60*P div max; d2:=$C0*P div max; d3:=$FF*P div max+90;if d3>255 then d3:=255;
i.picture.bitmap.pixelformat:=pf24bit;

for yy:=0 to h-1 do begin
s:=i.picture.bitmap.scanline[yy];
x1:=0; x2:=1; x3:=2;
k:=abs(yy-h div 2)*3;
c1:=d1-k; if c1<0 then c1:=0;
c2:=d2-k; if c2<0 then c2:=0;
c3:=d3-k; if c3<0 then c3:=0;

cb:=255-k;

for xx:=0 to w-1 do begin
  c:=(s[x1]=255)and(s[x2]=0)and(s[x3]=0);
  if xx<n then begin
    if c then begin s[x1]:=$FF;s[x2]:=$FF;s[x3]:=$FF end else begin s[x1]:=c1; s[x2]:=c2;s[x3]:=c3 end;
  end
  else if not c then begin s[x1]:=255; s[x2]:=cb;s[x3]:=cb end;
  inc(x1,3);inc(x2,3);inc(x3,3);
end;
end;
application.processMessages;
end;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
 i: integer;
begin
 for i:=1 to 10000 do
  POLOSKA(Image2,i,10000);
end;

end.
