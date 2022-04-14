package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import tarjetas.bean.TipoTarjetaDebBean;
import tarjetas.servicio.TipoTarjetaDebServicio;


public class ReporteTarDebTiposControlador extends SimpleFormController  {
	
	TipoTarjetaDebServicio  tipoTarjetaDebServicio= null;
		
		public ReporteTarDebTiposControlador() {
			setCommandClass(TipoTarjetaDebBean.class);
			setCommandName("tipoTarjetaDebBean");
		}	
		
		protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
										BindException errors) throws Exception {
		
			TipoTarjetaDebBean tipoTarjetaDebBean = (TipoTarjetaDebBean) command;
			
			tipoTarjetaDebServicio.getTipoTarjetaDebDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
	 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
	 								Integer.parseInt(request.getParameter("tipoTransaccion")):0;	 	
			MensajeTransaccionBean mensaje = null;
	 		mensaje = tipoTarjetaDebServicio.grabaTransaccion(tipoTransaccion,0, tipoTarjetaDebBean);
		
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
// --------------------setter---------------------

		public TipoTarjetaDebServicio getTipoTarjetaDebServicio() {
			return tipoTarjetaDebServicio;
		}

		public void setTipoTarjetaDebServicio(
				TipoTarjetaDebServicio tipoTarjetaDebServicio) {
			this.tipoTarjetaDebServicio = tipoTarjetaDebServicio;
		}
}