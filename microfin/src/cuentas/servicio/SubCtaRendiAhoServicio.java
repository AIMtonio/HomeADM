package cuentas.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cuentas.dao.SubCtaRendiAhoDAO;
import cuentas.servicio.SubCtaRendiAhoServicio.Enum_Con_SubCtaRendiAho;
import cuentas.bean.SubCtaRendiAhoBean;
import cuentas.bean.SubCtaRendiAhoBean;

public class SubCtaRendiAhoServicio extends BaseServicio {

	private SubCtaRendiAhoServicio(){
		super();
	}

	SubCtaRendiAhoDAO subCtaRendiAhoDAO = null;

	public static interface Enum_Tra_SubCtaRendiAho {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaRendiAho{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubCtaRendiAho{
		int principal = 1;
		int foranea = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SubCtaRendiAhoBean subCtaRendiAho){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_SubCtaRendiAho.alta:
			mensaje = subCtaRendiAhoDAO.alta(subCtaRendiAho);
			break;
		case Enum_Tra_SubCtaRendiAho.modificacion:
			mensaje = subCtaRendiAhoDAO.modifica(subCtaRendiAho);
			break;
		case Enum_Tra_SubCtaRendiAho.baja:
			mensaje = subCtaRendiAhoDAO.baja(subCtaRendiAho);
			break;
		}
		return mensaje;
	}
	
	public SubCtaRendiAhoBean consulta(int tipoConsulta, SubCtaRendiAhoBean subCtaRendiAho){
		SubCtaRendiAhoBean subCtaRendiAhoBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaRendiAho.principal:
				subCtaRendiAhoBean = subCtaRendiAhoDAO.consultaPrincipal(subCtaRendiAho, Enum_Con_SubCtaRendiAho.principal);
			break;		
		}
		return subCtaRendiAhoBean;
	}

	public void setSubCtaRendiAhoDAO(SubCtaRendiAhoDAO subCtaRendiAhoDAO) {
		this.subCtaRendiAhoDAO = subCtaRendiAhoDAO;
	}
	
}

