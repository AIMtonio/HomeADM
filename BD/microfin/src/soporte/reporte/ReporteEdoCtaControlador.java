package soporte.reporte;
import general.bean.ParametrosAuditoriaBean;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.RepEdoCtaBean;
import soporte.servicio.RepEdoCtaServicio;

public class ReporteEdoCtaControlador extends AbstractCommandController {
	private ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	RepEdoCtaServicio repEdoCtaServicio = null;
	String nombreReporte = null;
	String successView = null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	public static interface Enum_Rep_TipoReporte {
		int ReporteExcel = 1;
	}

	public ReporteEdoCtaControlador(){
		setCommandClass(RepEdoCtaBean.class);
		setCommandName("RepEdoCtaBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {

		RepEdoCtaBean repEdoCtaBean = (RepEdoCtaBean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null) ?
				Integer.parseInt(request.getParameter("tipoReporte")) : 0;

		String htmlString = "";

		switch (tipoReporte) {
			case Enum_Rep_TipoReporte.ReporteExcel:
				int numeroReporte = 1;
				List listaReportes = repEdoCtaServicio.reporteEdoCtaExcel(numeroReporte, repEdoCtaBean, response);
				break;
		}

		return null;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

	public RepEdoCtaServicio getRepEdoCtaServicio() {
		return repEdoCtaServicio;
	}

	public void setRepEdoCtaServicio(RepEdoCtaServicio repEdoCtaServicio) {
		this.repEdoCtaServicio = repEdoCtaServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}
