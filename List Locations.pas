unit ListLocations;

procedure ListLocation(loc: IInterface; indent: string;);
var
  name, id, keyword: string;
  locref, keywords, staticrefs: IInterface;
  i: integer;
  keywordsSorted: TStringList;
  hidden: boolean;
begin
	hidden := False;
	id := StringReplace(GetElementEditValues(loc, 'EDID'), 'Location', '', [rfReplaceAll]);
	name := id + ';' + GetElementEditValues(loc, 'FULL') + ';' + IntToStr(FormID(loc)) + ';';
	
	staticrefs := ElementByPath(loc, 'LCSR');
	for i:= 0 to ElementCount(staticrefs) - 1 do 
		if ContainsText(GetElementEditValues(ElementByIndex(staticrefs, i), 'Loc Ref Type'), 'MapMarkerRefType') then
			name := name + 'O';
	name := name + ';';
	keywords := ElementByPath(loc, 'Keywords\KWDA');
	keywordsSorted := TStringList.Create;
	keywordsSorted.Duplicates := dupIgnore; 
	keywordsSorted.CommaText := ',,,,,,,';
	for i:= 0 to ElementCount(keywords) - 1 do begin
		keyword := GetElementEditValues(LinksTo(ElementByIndex(keywords, i)), 'EDID');
		if ContainsText(keyword, 'LocTypeSubRegion') or ContainsText(keyword, 'LocTypeRegion') then
			hidden := True
		else if ContainsText(keyword, 'LocRegion') then
			keywordsSorted[0] := keyword
		else if ContainsText(keyword, 'LocTheme') then	
			keywordsSorted[1] := keyword
		else if ContainsText(keyword, 'LocLootScale') then	
			keywordsSorted[2] := keyword
		else if ContainsText(keyword, 'LocTypeFastTravelDestination') then	
			keywordsSorted[3] := keyword
		else if ContainsText(keyword, 'LocTypeClearable') then	
			keywordsSorted[4] := keyword
		else if ContainsText(keyword, 'LocTypeDungeonMajor') or ContainsText(keyword, 'LocTypeDungeonPOI') then	
			keywordsSorted[6] := keyword
		else if ContainsText(keyword, 'LocTypeDungeon') then	
			keywordsSorted[5] := keyword
		else if ContainsText(keyword, 'DungeonType') then	
			keywordsSorted[7] := keyword
		else
			keywordsSorted.Add(keyword);
	end;
	for i := 0 to Pred(keywordsSorted.Count) do
		name := name + keywordsSorted[i] + ';';
		
	
	if not hidden then
			AddMessage(indent + ';' + name);
	for i := 0 to Pred(ReferencedByCount(loc)) do begin
		locref := ReferencedByIndex(loc, i);
		if Signature(locref) = 'LCTN' then
			if(GetElementNativeValues(locref, 'PNAM')) = FormID(loc) then
				ListLocation(locref, indent + id + '/');
	end;

end;

//function Process(e: IInterface): integer;
//begin
//  if Signature(e) = 'LCTN' then
//	if GetElementEditValues(e, 'PNAM') = '' then
//		ListLocation(e, 0);
//end;

function Initialize: integer;
begin
	AddMessage(' '); AddMessage(' '); AddMessage(' '); AddMessage(' ');
	AddMessage('START-START-START-START-START-START-START-START-START-START-START-START-START-START-START-START-START-START-START-START-START');
	AddMessage('START-START-START-START-START-START-START-START-START-START-START-START-START-START-START-START-START-START-START-START-START');
	AddMessage(' '); AddMessage(' '); AddMessage(' '); AddMessage(' ');

    ListLocation(RecordByFormID(FileByIndex(0), $0001558C, False), '');
end;

end.