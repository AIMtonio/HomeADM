package tarjetas.controlador;

import java.io.IOException;
import general.bean.MensajeTransaccionBean;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.TarjetaCreditoServicio;
import tarjetas.servicio.TarjetaDebitoServicio;


public class TarDebActivacionControlador extends  SimpleFormController {	
	
	TarjetaDebitoServicio tarjetaDebitoServicio= null;
	TarjetaCreditoServicio tarjetaCreditoServicio= null;
						
	String archivoNombre="";
	public TarDebActivacionControlador(){
 		setCommandClass(TarjetaDebitoBean.class);
 		setCommandName("tarjetaDebActiva");
 	}

	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws ServletException, IOException  {
		
		tarjetaDebitoServicio.getTarjetaDebitoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		TarjetaDebitoBean tarjetaDebitoBean = (TarjetaDebitoBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
 		MensajeTransaccionBean mensaje = null;
 		if(tipoTransaccion == 8){
 			mensaje = tarjetaDebitoServicio.grabaTransaccion(tipoTransaccion,0, tarjetaDebitoBean);
 		}else if(tipoTransaccion == 4){
 			mensaje = tarjetaCreditoServicio.grabaTransaccion(tipoTransaccion,0, tarjetaDebitoBean);
 		}
 		

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}
	public TarjetaDebitoServicio getTarjetaDebitoServicio() {
		return tarjetaDebitoServicio;
	}

	public void setTarjetaDebitoServicio(TarjetaDebitoServicio tarjetaDebitoServicio) {
		this.tarjetaDebitoServicio = tarjetaDebitoServicio;
	}

	public TarjetaCreditoServicio getTarjetaCreditoServicio() {
		return tarjetaCreditoServicio;
	}

	public void setTarjetaCreditoServicio(
			TarjetaCreditoServicio tarjetaCreditoServicio) {
		this.tarjetaCreditoServicio = tarjetaCreditoServicio;
	}





}
