package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.TarjetaDebitoServicio;

public class TarDebReporteEstatusControlador extends SimpleFormController  {
	
	TarjetaDebitoServicio tarjetaDebitoServicio= null;
		
		public TarDebReporteEstatusControlador() {
			setCommandClass(TarjetaDebitoBean.class);
			setCommandName("tarjetaDebitoBean");
		}	
		
		protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
										BindException errors) throws Exception {
		
			TarjetaDebitoBean tarjetaDebitoBean = (TarjetaDebitoBean) command;
			
			tarjetaDebitoServicio.getTarjetaDebitoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
	 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
	 								Integer.parseInt(request.getParameter("tipoTransaccion")):0;						
	 	
			MensajeTransaccionBean mensaje = null;
	 		mensaje = tarjetaDebitoServicio.grabaTransaccion(tipoTransaccion,0, tarjetaDebitoBean);
		
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}

		// --------------------setter---------------------
		public TarjetaDebitoServicio getTarjetaDebitoServicio() {
			return tarjetaDebitoServicio;
		}

		public void setTarjetaDebitoServicio(TarjetaDebitoServicio tarjetaDebitoServicio) {
			this.tarjetaDebitoServicio = tarjetaDebitoServicio;
		}
}