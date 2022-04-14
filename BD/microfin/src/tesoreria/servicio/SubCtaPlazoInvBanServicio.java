package tesoreria.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import tesoreria.bean.SubCtaPlazoInvBanBean;
import tesoreria.dao.SubCtaPlazoInvBanDAO;

public class SubCtaPlazoInvBanServicio extends BaseServicio {
	
	SubCtaPlazoInvBanDAO subCtaPlazoInvBanDAO = null;
	
	private SubCtaPlazoInvBanServicio(){
		super();
	}
	
	public static interface Enum_Tra_SubCtaPlazoInvBan {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaPlazoInvBan{
		int principal = 1;
	}

	/**
	 * Consulta a las subcuentas por plazo de el Modulo de Inversiones Bancarias para la Guia Contable
	 * @param tipoConsulta
	 * @param subCtaMonedaDiv
	 * @return
	 */
	public SubCtaPlazoInvBanBean consulta(int tipoConsulta, SubCtaPlazoInvBanBean subCtaPlazoInvBanBean){
		SubCtaPlazoInvBanBean subCta= null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaPlazoInvBan.principal:
				subCta = subCtaPlazoInvBanDAO.consultaPrincipal(subCtaPlazoInvBanBean,tipoConsulta);
			break;		
		}
		return subCta;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccionPB, SubCtaPlazoInvBanBean subCtaPlazoInvBanBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccionPB) {
		case Enum_Tra_SubCtaPlazoInvBan.alta:
			mensaje = subCtaPlazoInvBanDAO.alta(subCtaPlazoInvBanBean);
			break;
		case Enum_Tra_SubCtaPlazoInvBan.modificacion:
			mensaje = subCtaPlazoInvBanDAO.modifica(subCtaPlazoInvBanBean);
			break;
		case Enum_Tra_SubCtaPlazoInvBan.baja:
			mensaje = subCtaPlazoInvBanDAO.baja(subCtaPlazoInvBanBean);
			break;
		}
		return mensaje;
	}
	

	public SubCtaPlazoInvBanDAO getSubCtaPlazoInvBanDAO() {
		return subCtaPlazoInvBanDAO;
	}

	public void setSubCtaPlazoInvBanDAO(SubCtaPlazoInvBanDAO subCtaPlazoInvBanDAO) {
		this.subCtaPlazoInvBanDAO = subCtaPlazoInvBanDAO;
	}


	

	
}