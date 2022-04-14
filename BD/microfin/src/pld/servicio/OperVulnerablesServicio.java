package pld.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import contabilidad.servicio.CuentasContablesServicio.Enum_Lis_CuentasContables;
import pld.bean.OpeInusualesBean;
import pld.bean.OperVulnerablesBean;
import pld.dao.OperVulnerablesDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;


public class OperVulnerablesServicio extends BaseServicio{
	private OperVulnerablesServicio(){
		super();
	}
	
	OperVulnerablesDAO operVulnerablesDAO = null;
	//TIPOS DE CONSULTA
	public static interface Enum_Con_OperVulnerables{
		int principal = 1;
	}
		
	//TIPOS DE TRANSACCION
	public static interface Enum_Tra_OpeInusuales {
		int actualizacion = 1;
		int	alta =2;
	}
	
	//TIPOS DE LISTA
	public static interface Enum_Lis_CuentasContables{
		int principal   = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, OperVulnerablesBean operVulnerables){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_OpeInusuales.actualizacion:
				//mensaje = actualizacion(operVulnerables, tipoTransaccion);
				mensaje = null;
				break;
				
		}
		return mensaje;
	}

	public List lista (int tipoLista, OperVulnerablesBean operVulnerables){
		List listaOperacionesVulnerables = null;
		switch (tipoLista) {
		case Enum_Lis_CuentasContables.principal:		
			listaOperacionesVulnerables=  operVulnerablesDAO.operacionesVulnerablesRep(operVulnerables, tipoLista);
			break;
		}
		
		return listaOperacionesVulnerables;
	}
	
	public OperVulnerablesBean consulta(int tipoConsulta, OperVulnerablesBean operVulnerables){
		OperVulnerablesBean operVulnerablesBean = null;
		switch (tipoConsulta) {
			case Enum_Con_OperVulnerables.principal:		
				operVulnerablesBean = operVulnerablesDAO.consultaPrincipal(operVulnerables, tipoConsulta);				
				break;							
				
			
		}		
		return operVulnerablesBean;
	}
	
	public OperVulnerablesDAO getOperVulnerablesDAO() {
		return operVulnerablesDAO;
	}

	public void setOperVulnerablesDAO(OperVulnerablesDAO operVulnerablesDAO) {
		this.operVulnerablesDAO = operVulnerablesDAO;
	}

	

}
