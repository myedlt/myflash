<?php

if(!defined("SETUP"))
{
     define("SETUP","setup");


     //----------------------------------------------
     // SMTP options
     //----------------------------------------------

     //connection options
     $smtpServer = "SMTP SERVER"; // often localhost
     $port = "25";
     $timeout = "30";
     $useAuth = true;
     $smtpAuthUsername = "Email account"; // if server does not require authentication
     $smtpAuthPassword = "Emaill password"; // then set $userAuth = false
     $localhost = "server";

     //mail header options
     $newLine = "\r\n";
     $appName = "PostACard";
     $orgName = "www.munkiihouse.com";
     $mimeVer = "1.0";
     $contentType = "text/html;"; //semi-colon-terminated line
     $charset = "\"us-ascii\"";  //double-quoted line
     $ctEncoding = "7bit"; //default content-transfer-encoding is 7bit (do not change)

     //POST string options (for replacements array)
     $pairSeparator = "-"; //separates a key-value pair from another key-value pair
     $keyValueSeparator = ":"; //separates a key from a value
     $httpColDelim = ":";
     $httpRowDelim = "-";
     $httpTokenDelim = "|";


     $emailTemplateFile = realpath(dirname(__FILE__)."/template/emailtemplate.html");
     
     $emailFromName = "PostACard";
     $emailFromAddress = "postacard@munkiihouse.com";
     

     $savedPostcardFolder = realpath(dirname(__FILE__))."/postcards/"; // location to save image
     $savedPostcardURL = "http:// URL TO THE ABOVE FOLDER";
}
?>
