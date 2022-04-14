package arrendamiento.servicio;

import java.util.List;

import general.servicio.BaseServicio;
import arrendamiento.bean.ProductoArrendaBean;
import arrendamiento.dao.ProductoArrendaDAO;

public class ProductoArrendaServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	ProductoArrendaDAO arrendamientosDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Arrenda {
		int principal = 1;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Arrenda {
		int principal = 1;
	}
	
	public ProductoArrendaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public ProductoArrendaBean consulta(int tipoConsulta, ProductoArrendaBean productoArrendaBean){
		ProductoArrendaBean resultado = null;
		switch (tipoConsulta) {
			case Enum_Con_Arrenda.principal:		
				resultado = arrendamientosDAO.consultaPrincipal(productoArrendaBean, tipoConsulta);				
				break;	
		}	
		return resultado;
	}
	
	public List lista(int tipoLista, ProductoArrendaBean productoArrendaBean){		
		List resultado = null;
		switch (tipoLista) {
			case Enum_Lis_Arrenda.principal:		
				resultado = arrendamientosDAO.listaPrincipal(productoArrendaBean, tipoLista);				
				break;
		}		
		return resultado;
	}
	

	
	//------------------ Geters y Seters ------------------------------------------------------	
	public ProductoArrendaDAO getProductoArrendaDAO() {
		return arrendamientosDAO;
	}


	public void setProductoArrendaDAO(ProductoArrendaDAO arrendamientosDAO) {
		this.arrendamientosDAO = arrendamientosDAO;
	}
	
			
}


