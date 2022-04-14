package tesoreria.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import tesoreria.bean.SubCtaRestInvBanBean;
import tesoreria.bean.SubCtaTituInvBanBean;
import tesoreria.dao.SubCtaTituInvBanDAO;

public class SubCtaTituInvBanServicio extends BaseServicio {
	
	SubCtaTituInvBanDAO subCtaTituInvBanDAO = null;
	
	private SubCtaTituInvBanServicio(){
		super();
	}
	
	public static interface Enum_Tra_SubCtaTituInvBan {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaTituInvBan{
		int principal = 1;
	}

	public SubCtaTituInvBanBean consulta(int tipoConsulta, SubCtaTituInvBanBean subCtaTituInvBanBean){
		SubCtaTituInvBanBean subCta = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaTituInvBan.principal:
				subCta = subCtaTituInvBanDAO.consultaPrincipal(subCtaTituInvBanBean,tipoConsulta);
			break;		
		}
		return subCta;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccionTM, SubCtaTituInvBanBean subCtaTituInvBanBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccionTM) {
		case Enum_Tra_SubCtaTituInvBan.alta:
			mensaje = subCtaTituInvBanDAO.alta(subCtaTituInvBanBean);
			break;
		case Enum_Tra_SubCtaTituInvBan.modificacion:
			mensaje = subCtaTituInvBanDAO.modifica(subCtaTituInvBanBean);
			break;
		case Enum_Tra_SubCtaTituInvBan.baja:
			mensaje = subCtaTituInvBanDAO.baja(subCtaTituInvBanBean);
			break;
		}
		return mensaje;
	}

	public SubCtaTituInvBanDAO getSubCtaTituInvBanDAO() {
		return subCtaTituInvBanDAO;
	}

	public void setSubCtaTituInvBanDAO(SubCtaTituInvBanDAO subCtaTituInvBanDAO) {
		this.subCtaTituInvBanDAO = subCtaTituInvBanDAO;
	}


}