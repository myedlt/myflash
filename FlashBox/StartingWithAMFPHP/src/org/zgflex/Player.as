package org.zgflex
{
    [RemoteClass(alias="org.zgflex.Player")]
    [Bindable]
    public class Player
    {
        public var id:int;
        public var name:String;
        public var team_id:String;
        public var team_title:String;
        public var team_league:String;
        public var position_id:String;
        public var position_title:String;
    }
}