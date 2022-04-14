package aportaciones.servicio;

import general.servicio.BaseServicio;
import aportaciones.bean.SubCtaTiProAportacionBean;
import aportaciones.dao.SubCtaTiProAportacionDAO;

public class SubCtaTiProAportacionServicio extends BaseServicio{
	
	private SubCtaTiProAportacionServicio(){
		super();
	}
 
	SubCtaTiProAportacionDAO subCtaTiProAportacionDAO = null;
	
	public static interface Enum_Tra_SubCtaTiProAportacion {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}
	
	public static interface Enum_Con_SubCtaTiProAportacion {
		int principal = 1;
	}
	
	public SubCtaTiProAportacionBean consulta(int tipoConsulta, SubCtaTiProAportacionBean subCtaTiProAportacion){
		SubCtaTiProAportacionBean subCtaTiProAporBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaTiProAportacion.principal:
				subCtaTiProAporBean = subCtaTiProAportacionDAO.consultaPrincipal(subCtaTiProAportacion, Enum_Con_SubCtaTiProAportacion.principal);
			break;		
		}
		return subCtaTiProAporBean;
	}

	public SubCtaTiProAportacionDAO getSubCtaTiProAportacionDAO() {
		return subCtaTiProAportacionDAO;
	}

	public void setSubCtaTiProAportacionDAO(
			SubCtaTiProAportacionDAO subCtaTiProAportacionDAO) {
		this.subCtaTiProAportacionDAO = subCtaTiProAportacionDAO;
	}

}
