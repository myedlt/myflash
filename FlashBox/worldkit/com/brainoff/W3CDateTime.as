/*
   W3CDateTime.as

   Mike Chambers
   mesh@macromedia.com

   Represents a date in the W3CDateTime format as described in

http://www.w3.org/TR/NOTE-datetime

version .60

Known Issues:
-The class does not support decimal seconds. Any decimal seconds
specificed in a W3CDateTime string will be lost / removed.

TODO:
-Look at optimize parsing code
-Extensive Testing
-Look into supporting decimal seconds

Thanks to:
Tatsuo Kato, Peter Hall and Gary Grossman for help with determining the
UTC offsets.
 */

/*Extends the Date object*/
class com.brainoff.W3CDateTime extends Date
{

    /*
       Constructor. Optionally takes a WC3DateTime string that the instance
       will represent.

       Otherwise, it represents the time that the instance was created.
     */
    public function W3CDateTime(dateString:String)
    {
        if(dateString != undefined)
        {
            setDateTimeString(dateString);
        }
    }

    /*
       Takes a W3CDateTime formatted string and sets the instance to represent
       the date and time represented in that string
     */
    public function setDateTimeString(dateString:String):Void
    {
        //this.dateString = dateString;
        setTime(W3CDateTime.parseString(dateString).getTime());		
    }

    /*
       Returns a W3CDateTime formatted string that represents the date represented
       by the current instance.

       Takes 4 optional arguments which specifies the format of the string:

incMonth : Whether the month should be included.

incDay : Whether the day of the month should be included. 

incHours : Whether the hours and minutes should be included.

incSeconds : Whether the seconds should be included.

Note, that all output will be a valid W3CDataTime item.
     */
    public function getDateTimeString(incMonth:Boolean,
            incDay:Boolean,
            incHours:Boolean,
            incSeconds:Boolean):String
    {
        return W3CDateTime.parseDate(this, incMonth, incDay, incHours, incSeconds);
    }    

    /*
       Returns the full W3CDateTime string represented by the instance.
     */
    public function toString(Void):String
    {
        return getDateTimeString(true, true, true, true);		
    }	

    /*
       Returns the Year the W3CDateTime represents in the following format:
       YYYY
     */
    public function getW3CYear(Void):String
    {
        return getFullYear().toString();
    }

    /*
       Returns the Month the W3CDateTime represents in the following format:
       MM

       where 1 = January
     */
    public function getW3CMonth(Void):String
    {
        return (getMonth() + 1).toString();
    }

    /*
       Returns the day of the month the W3CDateTime represents in the
       following format:
       dd
     */	
    public function getW3CDate(Void):String
    {
        return getDate().toString();
    }

    /*
       Returns the hour the W3CDateTime represents in the
       following format:
       hh		
     */
    public function getW3CHours(Void):String
    {
        //adjust for utc?
        return getHours().toString();
    }	

    /*
       Returns the minutes the W3CDateTime represents in the
       following format:
       mm		
     */	
    public function getW3CMinutes(Void):String
    {
        return getMinutes().toString();
    }	

    /*
       Returns the seconds the W3CDateTime represents in the
       following format:
       ss		
     */	
    public function getW3CSeconds(Void):String
    {
        return getMinutes().toString();
    }	

    /*
       Returns the UTC offset the W3CDateTime represents in the
       following format:
       +/-hh:mm

       Note, if there is no offset, it will return
       Z		
     */	
    public function getW3CUTCOffset(Void):String
    {
        return W3CDateTime.formatTimezoneOffset(this);
    }	

    /*
       Static functions that takes a String representation of a number and adds
       a leading 0 if it is a single digit.
     */
    public static function padDigit(digit:String):String
    {
        if(digit.length < 2)
        {
            return "0" + digit;
        }

        return digit;
    }

