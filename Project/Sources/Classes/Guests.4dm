Class extends DataClass

exposed Function storeGuestInfo($firstName : Text; $lastName : Text; $phone : Text; $email : Text)
	If (($firstName#"") & ($lastName#""))
		Use (cs:C1710.ClientSession.me)
			cs:C1710.ClientSession.me.guestInfo:=New shared object:C1526("firstName"; $firstName; "lastName"; $lastName; "phone"; $phone; "email"; $email)
		End use 
	Else 
		throw:C1805(400; "First and last name are required.")
	End if 
	
	