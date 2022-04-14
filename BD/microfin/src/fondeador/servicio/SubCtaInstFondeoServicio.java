package fondeador.servicio;

import fondeador.bean.SubCtaInstFonBean;
import fondeador.bean.SubCtaTipInstFonBean;
import fondeador.dao.SubCtaInsFonDAO;
import fondeador.dao.SubCtaTipInsFonDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class SubCtaInstFondeoServicio extends BaseServicio{

	private SubCtaInstFondeoServicio(){
		super();
	}

	SubCtaInsFonDAO subCtaInsFonDAO = null;



	public static interface Enum_Tra_SubCtaInsFon {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaInsFon{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubCtaInsFon{
		int principal = 1;
		int foranea = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SubCtaInstFonBean subCtaInstFonBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_SubCtaInsFon.alta:
			mensaje = subCtaInsFonDAO.alta(subCtaInstFonBean);
			break;
		case Enum_Tra_SubCtaInsFon.baja:
			mensaje = subCtaInsFonDAO.baja(subCtaInstFonBean);
			break;
		case Enum_Tra_SubCtaInsFon.modificacion:
			mensaje = subCtaInsFonDAO.modifica(subCtaInstFonBean);
			break;
		}
		return mensaje;
	}
	
	public SubCtaInstFonBean consulta(int tipoConsulta, SubCtaInstFonBean subCtaInstFon){
		SubCtaInstFonBean subCtaInstFonBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaInsFon.principal:
				subCtaInstFonBean = subCtaInsFonDAO.consultaPrincipal(subCtaInstFon, Enum_Con_SubCtaInsFon.principal);
			break;		
		}
		return subCtaInstFonBean;
	}
	public SubCtaInsFonDAO getSubCtaInsFonDAO() {
		return subCtaInsFonDAO;
	}

	public void setSubCtaInsFonDAO(SubCtaInsFonDAO subCtaInsFonDAO) {
		this.subCtaInsFonDAO = subCtaInsFonDAO;
	}

	
}

