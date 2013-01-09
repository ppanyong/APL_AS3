package com.flashloaded.as3{
	
	
	public class Points{
		private var data:Array;
		public function Points(n0:Number=0,n1:Number=0,n2:Number=0,n3:Number=0,n4:Number=0,n5:Number=0,n6:Number=0,n7:Number=0){
			data=new Array();
			setValues(n0,n1,n2,n3,n4,n5,n6,n7);
			
		}
		
		public function toArray():Array{
			return data;
		}
		
		public function setArray(arr:Array):void{
			data=arr;
		}
		public function equals(p:Points):Boolean{
			var arr1=this.toArray();
			var arr2=p.toArray();
			var iden:Boolean=true;
			
			for(var i:uint=0;i<arr1.length;i++){
				if(arr1[i]!=arr2[i]){
					iden=false;
				}
			}
			
			return iden;
			 
		}
		public function getX(index:int):Number{
			var i=index*2;
			return data[i];
		}
		public function getY(index:int):Number{
			var i=index*2+1;
			return data[i];
		}
		
		public function setValues(n0:Number,n1:Number,n2:Number,n3:Number,n4:Number,n5:Number,n6:Number,n7:Number):void{
			data[0]=n0;
			data[1]=n1;
			data[2]=n2;
			data[3]=n3;
			data[4]=n4;
			data[5]=n5;
			data[6]=n6;
			data[7]=n7;
		}
	}
}