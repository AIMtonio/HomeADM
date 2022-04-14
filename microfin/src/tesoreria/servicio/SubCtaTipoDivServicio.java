package tesoreria.servicio;


import tesoreria.bean.SubCtaTipoDivBean;
import tesoreria.dao.SubCtaTipoDivDAO;
import general.servicio.BaseServicio;

public class SubCtaTipoDivServicio extends BaseServicio {
	
	private SubCtaTipoDivServicio(){
		super();
	}
	
	SubCtaTipoDivDAO subCtaTipoDivDAO = null;
	
	public static interface Enum_Tra_SubCtaTipoDiv {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaTipoDiv {
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubCtaTipoDiv {
		int principal = 1;
		int foranea = 2;
	}
	
	public SubCtaTipoDivBean consulta(int tipoConsulta, SubCtaTipoDivBean subCtaTipoDiv){
		SubCtaTipoDivBean subCtaTipoDivBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaTipoDiv.principal:
				subCtaTipoDivBean = subCtaTipoDivDAO.consultaPrincipal(subCtaTipoDiv, Enum_Con_SubCtaTipoDiv.principal);
			break;		
		}
		return subCtaTipoDivBean;
	}

	public SubCtaTipoDivDAO getSubCtaTipoDivDAO() {
		return subCtaTipoDivDAO;
	}

	public void setSubCtaTipoDivDAO(SubCtaTipoDivDAO subCtaTipoDivDAO) {
		this.subCtaTipoDivDAO = subCtaTipoDivDAO;
	}
	
	
	
}
