package credito.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import credito.servicio.CondonaMasCarteraCastServicio;
import general.bean.MensajeTransaccionBean;
/**
 * Controlador para la pantalla de Recuperación Masiva de Cartera Castigada.
 * @author pmontero
 */
public class CondonaMasCarteraCastControlador extends SimpleFormController {
	
	CondonaMasCarteraCastServicio	condonaMasCarteraCastServicio	= null;
	
	public CondonaMasCarteraCastControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command,
			BindException errors) throws Exception {

		CreditosBean creditos = (CreditosBean) command;
		MensajeTransaccionBean mensaje = null;
		try {
			mensaje = condonaMasCarteraCastServicio.ejecutaKTR(creditos);

		} catch (Exception ex) {

		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CondonaMasCarteraCastServicio getCondonaMasCarteraCastServicio() {
		return condonaMasCarteraCastServicio;
	}

	public void setCondonaMasCarteraCastServicio(CondonaMasCarteraCastServicio condonaMasCarteraCastServicio) {
		this.condonaMasCarteraCastServicio = condonaMasCarteraCastServicio;
	}

	
}
