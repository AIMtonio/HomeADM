package cedes.servicio;

import java.util.List;

import cedes.bean.PlazosPorProductosBean;
import cedes.dao.PlazosPorProductosDAO;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;

public class PlazosPorProductosServicio extends BaseServicio{
	 
	public PlazosPorProductosServicio(){
		super();
	}
	
	PlazosPorProductosDAO plazosPorProductosDAO=null;
	ParametrosSesionBean parametrosSesionBean;

	public static interface Enum_Lis_PlazosPorProductos{
		int plazos	= 1;
	}
	
	//Lista Plazos Por Producto
	public List lista(int tipoLista, PlazosPorProductosBean plazosPorProductosBean){
		List listaPlazosPorProductos = null;
		
		switch (tipoLista){
		case Enum_Lis_PlazosPorProductos.plazos:
			listaPlazosPorProductos= plazosPorProductosDAO.listaPlazos(tipoLista,plazosPorProductosBean);
		}
		return listaPlazosPorProductos;
	}

	public PlazosPorProductosDAO getPlazosPorProductosDAO() {
		return plazosPorProductosDAO;
	}

	public void setPlazosPorProductosDAO(PlazosPorProductosDAO plazosPorProductosDAO) {
		this.plazosPorProductosDAO = plazosPorProductosDAO;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
	
}
