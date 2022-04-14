package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteArchivosBean;

public class RepDocumentosVigExpControlador extends SimpleFormController {

	public RepDocumentosVigExpControlador() {
		setCommandClass(ClienteArchivosBean.class);
		setCommandName("clienteArchivos");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors) throws Exception {
		ClienteArchivosBean bean = (ClienteArchivosBean) command;
		MensajeTransaccionBean mensaje=new MensajeTransaccionBean();
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
}
