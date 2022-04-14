package spei.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Priority;

import spei.bean.RepSpeiEnviosBean;
import spei.dao.RepSpeiEnviosDAO;

import general.servicio.BaseServicio;

public class RepSpeiEnviosServicio extends BaseServicio{
	private RepSpeiEnviosServicio(){
		super();
	}
	
	RepSpeiEnviosDAO repSpeiEnviosDAO = null;
	
	public static interface Enum_Num_Reporte {
		int principal = 1;
	}
	
	public List <RepSpeiEnviosBean> listaReporte(int numReporte, RepSpeiEnviosBean repSpeiEnviosBean , HttpServletResponse response){
		 List<RepSpeiEnviosBean> listaSpeiEnvios = null;
	
		switch(numReporte){		
			case  Enum_Num_Reporte.principal:
				listaSpeiEnvios = repSpeiEnviosDAO.listaReporte(repSpeiEnviosBean, numReporte);
				break;
			}
		
		return listaSpeiEnvios;
	}

	public RepSpeiEnviosDAO getRepSpeiEnviosDAO() {
		return repSpeiEnviosDAO;
	}

	public void setRepSpeiEnviosDAO(RepSpeiEnviosDAO repSpeiEnviosDAO) {
		this.repSpeiEnviosDAO = repSpeiEnviosDAO;
	}
}