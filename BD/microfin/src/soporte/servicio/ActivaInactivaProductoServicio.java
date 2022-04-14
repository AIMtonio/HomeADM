package soporte.servicio;

import soporte.bean.ActivaInactivaProductosBean;
import soporte.dao.ActivaInactivaProductosDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ActivaInactivaProductoServicio extends BaseServicio{
	ActivaInactivaProductosDAO activaInactivaProductosDAO = null;
	
	//---------- Tipo de Actualizacion --------------------------------------------------------------
	
	public static interface Enum_Tra_Producto{
		int actualiza = 1;
	}
	public MensajeTransaccionBean actualizaProducto(int tipoTransaccion,  int tipoActualizacion, ActivaInactivaProductosBean producto){
		MensajeTransaccionBean mensaje = null;
			switch(tipoTransaccion){
			case (Enum_Tra_Producto.actualiza):
				mensaje = activaInactivaProductosDAO.actualizaProducto(producto,tipoActualizacion);	
			break;
			}
		return mensaje;
	}

	public ActivaInactivaProductosDAO getActivaInactivaProductosDAO() {
		return activaInactivaProductosDAO;
	}

	public void setActivaInactivaProductosDAO(
			ActivaInactivaProductosDAO activaInactivaProductosDAO) {
		this.activaInactivaProductosDAO = activaInactivaProductosDAO;
	}

}
