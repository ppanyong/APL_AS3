package com.FSC.UI.CustomerListItemClass {

	/**
	 * 列表项接口
	 * @author Andy
	 */
	public interface ICustomerListItem {
		function get Content() : String ;
		function set Content(content : String) : void ;
		function get Id() : String ;
		function set Id(id : String) : void ;
		function get Selected() : Boolean ;
		function set Selected(s : Boolean) : void ;
	}
	
}
