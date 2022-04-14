package originacion.servicio;

import originacion.bean.CatdatsocioeBean;
import originacion.dao.CatDatSocioEDAO;
import general.servicio.BaseServicio;

public class CatDatSocioEServicio extends BaseServicio{
	CatDatSocioEDAO	catDatSocioEDAO	=null;

	
	
	
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_CatDatSocioE {
		int principal = 1;
	}	
	
	public CatdatsocioeBean consulta(int tipoConsulta, CatdatsocioeBean catdatsocioeBean){
		CatdatsocioeBean catdatsocioe = null;
		switch (tipoConsulta) {
			case Enum_Con_CatDatSocioE.principal:	
				catdatsocioe = catDatSocioEDAO.consultaPrincipal(catdatsocioeBean,tipoConsulta);
				break;									
		}				
		return catdatsocioe;
	}
	
	//-----------getter y setter -----------
	
	public CatDatSocioEDAO getCatDatSocioEDAO() {
		return catDatSocioEDAO;
	}

	public void setCatDatSocioEDAO(CatDatSocioEDAO catDatSocioEDAO) {
		this.catDatSocioEDAO = catDatSocioEDAO;
	}
	
	
	
}
