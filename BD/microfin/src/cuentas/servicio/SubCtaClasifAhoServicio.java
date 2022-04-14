package cuentas.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cuentas.dao.SubCtaClasifAhoDAO;
import cuentas.bean.SubCtaClasifAhoBean;

public class SubCtaClasifAhoServicio extends BaseServicio {

	private SubCtaClasifAhoServicio(){
		super();
	}

	SubCtaClasifAhoDAO subCtaClasifAhoDAO = null;

	public static interface Enum_Tra_SubCtaClasifAho {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaClasifAho{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubCtaClasifAho{
		int principal = 1;
		int foranea = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SubCtaClasifAhoBean subCtaClasifAho){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_SubCtaClasifAho.alta:
			mensaje = subCtaClasifAhoDAO.alta(subCtaClasifAho);
			break;
		case Enum_Tra_SubCtaClasifAho.baja:
			mensaje = subCtaClasifAhoDAO.baja(subCtaClasifAho);
			break;
		case Enum_Tra_SubCtaClasifAho.modificacion:
			mensaje = subCtaClasifAhoDAO.modifica(subCtaClasifAho);
			break;
		}
		return mensaje;
	}
	
	public SubCtaClasifAhoBean consulta(int tipoConsulta, SubCtaClasifAhoBean subCtaClasifAho){
		SubCtaClasifAhoBean subCtaClasifAhoBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaClasifAho.principal:
				subCtaClasifAhoBean = subCtaClasifAhoDAO.consultaPrincipal(subCtaClasifAho, Enum_Con_SubCtaClasifAho.principal);
			break;		
		}
		return subCtaClasifAhoBean;
	}

	public SubCtaClasifAhoDAO getSubCtaClasifAhoDAO() {
		return subCtaClasifAhoDAO;
	}

	public void setSubCtaClasifAhoDAO(SubCtaClasifAhoDAO subCtaClasifAhoDAO) {
		this.subCtaClasifAhoDAO = subCtaClasifAhoDAO;
	}
}

