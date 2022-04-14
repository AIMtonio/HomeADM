package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.TarjetaCreditoServicio;


public class AsignacionTarjetaCredControlador extends SimpleFormController  {
	TarjetaCreditoServicio tarjetaCreditoServicio = null;
		
		
		public AsignacionTarjetaCredControlador() {
			setCommandClass(TarjetaDebitoBean.class);
			setCommandName("tarjetaDebito");
		}	
		
		protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
										BindException errors) throws Exception {
		
			TarjetaDebitoBean tarjetaDebitoBean = (TarjetaDebitoBean) command;
			
			tarjetaCreditoServicio.getTarjetaCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
	 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
	 								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
			int tipoActualizacion =(request.getParameter("tipoActualizacion")!=null)?
									Integer.parseInt(request.getParameter("tipoActualizacion")):0;
	 		
			MensajeTransaccionBean mensaje = null;
	 		mensaje = tarjetaCreditoServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion,tarjetaDebitoBean);
		
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
// --------------------setter---------------------

		public TarjetaCreditoServicio getTarjetaCreditoServicio() {
			return tarjetaCreditoServicio;
		}

		public void setTarjetaCreditoServicio(
				TarjetaCreditoServicio tarjetaCreditoServicio) {
			this.tarjetaCreditoServicio = tarjetaCreditoServicio;
		}
	
		
		
		
}
