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
  planetarydata, orbitdata: IInterface;
  name, planettype, starid, planetid, parentid: string;
begin
  if Signature(e) <> 'PNDT' then
    Exit;
  planetarydata := ElementByIndex(ElementByName(e, 'Planetary Data'), 0);
  name := GetEditValue(ElementBySignature(planetarydata, 'ANAM'));
  planettype := GetEditValue(ElementBySignature(planetarydata, 'CNAM'));
  orbitdata := ElementBySignature(planetarydata, 'GNAM');
  starid := GetEditValue(ElementByName(orbitdata, 'Star ID'));
  planetid := GetEditValue(ElementByName(orbitdata, 'Primary planet ID'));
  parentid := GetEditValue(ElementByName(orbitdata, 'Planet ID'));
  sl.Add(Format('%s|%s|%s|%s|%s', [
    name, planettype, starid, planetid, parentid
  ]));
end;

function Finalize: integer;
var
  fname: string;
begin
  fname := ProgramPath + 'Edit Scripts\planetIds.txt';
  AddMessage('Saving list to ' + fname);
  sl.SaveToFile(fname);
  sl.Free;
end;

end.
