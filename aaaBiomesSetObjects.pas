{
  Export list of CELLs
}
unit UserScript;

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
			packin := ElementByIndex(obj, 0);
			SetNativeValue(packin, $02000805);
			//packinName := GetEditValue(ElementBySignature(packin, 'FLTR'));
			
			
			//objectDesc := biomeName + '|' + layerName + '|' + packinName;
			
			//values := ElementByIndex(obj, 1);
			//for k := 0 to Pred(ElementCount(values)) do begin
				//objectDesc := objectDesc + '|' + GetEditValue(ElementByIndex(values, k));
			//end;
		end;
	end;

end;

end.


//exotics
//ice
//rocks
//shrubs
//snow
//trees	