package ventanilla.servicio;

import java.util.List;

import ventanilla.bean.ReporteRemitentesUsuarioBean;
import ventanilla.dao.ReporteRemitentesUsuarioDAO;
import general.servicio.BaseServicio;

public class ReporteRemitentesUsuarioServicio extends BaseServicio{
	
	ReporteRemitentesUsuarioDAO reporteRemitentesUsuarioDAO = null;
	
	private ReporteRemitentesUsuarioServicio(){
		super();
	}
	
	public List listaReporteRemitentes(ReporteRemitentesUsuarioBean reporteRemitentesUsuarioBean){
		List<ReporteRemitentesUsuarioBean> listaRepRemi = null;	
		listaRepRemi = reporteRemitentesUsuarioDAO.reporteRemitentesExcel(reporteRemitentesUsuarioBean); 				
		return listaRepRemi;
	}

	public ReporteRemitentesUsuarioDAO getReporteRemitentesUsuarioDAO() {
		return reporteRemitentesUsuarioDAO;
	}

	public void setReporteRemitentesUsuarioDAO(
			ReporteRemitentesUsuarioDAO reporteRemitentesUsuarioDAO) {
		this.reporteRemitentesUsuarioDAO = reporteRemitentesUsuarioDAO;
	}

}
