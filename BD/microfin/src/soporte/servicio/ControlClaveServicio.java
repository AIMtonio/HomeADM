package soporte.servicio;

import java.util.List;

import soporte.bean.ControlClaveBean;
import soporte.dao.ControlClaveDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ControlClaveServicio extends BaseServicio{
	ControlClaveDAO controlClaveDAO = null;
	private ControlClaveServicio(){
		super();		
	}
	public static interface Enum_Tra_Claves {
		int grabar = 1;
	}
	public static interface Enum_Lis_Claves {
		int listaClaves = 1;
	}
	
	public static interface Enum_Con_Claves {
		int principal	= 1;
		int foranea 	= 2;
		int fechaActual = 3;
		int claveKey	= 4;
		int fechaActualExterna = 5;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ControlClaveBean controlClaveBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_Claves.grabar:
				mensaje = controlClaveDAO.guardarClaves(controlClaveBean);
			break;
		}
		return mensaje;
	}
	
	

	public ControlClaveBean consulta(int tipoConsulta, ControlClaveBean controlBean){
		ControlClaveBean controlClave = null;
		switch (tipoConsulta) {
			case Enum_Con_Claves.fechaActual:
				controlClave = controlClaveDAO.consultaFecha(tipoConsulta, controlBean);
			break;
			case Enum_Con_Claves.claveKey:
				controlClave = controlClaveDAO.validaClaveKey(tipoConsulta, controlBean);
			break;
			case Enum_Con_Claves.fechaActualExterna:
				controlClave = controlClaveDAO.consultaFechaExterna(3, controlBean);
			break;
		}
		return controlClave;
	}
	
	
	public List lista(int tipoLista, ControlClaveBean controlClave){
		List clavesAcceso = null;
		switch (tipoLista) {
			case Enum_Lis_Claves.listaClaves:
				clavesAcceso = controlClaveDAO.lista(controlClave, tipoLista);
			break;
		}
		return clavesAcceso;
	}
	
	public ControlClaveDAO getControlClaveDAO() {
		return controlClaveDAO;
	}
	public void setControlClaveDAO(ControlClaveDAO controlClaveDAO) {
		this.controlClaveDAO = controlClaveDAO;
	}

}
