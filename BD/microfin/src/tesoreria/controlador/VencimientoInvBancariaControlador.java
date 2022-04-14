package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.bean.InvBancariaBean;
import tesoreria.servicio.InvBancariaServicio;
public class VencimientoInvBancariaControlador extends SimpleFormController {

	InvBancariaServicio invBancariaServicio = null;

	public VencimientoInvBancariaControlador(){
 		setCommandClass(InvBancariaBean.class);
 		setCommandName("invBancariaBean");
 	}
 	
	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		InvBancariaBean invBancaria = (InvBancariaBean) command;
		invBancariaServicio.getInvBancariaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		mensaje = invBancariaServicio.vencimientoInvBancaria(invBancaria);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

	public InvBancariaServicio getInvBancariaServicio() {
		return invBancariaServicio;
	}

	public void setInvBancariaServicio(InvBancariaServicio invBancariaServicio) {
		this.invBancariaServicio = invBancariaServicio;
	}
}
