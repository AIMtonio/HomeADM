package spei.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import spei.bean.PagoRemesasTraspasosSpeiBean;
import spei.servicio.PagoRemesasTraspasosSpeiServicio;
import spei.servicio.ParametrosSpeiServicio;

public class PagoRemesasTraspasosSpeiControlador extends SimpleFormController{

	PagoRemesasTraspasosSpeiServicio pagoRemesasTraspasosSpeiServicio = null;

 	public PagoRemesasTraspasosSpeiControlador(){
 		setCommandClass(PagoRemesasTraspasosSpeiBean.class);
 		setCommandName("pagoRemesasTraspasosSpeiBean"); 		
 	}
 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		pagoRemesasTraspasosSpeiServicio.getPagoRemesasTraspasosSpeiDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		PagoRemesasTraspasosSpeiBean pagoRemesasTraspasosSpeiBean = (PagoRemesasTraspasosSpeiBean) command;

		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
		Integer.parseInt(request.getParameter("tipoTransaccion")):
	0;
		String datosGrid = request.getParameter("datosGrid");	
		MensajeTransaccionBean mensaje = null;
		mensaje = pagoRemesasTraspasosSpeiServicio.grabaTransaccion(tipoTransaccion, pagoRemesasTraspasosSpeiBean, datosGrid);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);


	}
 	
 // ---------------  getter y setter -------------------- 
 	public PagoRemesasTraspasosSpeiServicio getPagoRemesasTraspasosSpeiServicio() {
 		return pagoRemesasTraspasosSpeiServicio;
 	}

 	public void setPagoRemesasTraspasosSpeiServicio(
 			PagoRemesasTraspasosSpeiServicio pagoRemesasTraspasosSpeiServicio) {
 		this.pagoRemesasTraspasosSpeiServicio = pagoRemesasTraspasosSpeiServicio;
 	}
}
