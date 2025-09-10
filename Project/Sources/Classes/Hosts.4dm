Class extends DataClass

exposed Function queryByName($userInput : Text)->$res : 4D:C1709.EntitySelection
	$res:=This:C1470.query("firstName == :1 OR lastName == :1"; "@"+$userInput+"@").orderBy("lastName")
	
exposed Function getSelectedHostFullName()->$name : Text
	$name:=cs:C1710.ClientSession.me.selectedHost.firstName+" "+cs:C1710.ClientSession.me.selectedHost.lastName
	