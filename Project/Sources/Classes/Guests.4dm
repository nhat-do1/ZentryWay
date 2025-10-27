Class extends DataClass

exposed Function storeGuestInfo($firstName : Text; $lastName : Text; $phone : Text; $email : Text)
	If (($firstName#"") & ($lastName#""))
		Use (Session:C1714.storage.client)
			Session:C1714.storage.client.guestInfo:=New shared object:C1526("firstName"; $firstName; "lastName"; $lastName; "phone"; $phone; "email"; $email)
		End use 
	Else 
		throw:C1805(400; "First and last name are required.")
	End if 
	
exposed Function createGuestEntity()->$guest : 4D:C1709.Entity
	$guest:=This:C1470.new()
	$guest.email:=Session:C1714.storage.client.guestInfo.email
	$guest.firstName:=Session:C1714.storage.client.guestInfo.firstName
	$guest.lastName:=Session:C1714.storage.client.guestInfo.lastName
	$guest.phone:=Session:C1714.storage.client.guestInfo.phone