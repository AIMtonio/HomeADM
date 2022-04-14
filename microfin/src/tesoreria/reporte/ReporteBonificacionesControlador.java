package tesoreria.reporte;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.BonificacionesBean;
import tesoreria.servicio.BonificacionesServicio;

public class ReporteBonificacionesControlador extends AbstractCommandController {

	BonificacionesServicio bonificacionesServicio = null;
	String successView = null;

	public static interface Enum_Rep_Bonificacion {
		int reporteExcel = 1;
		int reportePDF   = 2;
	}

	public ReporteBonificacionesControlador () {
		setCommandClass(BonificacionesBean.class);
		setCommandName("bonificacionesBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {

		BonificacionesBean bonificacionesBean = (BonificacionesBean) command;

		int tipoReporte =(request.getParameter("tipoReporte")!=null) ? Integer.parseInt(request.getParameter("tipoReporte")): 0;

		try {
			switch(tipoReporte){
				case Enum_Rep_Bonificacion.reporteExcel:
					bonificacionesServicio.reporteBonificaciones(bonificacionesBean, response);
				break;
			}
		} catch(Exception exception) {
			exception.printStackTrace();
		}
		return null;

	}

	public BonificacionesServicio getBonificacionesServicio() {
		return bonificacionesServicio;
	}

	public void setBonificacionesServicio(
			BonificacionesServicio bonificacionesServicio) {
		this.bonificacionesServicio = bonificacionesServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}
