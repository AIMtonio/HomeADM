package fondeador.servicio;

import cuentas.bean.SubCtaTiProAhoBean;
import fondeador.bean.SubCtaTiInstCreditoPasBean;
import fondeador.dao.SubCtaTiInstCreditoPasDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class SubCtaTiInstCreditoPasServicio extends BaseServicio{

	private SubCtaTiInstCreditoPasServicio(){
		super();
	}

	SubCtaTiInstCreditoPasDAO subCtaTiInstCreditoPasDAO = null;

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

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SubCtaTiInstCreditoPasBean subCtaTiInstCreditoPas){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_SubCtaTiProAho.alta:
			mensaje = subCtaTiInstCreditoPasDAO.alta(subCtaTiInstCreditoPas);
			break;
		case Enum_Tra_SubCtaTiProAho.baja:
			mensaje = subCtaTiInstCreditoPasDAO.baja(subCtaTiInstCreditoPas);
			break;
		case Enum_Tra_SubCtaTiProAho.modificacion:
			mensaje = subCtaTiInstCreditoPasDAO.modifica(subCtaTiInstCreditoPas);
			break;
		}
		return mensaje;
	}
	
	public SubCtaTiProAhoBean consulta(int tipoConsulta, SubCtaTiInstCreditoPasBean subCtaTiInstCreditoPas){
		SubCtaTiProAhoBean subCtaTiProAhoBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaTiProAho.principal:
				subCtaTiProAhoBean = subCtaTiInstCreditoPasDAO.consultaPrincipal(subCtaTiInstCreditoPas, Enum_Con_SubCtaTiProAho.principal);
			break;		
		}
		return subCtaTiProAhoBean;
	}

	public SubCtaTiInstCreditoPasDAO getSubCtaTiInstCreditoPasDAO() {
		return subCtaTiInstCreditoPasDAO;
	}

	public void setSubCtaTiInstCreditoPasDAO(
			SubCtaTiInstCreditoPasDAO subCtaTiInstCreditoPasDAO) {
		this.subCtaTiInstCreditoPasDAO = subCtaTiInstCreditoPasDAO;
	}

	
}

