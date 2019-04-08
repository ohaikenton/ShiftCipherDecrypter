//program developed by Li Chun Kit
//Compiler: FPC v3.0.4
//IDE: Lazarus IDE v2.0.0 r60307
program ShiftCypher;
uses Crt, sysutils;
label Exit,MenuCustom,Menu,OutputErr;

const lineDisplay=100;
      totalLetter=2000;
      colorWriteln=TRUE;
      colorWrite=FALSE;
      defaultColor=White;

const Blue = 1; //colour constants
      Green = 2;
      Cyan = 3;
      Red = 4;
      Magenta = 5;
      Brown = 6;
      Yellow = 14;
      White = 15;

var   userOption,fileEncr,fileDir,finalFileDecr:string;
      i,j,lengthFile,KCount,userOptionInt,allLetterCount,finalK:integer;
      letterCount:array[65..90] of integer;
      K:array of integer;
      fileDecr:array of string;
      fileOut:text;

function IntToStr(inInt:integer):String;
var temp: String;
begin
  Str(inInt,temp);
  IntToStr:=temp;
end;

procedure stringColorChange(inString:string;inColor:byte;lineOption:boolean);
begin
  textcolor(inColor);
  if lineOption then
    writeln(inString)
  else
    write(inString);
  textcolor(defaultColor);
end;

procedure Input(dir:string);
var fileText:text;
begin
  assign(fileText,dir);
  reset(fileText);
  setlength(fileEncr,totalLetter);
  while not EOF(fileText) do
    begin
      while not EOLn(fileText) do
        begin
          i:=i+1;
          read(fileText,fileEncr[i]);
        end;
      readln(filetext);
    end;
  lengthFile:=i;
  setlength(fileEncr,lengthFile);
  close(fileText);
end;

procedure CountLetter;
begin
  for i:=65 to 90 do
    letterCount[i]:=0;
  for i:=1 to length(fileEncr) do
    case fileEncr[i] of
      'A'..'Z':inc(letterCount[ord(fileEncr[i])]);
    end;
end;

procedure CountCheck;
begin
  for i:=65 to 90 do
    begin
    write(chr(i) ,':');
    stringColorChange(IntToStr(letterCount[i]),Yellow,colorWrite);
    write(' ');
    end;
  writeln();
end;

procedure FindK;
var temp:integer;
    tempK:array of integer;
begin
  setlength(tempK,1);
  temp:=0;
  for i:=65 to 90 do
    begin
      if temp < letterCount[i] then
        begin
          temp:=letterCount[i];
          tempK[length(tempK)]:=i-69;
          KCount:=0;
        end;
      if temp = letterCount[i] then
        begin
          setlength(tempK,length(tempK)+1);
          inc(KCount);
          tempK[length(tempK)]:=i-69;
        end;
    end;
  setlength(K,KCount);
  j:=1;
  for i:=length(tempK)-KCount+1 to length(tempK) do
    begin
      K[j]:=tempK[i];
      inc(j);
    end;
end;

procedure InfoAppend;
begin
  assign(fileOut,fileDir);
  append(fileOut);
  writeln(fileOut);
  writeln(fileOut,'##Shift Cypher Decrypter file operation ',DateTimetoStr(Now));
  writeln(fileOut,'##Info of decryption performed is as follows:');
  writeln(fileOut,'Original file is: ',fileDir);
  write(fileOut,'Number of characters(including punctuations');
  writeln(fileOut,' and spaces): ',lengthFile);
  writeln(fileOut,'Number of letters: ',allLetterCount);
  writeln(fileOut,'Final (chosen) K/Shifted by: ',finalK);
  writeln(fileOut,'Most frequent letter in the original file: ',chr(finalK+69));
  write(fileOut,'Frequency of letters in original file: ');
  for i:=65 to 90 do
    write(fileOut,chr(i) ,':',letterCount[i],' ');
  close(fileOut);
end;

