package buroCredito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import buroCredito.bean.SolBuroCreditoBean;
import buroCredito.servicio.SolBuroCreditoServicio;

public class SolBuroCreditoControlador extends SimpleFormController {

	SolBuroCreditoServicio solBuroCreditoServicio = null;

	public SolBuroCreditoControlador(){
		setCommandClass(SolBuroCreditoBean.class);
		setCommandName("solBuroCreditoBean");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		SolBuroCreditoBean solBuroCreditoBean = (SolBuroCreditoBean) command;
		solBuroCreditoServicio.getSolBuroCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());	
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
		MensajeTransaccionBean mensaje = null;
		mensaje = solBuroCreditoServicio.grabaTransaccion(tipoTransaccion,solBuroCreditoBean, request);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setSolBuroCreditoServicio(
			SolBuroCreditoServicio solBuroCreditoServicio) {
		this.solBuroCreditoServicio = solBuroCreditoServicio;
	}

} 
