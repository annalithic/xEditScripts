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
	rnamIndex, i, j, k, packinIndex, a, p, r, t: integer;
	o: float;
	layers, layer, objs, obj, packin, values: IInterface;
	biomeName, layerName, packinName, objectDesc: string;
	packins, packinLayers, packinLookup: TwbFastStringList;
begin
	if Signature(e) <> 'BIOM' then
		Exit;
	biomeName := EditorID(e);
	layers := ElementByIndex(e, IndexOf(e, ElementBySignature(e, 'RNAM')) + 1);

	for i := 0 to Pred(ElementCount(layers)) do begin
		layer := ElementByIndex(layers, i);
		layerName := GetEditValue(ElementBySignature(layer, 'FNAM'));
		objs := ElementByIndex(layer, 2);
		
		for j := 0 to Pred(ElementCount(objs)) do begin
			obj := ElementByIndex(objs, j);
			packin := LinksTo(ElementByIndex(obj, 0));
			//packinName := GetEditValue(ElementBySignature(packin, 'FLTR'));
			
			packinName := GetEditValue(ElementBySignature(packin, 'FLTR')) + EditorID(packin);
			//if Signature(packin) = 'PKIN' then packinName := Copy(packinName, 1, length(packinName) - 2);
			
			a := GetNativeValue(ElementByName(obj, 'a'));
			o := GetNativeValue(ElementByName(obj, 'o'));
			p := GetNativeValue(ElementByName(obj, 'p'));
			r := GetNativeValue(ElementByName(obj, 'r'));
			t := GetNativeValue(ElementByName(obj, 't'));

			
			
			objectDesc := Format('%s|%s|%s|%d|%f|%d|%d|%d', [
				biomeName,
				layerName,
				packinName,
				a,
				o,
				p,
				r,
				t
			]);
			
			//objectDesc := biomeName + '|' + layerName + '|' + packinName;
			
			//values := ElementByIndex(obj, 1);
			//for k := 0 to Pred(ElementCount(values)) do begin
				//objectDesc := objectDesc + '|' + GetEditValue(ElementByIndex(values, k));
			//end;
			sl.Add(objectDesc);			
		end;
	end;

end;

function Finalize: integer;
var
	fname: string;
begin
	fname := ProgramPath + 'Edit Scripts\aaaBiomeValues.txt';
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