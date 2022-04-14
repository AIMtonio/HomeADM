package tesoreria.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import tesoreria.bean.CuentasMayorInvBanBean;
import tesoreria.bean.SubCtaMonedaInvBanBean;
import tesoreria.dao.SubCtaMonedaInvBanDAO;
import tesoreria.servicio.CuentasMayorInvBanServicio.Enum_Tra_CuentaMayorInv;

public class SubCtaMonedaInvBanServicio extends BaseServicio {
	
	SubCtaMonedaInvBanDAO subCtaMonedaInvBanDAO = null;
	
	private SubCtaMonedaInvBanServicio(){
		super();
	}
	
	public static interface Enum_Tra_SubCtaMoneda {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaMoneda{
		int principal = 1;
	}

	/**
	 * Consulta a las subcuentas de Divisas o Monedas para el Modulo de Inversiones Bancarias para la Guia Contable
	 * @param tipoConsulta
	 * @param subCtaMonedaDiv
	 * @return
	 */
	public SubCtaMonedaInvBanBean consulta(int tipoConsulta, SubCtaMonedaInvBanBean subCtaMonedaDiv){
		SubCtaMonedaInvBanBean subCta = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaMoneda.principal:
				subCta = subCtaMonedaInvBanDAO.consultaPrincipal(subCtaMonedaDiv,tipoConsulta);
			break;		
		}
		return subCta;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SubCtaMonedaInvBanBean subCtaMonedaInvBanBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_SubCtaMoneda.alta:
			mensaje = subCtaMonedaInvBanDAO.alta(subCtaMonedaInvBanBean);
			break;
		case Enum_Tra_SubCtaMoneda.modificacion:
			mensaje = subCtaMonedaInvBanDAO.modifica(subCtaMonedaInvBanBean);
			break;
		case Enum_Tra_SubCtaMoneda.baja:
			mensaje = subCtaMonedaInvBanDAO.baja(subCtaMonedaInvBanBean);
			break;
		}
		return mensaje;
	}


	public SubCtaMonedaInvBanDAO getSubCtaMonedaInvBanDAO() {
		return subCtaMonedaInvBanDAO;
	}


	public void setSubCtaMonedaInvBanDAO(SubCtaMonedaInvBanDAO subCtaMonedaInvBanDAO) {
		this.subCtaMonedaInvBanDAO = subCtaMonedaInvBanDAO;
	}
}
