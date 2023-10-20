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
	i, j, packinIndex: integer;
	layers, layer, objs, obj, packin: IInterface;
	biomeName, layerName, packinName, packInNameWithLayer: string;
	packins, packinLayers, packinLookup: TwbFastStringList;
begin
	if Signature(e) <> 'BIOM' then
		Exit;
	biomeName := EditorID(e);
	layers := ElementByName(e, 'Layers');
	packins := TwbFastStringList.Create;
	packinLayers := TwbFastStringList.Create;
	packinLookup := TwbFastStringList.Create;

	for i := 0 to Pred(ElementCount(layers)) do begin
		//packins.Sorted := True;
		//packins.Duplicates := dupIgnore;

		layer := ElementByIndex(layers, i);
		layerName := GetEditValue(ElementBySignature(layer, 'FNAM'));
		objs := ElementByIndex(layer, 2);
		for j := 0 to Pred(ElementCount(objs)) do begin
			obj := ElementByIndex(objs, j);
			packin := LinksTo(ElementByIndex(obj, 0));
			packinName := GetEditValue(ElementBySignature(packin, 'FLTR'));
			//packinName := GetEditValue(ElementBySignature(packin, 'FLTR')) + EditorID(packin);
			//if Signature(packin) = 'PKIN' then packinName := Copy(packinName, 1, length(packinName) - 2);
			packInNameWithLayer := packinName + layerName;

			if packinLookup.IndexOf(packInNameWithLayer) = -1 then begin
				packinLookup.Add(packInNameWithLayer);
				packinIndex := packins.IndexOf(packinName);
				if packinIndex = -1 then begin
					packins.Add(packinName);
					packinLayers.Add(layerName);
				end else packinLayers[packinIndex] := packinLayers[packinIndex] + ', ' + layerName;
			end;
		end;
	end;
	
	for i := 0 to Pred(packins.Count) do 
	sl.Add(Format('%s|%s|%s', [
		biomeName,
		packins[i],
		packinLayers[i]
	]));
		
	packins.Free;
	packinLayers.Free;
	packinLookup.Free;
end;

function Finalize: integer;
var
	fname: string;
begin
	fname := ProgramPath + 'Edit Scripts\aaaBiome.txt';
	AddMessage('Saving list to ' + fname);
	//sl.SaveToFile(fname);
	sl.Free;
end;

end.


//exotics
//ice
//rocks
//shrubs
//snow
//trees	