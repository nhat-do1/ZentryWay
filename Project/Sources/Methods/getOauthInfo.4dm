//%attributes = {}
#DECLARE()->$info : Object

$file:="oauth.json"
If (Test path name:C476($file)=Is a document:K24:1)
	$text:=Document to text:C1236($file)
	$info:=JSON Parse:C1218($text)
Else 
	throw:C1805(500; "Unable to find auth")
End if 