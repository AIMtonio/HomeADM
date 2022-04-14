

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
import tarjetas.servicio.TarjetaDebitoServicio;


public class DesbloqueodeTarjetaDebitoControlador extends SimpleFormController  {
	
	TarjetaDebitoServicio  tarjetaDebitoServicio= null;
	TarjetaCreditoServicio tarjetaCreditoServicio= null;
		
		public DesbloqueodeTarjetaDebitoControlador() {
			setCommandClass(TarjetaDebitoBean.class);
			setCommandName("tarjetaDebitoBean");
		}	
		
		protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
										BindException errors) throws Exception {
		
			TarjetaDebitoBean tarjetaDebitoBean = (TarjetaDebitoBean) command;
			
			int tipotarjeta = tarjetaDebitoBean.getTipoTarjeta();
			MensajeTransaccionBean mensaje = null;
			
			if(tipotarjeta ==1){
				tarjetaDebitoServicio.getTarjetaDebitoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
		 								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		 		mensaje = tarjetaDebitoServicio.grabaTransaccion(tipoTransaccion,0, tarjetaDebitoBean);
			}
			if(tipotarjeta ==2){
				tarjetaCreditoServicio.getTarjetaCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
		 								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		 		mensaje = tarjetaCreditoServicio.grabaTransaccion(tipoTransaccion, 0, tarjetaDebitoBean);
			}

			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
// --------------------setter---------------------

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
