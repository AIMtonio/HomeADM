package soporte.servicio;

import soporte.bean.CalculosyOperacionesBean;
import soporte.dao.CalculosyOperacionesDAO;
import general.servicio.BaseServicio;

public class CalculosyOperacionesServicio extends BaseServicio {
	
	//---------- Variables ------------------------------------------------------------------------
	CalculosyOperacionesDAO calculosyOperacionesDAO = null;

	
	//---------- Tipos de Operaciones ----------------------------------------------------------------
	public static interface Enum_Operaciones {
		int multiplicacionDosDecimales = 1;
		int multiplicacionCuatroDecimales = 2;
		int sumarDosDecimales = 3;
	}
	
	public CalculosyOperacionesServicio() {
		super();
	}
	
	public CalculosyOperacionesBean calculosYOperaciones(int tipoOperacion, CalculosyOperacionesBean calculosyOperacionesBean){
		CalculosyOperacionesBean mensaje = null;
		switch (tipoOperacion) {
			case Enum_Operaciones.multiplicacionDosDecimales:		
				mensaje = calculosyOperacionesDAO.calculosYOperaciones(calculosyOperacionesBean, Enum_Operaciones.multiplicacionDosDecimales);			
				break;				
			case Enum_Operaciones.multiplicacionCuatroDecimales:
				mensaje = calculosyOperacionesDAO.calculosYOperaciones(calculosyOperacionesBean, Enum_Operaciones.multiplicacionCuatroDecimales);			
				break;	
			case Enum_Operaciones.sumarDosDecimales:
				mensaje = calculosyOperacionesDAO.calculosYOperaciones(calculosyOperacionesBean, Enum_Operaciones.sumarDosDecimales);			
				break;	
		}
		return mensaje;
	}

	public CalculosyOperacionesDAO getCalculosyOperacionesDAO() {
		return calculosyOperacionesDAO;
	}

	public void setCalculosyOperacionesDAO(
			CalculosyOperacionesDAO calculosyOperacionesDAO) {
		this.calculosyOperacionesDAO = calculosyOperacionesDAO;
	}
	
}
