
package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.GiroNegocioTarDebBean;
import tarjetas.servicio.GiroNegocioTarDebServicio;

public class GiroNegocioTarDebControlador extends SimpleFormController  {
	
	GiroNegocioTarDebServicio  giroNegocioTarDebServicio= null;
		
		public GiroNegocioTarDebControlador() {
			setCommandClass(GiroNegocioTarDebBean.class);
			setCommandName("giroNegocioTarDebBean");
		}	
		
		protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
										BindException errors) throws Exception {
		
			GiroNegocioTarDebBean giroNegocioTarDebBean = (GiroNegocioTarDebBean) command;
			
			giroNegocioTarDebServicio.getGiroNegocioTarDebDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
	 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
	 								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
	 
			MensajeTransaccionBean mensaje = null;
	 		mensaje = giroNegocioTarDebServicio.grabaTransaccion(tipoTransaccion ,giroNegocioTarDebBean);
		
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
// --------------------setter---------------------

		public void setGiroNegocioTarDebServicio(
				GiroNegocioTarDebServicio giroNegocioTarDebServicio) {
			this.giroNegocioTarDebServicio = giroNegocioTarDebServicio;
		}

	
		
		

		
		
}