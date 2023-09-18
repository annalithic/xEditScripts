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


function BranchNode(e: IInterface; indent: integer): integer;
var
  i: integer;
  children, child: IInterface;
  name: string;
begin
  
  if Signature(e) = 'PCBN' then begin
     sl.Add(StringOfChar(' ', indent * 2) + EditorID(e));
    children := ElementByName(e, 'Child Nodes');
	for i := 0 to Pred(ElementCount(children)) do begin
	  child := LinksTo(ElementByIndex(children, i));
      BranchNode(child, indent + 1);
	end;
  end 
  else if Signature(e) = 'PCCN' then begin
    child := LinksTo(ElementBySignature(e, 'PCCC'));
	sl.Add(StringOfChar(' ', indent * 2) + EditorID(child));
  end;
end;


function Process(e: IInterface): integer;
var
  i: integer;
  children, child: IInterface;
  name: string;
begin
  if Signature(e) <> 'PCMT' then
    Exit;

  sl.Add(EditorID(e));

  children := ElementByName(e, 'Child Nodes');
  for i := 0 to Pred(ElementCount(children)) do begin
    child := LinksTo(ElementByIndex(children, i));
    BranchNode(child, 1);
  end;
  
  sl.Add('');

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
