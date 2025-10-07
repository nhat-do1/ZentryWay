property language : Text
property oauthToken : Object
property selectedHostID : Integer
property guestInfo : Object

shared singleton Class constructor
	This:C1470.language:="eng"  // default English
	
exposed shared Function setlanguage($language : Text)
	This:C1470.language:=$language
	
exposed Function getLanguage()->$language : Text
	$language:=This:C1470.language
	
exposed Function getDocumentPath()->$path : Text
	$path:="http://127.0.0.1:8089/"
	$language:=cs:C1710.ClientSession.me.language
	
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
	$guest.email:=This:C1470.guestInfo.email
	$guest.firstName:=This:C1470.guestInfo.firstName
	$guest.lastName:=This:C1470.guestInfo.lastName
	$guest.phone:=This:C1470.guestInfo.phone
	
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
	$tokenObj:=OB Copy:C1225($json.token; ck shared:K85:29; This:C1470.oauthToken)
	This:C1470.oauthToken:=New shared object:C1526("token"; $tokenObj)