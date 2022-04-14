package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.RepExtravioDocsBean;
import cliente.servicio.RepExtravioDocsServicio;

public class ExtravioDocsControlador extends SimpleFormController {
	
	RepExtravioDocsServicio repExtravioDocsServicio = null;
	
	public ExtravioDocsControlador(){
		setCommandClass(RepExtravioDocsBean.class);
		setCommandName("extravioDocsBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse reponse,
									Object command,
									BindException errores) {
		
		MensajeTransaccionBean mensaje = null;
		
		return new ModelAndView(getSuccessView(),"mensaje",mensaje);
	}

	public RepExtravioDocsServicio getRepExtravioDocsServicio() {
		return repExtravioDocsServicio;
	}

	public void setRepExtravioDocsServicio(RepExtravioDocsServicio repExtravioDocsServicio) {
		this.repExtravioDocsServicio = repExtravioDocsServicio;
	}
}
