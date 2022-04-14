package tesoreria.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import tesoreria.bean.SubCtaDeudaInvBanBean;
import tesoreria.dao.SubCtaDeudaInvBanDAO;
import tesoreria.servicio.SubCtaRestInvBanServicio.Enum_Tra_SubCtaRestInvBan;

public class SubCtaDeudaInvBanServicio extends BaseServicio {
	
	SubCtaDeudaInvBanDAO subCtaDeudaInvBanDAO = null;
	
	private SubCtaDeudaInvBanServicio(){
		super();
	}
	
	public static interface Enum_Tra_SubCtaDeudaInvBan{
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaDeudaInvBan{
		int principal = 1;
	}


	public SubCtaDeudaInvBanBean consulta(int tipoConsulta, SubCtaDeudaInvBanBean subCtaDeudaInvBanBean){
		SubCtaDeudaInvBanBean subCta= null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaDeudaInvBan.principal:
				subCta = subCtaDeudaInvBanDAO.consultaPrincipal(subCtaDeudaInvBanBean,tipoConsulta);
			break;		
		}
		return subCta;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccionTD, SubCtaDeudaInvBanBean subCtaDeudaInvBanBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccionTD) {
		case Enum_Tra_SubCtaDeudaInvBan.alta:
			mensaje = subCtaDeudaInvBanDAO.alta(subCtaDeudaInvBanBean);
			break;
		case Enum_Tra_SubCtaDeudaInvBan.modificacion:
			mensaje = subCtaDeudaInvBanDAO.modifica(subCtaDeudaInvBanBean);
			break;
		case Enum_Tra_SubCtaDeudaInvBan.baja:
			mensaje = subCtaDeudaInvBanDAO.baja(subCtaDeudaInvBanBean);
			break;
		}
		return mensaje;
	}

	public SubCtaDeudaInvBanDAO getSubCtaDeudaInvBanDAO() {
		return subCtaDeudaInvBanDAO;
	}


	public void setSubCtaDeudaInvBanDAO(SubCtaDeudaInvBanDAO subCtaDeudaInvBanDAO) {
		this.subCtaDeudaInvBanDAO = subCtaDeudaInvBanDAO;
	}


	
}