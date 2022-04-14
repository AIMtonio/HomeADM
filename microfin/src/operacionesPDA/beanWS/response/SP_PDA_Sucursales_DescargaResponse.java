package operacionesPDA.beanWS.response;

import general.bean.BaseBeanWS;

import java.util.ArrayList;

import soporte.bean.SucursalesBean;

public class SP_PDA_Sucursales_DescargaResponse extends BaseBeanWS{
	private ArrayList<SucursalesBean> sucursales = new ArrayList<SucursalesBean>(); 

	public ArrayList<SucursalesBean> getSucursales() {
		return sucursales;
	}

	public void setSucursales(ArrayList<SucursalesBean> sucursales) {
		this.sucursales = sucursales;
	}  
	
	 public void addSucursal(SucursalesBean sucursal){  
	        this.sucursales.add(sucursal);  
	 }

}