package cliente.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import cliente.bean.RepInteresesPagadosBean;
import cliente.dao.RepInteresesPagadosDAO;
import general.servicio.BaseServicio;

public class RepInteresesPagadosServicio extends BaseServicio{
	
	private RepInteresesPagadosServicio(){
		super();
	}
	
	RepInteresesPagadosDAO repInteresesPagadosDAO = null;

	public static interface Enum_Tip_Reporte { 
		int excel = 1;		
	}
	
	public List <RepInteresesPagadosBean> listaReporte(int tipoReporte, RepInteresesPagadosBean repInteresesPagadosBean , HttpServletResponse response){
		 List <RepInteresesPagadosBean>listaInteresesPag=null;
	
		switch(tipoReporte){		
			case  Enum_Tip_Reporte.excel:				
				listaInteresesPag = repInteresesPagadosDAO.listaReporte(repInteresesPagadosBean, tipoReporte);
				break;
			}
		
		return listaInteresesPag;
	}

	public RepInteresesPagadosDAO getRepInteresesPagadosDAO() {
		return repInteresesPagadosDAO;
	}

	public void setRepInteresesPagadosDAO(
			RepInteresesPagadosDAO repInteresesPagadosDAO) {
		this.repInteresesPagadosDAO = repInteresesPagadosDAO;
	}
}
