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
	components, component, values: IInterface;
	line, componentType: string;
	hasComponent: boolean;
begin
	if (Signature(e) <> 'PCBN') and (Signature(e) <> 'PCCN') then
		Exit;
	line := EditorID(e);
	components := ElementByName(e, 'Components');
	for i := 0 to Pred(ElementCount(components)) do begin
		component := ElementByIndex(components, i);
		componentType := GetEditValue(ElementBySignature(component, 'BFCB'));
		if componentType = 'BGSPlanetContentManagerContentProperties_Component' then begin
			hasComponent := true;
			values := ElementByIndex(component, 1);
			for j := 0 to Pred(ElementCount(values)) do begin
				line := line + '|' + GetEditValue(ElementByIndex(values, j));
			end;
		end;
	end;
	if hasComponent then sl.Add(line);
end;

function Finalize: integer;
var
	fname: string;
begin
	fname := ProgramPath + 'Edit Scripts\aaaPCMValues.txt';
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