package aportaciones.servicio;

import aportaciones.bean.SubCtaMonedaAportacionBean;
import aportaciones.dao.SubCtaMonedaAportacionDAO;
import general.servicio.BaseServicio;

public class SubCtaMonedaAportacionServicio extends BaseServicio{
	
	private SubCtaMonedaAportacionServicio(){
		super();
	}

	SubCtaMonedaAportacionDAO subCtaMonedaAportacionDAO = null;
	
	public static interface Enum_Tra_SubCtaMonedaAportacion {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_SubCtaMonedaAportacion{
		int principal = 1;
	}
	
	public SubCtaMonedaAportacionBean consulta(int tipoConsulta, SubCtaMonedaAportacionBean subCtaMonedaAportacion){
		SubCtaMonedaAportacionBean subCtaMonedaAportacionBean = null;
		switch(tipoConsulta){
			case Enum_Con_SubCtaMonedaAportacion.principal:
				subCtaMonedaAportacionBean = subCtaMonedaAportacionDAO.consultaPrincipal(subCtaMonedaAportacion, Enum_Con_SubCtaMonedaAportacion.principal);
			break;		
		}
		return subCtaMonedaAportacionBean;
	}

	public SubCtaMonedaAportacionDAO getSubCtaMonedaAportacionDAO() {
		return subCtaMonedaAportacionDAO;
	}

	public void setSubCtaMonedaAportacionDAO(
			SubCtaMonedaAportacionDAO subCtaMonedaAportacionDAO) {
		this.subCtaMonedaAportacionDAO = subCtaMonedaAportacionDAO;
	}

}
