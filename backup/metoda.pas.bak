unit Metoda;
interface
uses
Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
StdCtrls, ComCtrls, Grids, Buttons, Math;
type
TForm1 = class(TForm)
Edit1: TEdit;
StringGrid1: TStringGrid;
Label1: TLabel;
BitBtn1: TBitBtn;
BitBtn3: TBitBtn;
Edit2: TEdit;
Label2: TLabel;
Button1: TButton;
Button2: TButton;
Label3: TLabel;
Edit3: TEdit;
Label4: TLabel;
Label5: TLabel;
Edit4: TEdit;
Label8: TLabel;
Edit5: TEdit;
Label6: TLabel;
procedure Edit1Change(Sender: TObject);
procedure w_lewo(Sender: TObject);
procedure w_prawo(Sender: TObject);
procedure FormCreate(Sender: TObject);
procedure Button1Click(Sender: TObject);
procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
var CanSelect: Boolean);
procedure Button2Click(Sender: TObject);
private
{ Private declarations }
public
{ Public declarations }
end;
var
Form1: TForm1;
n,p,q: Integer;
prawo: Integer=1;
MX: Array of real;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
StringGrid1.ColCount:=1;
StringGrid1.RowCount:=2;
Edit1Change(Form1);
end;

//Zrobienie siatki i ustawienie tablic dynamicznych
procedure TForm1.Edit1Change(Sender: TObject);
var i:Integer;
begin
n:=StrToInt(Edit1.Text);
if n<2 then begin ShowMessage('Wielomian musi być conajmniej dgugiego stopnia'); exit; end;
StringGrid1.ColCount:=n+1;
SetLength(MX, n+1);
for i:=0 to n+1 do StringGrid1.Cells[i,1]:='';
for i:=0 to n do StringGrid1.Cells[i,0]:='x^'+IntToStr(n-i);
end;

//Nawigacja
procedure TForm1.w_lewo(Sender: TObject);
begin
if prawo>0 then
begin
prawo:=prawo-1;
StringGrid1.Col:=prawo;
end;
end;
procedure TForm1.w_prawo(Sender: TObject);
begin
if prawo<n then
begin
prawo:=prawo+1;
StringGrid1.Col:=prawo;
end;
end;
procedure TForm1.StringGrid1SelectCell(Sender: TObject; ACol,
ARow: Integer; var CanSelect: Boolean);
begin
prawo:=ACol;
end;

//wpis
procedure TForm1.Button1Click(Sender: TObject);
var i:Integer;
begin
Val(Edit2.Text,MX[n-prawo],i);
if i<>0 then ShowMessage('Blad podczas wpisu') Else StringGrid1.Cells[prawo,1]:=Edit2.Text;
end;

function w(k:Integer; x:Real):Real;  //algorytm Hornera - obliczanie wartości wielomianu
begin
if k=n then w:=MX[k] else w:=w(k+1,x)*x+MX[k]
end;

function s(j:Integer):Integer; //funkcja pomocnicza s(j)
begin
s:=(n-j) mod q;
end;

function r(j:Integer):Integer; //funkcja pomocnicza r(j)
begin
if (j mod q)<> 0 then r:=0 else r:=q;
end;

function T(a,b:Integer; x:Real):Real; //główna funkcja obliczająca znormalizowaną pochodną
begin
if x=0 then T:=MX[a] else //by można obliczyć silnię w punkcie x=0
if (a=-1) then T:=MX[n-b-1]*IntPower(x,s(b+1)) else //IntPower - moduł math - potęgowanie
if a=b then T:=MX[n]*IntPower(x,s(0)) else T:=T(a-1,b-1,x)+T(a,b-1,x)*IntPower(x,r(b-a));
end;

function pochodna(stopien:Integer; punkt:Real):Real;
begin
if punkt=0 then pochodna:=T(stopien,n,punkt) else pochodna:=T(stopien,n,punkt)/IntPower(punkt,stopien mod q);
end;

procedure TForm1.Button2Click(Sender: TObject);
var i,j: Integer;
a,b,c: Real;
begin
Val(Edit3.Text,a,i);
if i<>0 then begin ShowMessage('Źle wpisany początek przedziału'); exit; end;
Val(Edit4.Text,b,i);
if i<>0 then begin ShowMessage('Źle wpisany koniec przedziału'); exit; end;
if b<a then begin ShowMessage('Koniec przedziału jest mniejszy od początku!'); exit; end;
j:=StrToInt(Edit5.Text);
if j<1 then begin ShowMessage('Nieprawidłowa liczba iteracji'); exit; end;
p:=1; q:=n+1;
if pochodna(2,a)*w(0,a)>0 then c:=a else c:=b;
for i:=1 to j do
begin
c:=c-(w(0,c)/(pochodna(1,c)));
if w(0,c)=0 then break;
end;
if w(0,c)=0 then Label8.Caption:='Dokładny pierwiastek wynosi '+FloatToStr(c) else
Label8.Caption:='Przybliżony pierwiastek wynosi '+FloatToStr(c);
end;
end.
