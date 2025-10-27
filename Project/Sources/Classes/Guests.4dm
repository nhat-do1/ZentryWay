Class extends DataClass

exposed Function storeGuestInfo($firstName : Text; $lastName : Text; $phone : Text; $email : Text)
	If (($firstName#"") & ($lastName#""))
		Use (Session:C1714.storage.client)
			Session:C1714.storage.client.guestInfo:=New shared object:C1526("firstName"; $firstName; "lastName"; $lastName; "phone"; $phone; "email"; $email)
		End use 
	Else 
		throw:C1805(400; "First and last name are required.")
	End if 
	
	