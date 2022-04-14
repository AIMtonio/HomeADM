package spei.servicio;

import java.util.ArrayList;

import spei.bean.AutorizaSpeiBean;
import spei.bean.GuiaContableSpeiIEBean;
import spei.dao.GuiaContableSpeiIEDAO;
import spei.servicio.AutorizaSpeiServicio.Enum_Tra_Autoriza;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class GuiaContableSpeiIEServicio extends BaseServicio{
	
	private GuiaContableSpeiIEServicio(){
		super();
	}
	GuiaContableSpeiIEDAO guiaContableSpeiIEDAO = null;
	
	public static interface Enum_Tra_Autoriza {
		int grabar = 1;
		int modificar = 2;

	}
	
	public static interface Enum_Con_GuiaContablaSpeiIE{
		int estatusReg = 1;
	
	}
	
	
	
	/* controla el tipo de consulta para solicitudes de apoyo escolar */
	public GuiaContableSpeiIEBean consulta(int tipoConsulta,GuiaContableSpeiIEBean guiaContableSpeiIEBean){			
		GuiaContableSpeiIEBean guiaContableSpeiIEBeanCon = null;
		switch (tipoConsulta) {
			case Enum_Con_GuiaContablaSpeiIE.estatusReg:		
				guiaContableSpeiIEBeanCon = guiaContableSpeiIEDAO.consultaPrincipal(guiaContableSpeiIEBean, tipoConsulta);				
				break;
			
		}
			
		return guiaContableSpeiIEBeanCon;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, GuiaContableSpeiIEBean guiaContableSpeiIEBean) {
		
		MensajeTransaccionBean mensaje = null;
		
		switch(tipoTransaccion){		
		case Enum_Tra_Autoriza.grabar:
			mensaje = guiaContableSpeiIEDAO.guardaGuiaContableSpeiIE(guiaContableSpeiIEBean,tipoTransaccion);
			break;	
			
		case Enum_Tra_Autoriza.modificar:
			mensaje = guiaContableSpeiIEDAO.modificaGuiaContableSpeiIE(guiaContableSpeiIEBean,tipoTransaccion);
			break;	
		}
		
		return mensaje;
	
	}
	
	
	
	public GuiaContableSpeiIEDAO getGuiaContableSpeiIEDAO(){
		return guiaContableSpeiIEDAO;
	}

	public void setGuiaContableSpeiIEDAO(GuiaContableSpeiIEDAO guiaContableSpeiIEDAO) {
		this.guiaContableSpeiIEDAO = guiaContableSpeiIEDAO;
	}
}
