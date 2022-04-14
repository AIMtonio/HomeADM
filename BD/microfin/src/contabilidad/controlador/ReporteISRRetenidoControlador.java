package contabilidad.controlador;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.ReporteISRRetenidoBean;
public class ReporteISRRetenidoControlador  extends SimpleFormController {
	
	
	public ReporteISRRetenidoControlador() {
		setCommandClass(ReporteISRRetenidoBean.class);
		setCommandName("reporteISRRetenidoBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,							
									BindException errors) throws Exception {
	
		ReporteISRRetenidoBean reporteISRRetenidoBean= (ReporteISRRetenidoBean) command;
		MensajeTransaccionBean mensaje = null;
			
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}	
 

}
