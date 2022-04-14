package soporte.servicio;

import java.util.List;

import general.servicio.BaseServicio;
import soporte.bean.GeneradorXMLBean;
import soporte.bean.GeneradorXMLEtiquetasBean;
import soporte.bean.ReporteBean;
import soporte.bean.ReporteParametrosBean;
import soporte.dao.GeneradorXLMDAO;

public class GeneradorXLMServicio extends BaseServicio {

	GeneradorXLMDAO generadorXLMDAO;
	

	public GeneradorXMLBean encabezado(GeneradorXMLBean bean, int encabezado) {
		return generadorXLMDAO.encabezado(bean, encabezado);
	}
	
	public List<ReporteParametrosBean> getParametros(GeneradorXMLBean bean) {
		return generadorXLMDAO.getParametros(bean);
	}

	public List<GeneradorXMLEtiquetasBean> getEtiquetas(GeneradorXMLBean bean) {
		return generadorXLMDAO.getEtiquetas(bean);
	}

	public GeneradorXLMDAO getGeneradorXLMDAO() {
		return generadorXLMDAO;
	}

	public void setGeneradorXLMDAO(GeneradorXLMDAO generadorXLMDAO) {
		this.generadorXLMDAO = generadorXLMDAO;
	}

	public List<List<String>> getFilas(GeneradorXMLBean bean) {
		return generadorXLMDAO.getFilas(bean);
	}

}