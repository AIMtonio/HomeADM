package fondeador.servicio;

import fondeador.bean.SubCtaNacInstFonBean;
import fondeador.bean.SubCtaTipInstFonBean;
import fondeador.dao.SubCtaNacInsFonDAO;
import fondeador.dao.SubCtaTipInsFonDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class SubCtaNacInstFondeoServicio extends BaseServicio{

	private SubCtaNacInstFondeoServicio(){
		super();
	}

	SubCtaNacInsFonDAO subCtaNacInsFonDAO = null;



	public static interface Enum_Tra_SubCtaNacInsFon {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaNacInsFon{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubCtaNacInsFon{
		int principal = 1;
		int foranea = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SubCtaNacInstFonBean subCtaNacInstFonBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_SubCtaNacInsFon.alta:
			mensaje = subCtaNacInsFonDAO.alta(subCtaNacInstFonBean);
			break;
		case Enum_Tra_SubCtaNacInsFon.baja:
			mensaje = subCtaNacInsFonDAO.baja(subCtaNacInstFonBean);
			break;
		case Enum_Tra_SubCtaNacInsFon.modificacion:
			mensaje = subCtaNacInsFonDAO.modifica(subCtaNacInstFonBean);
			break;
		}
		return mensaje;
	}
	
	public SubCtaNacInstFonBean consulta(int tipoConsulta, SubCtaNacInstFonBean subCtaNacInstFon){
		SubCtaNacInstFonBean subCtaNacInstFonBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaNacInsFon.principal:
				subCtaNacInstFonBean = subCtaNacInsFonDAO.consultaPrincipal(subCtaNacInstFon, Enum_Con_SubCtaNacInsFon.principal);
			break;		
		}
		return subCtaNacInstFonBean;
	}
	public SubCtaNacInsFonDAO getSubCtaNacInsFonDAO() {
		return subCtaNacInsFonDAO;
	}

	public void setSubCtaNacInsFonDAO(SubCtaNacInsFonDAO subCtaNacInsFonDAO) {
		this.subCtaNacInsFonDAO = subCtaNacInsFonDAO;
	}

	
}

