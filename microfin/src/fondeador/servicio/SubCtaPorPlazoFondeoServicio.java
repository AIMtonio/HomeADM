package fondeador.servicio;

import fondeador.bean.SubCtaPorPlazoFonBean;
import fondeador.bean.SubCtaTipInstFonBean;
import fondeador.dao.SubCtaPorPlazoFonDAO;
import fondeador.dao.SubCtaTipInsFonDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class SubCtaPorPlazoFondeoServicio extends BaseServicio{

	private SubCtaPorPlazoFondeoServicio(){
		super();
	}

	SubCtaPorPlazoFonDAO subCtaPorPlazoFonDAO = null;
	public static interface Enum_Tra_SubCtaPlazoFon {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaPlazoFon{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubCtaPlazoFon{
		int principal = 1;
		int foranea = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SubCtaPorPlazoFonBean subCtaPorPlazoFonBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_SubCtaPlazoFon.alta:
			mensaje = subCtaPorPlazoFonDAO.alta(subCtaPorPlazoFonBean);
			break;
		case Enum_Tra_SubCtaPlazoFon.baja:
			mensaje = subCtaPorPlazoFonDAO.baja(subCtaPorPlazoFonBean);
			break;
		case Enum_Tra_SubCtaPlazoFon.modificacion:
			mensaje = subCtaPorPlazoFonDAO.modifica(subCtaPorPlazoFonBean);
			break;
		}
		return mensaje;
	}
	
	public SubCtaPorPlazoFonBean consulta(int tipoConsulta, SubCtaPorPlazoFonBean subCtaPorPlazoFon){
		SubCtaPorPlazoFonBean subCtaPorPlazoFonBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaPlazoFon.principal:
				subCtaPorPlazoFonBean = subCtaPorPlazoFonDAO.consultaPrincipal(subCtaPorPlazoFon, Enum_Con_SubCtaPlazoFon.principal);
			break;		
		}
		return subCtaPorPlazoFonBean;
	}
	public SubCtaPorPlazoFonDAO getSubCtaPorPlazoFonDAO() {
		return subCtaPorPlazoFonDAO;
	}

	public void setSubCtaPorPlazoFonDAO(SubCtaPorPlazoFonDAO subCtaPorPlazoFonDAO) {
		this.subCtaPorPlazoFonDAO = subCtaPorPlazoFonDAO;
	}

	
}

