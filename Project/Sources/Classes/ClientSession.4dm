shared singleton Class constructor
	
exposed shared Function setlanguage($language : Text)
	Use (Session:C1714.storage.client)
		Session:C1714.storage.client.language:=$language
	End use 
	
exposed Function getLanguage()->$language : Text
	$language:=Session:C1714.storage.client.language
	
exposed Function getDocumentPath()->$path : Text
	$path:="http://127.0.0.1:8089/"
	$language:=Session:C1714.storage.client.language
	
	Case of 
		: ($language="eng")
			$path+="visitor_nda_eng.pdf"
			
		: ($language="esp")
			$path+="visitor_nda_esp.pdf"
			
		Else 
			$path+="visitor_nda_eng.pdf"
			
	End case 
	
exposed Function createGuestEntity()->$guest : 4D:C1709.Entity
	$guest:=ds:C1482.Guests.new()
	$guest.email:=Session:C1714.storage.client.guestInfo.email
	$guest.firstName:=Session:C1714.storage.client.guestInfo.firstName
	$guest.lastName:=Session:C1714.storage.client.guestInfo.lastName
	$guest.phone:=Session:C1714.storage.client.guestInfo.phone
	
exposed shared Function signInOauth2
	var $oAuth2 : cs:C1710.NetKit.OAuth2Provider
	
	// build auth info obj
	$param:=New object:C1471()
	$param.name:="Google"
	$param.permission:="signedIn"
	$param.accessType:="offline"
	$param.redirectURI:="http://127.0.0.1:50993/authorize/"
	$param.scope:="https://www.googleapis.com/auth/gmail.send"
	$param.authenticationPage:=Folder:C1567(fk web root folder:K87:15).file("authentication.htm")
	$param.authenticationErrorPage:=Folder:C1567(fk web root folder:K87:15).file("error.htm")
	$oauthInfo:=getOauthInfo
	$param.clientId:=$oauthInfo.client_id
	$param.clientSecret:=$oauthInfo.client_secret
	
	// instantiate provider
	$oAuth2:=cs:C1710.NetKit.OAuth2Provider.new($param)
	// retrieve & save token for subsequent requests to Google
	// initial one-time maunual Gmail sign-in is manadatory
	$json:=$oAuth2.getToken()
	$tokenObj:=OB Copy:C1225($json.token; ck shared:K85:29; Session:C1714.storage.client.oauthToken)
	Use (Session:C1714.storage.client)
		Session:C1714.storage.client.oauthToken:=New shared object:C1526("token"; $tokenObj)
	End use 
	