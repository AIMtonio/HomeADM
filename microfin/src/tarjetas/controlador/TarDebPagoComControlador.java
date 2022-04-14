package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.TarjetaDebitoServicio;


public class TarDebPagoComControlador extends  SimpleFormController {	
	
	TarjetaDebitoServicio tarjetaDebitoServicio= null;
						
	public TarDebPagoComControlador(){
 		setCommandClass(TarjetaDebitoBean.class);
 		setCommandName("tarjetaDebito");
 	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		tarjetaDebitoServicio.getTarjetaDebitoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		TarjetaDebitoBean tarjetaDebitoBean = (TarjetaDebitoBean) command;
		
		int tipoActualizacion =(request.getParameter("tipoActualizacion")!=null) ?
				Integer.parseInt(request.getParameter("tipoActualizacion")): 0;
		
 		MensajeTransaccionBean mensaje = null;

 		mensaje = tarjetaDebitoServicio.actualizaTajetaCredito(tipoActualizacion, tarjetaDebitoBean);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}
	public TarjetaDebitoServicio getTarjetaDebitoServicio() {
		return tarjetaDebitoServicio;
	}

	public void setTarjetaDebitoServicio(TarjetaDebitoServicio tarjetaDebitoServicio) {
		this.tarjetaDebitoServicio = tarjetaDebitoServicio;
	}





}
