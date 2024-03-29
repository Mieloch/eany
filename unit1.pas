
unit Unit1;


{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Spin,
  StdCtrls, IntervalArithmetic, IntervalArithmetic32and64;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    procedure Button1Click(Sender: TObject);

  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
function Max(a : Extended; b : Extended) : Extended;
begin
         if a>b then
         begin
           Max :=a;
         end else
         begin
           Max :=b;

         end;
end;
function NewtonrootsInterval (n         : Integer;
                      a         : array of interval;
                      var x     : interval;
                      mit       : Integer;
                      eps       : Extended;
                      var w     : interval;
                      var it,st : integer) : Interval;

var i         : Integer;
  dw,xh, tmp: interval;
    u,v : Extended;
begin
  if (n<1) or (mit<1)
    then st:=1
    else begin
           w:=a[n];
           for i:=n-1 downto 0 do
           w:=iadd(a[i],imul(w,x));
           it:=0;
           if (w.a=0) and (w.b=0)

             then st:=0
             else begin
                    st:=3;
                    repeat
                      it:=it+1;
                      w:=a[n];
                      dw:=w;
                      for i:=n-1 downto 1 do
                        begin
                         // w:=w*x+a[i];
                          w:=iadd(a[i],imul(w,x));
                          dw:=iadd(w,imul(dw,x));
                         // dw:=dw*x+w
                        end;
                      //w:=w*x+a[0];
                      w:=iadd(a[0],imul(w,x));
                      if (dw.a=0) and (dw.b=0)
                        then st:=2
                        else begin
                               xh:=x;
                               //u:=abs(xh);

                               u:=abs(Max(xh.a,xh.b));
                               //u:=int_width(xh);
                               //x:=x-w/dw;
                               x:=isub(x,idiv(w,dw));
                              // v:=int_width(x);
                              v:=abs(Max(x.a,x.b));
                              tmp :=    isub(x,xh);
                               if v<u
                                 then v:=u;
                               if v=0
                                 then st:=0
                                 //else if abs(x-xh)/v<=eps
                                 //else if int_width(isub(x,xh))/v<=eps

                                 else if abs(Max(tmp.a,tmp.b))/v<=eps
                                        then st:=0
                             end
                    until (it=mit) or (st<>3);
                  end
         end;
  if (st=0) or (st=3)
    then begin
           NewtonrootsInterval:=x;
           w:=a[n];
           for i:=n-1 downto 0 do
             //w:=w*x+a[i]
             w:=iadd(a[i],imul(w,x));
         end
end;

function Newtonroots (n         : Integer;
                      a         : array of real;
                      var x     : Extended;
                      mit       : Integer;
                      eps       : Extended;
                      var w     : Extended;
                      var it,st : integer) : Extended;

var i         : Integer;
    dw,u,v,xh : Extended;
begin
  if (n<1) or (mit<1)
    then st:=1
    else begin
           w:=a[n];
           for i:=n-1 downto 0 do
             w:=w*x+a[i];
           it:=0;
           if w=0
             then st:=0
             else begin
                    st:=3;
                    repeat
                      it:=it+1;
                      w:=a[n];
                      dw:=w;
                      for i:=n-1 downto 1 do
                        begin
                          w:=w*x+a[i];
                          dw:=dw*x+w
                        end;
                      w:=w*x+a[0];
                      if dw=0
                        then st:=2
                        else begin
                               xh:=x;
                               u:=abs(xh);
                               x:=x-w/dw;
                               v:=abs(x);
                               if v<u
                                 then v:=u;
                               if v=0
                                 then st:=0
                                 else if abs(x-xh)/v<=eps
                                        then st:=0
                             end
                    until (it=mit) or (st<>3);
                  end
         end;
  if (st=0) or (st=3)
    then begin
           Newtonroots:=x;
           w:=a[n];
           for i:=n-1 downto 0 do
             w:=w*x+a[i]
         end
end;

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
     factorsStringList: TStringList;
     intervalList: TStringList;
     a_e: array of real;
     a_i: array of interval;
     i:Integer;
     precision: real;
     n: integer;
     x_e: Extended;
     x_i: interval;
     mit: integer;
     eps_e: Extended;
     eps_i: interval;
     st: integer;
     it: integer;
     w_e: Extended;
     normal_arithmetic : Boolean;
     l, p : string;
     tmp : interval;
     w_i : interval ;
     return_i : interval;
     return_e : Extended;


begin
         normal_arithmetic:= RadioButton1.Checked;
  //wspolczynniki
     if Edit1.Text = '' then
     begin
       Label1.Caption:='Podaj współczynniki wielomianu!';
       exit;
     end;
         tmp :=int_read('0');
     factorsStringList := TStringList.Create;
     intervalList := TStringList.Create;
     Split(' ', Edit1.Text, factorsStringList);
     setlength(a_e,factorsStringList.Count);
     setlength(a_i,factorsStringList.Count);
      for i:=0 to factorsStringList.Count-1 do
      begin
           if normal_arithmetic = false then
           begin


                if LastDelimiter(';',factorsStringList[i]) = 0 then
                begin
                  a_i[i]:=int_read(factorsStringList[i]);
                end
                else
                begin
                  Split(';', factorsStringList[i], intervalList);
                  tmp.a := left_read(intervalList[0]);
                  tmp.b := right_read(intervalList[1]);
                  a_i[i]:=tmp;
                end
           end
           else
           begin
                    try
                   a_e[i]:=StrToFloat(factorsStringList[i]);
                   except
                       on EConvertError do
                       begin
                       Label1.Caption:='Podaj poprawne współczynniki wielomianu!';
                         exit;
                       end;
                       end;
                 end;
           end;



       //dokladnowsc rozwiazania

              try
                 eps_e:=StrToFloat(Edit2.Text);
              except
                    on EConvertError do
                    begin
                         Label1.Caption:='Podaj poprawną dokładkość rozwiązania!';
                         exit;
                    end;
              end;
              if eps_e < 0 then
              begin
                         Label1.Caption:='Dokładność musi być większa od zera!';
                         exit;
              end;
            ;



       //stopien wielomianu

      n:=SpinEdit1.Value;

      // maksymalna ilosc iteracji

      mit:=SpinEdit2.Value;

      // poczatkowe przyblizenie
                        if normal_arithmetic = false then
           begin


                if LastDelimiter(';',Edit3.Text) = 0 then
                begin
                     try
                    x_i:=int_read(Edit3.Text);
                  except
                    on EConvertError do
                    begin
                         Label1.Caption:='Podaj poprawne przyblizenie!';
                         exit;
                    end;
                    end;
                end
                else
                begin
                  Split(';', Edit3.Text, intervalList);
                  tmp.a := left_read(intervalList[0]);
                  tmp.b := right_read(intervalList[1]);
                  x_i:=tmp;
                end
           end
            else
            begin
                     try
                 x_e:=StrToFloat(Edit3.Text);
              except
                    on EConvertError do
                    begin
                         Label1.Caption:='Podaj poprawne przyblizenie!';
                         exit;
                    end;
              end;
              if x_e < 0 then
              begin
                         Label1.Caption:='Przyblizenie musi być większe od zera!';
                         exit;
              end;
              end;


         if normal_arithmetic = true then
         begin
            return_e := Newtonroots(n,a_e,x_e,mit,eps_e,w_e,it,st);
            Label1.Caption:='Pierwiastek: ' + FloatToStr(return_e);
            iends_to_strings(w_i,l,p );
            Label8.Caption:='Wartość: ' + FloatToStr(w_e);
            Label9.Caption:='Ilość iterajcji: ' + IntToStr(it);
         end else

begin
  w_i := int_read('0');
  return_i := NewtonrootsInterval(n,a_i,x_i,mit,eps_e,w_i,st,it);
   iends_to_strings(return_i,l,p );

            Label1.Caption:='Pierwiastek: ' + l + ' ; ' + p;
            iends_to_strings(w_i,l,p );
            Label8.Caption:='Wartość: ' + l + ' ; ' + p;
            Label9.Caption:='Ilość iterajcji: ' + IntToStr(it);
end




end;



end.

