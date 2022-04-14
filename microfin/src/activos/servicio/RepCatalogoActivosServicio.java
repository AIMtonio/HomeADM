package activos.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import activos.bean.RepCatalogoActivosBean;
import activos.dao.RepCatalogoActivosDAO;

public class RepCatalogoActivosServicio extends BaseServicio{
	
	//---------- Variables ------------------------------------- //
	RepCatalogoActivosDAO repCatalogoActivosDAO = null;
	
	public RepCatalogoActivosServicio(){
		super();
	}
	
	// ------------ Reporte de Catalogo de Activos -------------- //
	public static interface Enum_Rep_Activos{
		int excel = 1;		
	}

	// Reporte Excel Catalogo de Activos 
	public List listaCatalogoActivos(int tipoLista,RepCatalogoActivosBean repCatalogoActivosBean, HttpServletResponse response){		
		List listaActivos = null;
		switch(tipoLista){
		case Enum_Rep_Activos.excel:
			listaActivos = repCatalogoActivosDAO.reporteCatalogoActivos(tipoLista,repCatalogoActivosBean);
			break;
		}
		return listaActivos;
	}

	/* ============== GETTER & SETTER ===================== */

	public RepCatalogoActivosDAO getRepCatalogoActivosDAO() {
		return repCatalogoActivosDAO;
	}

	public void setRepCatalogoActivosDAO(RepCatalogoActivosDAO repCatalogoActivosDAO) {
		this.repCatalogoActivosDAO = repCatalogoActivosDAO;
	}
}

