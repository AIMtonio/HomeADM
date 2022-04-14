package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.TarDebGirosNegocioBean;
import tarjetas.servicio.TarDebGirosNegocioServicio;

public class TarDebGirosNegocioControlador extends SimpleFormController  {

	TarDebGirosNegocioServicio  tarDebGirosNegocioServicio= null;
		
		public TarDebGirosNegocioControlador() {
			setCommandClass(TarDebGirosNegocioBean.class);
			setCommandName("girosNegociosTipoTarjeta");
		}	
		
		protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
										BindException errors) throws Exception {
		
			TarDebGirosNegocioBean tarDebGirosNegocioBean = (TarDebGirosNegocioBean) command;
			
			tarDebGirosNegocioServicio.getTarDebGirosNegocioDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
	 								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
	 	
			MensajeTransaccionBean mensaje = null;
	 		mensaje = tarDebGirosNegocioServicio.grabaTransaccion(tipoTransaccion,tarDebGirosNegocioBean);
		
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
// --------------------setter---------------------

		public TarDebGirosNegocioServicio getTarDebGirosNegocioServicio() {
			return tarDebGirosNegocioServicio;
		}

		public void setTarDebGirosNegocioServicio(
				TarDebGirosNegocioServicio tarDebGirosNegocioServicio) {
			this.tarDebGirosNegocioServicio = tarDebGirosNegocioServicio;
		}
		
}
