package cedes.servicio;

import cedes.bean.SubCtaTiProCedeBean;
import cedes.dao.SubCtaTiProCedeDAO;
import inversiones.bean.SubCtaTiProInvBean;
import inversiones.dao.SubCtaTiProInvDAO;
import inversiones.servicio.SubCtaTiProInvServicio.Enum_Con_SubCtaTiProInv;
import general.servicio.BaseServicio;

public class SubCtaTiProCedeServicio extends BaseServicio{

	private SubCtaTiProCedeServicio(){
		super();
	}
 
	SubCtaTiProCedeDAO subCtaTiProCedeDAO = null;

	public static interface Enum_Tra_SubCtaTiProCede {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}
	
	public static interface Enum_Con_SubCtaTiProCede{
		int principal = 1;
	}
	
	public SubCtaTiProCedeBean consulta(int tipoConsulta, SubCtaTiProCedeBean subCtaTiProCede){
		SubCtaTiProCedeBean subCtaTiProCedeBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaTiProCede.principal:
				subCtaTiProCedeBean = subCtaTiProCedeDAO.consultaPrincipal(subCtaTiProCede, Enum_Con_SubCtaTiProCede.principal);
			break;		
		}
		return subCtaTiProCedeBean;
	}

	public SubCtaTiProCedeDAO getSubCtaTiProCedeDAO() {
		return subCtaTiProCedeDAO;
	}

	public void setSubCtaTiProCedeDAO(SubCtaTiProCedeDAO subCtaTiProCedeDAO) {
		this.subCtaTiProCedeDAO = subCtaTiProCedeDAO;
	}


}
