package aportaciones.servicio;

import java.util.List;

import aportaciones.bean.SubCtaPlazoAportacionBean;
import aportaciones.dao.SubCtaPlazoAportacionDAO;
import general.servicio.BaseServicio;

public class SubCtaPlazoAportacionServicio extends BaseServicio{
	
	private SubCtaPlazoAportacionServicio(){
		super();
	}

	SubCtaPlazoAportacionDAO subCtaPlazoAportacionDAO = null;
	
	public static interface Enum_Tra_SubCtaPlazoAportacion {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaPlazoAportacion {
		int principal = 1;
	}
	
	public SubCtaPlazoAportacionBean consulta(int tipoConsulta, SubCtaPlazoAportacionBean subCtaPlazoAportacion){
		SubCtaPlazoAportacionBean subCtaPlazoAportacionBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaPlazoAportacion.principal:
				subCtaPlazoAportacionBean = subCtaPlazoAportacionDAO.consultaPrincipal(subCtaPlazoAportacion, Enum_Con_SubCtaPlazoAportacion.principal);
			break;		
		}
		return subCtaPlazoAportacionBean;
	}

	public SubCtaPlazoAportacionDAO getSubCtaPlazoAportacionDAO() {
		return subCtaPlazoAportacionDAO;
	}

	public void setSubCtaPlazoAportacionDAO(
			SubCtaPlazoAportacionDAO subCtaPlazoAportacionDAO) {
		this.subCtaPlazoAportacionDAO = subCtaPlazoAportacionDAO;
	}
	
	
}
