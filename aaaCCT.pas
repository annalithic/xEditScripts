unit UserScript;

var
	sl: TStringList;
	prefixRules, suffixRules1, suffixRules2, cctlld: IInterface; 

function Initialize: integer;
begin
	sl := TStringList.Create;
	prefixRules := ElementByName(ElementByIndex(ElementByName(RecordByFormID(FileByIndex(0), $00220394, False), 'Naming Rules'), 0), 'Names');
	suffixRules1 := ElementByName(ElementByIndex(ElementByName(RecordByFormID(FileByIndex(0), $003E8650, False), 'Naming Rules'), 0), 'Names');
	suffixRules2 := ElementByName(ElementByIndex(ElementByName(RecordByFormID(FileByIndex(0), $003E8650, False), 'Naming Rules'), 1), 'Names');
	cctlld := ElementByName(RecordByFormID(FileByIndex(0), $00074272, False), 'Leveled List Entries');
end;

function ApplyConditions(conditions: IInterface; avifs: TList): Boolean;
var
	i, searchval, operator: integer;
	res, currentOr, currentTrue: Boolean;
	ctda, avif: IInterface;
begin
	res := True;
	for i := 0 to Pred(ElementCount(conditions)) do begin

		ctda := ElementBySignature(ElementByIndex(conditions, i), 'CTDA');
		
		operator := GetNativeValue(ElementByName(ctda, 'Type'));
		if operator and 1 <> 0 then currentOr := True
		else currentOr := False;
		
		if GetEditValue(ElementByName(ctda, 'Function')) = 'GetValue' then begin
			avif := GetNativeValue(ElementByName(ctda, 'Actor Value'));
			searchval := avifs.IndexOf(avif);
			if searchval <> -1 then currentTrue := True; 
		end else if GetEditValue(ElementByName(ctda, 'Function')) = 'IsTrueForConditionForm' then begin
			currentTrue := ApplyConditions(ElementByName(LinksTo(ElementByName(ctda, 'Condition Form')), 'Conditions'), avifs);
		end;
		
		if not currentOr then begin
			if not currentTrue then begin
				Result := False;
				Exit;
			end;
			currentTrue := False;
		end;

		
	end;
	
	if not currentTrue then begin
		Result := False;
		Exit;
	end;
	
	Result := True;
end;

function ApplyRuleset(rules: IInterface; keywords: TList): string;
var
	i, j, nameIndex: integer;
	rule, ruleKeywords: IInterface;
	applies: boolean;
	name: string;
begin
	for i := 0 to Pred(ElementCount(rules)) do begin
		rule := ElementByIndex(rules, i);
		if GetNativeValue(ElementBySignature(rule, 'YNAM')) > nameIndex then begin
			applies := True;
			ruleKeywords := ElementByPath(rule, 'Keywords\KWDA');
			for j := 0 to Pred(ElementCount(ruleKeywords)) do begin
				if keywords.IndexOf(GetNativeValue(ElementByIndex(ruleKeywords, j))) = -1 then applies := False;
			end;
			if applies then begin
				name := GetEditValue(ElementBySignature(rule, 'WNAM'));
				nameIndex := GetNativeValue(ElementBySignature(rule, 'YNAM'));
			end;
		end;

	end;
	Result := name;
end;


function ProcessCreature(e: IInterface; biomes: string): integer;
var
	i, j, prefixIndex: integer;
	attachPoint, keyword: cardinal;
	templates, omods, omod, properties, omodproperty, lvliconditions, ctda: IInterface;
	name, scannerTemperament, scannerHarvest, scannerDomesticate,
	diet, biomeFaction, temperament, organicResource, resourceType, skin, schedule, size, 
	challenge, combatstyle, enviro1, enviro2, enviro3, extramods, prefix, fullname, suffix1, suffix2, resource: string;
	keywords, avifs: TList;
	isCCT, currentCondition: Boolean;
