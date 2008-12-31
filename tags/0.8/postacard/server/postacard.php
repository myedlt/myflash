<?php
    //error_reporting(0); // do not report errors
    set_time_limit(0); // do not time out


    include realpath(dirname(__FILE__)."/util/smtp.php");



    if ( isset($_REQUEST['toEmail']) && isset($_REQUEST['imageData']) )
    {

        sendPostCard( $_REQUEST['toEmail'], $_REQUEST['toName'], $_REQUEST['message'], $_REQUEST['imageData'] );

    }
    else
    {
        returnResponse(false, 'required parameter missing');
    }



    /**
     * Send a PostACard email to the target recipient
     */
    function sendPostCard( $toEmail, $toName, $message, $imageData )
    {
        global $emailTemplateFile, $savedPostcardFolder, $savedPostcardURL, $smtpError, $smtpMessage, $emailFromName, $emailFromAddress;
    
        // save image to fileSystem
        $imageString = base64_decode( $imageData );            
        $image = imagecreatefromstring( $imageString );
    
        $uniqueFileName = "pac_".time().".jpg";
        
        $imagePath = $savedPostcardFolder.$uniqueFileName;
        $imageURL = $savedPostcardURL.$uniqueFileName;
        
        $result = imagejpeg( $image, $imagePath );
        
        if( !result )
            returnResponse( false, "could not save image file" );
            
        
        // send email
        if( !$toName ) $toName = $toEmail;
        

        $subject = "A postcard for ".$toName;
        
        
        $message = str_replace( "&apos;", "&#39;", $message );
        
        $replacements['|pac_message|'] = $message;
        $replacements['|pac_imageurl|'] = $imageURL;
        
        
        sendmail($toEmail, $toName, $emailFromAddress, $emailFromName, $subject, $replacements, $emailTemplateFile );
        
        if( $smtpError )
            returnResponse( false, $smtpMessage );
        else
            returnResponse(true, "email sent successfully" );
        
    }



     /**
      * Return an xml response envelope to the caller
      */
     function returnResponse($success, $message, $data="")
     {
          if( $success )
          {
               echo "<result><success>Y</success><message>".$message."</message><data>".$data."</data></result>";
          }
          else
          {
               echo "<result><success>N</success><message>".$message."</message><data /></result>";
          }
          exit;
     }

?>
