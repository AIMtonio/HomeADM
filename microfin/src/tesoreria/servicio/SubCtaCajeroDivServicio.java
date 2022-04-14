package tesoreria.servicio;

import tesoreria.bean.SubCtaCajeroDivBean;
import tesoreria.dao.SubCtaCajeroDivDAO;
import tesoreria.servicio.SubCtaSucursDivServicio.Enum_Con_SubCtaSucurs;
import general.servicio.BaseServicio;

public class SubCtaCajeroDivServicio extends BaseServicio{
	
	private SubCtaCajeroDivServicio (){
		super();
	}
	
	SubCtaCajeroDivDAO subCtaCajeroDivDAO =null;

	public static interface Enum_Tra_SubCtaCajero {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaCajero {
		int principal = 1;
	}

	
	public SubCtaCajeroDivBean consulta(int tipoConsulta, SubCtaCajeroDivBean subCtaCajeroDivBean){
		SubCtaCajeroDivBean subCtaCajeroDiv = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaSucurs.principal:
				subCtaCajeroDiv = subCtaCajeroDivDAO.consultaSubCtaCaja(subCtaCajeroDivBean, Enum_Con_SubCtaSucurs.principal);
			break;		
		}
		return subCtaCajeroDiv;
	}


	
	//---------------------getter y setter
	public SubCtaCajeroDivDAO getSubCtaCajeroDivDAO() {
		return subCtaCajeroDivDAO;
	}

	public void setSubCtaCajeroDivDAO(SubCtaCajeroDivDAO subCtaCajeroDivDAO) {
		this.subCtaCajeroDivDAO = subCtaCajeroDivDAO;
	}
	
	
	

}
