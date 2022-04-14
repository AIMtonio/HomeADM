package spei.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
 

import reporte.ParametrosReporte;
import reporte.Reporte;
import spei.bean.RepRecepcionesSpeiiBean;
import spei.dao.RepRecepcionesSpeiiDAO;
import general.servicio.BaseServicio;

public class RepRecepcionesSpeiiServicio extends BaseServicio{
	RepRecepcionesSpeiiDAO repRecepcionesSpeiiDAO = null;
	
	private RepRecepcionesSpeiiServicio(){
		super();
	}
	

	public List ListaRep(
			RepRecepcionesSpeiiBean repRecepcionesSpeiBean,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		List lista =null;
		
		
		
		lista = repRecepcionesSpeiiDAO.consulta(repRecepcionesSpeiBean); 
		return lista;
	}
	
	public RepRecepcionesSpeiiDAO getRepRecepcionesSpeiiDAO() {
		return repRecepcionesSpeiiDAO;
	}


	public void setRepRecepcionesSpeiiDAO(
			RepRecepcionesSpeiiDAO repRecepcionesSpeiiDAO) {
		this.repRecepcionesSpeiiDAO = repRecepcionesSpeiiDAO;
	}




}
