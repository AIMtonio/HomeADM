package ventanilla.servicio;

import ventanilla.bean.ReporteCoincidenciasRemesasBean;
import ventanilla.dao.ReporteCoincidenciasRemesasDAO;
import general.servicio.BaseServicio;
import java.util.List;

public class ReporteCoincidenciasRemesasServicio extends BaseServicio{
	
	ReporteCoincidenciasRemesasDAO reporteCoincidenciasRemesasDAO = null;
	
	private ReporteCoincidenciasRemesasServicio(){
		super();
	}
	
	public List listaReporteCoincidencias(ReporteCoincidenciasRemesasBean reporteCoincidenciasRemesasBean){
		List<ReporteCoincidenciasRemesasBean> listaRepCoincidencias = null;	
		listaRepCoincidencias = reporteCoincidenciasRemesasDAO.reporteCoincidenciasExcel(reporteCoincidenciasRemesasBean); 				
		return listaRepCoincidencias;
	}

	public ReporteCoincidenciasRemesasDAO getReporteCoincidenciasRemesasDAO() {
		return reporteCoincidenciasRemesasDAO;
	}

	public void setReporteCoincidenciasRemesasDAO(
			ReporteCoincidenciasRemesasDAO reporteCoincidenciasRemesasDAO) {
		this.reporteCoincidenciasRemesasDAO = reporteCoincidenciasRemesasDAO;
	}
	

}
