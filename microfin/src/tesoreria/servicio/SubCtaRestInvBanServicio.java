package tesoreria.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import tesoreria.bean.SubCtaRestInvBanBean;
import tesoreria.bean.SubCtaTituInvBanBean;
import tesoreria.dao.SubCtaRestInvBanDAO;
import tesoreria.servicio.SubCtaDeudaInvBanServicio.Enum_Con_SubCtaDeudaInvBan;
import tesoreria.servicio.SubCtaTituInvBanServicio.Enum_Tra_SubCtaTituInvBan;

public class SubCtaRestInvBanServicio extends BaseServicio {
	
	SubCtaRestInvBanDAO subCtaRestInvBanDAO = null;
	
	private SubCtaRestInvBanServicio(){
		super();
	}
	
	public static interface Enum_Tra_SubCtaRestInvBan{
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaRestInvBan{
		int principal = 1;
	}


	public SubCtaRestInvBanBean consulta(int tipoConsulta, SubCtaRestInvBanBean subCtaRestInvBanBean){
		SubCtaRestInvBanBean subCta= null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaRestInvBan.principal:
				subCta = subCtaRestInvBanDAO.consultaPrincipal(subCtaRestInvBanBean,tipoConsulta);
			break;		
		}
		return subCta;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccionR, SubCtaRestInvBanBean subCtaRestInvBanBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccionR) {
		case Enum_Tra_SubCtaRestInvBan.alta:
			mensaje = subCtaRestInvBanDAO.alta(subCtaRestInvBanBean);
			break;
		case Enum_Tra_SubCtaRestInvBan.modificacion:
			mensaje = subCtaRestInvBanDAO.modifica(subCtaRestInvBanBean);
			break;
		case Enum_Tra_SubCtaRestInvBan.baja:
			mensaje = subCtaRestInvBanDAO.baja(subCtaRestInvBanBean);
			break;
		}
		return mensaje;
	}

	public SubCtaRestInvBanDAO getSubCtaRestInvBanDAO() {
		return subCtaRestInvBanDAO;
	}


	public void setSubCtaRestInvBanDAO(SubCtaRestInvBanDAO subCtaRestInvBanDAO) {
		this.subCtaRestInvBanDAO = subCtaRestInvBanDAO;
	}
}