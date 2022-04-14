package pld.reporte;

import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import pld.bean.SeguimientoPersonaRepBean;
import pld.servicio.SeguimientoPersonaRepServicio;

public class SeguimientoPersonaRepControlador extends AbstractCommandController {

	SeguimientoPersonaRepServicio seguimientoPersonaRepServicio=null;
	
	public interface Enum_Con_TipRepor{
		int EXCEL = 1;
	}
	
	public SeguimientoPersonaRepControlador() {
		setCommandClass(SeguimientoPersonaRepBean.class);
		setCommandName("seguimientoPersonaRepBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		SeguimientoPersonaRepBean bean = (SeguimientoPersonaRepBean) command;
		int tipoReporte = Utileria.convierteEntero(request.getParameter("tipoReporte"));
		String htmlString = "";
		switch (tipoReporte) {
			case Enum_Con_TipRepor.EXCEL :
				seguimientoPersonaRepServicio.reporteExcel(bean, request, response,tipoReporte);
				break;
		}
		
		return null;
	}

	public SeguimientoPersonaRepServicio getSeguimientoPersonaRepServicio() {
		return seguimientoPersonaRepServicio;
	}

	public void setSeguimientoPersonaRepServicio(
			SeguimientoPersonaRepServicio seguimientoPersonaRepServicio) {
		this.seguimientoPersonaRepServicio = seguimientoPersonaRepServicio;
	}
	
	
}
