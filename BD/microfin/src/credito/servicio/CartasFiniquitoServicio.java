package credito.servicio;
 
import general.servicio.BaseServicio;

import java.io.ByteArrayOutputStream;

import credito.bean.CartasFiniquitoBean;
import credito.dao.CartasFiniquitoDAO;

import reporte.ParametrosReporte;
import reporte.Reporte;


public class CartasFiniquitoServicio extends BaseServicio {
	CartasFiniquitoDAO cartasFiniquitoDAO= null;
	
	private CartasFiniquitoServicio(){
		super();
	}	

	public CartasFiniquitoDAO getcartasFiniquitoDAO() {
		return cartasFiniquitoDAO;
	}

	public void setcartasFiniquitoDAO(
			CartasFiniquitoDAO cartasFiniquitoDAO) {
		this.cartasFiniquitoDAO = cartasFiniquitoDAO;
	}
	
	
}
