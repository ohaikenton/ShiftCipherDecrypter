(* Program developed by Li Chun Kit
  Compiler: FPC v3.0.4
  IDE: Lazarus, Visual Studio Code *)
program ShiftCypher;
uses Crt, sysutils;
label Exit,MenuCustom,Menu,OutputErr;

const lineDisplay=100;
      maxLetter=2000;
      colorWriteln=TRUE;
      colorWrite=FALSE;
      defaultColor=White;

var   userOption,fileEncr,fileDir,finalFileDecr:string;
      i,j,lengthFile,KCount,userOptionInt,allLetterCount,finalK:integer;
      letterCount:array[65..90] of integer;
      K:array of integer;
      fileDecr:array of string;
      fileOut:text;

(* Allowing integers to be used as a string while keeping its value *)
function IntToStr(inInt:integer):String;
var temp: String;
begin
  Str(inInt,temp);
  IntToStr:=temp;
end;

(* Changing the colour of input string and optionally add a line break *)
procedure stringColorChange(inString:string;inColor:byte;lineOption:boolean);
begin
  textcolor(inColor);
  if lineOption then
    writeln(inString)
  else
    write(inString);
  textcolor(defaultColor);
end;

(* Handling input from users' file system and store it in 1 string variable *)
procedure Input(dir:string);
var fileText:text;
begin
  assign(fileText,dir);
  reset(fileText);
  (* Set the string variable to the predefined constant of maximum length *)
  setlength(fileEncr,maxLetter);
  (* Read the file into the variable no matter the amount of lines *)
  while not EOF(fileText) do
    begin
      while not EOLn(fileText) do
        begin
          i:=i+1;
          read(fileText,fileEncr[i]);
        end;
      readln(filetext);
    end;
  (* Readjust the length of the file *)
  lengthFile:=i;
  setlength(fileEncr,lengthFile);
  close(fileText);
end;

(* Counting the times each alphabet is present in the encrypted text *)
procedure CountLetter;
begin
  for i:=65 to 90 do
    letterCount[i]:=0;
  for i:=1 to length(fileEncr) do
    case fileEncr[i] of
      'A'..'Z':inc(letterCount[ord(fileEncr[i])]);
    end;
end;

(* Displaying the amount of times each alphabet is present in the encrypted text *)
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

(* Calculating the value(s) of k *)
procedure FindK;
  var
    (* Temporarily stores the times that one specific alphabet is present in the encrypted text *)
    temp:integer;
    (* Stores the possible value(s) of k while expanding/contracting according to no. of k values found *)
    tempK:array of integer;
begin
  (* Initialisation *)
  setlength(tempK,1);
  temp:=0;
  for i:=65 to 90 do
    begin
      (* Replace old k value when a more probable one is found *)
      if temp < letterCount[i] then
        begin
          temp:=letterCount[i];
          tempK[length(tempK)]:=i-69;
          KCount:=0;
        end;
      (* Expand tempK to the amount of K found and store its value *)
      if temp = letterCount[i] then
        begin
          setlength(tempK,length(tempK)+1);
          inc(KCount);
          tempK[length(tempK)]:=i-69;
        end;
    end;
  (* Finalisation of k value(s) *)
  setlength(K,KCount);
  j:=1;
  (* Clean up and copy the k value(s) to the final variable (K) *)
  for i:=length(tempK)-KCount+1 to length(tempK) do
    begin
      K[j]:=tempK[i];
      inc(j);
    end;
end;

(* Appending information on performed actions and statistics to original file *)
procedure InfoAppend;
begin
  assign(fileOut,fileDir);
  append(fileOut);
  writeln(fileOut,'##Shift Cypher Decrypter file operation ',DateTimetoStr(Now));
  writeln(fileOut,'##Info of decryption performed is as follows:');
  writeln(fileOut,'Original file is: ',fileDir);
  writeln(fileOut,'Number of characters(including punctuations and spaces): ',lengthFile);
  writeln(fileOut,'Number of letters: ',allLetterCount);
  writeln(fileOut,'Final (chosen) K/Shifted by: ',finalK);
  writeln(fileOut,'Most frequent letter in the original file: ',chr(finalK+69));
  write(fileOut,'Frequency of letters in original file: ');
  for i:=65 to 90 do
    write(fileOut,chr(i) ,':',letterCount[i],' ');
  close(fileOut);
end;

(* Writing information on performed actions and statistics to user specified file *)
procedure InfoRewrite;
begin
  clrscr;
  writeln('Please enter the file name to be created.');
  (* Provide path formatting guidelines *)
  stringColorChange('Guide: ',Yellow,colorWrite);
  writeln('To save the file in the same folder as the program, enter the file name only (e.g. FileOut.txt)');
  writeln('       To save the file in a different folder, enter the full path (e.g. C:\OutDir\FileOut.txt)');
  writeln('       To save the file in a sub-folder, enter the path with respect to the program (e.g. Insub\FileOut.txt)');
  write('Save file as: ');
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

(* Display information on performed actions and statistics *)
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
  (* Provide options to output displayed information *)
  writeln();
  writeln('Choose what you would like to do next.');
  writeln();
  writeln(' 1: Output above info to file');
  writeln(' Any other character: Exit to the main menu');
  writeln();
  write('Please enter the number corresponding to your choice: ');
  readln(userOption);
  (* Go to InfoAppend or InfoRewrite depending on user choice *)
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
         (* Write an error message and loop sub-menu due to invalid input *)
           begin
             clrscr;
             write('Invalid option. ');
           end;
         end;
         clrscr;
       end;
end;

(* Shifting the input/encrypted passage with the calculated k value(s) *)
procedure Shift;
var temp:string;
begin
  //writeln('Number of K is: ',KCount);
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

(* Asking user to choose the most probable decryption result when there are multiple k values *)
(* This procedure is only called when the array size of K is larger than 1 *)
procedure ChooseFinal;
var temp:string;
begin
  clrscr;
  write('Multiple possible solutions found. ');
  writeln('Please select the most probable one:');
  (* Display only a portion of each results whose length is predefined with constant lineDisplay *)
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
  (* Mark final decryption based on user choice and omitting others *)
  finalK:=userOptionInt;
  finalFileDecr:=fileDecr[userOptionInt];
end;

(* Appending decrypted text to original file *)
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

(* Writing decrypted text to user specified file *)
procedure OutRewrite;
begin
  writeln('Please enter the file name to be created.');
  (* Provide path formatting guidelines *)
  stringColorChange('Guide: ',Yellow,colorWrite);
  writeln('To save the file in the same folder as the program, enter the file name only (e.g. FileOut.txt)');
  writeln('       To save the file in a different folder, enter the full path (e.g. C:\OutDir\FileOut.txt)');
  writeln('       To save the file in a sub-folder, enter the path with respect to the program (e.g. Insub\FileOut.txt)');
  write('Save decrypted file as: ');
  readln(userOption);
  assign(fileOut,userOption);
  rewrite(fileOut);
  writeln(fileOut,finalFileDecr);
  close(fileOut);
end;

(* IDE reserved parser *)
{$R *.res}

(* Main program *)
begin
  (* Initialisation *)
  i:=0;
  allLetterCount:=0;
  textcolor(defaultColor);
  writeln('Welcome to Shift Cypher Decrypter.');
  (*Loop input phase until input is valid*)
  repeat
    writeln('Please enter the file name of the file to be decrypted.');
    writeln('Current limit on maximum length of input is: ',maxLetter,' characters in total.');
    (* Provide path formatting guidelines *)
    stringColorChange('Guide: ',Yellow,colorWrite);
    writeln('If the file is in the same folder as the program, enter the file name only (e.g. FileIn.txt)');
    writeln('       If the file is in a different folder, enter the full path (e.g. C:\InDir\FileIn.txt)');
    writeln('       If the file is in a sub-folder, enter the path with respect to the program (e.g. Insub\FileIn.txt)');
    stringColorChange('If the path to the file does not include spaces, you may simply drag the file and drop it onto this window to automatically insert the path.',Cyan,colorWriteln)
    write('If you wish to exit the program now, type EXIT and press enter: ');
    (* Receive user input on text file to be decrypted *)
    readln(userOption);
    clrscr;
    if not FileExists(userOption) then
      writeln(userOption,' is invalid.');
  until FileExists(userOption);
    (* Stop the program if user wish to do so *)
    if (userOption = 'EXIT') or (userOption = 'exit')then
      goto Exit
    else
      begin
        fileDir:=userOption;
        Input(userOption);
      end;
  (* Call procedured that are required to decrypt the excrypted text *)
  CountLetter;
  FindK;
  Shift;
  (* Ask user to choose the most probable decryption result when there are multiple k values *)
  if KCount>1 then
    ChooseFinal
  else
    begin
      finalFileDecr:=fileDecr[KCount];
      finalK:=K[1];
    end;
   Menu:
  ClrScr;
  (* Draw the main UI of the program and display options *)
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
  (* Call different procedure(s) according to user's choice *)
  case userOptionInt of
    1: (* Display the decrypted text on display *)
       begin
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
    2: (* Write/Append the decrypted text to a file *)
       begin
         clrscr;
           OutputErr:
         writeln('Would you like to write to the existing file or write to a new file?');
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
           (* Write an error message and loop sub-menu due to invalid input *)
           begin
             clrscr;
             write('Invalid option. ');
             goto OutputErr;
           end;
         end;
         clrscr;
         write('Output complete. ');
         goto MenuCustom;
       end;
    3: (* Display information on performed actions and statistics *)
       begin
         ShowInfo;
         goto Menu;
       end;
    4: (* Display the original/encrypted text on display  *)
       begin
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
(* end of program *)
end.
