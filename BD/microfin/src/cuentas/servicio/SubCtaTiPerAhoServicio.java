package cuentas.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cuentas.dao.SubCtaTiPerAhoDAO;
import cuentas.servicio.SubCtaTiPerAhoServicio.Enum_Con_SubCtaTiPerAho;
import cuentas.bean.SubCtaTiPerAhoBean;
import cuentas.bean.SubCtaTiPerAhoBean;

public class SubCtaTiPerAhoServicio extends BaseServicio {

	private SubCtaTiPerAhoServicio(){
		super();
	}

	SubCtaTiPerAhoDAO subCtaTiPerAhoDAO = null;

	public static interface Enum_Tra_SubCtaTiPerAho {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaTiPerAho{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubCtaTiPerAho{
		int principal = 1;
		int foranea = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SubCtaTiPerAhoBean subCtaTiPerAho){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_SubCtaTiPerAho.alta:
			mensaje = subCtaTiPerAhoDAO.alta(subCtaTiPerAho);
			break;
		case Enum_Tra_SubCtaTiPerAho.modificacion:
			mensaje = subCtaTiPerAhoDAO.modifica(subCtaTiPerAho);
			break;
		case Enum_Tra_SubCtaTiPerAho.baja:
			mensaje = subCtaTiPerAhoDAO.baja(subCtaTiPerAho);
			break;
		}
		return mensaje;
	}
	
	public SubCtaTiPerAhoBean consulta(int tipoConsulta, SubCtaTiPerAhoBean subCtaTiPerAho){
		SubCtaTiPerAhoBean subCtaTiPerAhoBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaTiPerAho.principal:
				subCtaTiPerAhoBean = subCtaTiPerAhoDAO.consultaPrincipal(subCtaTiPerAho, Enum_Con_SubCtaTiPerAho.principal);
			break;		
		}
		return subCtaTiPerAhoBean;
	}

	public void setSubCtaTiPerAhoDAO(SubCtaTiPerAhoDAO subCtaTiPerAhoDAO) {
		this.subCtaTiPerAhoDAO = subCtaTiPerAhoDAO;
	}
	
}


