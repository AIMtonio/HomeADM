package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import soporte.bean.TiposDocumentosBean;
import soporte.dao.TiposDocumentosDAO;

public class AlertNotificacionesServicio extends BaseServicio {
	TiposDocumentosDAO	tiposDocumentosDAO;
	
	public static interface Enum_Con_Alertas {
		int	expiracionDocsPLD			= 1;
		int restExpDocRiesAltoPLD		= 2;
	}
	
	public MensajeTransaccionBean alertaExpiraDocs(int tipoConsulta, TiposDocumentosBean tiposDocumentosBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoConsulta) {
			case Enum_Con_Alertas.expiracionDocsPLD :
				mensaje = tiposDocumentosDAO.consultaAlerta(tiposDocumentosBean,tipoConsulta);
				break;
			case Enum_Con_Alertas.restExpDocRiesAltoPLD :
				mensaje = tiposDocumentosDAO.consultaAlerta(tiposDocumentosBean,tipoConsulta);
				break;
		}
		return mensaje;
	}
	public TiposDocumentosDAO getTiposDocumentosDAO() {
		return tiposDocumentosDAO;
	}
	public void setTiposDocumentosDAO(TiposDocumentosDAO tiposDocumentosDAO) {
		this.tiposDocumentosDAO = tiposDocumentosDAO;
	}
}
