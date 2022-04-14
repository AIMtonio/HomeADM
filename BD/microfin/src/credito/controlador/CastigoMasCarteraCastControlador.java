package credito.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import credito.servicio.CastigoMasCarteraCastServicio;
import general.bean.MensajeTransaccionBean;
/**
 * Controlador para la pantalla de Castigo Masivo de Cartera.
 * @author pmontero
 */
public class CastigoMasCarteraCastControlador extends SimpleFormController {
	
	CastigoMasCarteraCastServicio	castigoMasCarteraCastServicio	= null;
	
	public CastigoMasCarteraCastControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditosBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {

		CreditosBean creditos = (CreditosBean) command;
		MensajeTransaccionBean mensaje = null;
		try {
			mensaje = castigoMasCarteraCastServicio.ejecutaKTR(creditos);

		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CastigoMasCarteraCastServicio getCastigoMasCarteraCastServicio() {
		return castigoMasCarteraCastServicio;
	}

	public void setCastigoMasCarteraCastServicio(CastigoMasCarteraCastServicio castigoMasCarteraCastServicio) {
		this.castigoMasCarteraCastServicio = castigoMasCarteraCastServicio;
	}
	
}
