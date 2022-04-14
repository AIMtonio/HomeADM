package fondeador.servicio;

import fondeador.bean.SubCtaMonFonBean;
import fondeador.dao.SubCtaMonFonDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class SubCtaMonFonServicio extends BaseServicio{
	public SubCtaMonFonServicio(){
		super();
	}
	SubCtaMonFonDAO subCtaMonFonDAO;
	
	public static interface Enum_Tra_SubCtaMonFon {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaMonFon{
		int principal = 1;
	}

	public static interface Enum_Lis_SubCtaMonFon{
		int principal = 1;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SubCtaMonFonBean SubCtaMonFonBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_SubCtaMonFon.alta:
			mensaje = subCtaMonFonDAO.alta(SubCtaMonFonBean);
			break;
		case Enum_Tra_SubCtaMonFon.baja:
			mensaje = subCtaMonFonDAO.baja(SubCtaMonFonBean);
			break;
		case Enum_Tra_SubCtaMonFon.modificacion:
			mensaje = subCtaMonFonDAO.modifica(SubCtaMonFonBean);
			break;
		}
		return mensaje;
	}
	
	public SubCtaMonFonBean consulta(int tipoConsulta, SubCtaMonFonBean subCtaMonFon){
		SubCtaMonFonBean subCtaMonFonBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaMonFon.principal:
				subCtaMonFonBean = subCtaMonFonDAO.consultaPrincipal(subCtaMonFon, Enum_Con_SubCtaMonFon.principal);
			break;		
		}
		return subCtaMonFonBean;
	}

	public SubCtaMonFonDAO getSubCtaMonFonDAO() {
		return subCtaMonFonDAO;
	}

	public void setSubCtaMonFonDAO(SubCtaMonFonDAO subCtaMonFonDAO) {
		this.subCtaMonFonDAO = subCtaMonFonDAO;
	}
	
}
