package cedes.servicio;

import cedes.bean.SubCtaTiPerCedeBean;
import cedes.dao.SubCtaTiPerCedeDAO;
import general.servicio.BaseServicio;

public class SubCtaTiPerCedeServicio extends BaseServicio{
	
	private SubCtaTiPerCedeServicio(){
		super();
	}
	 
	SubCtaTiPerCedeDAO subCtaTiPerCedeDAO = null;
	
	public static interface Enum_Tra_SubCtaTiPerCede {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaTiPerCede{
		int principal = 1;
	}
	
	public SubCtaTiPerCedeBean consulta(int tipoConsulta, SubCtaTiPerCedeBean subCtaTiPerCede){
		SubCtaTiPerCedeBean subCtaTiPerCedeBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaTiPerCede.principal:
				subCtaTiPerCedeBean = subCtaTiPerCedeDAO.consultaPrincipal(subCtaTiPerCede, Enum_Con_SubCtaTiPerCede.principal);
			break;		
		}
		return subCtaTiPerCedeBean;
	}

	public SubCtaTiPerCedeDAO getSubCtaTiPerCedeDAO() {
		return subCtaTiPerCedeDAO;
	}

	public void setSubCtaTiPerCedeDAO(SubCtaTiPerCedeDAO subCtaTiPerCedeDAO) {
		this.subCtaTiPerCedeDAO = subCtaTiPerCedeDAO;
	}


}
