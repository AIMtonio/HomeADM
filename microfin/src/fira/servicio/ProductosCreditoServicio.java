package fira.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import credito.bean.ProductosCreditoBean;
import credito.dao.ProductosCreditoDAO;

public class ProductosCreditoServicio extends BaseServicio {

	ProductosCreditoDAO productosCreditoDAO = null;

	public ProductosCreditoServicio () {
		// TODO Auto-generated constructor stub
		super();
	}
	
	public static interface Enum_Tra_ProductosCredito {
		int alta = 1;
		int modificacion = 2;
	}

	public static interface Enum_Act_ProductosCredito {
		int agropecuario = 3;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ProductosCreditoBean clasificCredito){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_ProductosCredito.alta:
			mensaje = productosCreditoDAO.altaProdAgro(clasificCredito);
			break;
		case Enum_Tra_ProductosCredito.modificacion:
			mensaje = productosCreditoDAO.modificaProdAgro(clasificCredito);
			break;
		}
		return mensaje;
	}
	
	public void setProductosCreditoDAO(ProductosCreditoDAO productosCreditoDAO) {
		this.productosCreditoDAO = productosCreditoDAO;
	}

	public ProductosCreditoDAO getProductosCreditoDAO() {
		return productosCreditoDAO;
	}	
}