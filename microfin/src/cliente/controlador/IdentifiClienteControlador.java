package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import general.bean.MensajeTransaccionBean;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import cliente.bean.IdentifiClienteBean;
import cliente.servicio.IdentifiClienteServicio;

public class IdentifiClienteControlador extends SimpleFormController {

	IdentifiClienteServicio identifiClienteServicio = null;

	public IdentifiClienteControlador(){
		setCommandClass(IdentifiClienteBean.class);
		setCommandName("identifiCliente");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		IdentifiClienteBean identifiCliente = (IdentifiClienteBean) command;

		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = identifiClienteServicio.grabaTransaccion(tipoTransaccion, identifiCliente);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setIdentifiClienteServicio(IdentifiClienteServicio identifiClienteServicio){
                    this.identifiClienteServicio = identifiClienteServicio;
	}
} 