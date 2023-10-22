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
	btps, bdfs: IInterface;
	line: string;
begin
	if Signature(e) <> 'BIOM' then
		Exit;
	line := EditorID(e);
	btps := ElementBySignature(e, 'BTPS');
	for i := 0 to Pred(ElementCount(btps)) do line := line + '|' + GetEditValue(ElementByIndex(btps, i));
	
	bdfs := ElementBySignature(e, 'BDFS');
	for i := 0 to Pred(ElementCount(bdfs)) do line := line + '|' + GetEditValue(ElementByIndex(bdfs, i));

	sl.Add(line);

end;

function Finalize: integer;
var
	fname: string;
begin
	fname := ProgramPath + 'Edit Scripts\aaaBiomeUnknowns.txt';
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