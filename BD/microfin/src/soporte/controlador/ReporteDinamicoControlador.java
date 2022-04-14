package soporte.controlador;

import java.io.File;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;
import soporte.bean.ReporteBean;
import soporte.servicio.ReporteDinamicoServicio;
/**
 * Clase para las pantallas de los reportes dinamicos.
 * @author pmontero
 * @version 1.0.0
 */
@SuppressWarnings("deprecation")
public class ReporteDinamicoControlador extends SimpleFormController {
	
	ReporteDinamicoServicio reporteDinamicoServicio;

	public ReporteDinamicoControlador() {
		setCommandClass(ReporteBean.class);
		setCommandName("reporteBean");
	}

	protected ModelAndView showForm(HttpServletRequest request,HttpServletResponse response,BindException errors) throws Exception {
		int reporteID = Utileria.convierteEntero(request.getParameter("reporteID"));
		String vista="";
		try {
			ReporteBean bean=new ReporteBean();
			bean.setReporteID(String.valueOf(reporteID));
			vista = reporteDinamicoServicio.getVista(bean);
			String path = getServletContext().getRealPath("WEB-INF/jsp/"+vista+".jsp");
			File file=new File(path);
			System.out.println("Ruta Vista:"+path);
			if(!file.exists()) {
				vista="soporte/error404Vista";
			}
			
		}catch(Exception ex) {
			ex.printStackTrace();
			vista="soporte/error404Vista";
		}
		return new ModelAndView(vista, "reporteID", reporteID);
		
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		ReporteBean bean = (ReporteBean) command;
		MensajeTransaccionBean mensaje = null;
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public ReporteDinamicoServicio getReporteDinamicoServicio() {
		return reporteDinamicoServicio;
	}

	public void setReporteDinamicoServicio(ReporteDinamicoServicio reporteDinamicoServicio) {
		this.reporteDinamicoServicio = reporteDinamicoServicio;
	}


}