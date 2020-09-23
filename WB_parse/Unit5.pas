﻿unit Unit5;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, FMX.WebBrowser;

type
  TForm5 = class(TForm)
    IdHTTP1: TIdHTTP;
    Memo1: TMemo;
    Button1: TButton;
    WebBrowser1: TWebBrowser;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure LoadInfo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  html:string;
implementation

{$R *.fmx}

procedure TForm5.Button1Click(Sender: TObject);
begin
html:=IdHTTP1.Get('https://www.wildberries.ru/catalog/14129651/detail.aspx?targetUrl=ES');
WebBrowser1.Navigate('https://www.wildberries.ru/catalog/14129651/detail.aspx?targetUrl=ES');
if IdHTTP1.ResponseCode=200 then
begin
memo1.Text:=html;
LoadInfo;
end
else if (IdHTTP1.ResponseCode>=400) and (IdHTTP1.ResponseCode<=415) then ShowMessage('Ошибка на стороне клиента')
else if (IdHTTP1.ResponseCode>=500) and (IdHTTP1.ResponseCode<=505) then ShowMessage('Ошибка сервера')
else ShowMessage('Неизвестная ошибка');
end;

procedure TForm5.LoadInfo;
var i, c:integer;
s, s1:string;
begin
c:=0;
//=========================brand name========================
if pos('<span class="brand">', Form5.Memo1.Lines.Text)<>0 then
begin
  c:=pos('class="brand"', Form5.Memo1.Lines.Text);
  s:=Copy(Form5.Memo1.Lines.Text,c,pos('/',Form5.Memo1.Lines.Text));
  Delete(s,1,pos('>',s));
  Delete(s,pos('<',s),s.Length-1);
  Memo2.Lines.Add('Бренд: '+s);
end
else
  Memo2.Lines.Add('Бренд не найден');
//=========================product name========================
if pos('<span class="name">', Form5.Memo1.Lines.Text)<>0 then
begin
  c:=pos('class="name"', Form5.Memo1.Lines.Text);
  s:=Copy(Form5.Memo1.Lines.Text,c,pos('/',Form5.Memo1.Lines.Text));
  Delete(s,1,pos('>',s));
  Delete(s,pos('<',s),s.Length-1);
  Memo2.Lines.Add('Название: '+s);
end
else
  Memo2.Lines.Add('Название не найдено');
//=======================final cost=========================
if pos('<span class="final-cost">', Form5.Memo1.Lines.Text)<>0 then
begin
  c:=pos('class="final-cost"', Form5.Memo1.Lines.Text);
  s:=Copy(Form5.Memo1.Lines.Text,c,pos('/',Form5.Memo1.Lines.Text));
  Delete(s,1,pos('>',s)+2);
  Delete(s,pos('&',s),pos(';',s));
  s:=StringReplace(s,' ','',[rfReplaceAll]);
  Memo2.Lines.Add('Финальная стоимость: '+s);
end
else
  Memo2.Lines.Add('Финальная стоимость не найдена');
//=======================old price=========================
if pos('<span class="old-price">', Form5.Memo1.Lines.Text)<>0 then
begin
  c:=pos('class="c-text-base"', Form5.Memo1.Lines.Text);
  s:=Copy(Form5.Memo1.Lines.Text,c,pos('/',Form5.Memo1.Lines.Text));
  Delete(s,1,pos('>',s));
  Delete(s,pos('&',s),pos(';',s)-2);
  Delete(s,pos('<',s),s.Length-1);
  s:=StringReplace(s,' ','',[rfReplaceAll]);
  Memo2.Lines.Add('Старая цена: '+s);
end
else
  Memo2.Lines.Add('Старая цена не найдена');
//=======================hide content=========================
if pos('<div class="discount-tooltipster-content">', Form5.Memo1.Lines.Text)<>0 then
begin
  c:=pos('class="discount-tooltipster-content"', Form5.Memo1.Lines.Text);
  s1:=Copy(Form5.Memo1.Lines.Text,c,pos('div',Form5.Memo1.Lines.Text));
  Delete(s1,pos('</div>',s1),s1.Length-1);
  if pos('class="discount-tooltipster-value">', s1)<>0 then
   begin
    c:=pos('class="discount-tooltipster-value"', s1);
    s:=Copy(s1,c,pos('span',s1));
    Delete(s1,1,pos('/p',s1));
    Delete(s,1,pos('>',s));
    Delete(s,pos('&',s),pos(';',s)-2);
    Delete(s,pos('<',s),s.Length-1);
    Memo2.Lines.Add('Ваша экономия: '+s);
   end
   else
    Memo2.Lines.Add('Пункт "Ваша экономия" не может быть найден');
   if pos('class="discount-tooltipster-value">', s1)<>0 then
   begin
    c:=pos('class="discount-tooltipster-value"', s1);
    s:=Copy(s1,c,pos('span',s1));
    Delete(s1,1,pos('/p',s1));
    Delete(s,1,pos('>',s));
    Delete(s,pos('&',s),pos(';',s)-2);
    Delete(s,pos('<',s),s.Length-1);
    Memo2.Lines.Add('Промокод 20%: '+s);
   end
   else
    Memo2.Lines.Add('Пункт "Промокод" не может быть найден');
    if pos('42207181', Form5.Memo1.Lines.Text)<>0 then
   begin
    c:=pos('42207181', Form5.Memo1.Lines.Text);
    s:=Copy(Form5.Memo1.Lines.Text,c,Form5.Memo1.Lines.Text.Length);
    Delete(s,1,pos('basicPrice',s));
    Delete(s,pos('promoSale',s),s.Length);
    Delete(s,1,pos(':',s));
    Delete(s,pos(',',s),s.Length);
    Memo2.Lines.Add('Скидка 46%: '+s);
   end
   else
    Memo2.Lines.Add('Пункт "Скидка" не может быть найден');
end
else
  Memo2.Lines.Add('Скрытый контент не найден');
end;

end.
