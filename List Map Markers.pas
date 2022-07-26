unit ListMapMarkers;

function Initialize: integer;
var
  MapMarkerStat, e, markerParent, flags: IInterface;
  i, j: integer;
  s, flagStr, loc: string;
begin
    MapMarkerStat := RecordByFormID(FileByIndex(0), $00000010, False);
    for i := 0 to Pred(ReferencedByCount(MapMarkerStat)) do begin
		e := ReferencedByIndex(MapMarkerStat, i);
		if Signature(e) = 'REFR' then begin
			s := GetElementEditValues(e, 'Map Marker\FULL');
			if GetElementNativeValues(e, 'Map Marker\FNAM') and 8 > 0 then
				for i := 0 to Pred(ReferencedByCount(e)) do begin
					markerParent := ReferencedByIndex(e, i);
					if Signature(markerParent) = 'LCTN' then begin
						s := GetElementEditValues(markerParent, 'FULL');
						Break;
					end;
				end;

			//if GetIsInitiallyDisabled(e) then
			//	s := s + ' (DISABLED)';
			if IntToHex(FormID(LinksTo(ElementByName(LinksTo(ElementByName(e, 'Cell')), 'Worldspace'))), 6) = '25DA15' then
				if s <> '' then
					AddMessage(IntToHex(FixedFormID(e), 6) + ' ' + s);
		end;
	end;
end;

end.