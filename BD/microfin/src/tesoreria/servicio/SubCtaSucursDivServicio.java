package tesoreria.servicio;


import tesoreria.bean.SubCtaSucursDivBean;
import tesoreria.dao.SubCtaSucursDivDAO;
import general.servicio.BaseServicio;

public class SubCtaSucursDivServicio extends BaseServicio{

	
	private SubCtaSucursDivServicio(){
		super();
	}
	
	
SubCtaSucursDivDAO subCtaSucursDivDAO = null;
	
	public static interface Enum_Tra_SubCtaSucurs {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaSucurs {
		int principal = 1;
	}

	
	public SubCtaSucursDivBean consulta(int tipoConsulta, SubCtaSucursDivBean subCtaSucursDivBean){
		SubCtaSucursDivBean subCtaSucursDiv = null;		
		switch(tipoConsulta){
			case Enum_Con_SubCtaSucurs.principal:
				subCtaSucursDiv = subCtaSucursDivDAO.consultaSubCtaSucursal(subCtaSucursDivBean, Enum_Con_SubCtaSucurs.principal);
			break;		
		}
		return subCtaSucursDiv;
	}


	//-------------------getter y setters
	public SubCtaSucursDivDAO getSubCtaSucursDivDAO() {
		return subCtaSucursDivDAO;
	}


	public void setSubCtaSucursDivDAO(SubCtaSucursDivDAO subCtaSucursDivDAO) {
		this.subCtaSucursDivDAO = subCtaSucursDivDAO;
	}
	
	
	
}
