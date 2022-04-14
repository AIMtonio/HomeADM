package fondeador.servicio;

import fondeador.bean.SubCtaTipInstFonBean;
import fondeador.dao.SubCtaTipInsFonDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class SubCtaTipInstFondeoServicio extends BaseServicio{

	private SubCtaTipInstFondeoServicio(){
		super();
	}

	SubCtaTipInsFonDAO subCtaTipInsFonDAO = null;

	public SubCtaTipInsFonDAO getSubCtaTipInsFonDAO() {
		return subCtaTipInsFonDAO;
	}

	public void setSubCtaTipInsFonDAO(SubCtaTipInsFonDAO subCtaTipInsFonDAO) {
		this.subCtaTipInsFonDAO = subCtaTipInsFonDAO;
	}

	public static interface Enum_Tra_SubCtaTipInsFon {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaTipInsFon{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubCtaTipInsFon{
		int principal = 1;
		int foranea = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SubCtaTipInstFonBean subCtaTipInstFonBean){
		System.out.println("service--"+subCtaTipInstFonBean.getTipoInstitID());
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_SubCtaTipInsFon.alta:
			mensaje = subCtaTipInsFonDAO.alta(subCtaTipInstFonBean);
			break;
		case Enum_Tra_SubCtaTipInsFon.baja:
			mensaje = subCtaTipInsFonDAO.baja(subCtaTipInstFonBean);
			break;
		case Enum_Tra_SubCtaTipInsFon.modificacion:
			mensaje = subCtaTipInsFonDAO.modifica(subCtaTipInstFonBean);
			break;
		}
		return mensaje;
	}
	
	public SubCtaTipInstFonBean consulta(int tipoConsulta, SubCtaTipInstFonBean subCtaTipInstFon){
		SubCtaTipInstFonBean subCtaTipInstFonBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaTipInsFon.principal:
				subCtaTipInstFonBean = subCtaTipInsFonDAO.consultaPrincipal(subCtaTipInstFon, Enum_Con_SubCtaTipInsFon.principal);
			break;	
			case Enum_Con_SubCtaTipInsFon.foranea:
				subCtaTipInstFonBean = subCtaTipInsFonDAO.consultaForanea(subCtaTipInstFon, Enum_Con_SubCtaTipInsFon.foranea);
			break;		
		}
		return subCtaTipInstFonBean;
	}

	
}

