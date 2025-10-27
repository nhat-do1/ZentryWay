Class extends DataClass

exposed Function queryByName($userInput : Text)->$res : 4D:C1709.EntitySelection
	$res:=This:C1470.query("firstName == :1 OR lastName == :1"; "@"+$userInput+"@").orderBy("lastName")
	
exposed Function getSelectedHostFullName()->$name : Text
	$entSel:=This:C1470.query("ID = :1"; Session:C1714.storage.client.selectedHostID)
	If ($entSel.first()#Null:C1517)
		$host:=$entSel.first()
		$name:=$host.firstName+" "+$host.lastName
	Else 
		$name:="your host"
	End if 