property language : Text
property oauthToken : Object
property selectedHost : Object

shared singleton Class constructor
	This:C1470.language:="eng"  // default English
	
exposed shared Function setlanguage($language : Text)
	This:C1470.language:=$language
	
exposed Function getLanguage()->$language : Text
	$language:=This:C1470.language
	
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
	$tokenObj:=OB Copy:C1225($json.token; ck shared:K85:29)
	This:C1470.oauthToken:=New shared object:C1526("token"; $tokenObj)