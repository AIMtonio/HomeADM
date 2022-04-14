package cliente.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cliente.bean.ConocimientoCteBean;
import cliente.bean.InfoAdiContaBean;
import cliente.dao.InfoAdiContaDAO;
import cliente.servicio.ConocimientoCteServicio.Enum_Tra_ConoClient;

public class InfoAdiContaServicio extends BaseServicio{
	InfoAdiContaDAO infoAdiContaDAO = null;
	public static interface Enum_Con_InfoAdiConta {
		int principal = 1;
	}
	
	public static interface Enum_Tra_InfoAdiConta {
		int alta = 1;
		int modificacion = 2;
	}
	
	public InfoAdiContaBean consulta(int tipoConsulta, InfoAdiContaBean infoAdiContaBean) {
		InfoAdiContaBean bean = null;
		switch (tipoConsulta) {
			case Enum_Con_InfoAdiConta.principal :
				bean = infoAdiContaDAO.consulta(infoAdiContaBean, tipoConsulta);
				break;
		}
		return bean;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, InfoAdiContaBean infoAdiContaBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_InfoAdiConta.alta :
				mensaje = infoAdiContaDAO.alta(infoAdiContaBean);
				break;
			case Enum_Tra_InfoAdiConta.modificacion :
				mensaje = infoAdiContaDAO.modificacion(infoAdiContaBean);
				break;
		}
		return mensaje;
	}

	public InfoAdiContaDAO getInfoAdiContaDAO() {
		return infoAdiContaDAO;
	}

	public void setInfoAdiContaDAO(InfoAdiContaDAO infoAdiContaDAO) {
		this.infoAdiContaDAO = infoAdiContaDAO;
	}
}
