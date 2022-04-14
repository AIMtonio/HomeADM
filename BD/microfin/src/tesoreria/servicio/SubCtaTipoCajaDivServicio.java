package tesoreria.servicio;

import tesoreria.bean.SubCtaTipoCajaDivBean;
import tesoreria.dao.SubCtaTipoCajaDivDAO;
import tesoreria.servicio.SubCtaSucursDivServicio.Enum_Con_SubCtaSucurs;
import general.servicio.BaseServicio;

public class SubCtaTipoCajaDivServicio extends BaseServicio{

	private SubCtaTipoCajaDivServicio (){
		super();		
	}
	
	SubCtaTipoCajaDivDAO subCtaTipoCajaDivDAO =null;

	
	public static interface Enum_Tra_SubCtaTipoCaja {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaTipoCaja {
		int principal = 1;
	}

	
	public SubCtaTipoCajaDivBean consulta(int tipoConsulta, SubCtaTipoCajaDivBean subCtaTipoCajaDivBean){				
		SubCtaTipoCajaDivBean subCtaCajeroDiv = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaSucurs.principal:
				subCtaCajeroDiv = subCtaTipoCajaDivDAO.consultaSubCtaTipoCaja(subCtaTipoCajaDivBean, Enum_Con_SubCtaSucurs.principal);
			break;		
		}
		return subCtaCajeroDiv;
	}

	
	//---------------------getter y setter------------
	public SubCtaTipoCajaDivDAO getSubCtaTipoCajaDivDAO() {
		return subCtaTipoCajaDivDAO;
	}

	public void setSubCtaTipoCajaDivDAO(SubCtaTipoCajaDivDAO subCtaTipoCajaDivDAO) {
		this.subCtaTipoCajaDivDAO = subCtaTipoCajaDivDAO;
	}
	
	
	
	
}
