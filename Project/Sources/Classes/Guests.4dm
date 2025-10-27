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
	// create entity to attach photo to pic field
	$guest:=This:C1470.new()
	$guest.email:=Session:C1714.storage.client.guestInfo.email
	$guest.firstName:=Session:C1714.storage.client.guestInfo.firstName
	$guest.lastName:=Session:C1714.storage.client.guestInfo.lastName
	$guest.phone:=Session:C1714.storage.client.guestInfo.phone
	
exposed Function saveGuestEntity($guest)
	// if guest already in db (by email) just overwrite existing data
	$entSel:=This:C1470.query("email == :1"; $guest.email)
	If ($entSel.first()#Null:C1517)
		$ent:=$entSel.first()
		$ent.firstName:=$guest.firstName
		$ent.lastName:=$guest.lastName
		$ent.phone:=$guest.phone
		$ent.pic:=$guest.pic
		$saved:=$ent.save()
		If ($saved.success=False:C215)
			throw:C1805($saved.status; $saved.statusText)
		End if 
	Else 
		$saved:=$guest.save()
		If ($saved.success=False:C215)
			throw:C1805($saved.status; $saved.statusText)
		End if 
	End if 
	
exposed Function fetchGuestEntity()->$guest : 4D:C1709.Entity
	$guestID:=Session:C1714.storage.client.guestInfo.ID
	$guest:=ds:C1482.Guests.query("ID == :1"; $guestID).first()
	
	
	
	