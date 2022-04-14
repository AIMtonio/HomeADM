package fira.reporte;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fira.bean.GarantiaFiraBean;
import fira.servicio.GarantiaFiraServicio;

public class ReporteCreditoAfectacionGarantiaControlador extends AbstractCommandController {

	GarantiaFiraServicio garantiaFiraServicio = null;
	String nomReporte = null;
	String successView = null;

	public static interface Enum_Con_Reporte {
		int ReporteExcel = 1;
	}

	public ReporteCreditoAfectacionGarantiaControlador() {
		setCommandClass(GarantiaFiraBean.class);
		setCommandName("garantiaFiraBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		GarantiaFiraBean garantiaFiraBean = (GarantiaFiraBean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null) ? Integer.parseInt(request.getParameter("tipoReporte")): 0;

		switch(tipoReporte){
			case Enum_Con_Reporte.ReporteExcel:
				garantiaFiraServicio.reporteCreditoAfectacionGarantia(garantiaFiraBean, response);
			break;
		}

		return null;

	}	

	public GarantiaFiraServicio getGarantiaFiraServicio() {
		return garantiaFiraServicio;
	}

	public void setGarantiaFiraServicio(GarantiaFiraServicio garantiaFiraServicio) {
		this.garantiaFiraServicio = garantiaFiraServicio;
	}

	public String getNomReporte() {
		return nomReporte;
	}

	public void setNomReporte(String nomReporte) {
		this.nomReporte = nomReporte;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}
}
