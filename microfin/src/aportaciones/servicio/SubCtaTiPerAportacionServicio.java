package aportaciones.servicio;

import aportaciones.bean.SubCtaTiPerAportacionBean;
import aportaciones.dao.SubCtaTiPerAportacionDAO;
import general.servicio.BaseServicio;

public class SubCtaTiPerAportacionServicio extends BaseServicio{
	
	private SubCtaTiPerAportacionServicio(){
		super();
	}
	 
	SubCtaTiPerAportacionDAO subCtaTiPerAportacionDAO = null;
	
	public static interface Enum_Tra_SubCtaTiPerAportacion {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaTiPerAportacion{
		int principal = 1;
	}
	
	public SubCtaTiPerAportacionBean consulta(int tipoConsulta, SubCtaTiPerAportacionBean subCtaTiPerAportacion){
		SubCtaTiPerAportacionBean subCtaTiPerAporBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaTiPerAportacion.principal:
				subCtaTiPerAporBean = subCtaTiPerAportacionDAO.consultaPrincipal(subCtaTiPerAportacion, Enum_Con_SubCtaTiPerAportacion.principal);
			break;		
		}
		return subCtaTiPerAporBean;
	}

	public SubCtaTiPerAportacionDAO getSubCtaTiPerAportacionDAO() {
		return subCtaTiPerAportacionDAO;
	}

	public void setSubCtaTiPerAportacionDAO(
			SubCtaTiPerAportacionDAO subCtaTiPerAportacionDAO) {
		this.subCtaTiPerAportacionDAO = subCtaTiPerAportacionDAO;
	}
	
}