procedure InfoRewrite;
begin
  clrscr;
  writeln('Please enter the file name to be created.');
  stringColorChange('Guide: ',Yellow,colorWrite);
  write('To save the file in the same folder as the program, enter the file');
  writeln(' name only(e.g. FileOut.txt)');
  write('       To save the file in a different folder, enter the full path(');
  writeln('e.g. C:\OutDir\FileOut.txt)');
  write('Save decrypted file as: ');
  readln(userOption);
  assign(fileOut,userOption);
  rewrite(fileOut);
  writeln(fileOut,'Original file is: ',fileDir);
  write(fileOut,'Number of characters(including punctuations');
  writeln(fileOut,' and spaces): ',lengthFile);
  writeln(fileOut,'Number of letters: ',allLetterCount);
  writeln(fileOut,'Final (chosen) K/Shifted by: ',finalK);
  writeln(fileOut,'Most frequent letter in the original file: ',chr(finalK+69));
  write(fileOut,'Frequency of letters in original file: ');
  for i:=65 to 90 do
    write(fileOut,chr(i) ,':',letterCount[i],' ');
  close(fileOut);
end;

procedure ShowInfo;
begin
  clrscr;
  if allLetterCount=0 then
    for i:=65 to 90 do
      allLetterCount:=allLetterCount + letterCount[i];
  writeln('Showing detailed information on action.');
  writeln();
  write('Original file is: ');
  stringColorChange(fileDir,Yellow,colorWriteLn);
  write('Number of characters(including punctuations and spaces): ');
  stringColorChange(IntToStr(lengthFile),Yellow,colorWriteln);
  write('Number of letters: ');
  stringColorChange(IntToStr(allLetterCount),Yellow,colorWriteln);
  write('Final (chosen) K/Shifted by: ');
  if finalK=0 then
    stringColorChange(IntToStr(finalK),Red,colorWriteln)
  else
    stringColorChange(IntToStr(finalK),Yellow,colorWriteln);
  write('Most frequent letter in the original file: ');
  stringColorChange(chr(finalK+69),Yellow,colorWriteln);
  write('Frequency of letters in original file: ');
  CountCheck;
  writeln();
  writeln('Choose what you would like to do next.');
  writeln();
  writeln(' 1: Output above info to file');
  writeln(' Any other character: Exit to the main menu');
  writeln();
  write('Please enter the number corresponding to your choice: ');
  readln(userOption);
  if userOption='1' then
    begin
      clrscr;
      write('Would you like to write to the existing file or write to');
      writeln(' a new file?');
      writeln();
      writeln(' 1: Output to existing file');
      writeln(' 2: Output to new file');
      writeln(' 0: Go back to the main menu');
      writeln();
         write('Please enter the number corresponding to your choice: ');
         readln(userOptionInt);
         case userOptionInt of
           1:InfoAppend;
           2:InfoRewrite;
           0:;
         else
           begin
             clrscr;
             write('Invalid option. ');
           end;
         end;
         clrscr;
       end;
end;

procedure Shift;
var temp:string;
begin
  writeln('Number of K is: ',KCount);
  setlength(fileDecr,KCount+1);
  temp:=fileEncr;
  for i:=1 to KCount do
    begin
      for j:=1 to lengthFile do
        if (temp[j]>='A') and (temp[j]<='Z') then
          begin
            temp[j]:=chr(ord(temp[j])-abs(K[i]));
            if temp[j]<'A' then
              inc(temp[j],26);
          end;
      fileDecr[i]:=temp;
    end;
end;

procedure ChooseFinal;
var temp:string;
begin
  clrscr;
  write('Multiple possible solutions found. ');
  writeln('Please select the most probable one:');
  for i:=1 to KCount do
    begin
      temp:=fileDecr[i];
      writeln();
      writeln(i,':');
      for j:=1 to lineDisplay do
        write(temp[j]);
      write('...');
      writeln();
    end;
  writeln();
  write('Please enter the number corresponding to your choice: ');
  readln(userOptionInt);
  while (userOptionInt<1) or (userOptionInt>KCount) do
    begin
      write('Invalid option. Please enter a valid number: ');
      readln(userOptionInt);
    end;
  finalK:=userOptionInt;
  finalFileDecr:=fileDecr[userOptionInt];
end;

