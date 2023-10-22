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
	i, j: integer;
	edid, layers, layer, dnam: IInterface;
	line: string;
begin
	if Signature(e) <> 'BIOM' then
		Exit;
	edid := EditorID(e);
	layers := ElementByIndex(e, IndexOf(e, ElementBySignature(e, 'RNAM')) + 1);

	for i := 0 to Pred(ElementCount(layers)) do begin
		layer := ElementByIndex(layers, i);
		line := edid + '|' + GetEditValue(ElementBySignature(layer, 'FNAM'));
		dnam := ElementByIndex(layer, 3);
		for j := 0 to Pred(4) do line := line + '|' + GetEditValue(ElementByIndex(dnam, j));
		sl.Add(line);
	end;

end;

function Finalize: integer;
var
	fname: string;
begin
	fname := ProgramPath + 'Edit Scripts\aaaBiomeLayerDnam.txt';
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