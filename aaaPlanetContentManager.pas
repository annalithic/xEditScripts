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

function WriteCondition(e: IInterface): string;
var
  operator: IInterface;
  comp, bool, param: string;
begin

	operator := GetNativeValue(ElementByName(e, 'Type'));
	if operator and 1 <> 0 then bool := 'OR' else bool := 'AND';

	operator := operator and $F0;
	if operator = $00 then comp := '=='
	else if operator = $20 then comp := '!='
	else if operator = $40 then comp := '>'
	else if operator = $60 then comp := '>='
	else if operator = $80 then comp := '<'
	else if operator = $A0 then comp := '<=';

	param := GetEditValue(ElementByIndex(e, 5));
	if param = '00 00 00 00' then param := '';

	Result := '"' +
		GetEditValue(ElementByName(e, 'Run On')) + '.' +
		GetEditValue(ElementByName(e, 'Function')) + '(' +
		param + ') ' +
		comp + ' ' +
		GetEditValue(ElementByName(e, 'Comparison Value')) + 
		'"'
	;
end;

function BranchNode(e: IInterface; indent: integer): integer;
var
  i: integer;
  children, child, conditions, condition, location: IInterface;
  name, world: string;
begin
  
  if (Signature(e) = 'PCBN') or (Signature(e) = 'PCMT') then begin
    name := StringOfChar(' ', indent * 2) + EditorID(e);
	
	conditions := ElementByName(e, 'Conditions');
	for i := 0 to Pred(ElementCount(conditions)) do begin
	  condition := ElementBySignature(ElementByIndex(conditions, i), 'CTDA');
	  name := name + ' ' + WriteCondition(condition);
	end;

	sl.Add(name);
	 
    children := ElementByName(e, 'Child Nodes');
	for i := 0 to Pred(ElementCount(children)) do begin
	  child := LinksTo(ElementByIndex(children, i));
      BranchNode(child, indent + 1);
	end;
	
	
  end 
  else if Signature(e) = 'PCCN' then begin
    child := LinksTo(ElementBySignature(e, 'PCCC'));
	world := StringOfChar(' ', indent * 2) + EditorID(child);
	
	if Signature(child) = 'WRLD' then begin
	  location := LinksTo(ElementBySignature(child, 'XLCN'));
	  world := world + ' "' +  
	  GetEditValue(ElementBySignature(location, 'FULL')) + '"'
	  ;

	end;
	sl.Add(world);
  end;
end;


function Process(e: IInterface): integer;
begin
  BranchNode(e, 0);
end;

function Finalize: integer;
var
  fname: string;
begin
  fname := ProgramPath + 'Edit Scripts\planetcontent.txt';
  AddMessage('Saving list to ' + fname);
  sl.SaveToFile(fname);
  sl.Free;
end;

end.
