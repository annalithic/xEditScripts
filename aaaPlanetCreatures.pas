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
  i, p: integer;
  components, component, biomes, perbiome, biome, plant: IInterface;
  name, biomename: string;
begin
  if Signature(e) <> 'PNDT' then
    Exit;
  components := ElementByIndex(e, 2);
  for i := 0 to Pred(ElementCount(components)) do begin
    component := ElementByIndex(components, i);
	if GetEditValue(ElementBySignature(component, 'BFCB')) = 'TESFullName_Component' then begin
      name := GetEditValue(ElementByIndex(ElementByIndex(component, 1), 0));
	end;
  end;
  biomes := ElementByIndex(e, 4);
  for i := 0 to Pred(ElementCount(biomes)) do begin
	perbiome := ElementByIndex(biomes, i);
    biomename :=  GetEditValue(ElementBySignature(LinksTo(ElementByIndex(perbiome, 0)), 'FULL'));
	for p := 0 to Pred(ElementCount(ElementByName(perbiome, 'Fauna'))) do begin
	  plant := LinksTo(ElementByIndex(ElementByIndex(ElementByName(perbiome, 'Fauna'), p), 0));
	  sl.Add(Format('%s|%s|%s', [
	    name,
		biomename,
	    EditorId(plant)
	]));

	end;
	
  end;

end;

function Finalize: integer;
var
  fname: string;
begin
  fname := ProgramPath + 'Edit Scripts\aaaplanetcreatures.txt';
  AddMessage('Saving list to ' + fname);
  sl.SaveToFile(fname);
  sl.Free;
end;

end.