begin
	if Signature(e) <> 'NPC_' then
		Exit;

	
	keywords := TList.Create;
	avifs := TList.Create;
	isCCT := False;
	for i := 0 to Pred(ElementCount(ElementByPath(e, 'Keywords\KWDA'))) do begin
		keywords.Add(GetNativeValue(ElementByIndex(ElementByPath(e, 'Keywords\KWDA'), i)));
		if keywords[i] = $002AD3EC then isCCT := True;
	end;
	
		
	templates := ElementByIndex(ElementByName(e, 'Object Template'), 0);
	if (ElementCount(templates) = 2) and isCCT then begin
		omods := ElementByName(ElementBySignature(ElementByIndex(ElementByIndex(templates, 1), 0), 'OBTS'), 'Includes');
		for i := 0 to Pred(ElementCount(omods)) do begin
			omod := LinksTo(ElementByName(ElementByIndex(omods, i), 'Mod'));
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
				if GetEditValue(ElementByName(omodproperty, 'Property Name')) = 'NPC - Keyword' then
					keywords.Add(GetNativeValue(ElementByName(omodproperty, 'Value 1 - FormID')))
				else if GetEditValue(ElementByName(omodproperty, 'Property Name')) = 'NPC - Actor Value' then
					avifs.Add(GetNativeValue(ElementByName(omodproperty, 'Value 1 - FormID')));
			end;
		end;
		
		for i := 0 to Pred(ElementCount(cctlld)) do begin
			lvliconditions := ElementByName(ElementByIndex(cctlld, i), 'Conditions');
			currentCondition := ApplyConditions(lvliconditions, avifs);
			if currentCondition then begin
				resource := resource + GetEditValue(ElementBySignature(LinksTo(ElementByPath(ElementByIndex(cctlld, i), 'LVLO\Reference')), 'FULL'));
			end;
		end;
		
		//for i := 0 to Pred(avifs.Count) do begin
		//	sl.Add(EditorID(RecordByFormID(FileByIndex(0), avifs[i], False)));
		//end;
		
		for i := 0 to Pred(keywords.Count) do begin
			keyword := keywords[i];
			if keyword = $001699AB then scannerTemperament := 'Aggressive'
			else if keyword = $00280174 then scannerTemperament := 'Wary'
			else if keyword = $00280175 then scannerTemperament := 'Fearless'
			else if keyword = $00169995 then scannerTemperament := 'Skittish'
			else if keyword = $001699A3 then scannerTemperament := 'Territorial'
			else if keyword = $00280177 then scannerTemperament := 'Defensive'
			else if keyword = $001699A1 then scannerTemperament := 'Peaceful'
			else if keyword = $002634BC then scannerHarvest := 'Non-lethal harvest'
			else if keyword = $002AC11D then scannerDomesticate := 'Outpost production allowed';
		end;
		
		prefix := ApplyRuleset(prefixRules, keywords);
		if length(prefix) > 0 then name := prefix + ' ';
		
		fullname := GetEditValue(ElementBySignature(e, 'FULL'));
		if length(fullname) > 0 then name := name + fullname + ' ';

		suffix1 := ApplyRuleset(suffixRules1, keywords);		
		if length(suffix1) > 0 then name := name + suffix1;


		suffix2 := ApplyRuleset(suffixRules2, keywords);		
		if length(suffix2) > 0 then name :=name + ' ' + suffix2;

		
		sl.Add(Format('%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s|%s', [
			IntToHex(FixedFormID(e), 8),
			EditorID(e),
			name,
			biomes,
			scannerTemperament,
			resource,
			scannerHarvest,
			scannerDomesticate,
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
		
		keywords.Free;
		avifs.Free;
	end;
end;

function Process(e: IInterface): integer;
var
  i, p, searchval: integer;
  components, component, biomes, perbiome, creature: IInterface;
  name, biomename, tempBiomeList: string;
  biomeList: TStringList;
  dictCreatures, dictBiomes: TList;
begin
  if Signature(e) <> 'PNDT' then
    Exit;
	dictCreatures := TList.Create;
	biomeList := TStringList.Create;
	
	components := ElementByIndex(e, 2);
	for i := 0 to Pred(ElementCount(components)) do begin
		component := ElementByIndex(components, i);
		if GetEditValue(ElementBySignature(component, 'BFCB')) = 'TESFullName_Component' then
			name := GetEditValue(ElementByIndex(ElementByIndex(component, 1), 0));
	end;
	biomes := ElementByIndex(e, 4);
	for i := 0 to Pred(ElementCount(biomes)) do begin
		perbiome := ElementByIndex(biomes, i);
		biomename :=  GetEditValue(ElementBySignature(LinksTo(ElementByIndex(perbiome, 0)), 'FULL'));
		for p := 0 to Pred(ElementCount(ElementByName(perbiome, 'Fauna'))) do begin
			creature := GetNativeValue(ElementByIndex(ElementByIndex(ElementByName(perbiome, 'Fauna'), p), 0));
			searchval := dictCreatures.IndexOf(creature);
			if searchval = -1 then begin
				dictCreatures.Add(creature);
				biomeList.Add(name + '|' + biomename);
			end else begin
				tempBiomeList := biomeList[searchval];
				tempBiomeList := tempBiomeList  + ', ' + biomename;
				biomeList[searchval] := tempBiomeList;
			end;
		end;
	end;
	
	for i := 0 to Pred(dictCreatures.Count) do begin
		creature := RecordByFormID(FileByIndex(0), dictCreatures[i], False);
		ProcessCreature(creature, biomeList[i]);
	end
	
	dictCreatures.Free;
	biomeList.Free;
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
