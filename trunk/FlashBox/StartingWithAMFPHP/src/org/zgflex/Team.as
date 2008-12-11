package org.zgflex
{

    [RemoteClass(alias="org.zgflex.Team")]
    [Bindable]
    public class Team
    {
        public var id:int;
        public var title:String;
        public var league:String;
    }

}