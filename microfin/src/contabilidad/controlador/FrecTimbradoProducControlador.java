package contabilidad.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.FrecTimbradoProducBean;
import contabilidad.servicio.FrecTimbradoProducServicio;

import cobranza.bean.BitacoraSegCobBean;

public class FrecTimbradoProducControlador extends SimpleFormController {
	FrecTimbradoProducServicio frecTimbradoProducServicio = null;
	
	public FrecTimbradoProducControlador(){
		setCommandClass(FrecTimbradoProducBean.class);
		setCommandName("frecTimbradoProducBean");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		frecTimbradoProducServicio.getFrecTimbradoProducDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		FrecTimbradoProducBean frecTimbradoProducBean =(FrecTimbradoProducBean)command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));	
		MensajeTransaccionBean mensaje = null;	
		
		
		mensaje =  frecTimbradoProducServicio.grabaTransaccion(tipoTransaccion, frecTimbradoProducBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);	
	}
	

	public FrecTimbradoProducServicio getFrecTimbradoProducServicio() {
		return frecTimbradoProducServicio;
	}

	public void setFrecTimbradoProducServicio(
			FrecTimbradoProducServicio frecTimbradoProducServicio) {
		this.frecTimbradoProducServicio = frecTimbradoProducServicio;
	}



}
