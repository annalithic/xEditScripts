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
	attachPoint: cardinal;
	templates, template, mods, omod, properties, omodproperty, keyword: IInterface;
	name, diet, biomeFaction, temperament, organicResource, resourceType, skin, schedule, size,
	challenge, combatstyle, enviro1, enviro2, enviro3, extramods: string;
	keywords: TList;
begin
	if Signature(e) <> 'NPC_' then
		Exit;
		
	keywords := TList.Create;
		
	templates := ElementByIndex(ElementByName(e, 'Object Template'), 0);
	if ElementCount(templates) = 2 then begin
		template := ElementBySignature(ElementByIndex(ElementByIndex(templates, 1), 0), 'OBTS');
		mods := ElementByName(template, 'Includes');
		name := EditorID(e);
		for i := 0 to Pred(ElementCount(mods)) do begin
			omod := LinksTo(ElementByName(ElementByIndex(mods, i), 'Mod'));
			attachPoint := GetNativeValue(ElementByPath(omod, 'DATA\Attach Point'));
			if attachPoint = $002AD3E8 then diet := EditorID(omod)
			else if attachPoint = $002AD3E9 then biomeFaction := EditorID(omod)
			else if attachPoint = $0023CB01 then temperament := EditorID(omod)
			else if attachPoint = $0023AF14 then organicResource := EditorID(omod)
			else if attachPoint = $0023AF12 then resourceType := EditorID(omod)
			else if attachPoint = $002AD3EB then skin := EditorID(omod)
			else if attachPoint = $0020AA13 then schedule := EditorID(omod)
			else if attachPoint = $002AD3EA then size := EditorID(omod)
			
			else if attachPoint = $001C5212 then challenge := EditorID(omod)
			else if attachPoint = $001D9CF8 then combatstyle := EditorID(omod)
			else if attachPoint = $0020AA16 then enviro1 := EditorID(omod)
			else if attachPoint = $0020AA15 then enviro2 := EditorID(omod)
			else if attachPoint = $0020AA14 then enviro3 := EditorID(omod)
			else extramods := extramods + EditorID(omod)  + '|';
			
			properties := ElementByPath(omod, 'DATA\Properties');
			for j := 0 to Pred(ElementCount(properties)) do begin
				omodproperty := ElementByIndex(properties, j);
				if GetEditValue(ElementByName(omodproperty, 'Property Name')) = 'NPC - Keyword' then begin
					keywords.Add(GetNativeValue(ElementByName(omodproperty, 'Value 1 - FormID')));
				end;
			end;
		end;
		
		//for i := 0 to Pred(keywords.Count) do begin
		//	keyword := RecordByFormID(FileByIndex(0), keywords[i], False);
		//	sl.Add(EditorID(keyword));
		//end;
		
		sl.Add(Format('%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s', [
				name,
				diet,
				biomeFaction,
				temperament,
				organicResource,
				resourceType,
				skin,
				schedule,
				size,
				challenge,
				combatstyle,
				enviro1,
				enviro2,
				enviro3,
				extramods
		]));
	end;
end;

function Finalize: integer;
var
	fname: string;
begin
	fname := ProgramPath + 'Edit Scripts\aaaCCT.txt';
	AddMessage('Saving list to ' + fname);
	sl.SaveToFile(fname);
	sl.Free;
end;

end.
