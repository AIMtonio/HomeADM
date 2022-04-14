package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import tarjetas.bean.TarDebLimiteTipoBean;
import tarjetas.servicio.TarDebLimiteTipoServicio;


public class TarDebLimiteTipoControlador extends SimpleFormController  {
	
	TarDebLimiteTipoServicio  tarDebLimiteTipoServicio= null;
		
		public TarDebLimiteTipoControlador() {
			setCommandClass(TarDebLimiteTipoBean.class);
			setCommandName("limiteTarjetaDebitoBean");
		}	
		
		protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
										BindException errors) throws Exception {
		
			TarDebLimiteTipoBean tarDebLimiteTipoBean = (TarDebLimiteTipoBean) command;
			
			tarDebLimiteTipoServicio.getTarDebLimiteTipoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
	 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
	 								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
	 	
			MensajeTransaccionBean mensaje = null;
	 		mensaje = tarDebLimiteTipoServicio.grabaTransaccion(tipoTransaccion, tarDebLimiteTipoBean);
		
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}

// --------------------setter---------------------

		public TarDebLimiteTipoServicio getTarDebLimiteTipoServicio() {
			return tarDebLimiteTipoServicio;
		}

		public void setTarDebLimiteTipoServicio(
				TarDebLimiteTipoServicio tarDebLimiteTipoServicio) {
			this.tarDebLimiteTipoServicio = tarDebLimiteTipoServicio;
		}
}