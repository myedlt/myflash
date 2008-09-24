<?php

/*
=============================================================
SMTP mailer.

Extracts an array of keys/values from a HTTP request string
Keys are tags that correspond to tags in an html document
template that are to be replaced with the corresponding value
eg.
"|lastname|" => "Smith"
will replace the occurence of "|lastname|" (in the template)
with "Smith".

The script then opens a connection and mails the document
to the recipient.

The script currently checks at each stage of the SMTP
transaction for errors, but does not do anything about
them yet.
=============================================================
*/



include realpath(dirname(__FILE__)."/../setup.php");

/*==============================================
sendmail() - send an email
Parameters:
$to - 		the email address of the recipient
$toname - 	the name of the recipient (may be empty)
$from - 	the email address of the sender
$fromname - 	the name of the sender
$subject - 	the email subject
$message - 	an array of key-value pairs generated
		by parseMessageTokens()
$template - the html template for the email

(the keys in $message should match the tags in
$template so that the tags are replaced with
the appropriate values)
================================================*/

$smtpError = false;
$smtpMessage = "";


function sendmail($to, $toname, $from, $fromname, $subject, $message, $template)
{
	global $useAuth, $smtpServer, $port, $timeout, $smtpAuthUsername, $smtpAuthPassword, $localhost;

	$templatestring = file_get_contents($template);

	if($templatestring === FALSE)
	{
		setError("email template file not found");
		return;
	}

	foreach($message as $token => $replacewith)
	{
		// if a user sticks a $key in a $value string, this will screw up
		$exploded = explode($token, $templatestring);
		$templatestring = implode($replacewith,$exploded);
	}

	$conn = fsockopen($smtpServer, $port, $errno, $errstr, $timeout);


	if(empty($conn))
	{
		setError("Failed to connect: $smtpResponse");
		return;
	}

    	$status = getResponse($conn);
	if(checkStatus($status)){//CONNECTION ESTABLISHMENT


		//Mail Creation: issue EHLO to server and create a new email to send
		sendLine($conn,"EHLO $localhost",false);
		$status = getResponse($conn);
		if(checkStatus($status)){//EHLO
			//Authentication: send user name and password if authentication is
			//enabled, otherwise skip AUTH
			if($useAuth){
				sendLine($conn,"AUTH LOGIN",false);
				$status = getResponse($conn);
				if(checkStatus($status)){//AUTH LOGIN
					sendLine($conn,base64_encode($smtpAuthUsername),false);
					$status = getResponse($conn);
					if(checkStatus($status)){//username
						sendLine($conn,base64_encode($smtpAuthPassword),false);
						$status = getResponse($conn);
						if(!checkStatus($status)){//password
							setError("SMTP authorization failed");
							return; //quit if AUTH fails.
						}
					}else{setError("SMTP authorization failed after username"); return;}
				}else{setError("SMTP authorization failed after AUTH LOGIN"); return;}
			}


			sendLine($conn,"MAIL FROM: $from", false);
			$status = getResponse($conn);
			if(checkStatus($status)){//MAIL FROM:
				sendLine($conn,"RCPT TO: $to",false);
				$status = getResponse($conn);
				if(checkStatus($status)){//RCPT TO:
					sendLine($conn,"DATA",false);
					$status = getResponse($conn);
					if($status == 354){//DATA
						writeEmail($conn, $to, $toname, $from, $fromname, $subject,$templatestring);
						$status = getResponse($conn);
						if(checkStatus($status)){//MESSAGE DATA
							sendLine($conn,"QUIT",false);
							//$status = getResponse($conn);
							//if(checkStatus($status)){
								setMessage("email sent to: ".$to);
							//}
						}else{setError("SMTP connection failed after data send");}//MESSAGE DATA
					}else{setError("SMTP connection failed after DATA");}//DATA
				}else{setError("SMTP connection failed after RCPT TO");}//RCPT TO:
			}else{setError("SMTP connection failed after MAIL FROM");} //MAIL FROM:
		}else{setError("SMTP connection failed after EHLO");}//EHLO
	}else{setError("SMTP connection failed after connection establish");}//CONNECTION ESTABLISHMENT
	return;
}

function writeEmail($connection, $to, $toname, $from, $fromname, $subject, $content)
{
	global $newLine, $appName, $orgName, $mimeVer, $contentType ,$charset ,$ctEncoding;
	sendLine($connection,("Date: ".date("r")),false);
	sendLine($connection,("To: ".$toname." <".$to.">"),false);
	sendLine($connection,("From: ".$fromname." <".$from.">"),false);
	sendLine($connection,("Subject: ".$subject),false);
	sendLine($connection,("Reply-to: ".$from),false);

	sendLine($connection,("X-Mailer: ".$appName),false);
	sendLine($connection,("Organization: ".$orgName),false);
	sendLine($connection,("MIME-version: ".$mimeVer),false);
	sendLine($connection,("Content-Type: ".$contentType.$newLine."     charset=".$charset),false);
	sendLine($connection,("Content-Transfer-Encoding: ".$ctEncoding),false);

	$lines = explode($newLine,$content);

	foreach($lines as $line)
	{
		//this branch is to protect the '.' character if on a line by itself
		//otherwise this character would signal the end of the message
		if($line == ".")
		{
			sendLine($connection,"..",true);
		}
		else
		{
			sendLine($connection,$line,true);
		}
	}
	//end the email with a '.' on a line by itself
	sendLine($connection,$newLine.".",false);
}

function getResponse($connection)
{
	$read = array($connection);
	$resultline = fgets($connection, 4096);
	while(true)
	{


		if (false === ($num_changed_streams = stream_select($read, $write = NULL, $except = NULL, 0,500000)))
		{
			break;
		}
		elseif ($num_changed_streams > 0)
		{
			$resultline = fgets($connection, 4096);
		}
		else
		{
			break;
		}
	}
	//echo $resultline;
	//echo("status returned: |".substr($resultline,0,3)."| \n");
	return substr($resultline,0,3);
}

function checkStatus($statuscode)
{
	$majorclass = (int) ($statuscode / 100);
	//echo("\ncode: ".$majorclass."\n");
	switch($majorclass)
	{
		case(2): {return true;}
		case(3): {return true;}
		case(4): {return false;}
		case(5): {return false;}
		default: {return false;}
	}
}

function sendLine($connection, $line, $silent)
{
	global $newLine;
	//echo($line.$newLine);
	fputs($connection, $line.$newLine);
	if($silent)
	{
		//echo($line.$newLine);
	}
}

function parseMessageTokens($msg)
{
	global $pairSeparator, $keyValueSeparator;

	$msg = urldecode($msg);

	$replacements = array();

	$msgarr = explode($pairSeparator, $msg);
	foreach($msgarr as $pair)
	{
		$x = strpos($pair,$keyValueSeparator);
		$replacements[substr($pair,0,$x)] = substr($pair,($x + strlen($keyValueSeparator)));
	}
	return $replacements;
}

function setError($message)
{
	global $smtpError, $smtpMessage;

	$smtpError = true;
	$smtpMessage = $message;
}

function setMessage($message)
{
	global $smtpError, $smtpMessage;

	$smtpError = false;
	$smtpMessage = $message;
}

?>
