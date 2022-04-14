package cuentas.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cuentas.dao.SubCtaTiProAhoDAO;
import cuentas.servicio.SubCtaTiProAhoServicio.Enum_Con_SubCtaTiProAho;
import cuentas.bean.SubCtaTiProAhoBean;
import cuentas.bean.SubCtaTiProAhoBean;

public class SubCtaTiProAhoServicio extends BaseServicio {

	private SubCtaTiProAhoServicio(){
		super();
	}

	SubCtaTiProAhoDAO subCtaTiProAhoDAO = null;

	public static interface Enum_Tra_SubCtaTiProAho {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaTiProAho{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubCtaTiProAho{
		int principal = 1;
		int foranea = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SubCtaTiProAhoBean subCtaTiProAho){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_SubCtaTiProAho.alta:
			mensaje = subCtaTiProAhoDAO.alta(subCtaTiProAho);
			break;
		case Enum_Tra_SubCtaTiProAho.baja:
			mensaje = subCtaTiProAhoDAO.baja(subCtaTiProAho);
			break;
		case Enum_Tra_SubCtaTiProAho.modificacion:
			mensaje = subCtaTiProAhoDAO.modifica(subCtaTiProAho);
			break;
		}
		return mensaje;
	}
	
	public SubCtaTiProAhoBean consulta(int tipoConsulta, SubCtaTiProAhoBean subCtaTiProAho){
		SubCtaTiProAhoBean subCtaTiProAhoBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaTiProAho.principal:
				subCtaTiProAhoBean = subCtaTiProAhoDAO.consultaPrincipal(subCtaTiProAho, Enum_Con_SubCtaTiProAho.principal);
			break;		
		}
		return subCtaTiProAhoBean;
	}

	public void setSubCtaTiProAhoDAO(SubCtaTiProAhoDAO subCtaTiProAhoDAO) {
		this.subCtaTiProAhoDAO = subCtaTiProAhoDAO;
	}
}

