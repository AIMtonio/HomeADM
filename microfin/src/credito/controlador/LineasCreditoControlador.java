package credito.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.LineasCreditoBean;
import credito.servicio.LineasCreditoServicio;

public class LineasCreditoControlador extends SimpleFormController {

	LineasCreditoServicio lineasCreditoServicio = null;

	public LineasCreditoControlador(){
		setCommandClass(LineasCreditoBean.class);
		setCommandName("lineasCreditoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		LineasCreditoBean lineasCreditoBean = (LineasCreditoBean) command;
		lineasCreditoBean.setEsAgropecuario(Constantes.STRING_NO);
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)? Integer.parseInt(request.getParameter("tipoTransaccion")): 0;
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)? Integer.parseInt(request.getParameter("tipoActualizacion")): 0;

		MensajeTransaccionBean mensaje = null;
		mensaje = lineasCreditoServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion,lineasCreditoBean);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setLineasCreditoServicio(LineasCreditoServicio lineasCreditoServicio){
		this.lineasCreditoServicio = lineasCreditoServicio;
	}
}
