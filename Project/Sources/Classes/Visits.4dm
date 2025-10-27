Class extends DataClass

exposed Function createVisit
	$ent:=This:C1470.new()
	$ent.date:=Current date:C33
	$ent.checkin:=Current time:C178
	//  link guest by ID
	$guestEmail:=Session:C1714.storage.client.guestInfo.email
	$guest:=ds:C1482.Guests.query("email == :1"; $guestEmail).first()
	$ent.guestID:=$guest.ID
	// link host by ID
	$ent.hostID:=Session:C1714.storage.client.selectedHostID
	$saved:=$ent.save()
	If ($saved.success=False:C215)
		throw:C1805($saved.status; $saved.statusText)
	End if 
	
exposed Function searchPriorVisit($email)
	$entSel:=ds:C1482.Guests.query("email == :1"; $email)
	If ($entSel.length>0)
		$guest:=$entSel.first()
		Use (Session:C1714.storage.client)
			Session:C1714.storage.client.guestInfo:=New shared object:C1526("ID"; $guest.ID)
		End use 
	Else 
		throw:C1805(403; "Email not found.")
	End if 
	
exposed Function fetchLastHostOfGuest()->$host : 4D:C1709.Entity
	$entSel:=ds:C1482.Visits.query("guestID == :1"; Session:C1714.storage.client.guestInfo.ID)
	$lastVisit:=$entSel.last()
	$host:=$lastVisit.contact