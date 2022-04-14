package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import pld.bean.ParametrosAlertasBean;
import pld.dao.ParametrosAlertasDAO;

public class ParametrosAlertasServicio extends BaseServicio {
	//----------- Constructor ------------------------------------------------------------------------
	private ParametrosAlertasServicio() {
		super();
	}
	//---------- Variables ------------------------------------------------------------------------	
	
	public static interface Enum_Con_Alertas {
		int	principal		= 1;
		int	folioVigente	= 3;
	}
	
	public static interface Enum_Tra_Alertas {
		int	alta			= 1;
		int	modificacion	= 2;
		int	actualizacion	= 3;
	}
	
	public static interface Enum_Lis_Alertas {
		int	alfanumerica	= 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParametrosAlertasBean parametrosAlertas) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Alertas.alta :
				mensaje = alta(parametrosAlertas);
				break;
			case Enum_Tra_Alertas.modificacion :
				mensaje = modificacion(parametrosAlertas);
				break;
			case Enum_Tra_Alertas.actualizacion :
				mensaje = actualizacion(parametrosAlertas);
				break;
		
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean alta(ParametrosAlertasBean parametrosAlertas) {
		MensajeTransaccionBean mensaje = null;
		mensaje = parametrosAlertasDAO.altaParametrosalertas(parametrosAlertas);
		return mensaje;
	}
	
	public MensajeTransaccionBean modificacion(ParametrosAlertasBean parametrosAlertas) {
		MensajeTransaccionBean mensaje = null;
		mensaje = parametrosAlertasDAO.modificaParametrosalertas(parametrosAlertas);
		return mensaje;
	}
	
	public MensajeTransaccionBean actualizacion(ParametrosAlertasBean parametrosAlertas) {
		MensajeTransaccionBean mensaje = null;
		mensaje = parametrosAlertasDAO.actualizacion(parametrosAlertas);
		return mensaje;
	}
	
	public ParametrosAlertasBean consulta(int tipoConsulta, ParametrosAlertasBean parametrosAlertas) {
		ParametrosAlertasBean parametrosAlertasBean = null;
		switch (tipoConsulta) {
			case Enum_Con_Alertas.principal :
				parametrosAlertasBean = parametrosAlertasDAO.consultaPrincipal(parametrosAlertas, Enum_Con_Alertas.principal);
				break;
			case Enum_Con_Alertas.folioVigente :
				parametrosAlertasBean = parametrosAlertasDAO.consultaFoliovigente(parametrosAlertas, Enum_Con_Alertas.folioVigente);
				break;
		
		}
		return parametrosAlertasBean;
		
	}
	
	public List lista(int tipoLista, ParametrosAlertasBean parametrosAlertasBean) {
		List listaParametros = null;
		switch (tipoLista) {
			case Enum_Lis_Alertas.alfanumerica :
				listaParametros = parametrosAlertasDAO.listaAlfanumerica(parametrosAlertasBean, Enum_Lis_Alertas.alfanumerica);
				break;
		}
		return listaParametros;
	}
	
	ParametrosAlertasDAO	parametrosAlertasDAO	= null;
	public ParametrosAlertasDAO getParametrosAlertasDAO() {
		return parametrosAlertasDAO;
	}
	public void setParametrosAlertasDAO(ParametrosAlertasDAO parametrosAlertasDAO) {
		this.parametrosAlertasDAO = parametrosAlertasDAO;
	}
	
}
