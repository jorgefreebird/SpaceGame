package {
	import flash.display.MovieClip;
		public class Heart extends MovieClip {
		public var yspeed:int=4;
		public var dead:Boolean;
		
		public function action():void {
			this.y+=yspeed;
			if(this.y>610){dead=true;}
			
		}//action
		
	}
}