procedure OutAppend;
begin
  assign(fileOut,fileDir);
  append(fileOut);
  writeln(fileOut);
  writeln(fileOut,'##Shift Cypher Decrypter file operation ',DateTimetoStr(Now));
  writeln(fileOut,'##The decrypted version of this file is as follows:');
  writeln(fileOut,finalFileDecr);
  close(fileOut);
end;

procedure OutRewrite;
begin
  writeln('Please enter the file name to be created.');
  stringColorChange('Guide: ',Yellow,colorWrite);
  write('To save the file in the same folder as the program, enter the file');
  writeln(' name only(e.g. FileOut.txt)');
  write('       To save the file in a different folder, enter the full path(');
  writeln('e.g. C:\OutDir\FileOut.txt)');
  write('Save decrypted file as: ');
  readln(userOption);
  assign(fileOut,userOption);
  rewrite(fileOut);
  writeln(fileOut,finalFileDecr);
  close(fileOut);
end;

{$R *.res}

begin
  i:=0;
  allLetterCount:=0;
  textcolor(defaultColor);
  writeln('Welcome to Shift Cypher Decrypter.');
  writeln('Please enter the file name of the file to be decrypted (.txt only).');
  stringColorChange('Guide: ',Yellow,colorWrite);
  write('If the file in the same folder as the program, enter the file');
  writeln(' name only(e.g. FileIn.txt)');
  write('       If the file in a different folder, enter the full path(');
  writeln('e.g. C:\InDir\FileIn.txt)');
  write('If you wish to exit the program now, type EXIT and press enter: ');
  readln(userOption);
  if (userOption = 'EXIT') or (userOption = 'exit')then
    goto Exit
  else
    begin
      clrscr;
      fileDir:=userOption;
      writeln('Please restart the program and input a valid file name.');
      Input(userOption);
    end;
  CountLetter;
  FindK;
  Shift;
  if KCount>1 then
    ChooseFinal
  else
    begin
      finalFileDecr:=fileDecr[KCount];
      finalK:=K[1];
    end;
   Menu:
  ClrScr;
  write('Decryption successfully completed for ',fileDir,'. ');
   MenuCustom:
  writeln('Choose what you would like to do next.');
  writeln();
  writeln(' 1: See decrypted text');
  writeln(' 2: Output decrypted text to a file');
  writeln(' 3: See info on performed operation');
  writeln(' 4: See original (encrypted) file');
  writeln(' 0: Exit');
  writeln();
  write('Please enter the number corresponding to your choice: ');
  readln(userOptionInt);
  case userOptionInt of
    1: begin
         clrscr;
         writeln('Showing decrypted ',fileDir,':');
         writeln();
         writeln(finalFileDecr);
         writeln();
         writeln();
         writeln('Press enter to exit to the main menu.');
         readln;
         goto Menu;
       end;
    2: begin
         clrscr;
           OutputErr:
         write('Would you like to write to the existing file or write to');
         writeln(' a new file?');
         writeln();
         writeln(' 1: Output to existing file');
         writeln(' 2: Output to new file');
         writeln(' 0: Go back to the main menu');
         writeln();
         write('Please enter the number corresponding to your choice: ');
         readln(userOptionInt);
         case userOptionInt of
           1:OutAppend;
           2:OutRewrite;
           0:goto Menu;
         else
           begin
             clrscr;
             write('Invalid option. ');
           end;
         end;
         clrscr;
         write('Output complete. ');
         goto MenuCustom;
       end;
    3: begin
         ShowInfo;
         goto Menu;
       end;
    4: begin
           clrscr;
           writeln('Showing undecrypted ',fileDir,':');
           writeln();
           writeln(fileEncr);
           writeln();
           writeln();
           writeln('End of ',fileDir,'. Press enter to exit to the main menu.');
           readln();
           goto Menu;
         end;
    0: goto Exit;
  else begin
         ClrScr;
         write('Invalid option. ');
         goto MenuCustom;
       end;
  end;
  Exit:
  ClrScr;
  writeln('Thank you for using Shift Cypher Decrypter. Press enter to exit.');
  readln;
end. //end of program
