package tesoreria.servicio;


import tesoreria.bean.SubCtaMonedaDivBean;
import tesoreria.dao.SubCtaMonedaDivDAO;
import general.servicio.BaseServicio;

public class SubCtaMonedaDivServicio extends BaseServicio {
	
	private SubCtaMonedaDivServicio(){
		super();
	}
					   
	SubCtaMonedaDivDAO subCtaMonedaDivDAO = null;
	
	public static interface Enum_Tra_SubCtaMonedaDiv {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaMonedaDiv{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_SubCtaMonedaDiv{
		int principal = 1;
		int foranea = 2;
	}
	
	public SubCtaMonedaDivBean consulta(int tipoConsulta, SubCtaMonedaDivBean subCtaMonedaDiv){
		SubCtaMonedaDivBean subCtaMonedaDivBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaMonedaDiv.principal:
				subCtaMonedaDivBean = subCtaMonedaDivDAO.consultaPrincipal(subCtaMonedaDiv,tipoConsulta);
			break;		
		}
		return subCtaMonedaDivBean;
	}
	
	public SubCtaMonedaDivDAO getSubCtaMonedaDivDAO() {
		return subCtaMonedaDivDAO;
	}

	public void setSubCtaMonedaDivDAO(SubCtaMonedaDivDAO subCtaMonedaDivDAO) {
		this.subCtaMonedaDivDAO = subCtaMonedaDivDAO;
	}
	
	

}
