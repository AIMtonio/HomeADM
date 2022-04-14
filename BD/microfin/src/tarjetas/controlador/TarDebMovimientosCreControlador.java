package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.TarDebMovimientosBean;
import tarjetas.servicio.TarDebMovimientosServicio;

public class TarDebMovimientosCreControlador extends  SimpleFormController{
	
	TarDebMovimientosServicio tarDebMovimientosServicio = null;
	
	public TarDebMovimientosCreControlador(){
 		setCommandClass(TarDebMovimientosBean.class);
 		setCommandName("tarDebMovimientosBean");
 	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		tarDebMovimientosServicio.getTarDebMovimientosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());	
 		MensajeTransaccionBean mensaje = null;
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);	
	}	
	//Getter y Setter
	public TarDebMovimientosServicio getTarDebMovimientosServicio() {
		return tarDebMovimientosServicio;
	}

	public void setTarDebMovimientosServicio(
			TarDebMovimientosServicio tarDebMovimientosServicio) {
		this.tarDebMovimientosServicio = tarDebMovimientosServicio;
	}

}
