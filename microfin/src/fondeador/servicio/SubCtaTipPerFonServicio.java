package fondeador.servicio;

import fondeador.bean.SubCtaTipPerFonBean;
import fondeador.dao.SubCtaTipPerFonDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class SubCtaTipPerFonServicio extends BaseServicio{

	private SubCtaTipPerFonServicio(){
		super();
	}

	SubCtaTipPerFonDAO subCtaTipPerFonDAO = new SubCtaTipPerFonDAO();

	public static interface Enum_Tra_SubCtaTipPerFon {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaTipPerFon{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubCtaTipPerFon{
		int principal = 1;
		int foranea = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SubCtaTipPerFonBean subCtaTipPerFonBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_SubCtaTipPerFon.alta:
			mensaje = subCtaTipPerFonDAO.alta(subCtaTipPerFonBean);
			break;
		case Enum_Tra_SubCtaTipPerFon.baja:
			mensaje = subCtaTipPerFonDAO.baja(subCtaTipPerFonBean);
			break;
		case Enum_Tra_SubCtaTipPerFon.modificacion:
			mensaje = subCtaTipPerFonDAO.modifica(subCtaTipPerFonBean);
			break;
		}
		return mensaje;
	}
	
	public SubCtaTipPerFonBean consulta(int tipoConsulta, SubCtaTipPerFonBean subCtaTipPerFonBean){
		SubCtaTipPerFonBean subCtaTipPerFon = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaTipPerFon.principal:
				subCtaTipPerFon = subCtaTipPerFonDAO.consultaPrincipal(subCtaTipPerFonBean, Enum_Con_SubCtaTipPerFon.principal);
			break;		
		}
		return subCtaTipPerFon;
	}

	public SubCtaTipPerFonDAO getSubCtaTipPerFonDAO() {
		return subCtaTipPerFonDAO;
	}

	public void setSubCtaTipPerFonDAO(SubCtaTipPerFonDAO subCtaTipPerFonDAO) {
		this.subCtaTipPerFonDAO = subCtaTipPerFonDAO;
	}
	
	
}

