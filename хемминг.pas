program hem;
var l , i , schet , summa , n , err , z :integer;
a , b , c , d: array of integer;
s :string;

function twopower(n: integer): integer; // Возведение двойки в степень
  var q, i : integer;
  begin
  i:=0;
  q:=1;
  while( i < n) do
    begin
    i:=i+1;
    q:=q*2;
    end;
  twopower:=q
  end;                                  // Возведение двойки в степень



function dopinfo(m: integer): integer;  // Кол-во дополнительных символов
  var n : integer;
  begin
  n:=1;
    while (n+m>twopower(n)-1) do
    begin
    n:=n+1
    end;
  dopinfo:=n
  end;                                  // Кол-во дополнительных символов



function invmass (a: array of integer ; l : integer ) :array of integer; // получаем из программы данные и объявляем, что на выходе массив
  var 
  b : array of integer; //объявляем внутренние переменные
  i : integer;
  begin
  i:= 0;
  b:= new integer[l]; // делаем такую-же длину массива
    repeat  // цикл
      if a[i]=1 then // меняем "1"на "0" и "0" на "1" через условный оператор
      b[i]:=0
      else
      b[i]:=1;
      i:=i+1
    until l=i;
  invmass:=b; // присваиваем функции значение
  end;



function checktp (n : integer):integer; //проверяем число на степень двойки
  var
  a , b : integer;
  begin
  a:=0;
  b:=0;
    repeat
      if n=twopower(a)then
      b:=1
      else
        if n>twopower(a)then
        a:=a+1
        else 
        b:=2;
    until (b=1)or(b=2);
      if b=2 then
      b:=0;
    checktp:=b;
    end;
    
    
    
function code ( b: array of integer ; l : integer ):array of integer;  // Закодируем сообщение
  var 
  pos , pos_sp , summa,n : integer;
  begin
  pos:=0;
  n:=0;
	  repeat
	    if b[pos]=2 then
	    begin
	      //writeln('pos =', pos);   //контролььная печать
	      pos_sp:=pos+1;
	      summa:=0;
	      //writeln('pos_sp cycle'); //контролььная печать
	      repeat
	        if ((((pos_sp + 1) div twopower(n)) mod 2) = 1) then
	        begin
	          //print(pos_sp+1);     //контролььная печать
	          summa:=summa+b[pos_sp];
	        end;
	        pos_sp:=pos_sp+1;
	      until pos_sp=l+dopinfo(l);
	      summa:=summa mod 2;
	      b[pos]:=summa;
	      n:=n+1;
	    end;
	  pos:=pos+1;
	  until pos=l+dopinfo(l);
	code:=b;
	end;



function decode ( b: array of integer ; l : integer ):array of integer;
  var 
  pos , pos_sp , summa , i , n: integer;
  a : array of integer;
  begin
  pos:=0; //оригинально:D
  pos_sp:=0;
  summa:=0;
  i:=dopinfo(l);
  a := new integer [i];
  n:=0;
    repeat 
      if ((pos+1)=twopower(n)) then
      begin
        pos_sp:=pos+1;
        summa:=summa+b[pos];
        //writeln('n=', n);  //контролььная печать
        //print(pos+1);      //контролььная печать
          repeat
            if ((((pos_sp+1) div twopower(n))mod 2)=1) then 
            begin
              summa:=summa+b[pos_sp];
              //print(pos_sp+1); //контролььная печать
            end;
            pos_sp:=pos_sp+1;
          until pos_sp = l + dopinfo(l);
        a[n]:=summa mod 2;
        summa:=0;
        n:=n+1;
      end;
      pos:=pos+1;
  until pos = l + dopinfo(l);
  decode:=a;
  end;



BEGIN
  writeln('Введите сообщение');
  readln(s);
  l:= Length(s);
  a:= new integer[l]; // присваиваем размер массиву
  i:=0;
  schet:=0;
    repeat
      if (s[i+1]= '0') or (s[i+1]= '1') then
        begin
        val(s[i+1],z,err);
        a[i]:=z;
        i:=i+1;
        end
      else
        begin
        i:=0;
        writeln('Неверный ввод. Повторите попытку!');
        s:=nil;
        readln(s);
        a:=nil;
        l:= Length(s);
        a:= new integer[l];
        end;
    until i=l;
  writeln('Количество дополнительных символов = ' , dopinfo(l) );
  writeln('Ваш код: ' , a);
  //writeln('Ваш инвертированный код: ' , invmass(a,l) ); // вызываем функцию.
  b:= new integer[l+dopinfo(l)];
  i:=0;
  schet:=0;
    repeat
      if checktp(schet+1)=1 then
      b[schet]:=2
      else 
      begin
      b[schet]:=a[i];
      i:=i+1;
	    end;
    schet:=schet+1;
    until schet=dopinfo(l)+l;
  i:=0;
  schet:=0;
  writeln('На позициях помеченных"2" будут нахожиться контрольные символы: ' , b);
  writeln('Ваш код для передачи: ' , code(b,l) );
  //readln(n);               //альтернатива
  //writeln(checktp(n));     //альтернатива
  //repeat                   //альтернатива
  //  print(pos);            //альтернатива
  //  pos:=pos+1;            //альтернатива
  //until pos>l+dopinfo(l);  //альтернатива
  writeln('Помехи...');
  b:=code(b,l);
  i:=random(0,((l+dopinfo(l))-1)); // делаем случайную ошибку
  b[i]:=random(0,1);
  //b[6]:=(b[6]+1)mod 2;           // Принудительная ошибка(для отладки)
  writeln('Полученное сообщение: ' , b);
  c:=decode(b,l);
  i:=0;
  summa:=0;
  repeat
    summa:=summa+(c[i]*twopower(i));
    i:=i+1;
  until i = dopinfo(l);
  //writeln('summa= ' , summa); // Для отладки
  writeln('Ошибка в клетке№: ' , decode(b,l) , ' . В десятичной системе: ' , summa);
    if (summa <> 0 ) then              // Исправляем ошибку(если есть)
    begin
    b[summa-1] := (b[summa-1]+1) mod 2;
    writeln('Ошибка исправлена');
    writeln('Вам передавали: ' , b );
    end
    else
    writeln('Ошибки нет! Вам передавали: ' , b);
  i:= length(b);
  n:= length(c);
  d := new integer  [i-n];
  //writeln(length(d));
  i:=0;
  repeat
    //print(i);
    b[twopower(i)-1]:=2;
    i:=i+1;
  until i=n;
  i:=0;
  schet:=0;
  repeat
    if b[i]<>2 then
    begin
      d[schet]:=b[i];
      schet:=schet+1;
    end;
    i:=i+1;
    //print(i+1 , schet+1);
  until i=length(b);
  writeln('Ваше раскодированное сообщение: ' , d);
  writeln('Для выхода из программы нажмите ENTER');
  readln();
END.
