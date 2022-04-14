package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.TarjetaDebitoServicio;

public class TarjetaDebitoAsociaCuentasControlador extends SimpleFormController  {
	TarjetaDebitoServicio tarjetaDebitoServicio = null;
		
		
		public TarjetaDebitoAsociaCuentasControlador() {
			setCommandClass(TarjetaDebitoBean.class);
			setCommandName("tarjetaDebito");
		}	
		
		protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
										BindException errors) throws Exception {
		
			TarjetaDebitoBean tarjetaDebitoBean = (TarjetaDebitoBean) command;
			
			tarjetaDebitoServicio.getTarjetaDebitoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
	 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
	 								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
			int tipoActualizacion =(request.getParameter("tipoActualizacion")!=null)?
									Integer.parseInt(request.getParameter("tipoActualizacion")):0;
	 		
			MensajeTransaccionBean mensaje = null;
	 		mensaje = tarjetaDebitoServicio.grabaTransaccion(tipoTransaccion,tipoActualizacion,tarjetaDebitoBean);
		
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
// --------------------setter---------------------
		public void setTarjetaDebitoServicio(TarjetaDebitoServicio tarjetaDebitoServicio) {
			this.tarjetaDebitoServicio = tarjetaDebitoServicio;
		}
		
		
		
}
