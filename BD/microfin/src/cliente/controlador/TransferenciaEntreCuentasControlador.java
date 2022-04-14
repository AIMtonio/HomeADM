package cliente.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.TransferenciaEntreCuentasBean;
import cliente.servicio.TransferenciaEntreCuentasServicio;

public class TransferenciaEntreCuentasControlador extends SimpleFormController {
	
	TransferenciaEntreCuentasServicio transferenciaEntreCuentasServicio = null;

	public TransferenciaEntreCuentasControlador() {
		setCommandClass(TransferenciaEntreCuentasBean.class);
		setCommandName("transferenciaEntreCuentasBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		transferenciaEntreCuentasServicio.getTransferenciaEntreCuentasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		TransferenciaEntreCuentasBean transferenciaEntreCuentasBean = (TransferenciaEntreCuentasBean) command;
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
		MensajeTransaccionBean mensajeTransaccionBean = null;
		mensajeTransaccionBean  = transferenciaEntreCuentasServicio.grabaTransaccion(tipoTransaccion,transferenciaEntreCuentasBean);
										
		return new ModelAndView(getSuccessView(), "mensaje", mensajeTransaccionBean);
	}

	public TransferenciaEntreCuentasServicio getTransferenciaEntreCuentasServicio() {
		return transferenciaEntreCuentasServicio;
	}

	public void setTransferenciaEntreCuentasServicio(
			TransferenciaEntreCuentasServicio transferenciaEntreCuentasServicio) {
		this.transferenciaEntreCuentasServicio = transferenciaEntreCuentasServicio;
	}
}
