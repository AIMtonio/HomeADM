package soporte.servicio;

import java.util.List;

import general.servicio.BaseServicio;
import soporte.bean.ReporteBean;
import soporte.bean.ReporteColumnasBean;
import soporte.bean.ReporteParametrosBean;
import soporte.dao.GenDinamicoRepDAO;

/**
 * 
 * @author pmontero
 *
 */
public class ReporteDinamicoServicio extends BaseServicio{

	GenDinamicoRepDAO genDinamicoRepDAO;
	
	public String getVista(ReporteBean bean) {
		return genDinamicoRepDAO.getVista(bean);
	}

	public ReporteBean encabezado(ReporteBean bean, int encabezado) {
		return genDinamicoRepDAO.encabezado(bean, encabezado);
	}
	
	public List<ReporteParametrosBean> getParametros(ReporteBean bean) {
		return genDinamicoRepDAO.getParametros(bean);
	}
	
	public List<ReporteColumnasBean> getColumnas(ReporteBean bean) {
		return genDinamicoRepDAO.getColumnas(bean);
	}
	
	public List<List<String>> getFilas(ReporteBean bean) {
		return genDinamicoRepDAO.getFilas(bean);
	}
	
	public GenDinamicoRepDAO getGenDinamicoRepDAO() {
		return genDinamicoRepDAO;
	}

	public void setGenDinamicoRepDAO(GenDinamicoRepDAO genDinamicoRepDAO) {
		this.genDinamicoRepDAO = genDinamicoRepDAO;
	}


}
