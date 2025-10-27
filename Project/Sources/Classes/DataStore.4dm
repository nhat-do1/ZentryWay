Class extends DataStoreImplementation

exposed Function authentify($name : Text; $pw : Text)
	
	var $users : cs:C1710.UsersSelection
	var $user : cs:C1710.UsersEntity
	
	$users:=ds:C1482.Users.query("name = :1"; $name)
	$user:=$users.first()
	
	If ($user#Null:C1517)
		If (Verify password hash:C1534($pw; $user.pw))
			Session:C1714.setPrivileges("client")
			// create object to store current client info
			Use (Session:C1714.storage)
				Session:C1714.storage.client:=New shared object:C1526("language"; "eng")
			End use 
		Else 
			throw:C1805(401; "Credentials do not match.")
		End if 
	Else 
		throw:C1805(401; "User not found.")
	End if 