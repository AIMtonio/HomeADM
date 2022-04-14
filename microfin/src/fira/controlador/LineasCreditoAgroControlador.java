package fira.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.LineasCreditoBean;
import credito.servicio.LineasCreditoServicio;

public class LineasCreditoAgroControlador extends SimpleFormController {

	LineasCreditoServicio lineasCreditoServicio = null;

	public LineasCreditoAgroControlador(){
		setCommandClass(LineasCreditoBean.class);
		setCommandName("lineasCreditoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		
		lineasCreditoServicio.getLineasCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		LineasCreditoBean lineasCreditoBean = (LineasCreditoBean) command;
		lineasCreditoBean.setEsAgropecuario(Constantes.STRING_SI);
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)? Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)? Integer.parseInt(request.getParameter("tipoActualizacion")): 0;

		MensajeTransaccionBean mensajeTransaccionBean = null;
		mensajeTransaccionBean = lineasCreditoServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion,lineasCreditoBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensajeTransaccionBean);
	}

	public LineasCreditoServicio getLineasCreditoServicio() {
		return lineasCreditoServicio;
	}

	public void setLineasCreditoServicio(LineasCreditoServicio lineasCreditoServicio) {
		this.lineasCreditoServicio = lineasCreditoServicio;
	}
}