    /*
       Static function that takes an ActionScript Date object and returns
       a well formed W3CDateTime String that represents the specified date.

       Takes 4 additional optional arguments which specifies the format of
       the string:

incMonth : Whether the month should be included.

incDay : Whether the day of the month should be included. 

incHours : Whether the hours and minutes should be included.

incSeconds : Whether the seconds should be included.

Note, that all output will be a valid W3CDataTime item.		
     */
    public static function parseDate(inDate:Date, 
            incMonth:Boolean,
            incDay:Boolean,
            incHours:Boolean,
            incSeconds:Boolean):String
    {
        if(inDate == undefined)
        {
            return undefined;
        }

        if(incMonth == undefined)
        {
            incMonth = false;
        }

        if(incDay == undefined)
        {
            incDay = false;
        }

        if(incHours == undefined)
        {
            incHours = false;
        }		

        if(incSeconds == undefined)
        {
            incSeconds = false;
        }		

        var now:Date = new Date();

        var w3cString:String = now.getFullYear().toString();

        if(!incMonth)
        {
            return w3cString;
        }

        w3cString += "-" + W3CDateTime.padDigit((now.getMonth() + 1).toString());

        if(!incDay)
        {
            return w3cString;			
        }

        w3cString += "-" + W3CDateTime.padDigit(now.getDate().toString());

        if(!incHours)
        {
            return w3cString;			
        }

        w3cString += "T" + W3CDateTime.padDigit(now.getHours().toString()) +
            ":" + W3CDateTime.padDigit(now.getMinutes().toString());		

        if(!incSeconds)
        {
            //need to format the timeset appropriately
            return w3cString + W3CDateTime.formatTimezoneOffset(now);			
        }

        return w3cString + ":" + W3CDateTime.padDigit(now.getSeconds().toString()) +
            W3CDateTime.formatTimezoneOffset(now);
    }

    /*
       Static methods that takes an ActionScript date instance, and returns
       the UTC offset in the format used in a W3CDateTime string.

       The format is:

       +/-hh:mm

       If the offset is 0, then method will return
       Z
     */
    public static function formatTimezoneOffset(d:Date):String
    {
        var timezoneOffset:Number = d.getTimezoneOffset();

        if(timezoneOffset == 0)
        {
            return "Z";
        }

        var operator:String = (timezoneOffset > -1)? "+" : "-";

        if(timezoneOffset < 0)
        {
            timezoneOffset *= -1;
        }

        //what if offset if 0 or less
        var hours_i:Number = (timezoneOffset / 60);
        var seconds:String = (timezoneOffset - (hours_i * 60)).toString();

        return operator + W3CDateTime.padDigit(hours_i.toString()) +
            ":" + W3CDateTime.padDigit(seconds);
    }

    /*
       Static method that takes a W3CDateTime string and returns an
       ActionScript Date object that represents the string passed in.
     */
    public static function parseString(dateString:String):Date
    {
        if(dateString == undefined || dateString.length < 1)
        {
            return undefined;
        }

        var YYYY:String = dateString.substr(0, 4);
        var MM:String = dateString.substr(5, 2);
        var DD:String = dateString.substr(8, 2);
        var hh:String = dateString.substr(11, 2);
        var mm:String = dateString.substr(14, 2);
        var ss:String = dateString.substr(17, 2);
        var s:String = "";

        var offsetOperator:String;
        var offsetHours:String;
        var offsetMinutes:String;

        var offset:Number = 0;		
        var operator:Number;
        var indexBump:Number = 0;

        if(dateString.substr(19, 1) == ".")
        {
            //they have a decimal second
            s = dateString.substr(20, 2);

            indexBump = 3;			
        }
        else if (ss == "") { //can have tz offset with no seconds
            indexBump = -2;
        }
        else
        {
            indexBump = 0;
            //they dont have a decimal second
        }

        offsetOperator = dateString.substr(19 + indexBump,1);
        offsetHours = dateString.substr(20 + indexBump,2);
        offsetMinutes = dateString.substr(23 + indexBump,2);

        //this could be wrong if there is no operator
        operator = ((offsetOperator == "-") || (offsetOperator == undefined))? 1 : -1; 

        //this could be wrong if offsethours or offsetminutes is undefined
        offset = operator * (Number(offsetHours) * 60) + Number(offsetMinutes);

        if(isNaN(offset))
        {
            offset = 0;
        }

        var minutes:Number;
        if(mm != "")
        {
            minutes = Number(mm) + offset;
        }

        var month:Number;
        if(MM != "")
        {
            month = Number(MM) - 1;
        }

        var year:Number;
        if(YYYY != "")
        {
            year = Number(YYYY);
        }

        var day:Number;
        if(DD != "")
        {			
            day = Number(DD);
        }

        var hours:Number;
        if(hh != "")
        {
            hours = Number(hh);
        }		

        var seconds:Number;
        if(ss != "")
        {
            seconds = Number(ss);
        }	

        var utcTimeMS = Date.UTC(
                year,
                month, 
                day,
                hours, 
                minutes,
                seconds);

        return new Date(utcTimeMS);;
    }
}
