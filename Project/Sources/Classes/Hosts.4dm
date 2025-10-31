Class extends DataClass

exposed Function queryByName($userInput : Text)->$res : 4D:C1709.EntitySelection
	$res:=This:C1470.query("firstName == :1 OR lastName == :1"; "@"+$userInput+"@").orderBy("lastName")
	
exposed Function getSelectedHostFullName()->$name : Text
	$entSel:=This:C1470.query("ID = :1"; Session:C1714.storage.client.selectedHostID)
	If ($entSel.first()#Null:C1517)
		$host:=$entSel.first()
		$name:=$host.firstName+" "+$host.lastName
	Else 
		$name:="your host"
	End if 
	
exposed Function notifyHost($host : 4D:C1709.Entity)
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
	$param.token:=Session:C1714.storage.client.oauthToken
	
	// instantiate provider
	$oAuth2:=cs:C1710.NetKit.OAuth2Provider.new($param)
	// get new token silently
	$json:=$oAuth2.getToken()
	// update saved token
	$tokenObj:=OB Copy:C1225($json.token; ck shared:K85:29; Session:C1714.storage.client.oauthToken)
	Use (Session:C1714.storage.client)
		Session:C1714.storage.client.oauthToken.token:=$tokenObj
	End use 
	
	// compose email
	$google:=cs:C1710.NetKit.Google.new($oAuth2; {mailType: "JMAP"})
	$email:=New object:C1471
	$email.subject:="[ZentryWay] You have a visitor at the front"
	$email.textBody:="Hi "+$host.firstName+",\n\n"
	$email.textBody+="Your visitor is currently checking in at the front.\n"
	$email.textBody+="Please meet them there and escort them in.\n"
	$email.textBody+="(This is an automated message. No need to reply.)\n"
	$email.from:=$oauthInfo.host_email
	
	If ($host.ID#9)
		// testing
		$email.to:=$oauthInfo.test_email
	Else 
		$email.to:=$host.email
	End if 
	
	$status:=$google.mail.send($email)
	
	If (Not:C34($status.success))
		throw:C1805(500; "Unable to send email")
	Else 
		// save selected host for future use
		Use (Session:C1714.storage.client)
			Session:C1714.storage.client.selectedHostID:=$host.ID
		End use 
	End if 