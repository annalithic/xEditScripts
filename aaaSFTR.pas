{
  Export list of CELLs
}
unit UserScript;


function Process(e: IInterface): integer;
var
	i, hemiIndex: integer;
	hemi: IInterface;
	name, path: string;
	planet: TwbFastStringList;
begin
	if Signature(e) <> 'SFTR' then
		Exit;
	planet := TwbFastStringList.Create;
	name := EditorID(e);
	hemi := ElementBySignature(e, 'ENAM');
	
	for i := 0 to Pred(ElementCount(hemi)) do begin
		//planet.Add(IntToHex(GetNativeValue(ElementByIndex(hemi, i)), 8));
		planet.Add(EditorID(LinksTo(ElementByIndex(hemi, i))));
	end;
	
	hemiIndex := IndexOf(e, hemi);
	hemi := ElementByIndex(e, hemiIndex + 1);
	for i := 0 to Pred(ElementCount(hemi)) do begin
		//planet.Add(IntToHex(GetNativeValue(ElementByIndex(hemi, i)), 8));
		planet.Add(EditorID(LinksTo(ElementByIndex(hemi, i))));
	end;

	path := ProgramPath + 'Edit Scripts\SFTR\' + name + '.txt';
	AddMessage(path);
	planet.SaveToFile(path);
	planet.Free;
end;

end.
