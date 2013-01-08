package com.FSC.UI.InterActiveObject.NavTweenButtonBarClass {
	import com.FSC.Model.ModelDataBase;	

	/**菜单数据类
	 * 通过分析xml 输出菜单的目录结构
	 * @author	panyong 
	 * @date	080505
	 * @version	1.0.080513
	 */
	public class NavTweenButtonBarData extends ModelDataBase {

		public function NavTweenButtonBarData(source:String=null) {
			super(source);
		}
		
		/**
		 * @param tagString		需要从xml中筛选的tag的名字 默认值为root
		 * @deprecated 返回某一子叶的 菜单
		 * @deprecated 返回第level层的菜单 root表示根 这里存在和nav.xml极大的耦合性！
		 * */
		public function getXMLListByTag(tagString:String="root"):XMLList{
			if(tagString=="root"){
				return data.children();
			}else{
				if(data.navItem!=null)			
            	return data.navItem.(@tag==tagString);
   			}
   			return null;
		}
		
	}
}