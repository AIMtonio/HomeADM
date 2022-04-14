package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import soporte.bean.CierreGeneralBean;
import soporte.dao.GeneralDAO;

public class GeneralServicio extends BaseServicio{

	//---------- Variables ------------------------------------------------------------------------
	GeneralDAO generalDAO = null;
	
	public static interface Enum_Con_CierreGeneral{
		int realizaCierre	= 1;

	}
	
	public GeneralServicio() {
		super();
		// TODO Auto-generated constructor stub
		
	}	
	
	//---------- Procedimientos ------------------------------------------------------------------------
	public MensajeTransaccionBean cerrarDia(){
		MensajeTransaccionBean mensaje = null;
		mensaje = generalDAO.procesaCierre();		
		return mensaje;
	}	
	
	public CierreGeneralBean consulta(int tipoConsulta, CierreGeneralBean cierreGeneralBean){
		CierreGeneralBean consultabean = null;
		
		switch(tipoConsulta){
			case Enum_Con_CierreGeneral.realizaCierre:
				consultabean = generalDAO.consultaRealizaCierre(tipoConsulta, cierreGeneralBean);
				break;
		}
		
		return consultabean;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------
	
	public GeneralDAO getGeneralDAO() {
		return generalDAO;
	}	
	
	public void setGeneralDAO(GeneralDAO generalDAO) {
		this.generalDAO = generalDAO;
	}			   
	
	
	
	
}
