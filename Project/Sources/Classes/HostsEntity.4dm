Class extends Entity

exposed Function notifyHost()
	var $oAuth2 : cs:C1710.NetKit.OAuth2Provider
	var $google : cs:C1710.NetKit.Google
	
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
	// use saved token to bypass manual sign-in
	$param.token:=cs:C1710.ClientSession.me.oauthToken
	
	// instantiate provider
	$oAuth2:=cs:C1710.NetKit.OAuth2Provider.new($param)
	// get new token silently
	$json:=$oAuth2.getToken()
	// update saved token
	$tokenObj:=OB Copy:C1225($json.token; ck shared:K85:29; cs:C1710.ClientSession.me.oauthToken)
	Use (cs:C1710.ClientSession.me.oauthToken)
		cs:C1710.ClientSession.me.oauthToken:=New shared object:C1526("token"; $tokenObj)
	End use 
	
	// compose email
	$google:=cs:C1710.NetKit.Google.new($oAuth2; {mailType: "JMAP"})
	$email:=New object:C1471
	$email.subject:="[ZentryWay] You have a visitor at the front"
	$email.textBody:="Hi "+This:C1470.firstName+",\n\n"
	$email.textBody+="Your visitor is currently checking in at the front.\n"
	$email.textBody+="Please come there to greet them.\n"
	$email.textBody+="(This is an automated message. No need to reply.)\n"
	$email.from:=$oauthInfo.host_email
	//$email.to:=This.email
	// testing
	If (This:C1470.ID#9)
		$email.to:=$oauthInfo.test_email
	Else 
		$email.to:=$oauthInfo.other_test_email
	End if 
	
	$status:=$google.mail.send($email)
	
	If (Not:C34($status.success))
		throw:C1805(500; "Unable to send email")
	Else 
		// save selected host for future use
		Use (cs:C1710.ClientSession.me)
			cs:C1710.ClientSession.me.selectedHostID:=This:C1470.ID
		End use 
	End if 
	