package tesoreria.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import tesoreria.bean.SubCtaInstInvBanBean;
import tesoreria.dao.SubCtaInstInvBanDAO;

public class SubCtaInstInvBanServicio extends BaseServicio {

	SubCtaInstInvBanDAO subCtaInstInvBanDAO = null;

	private SubCtaInstInvBanServicio() {
		super();
	}

	public static interface Enum_Tra_SubCtaInstInvBan {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaInstInvBan {
		int principal = 1;
	}

	public SubCtaInstInvBanBean consulta(int tipoConsulta, SubCtaInstInvBanBean subCtaInstInvBanBean) {
		SubCtaInstInvBanBean subCta = null;
		switch (tipoConsulta) {
		case Enum_Con_SubCtaInstInvBan.principal:
			subCta = subCtaInstInvBanDAO.consultaPrincipal(subCtaInstInvBanBean, tipoConsulta);
			break;
		}
		return subCta;
	}

	public SubCtaInstInvBanDAO getSubCtaInstInvBanDAO() {
		return subCtaInstInvBanDAO;
	}

	public void setSubCtaInstInvBanDAO(SubCtaInstInvBanDAO subCtaInstInvBanDAO) {
		this.subCtaInstInvBanDAO = subCtaInstInvBanDAO;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccionTM, SubCtaInstInvBanBean subCtaInstInvBanBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccionTM) {
		case Enum_Tra_SubCtaInstInvBan.alta:
			mensaje = subCtaInstInvBanDAO.alta(subCtaInstInvBanBean);
			break;
		case Enum_Tra_SubCtaInstInvBan.modificacion:
			mensaje = subCtaInstInvBanDAO.modifica(subCtaInstInvBanBean);
			break;
		case Enum_Tra_SubCtaInstInvBan.baja:
			mensaje = subCtaInstInvBanDAO.baja(subCtaInstInvBanBean);
			break;
		}
		return mensaje;
	}

}