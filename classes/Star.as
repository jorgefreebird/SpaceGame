package {
	import flash.display.MovieClip;
		public class Star extends MovieClip {
		public var yspeed:int=1.5;
		public var yspeedslow:int=4;
		public var yspeedsuperslow:int=2.25;
		public var rnd1:int=Math.random()*3;
		public var mydirection:String;
		public var dead:Boolean;
		
		public function action():void {
						if(rnd1==0){this.y+=yspeed;}
						if(rnd1==1){this.y+=yspeedslow;}
						if(rnd1==2){this.y+=yspeedsuperslow;}
			if(this.y>610){dead=true;}
			
		}//action
		
	}
}