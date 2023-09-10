{
  Export list of CELLs
}
unit UserScript;

var
  sl: TStringList;

function Initialize: integer;
begin
  sl := TStringList.Create;
end;

function Process(e: IInterface): integer;
var
  i: integer;
  name, id: string;
begin
  if Signature(e) <> 'STDT' then
    Exit;
  sl.Add(Format('%s|%s', [
    GetEditValue(ElementBySignature(e, 'ANAM')),
	GetEditValue(ElementBySignature(e, 'DNAM'))
  ]));
end;

function Finalize: integer;
var
  fname: string;
begin
  fname := ProgramPath + 'Edit Scripts\starIds.txt';
  AddMessage('Saving list to ' + fname);
  sl.SaveToFile(fname);
  sl.Free;
end;

end.
