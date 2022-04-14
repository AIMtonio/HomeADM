package cuentas.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cuentas.dao.SubCtaMonedaAhoDAO;
import cuentas.bean.SubCtaMonedaAhoBean;

public class SubCtaMonedaAhoServicio extends BaseServicio {

	private SubCtaMonedaAhoServicio(){
		super();
	}

	SubCtaMonedaAhoDAO subCtaMonedaAhoDAO = null;

	public static interface Enum_Tra_SubCtaMonedaAho {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaMonedaAho{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubCtaMonedaAho{
		int principal = 1;
		int foranea = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SubCtaMonedaAhoBean subCtaMonedaAho){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_SubCtaMonedaAho.alta:
			mensaje = subCtaMonedaAhoDAO.alta(subCtaMonedaAho);
			break;
		case Enum_Tra_SubCtaMonedaAho.modificacion:
			mensaje = subCtaMonedaAhoDAO.modifica(subCtaMonedaAho);
			break;
		case Enum_Tra_SubCtaMonedaAho.baja:
			mensaje = subCtaMonedaAhoDAO.modifica(subCtaMonedaAho);
			break;
		}
		return mensaje;
	}

	public SubCtaMonedaAhoBean consulta(int tipoConsulta, SubCtaMonedaAhoBean subCtaMonedaAho){
		SubCtaMonedaAhoBean subCtaMonedaAhoBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaMonedaAho.principal:
				subCtaMonedaAhoBean = subCtaMonedaAhoDAO.consultaPrincipal(subCtaMonedaAho, Enum_Con_SubCtaMonedaAho.principal);
			break;		
		}
		return subCtaMonedaAhoBean;
	}
	
	public void setSubCtaMonedaAhoDAO(SubCtaMonedaAhoDAO subCtaMonedaAhoDAO) {
		this.subCtaMonedaAhoDAO = subCtaMonedaAhoDAO;
	}
}

