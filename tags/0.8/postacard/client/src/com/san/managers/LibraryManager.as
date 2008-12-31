package com.san.managers
{
	import com.san.values.Photo;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	
	public class LibraryManager extends EventDispatcher
	{
		
		public static const manager:LibraryManager = new LibraryManager();
		
		public function LibraryManager()
		{
			if( manager )
				throw new Error( "Singleton Error: Use LibraryManager.manager" );
				
			addDefaultItems();
		}
		
		
		private function addDefaultItems():void
		{
			addPhoto( Photo.create( "http://flickr.com/photos/7224151@N08/2273210105/",
									"http://farm3.static.flickr.com/2009/2273210105_445d44553e_s.jpg",
									"http://farm3.static.flickr.com/2009/2273210105_445d44553e_t.jpg",
									"http://farm3.static.flickr.com/2009/2273210105_445d44553e_m.jpg",
									"http://farm3.static.flickr.com/2009/2273210105_445d44553e.jpg",
									"http://farm3.static.flickr.com/2009/2273210105_445d44553e_b.jpg" ) );
									
			addPhoto( Photo.create( "http://flickr.com/photos/moonjuice/120162985/",
									"http://farm1.static.flickr.com/47/120162985_61a81ed5aa_s.jpg",
									"http://farm1.static.flickr.com/47/120162985_61a81ed5aa_t.jpg",
									"http://farm1.static.flickr.com/47/120162985_61a81ed5aa_m.jpg",
									"http://farm1.static.flickr.com/47/120162985_61a81ed5aa.jpg",
									"http://farm1.static.flickr.com/47/120162985_61a81ed5aa_o.jpg" ) );

			addPhoto( Photo.create( "http://flickr.com/photos/beeblecat/221979531/",
									"http://farm1.static.flickr.com/84/221979531_fb3a5a4035_s.jpg",
									"http://farm1.static.flickr.com/84/221979531_fb3a5a4035_t.jpg",
									"http://farm1.static.flickr.com/84/221979531_fb3a5a4035_m.jpg",
									"http://farm1.static.flickr.com/84/221979531_fb3a5a4035.jpg",
									"http://farm1.static.flickr.com/84/221979531_fb3a5a4035_b.jpg" ) );
		}
		
		private var _photos:ArrayCollection = new ArrayCollection();
		
		[Bindable(event="libraryChanged")]
		public function get photos():ArrayCollection
		{
			return _photos;
		}
		
		public function addPhoto( photo:Photo ):void
		{
			_photos.addItemAt( photo, 0 );
			dispatchEvent( new Event( "libraryChanged" ) );
		}
		
		public function removePhoto( photo:Photo ):void
		{
			_photos.removeItemAt( _photos.getItemIndex( photo ) );
			dispatchEvent( new Event( "libraryChanged" ) );
		}
		
	}
}