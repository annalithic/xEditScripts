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
	opds: IInterface;
	line: string;
begin
	opds := ElementBySignature(e, 'OPDS');
	if ElementCount(opds) = 0 then Exit;

	line := EditorID(e);
	for i := 0 to Pred(ElementCount(opds)) do line := line + '|' + GetEditValue(ElementByIndex(opds, i));

	sl.Add(line);
end;

function Finalize: integer;
var
	fname: string;
begin
	fname := ProgramPath + 'Edit Scripts\aaaOPDS.txt';
	AddMessage('Saving list to ' + fname);
	sl.SaveToFile(fname);
	sl.Free;
end;

end.


//exotics
//ice
//rocks
//shrubs
//snow
//trees	