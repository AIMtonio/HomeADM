package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import tarjetas.bean.TarDebGirosAcepIndividualBean;
import tarjetas.servicio.TarCredGirosAcepIndividualServicio;
import tarjetas.servicio.TarDebGirosAcepIndividualServicio;


public class TarDebGirosAcepIndividualControlador extends SimpleFormController  {

	TarDebGirosAcepIndividualServicio  tarDebGirosAcepIndividualServicio= null;
	TarCredGirosAcepIndividualServicio  tarCredGirosAcepIndividualServicio= null;
		
		public TarDebGirosAcepIndividualControlador() {
			setCommandClass(TarDebGirosAcepIndividualBean.class);
			setCommandName("girosAceptadosTarjetaIndividual");
		}	
		
		protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
										BindException errors) throws Exception {
		
			TarDebGirosAcepIndividualBean tarDebGirosAcepIndividualBean = (TarDebGirosAcepIndividualBean) command;
			int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
						Integer.parseInt(request.getParameter("tipoTransaccion")):0;
			int tipotarjeta = tarDebGirosAcepIndividualBean.getTipoTarjeta();
			MensajeTransaccionBean mensaje = null;
			
			if(tipotarjeta ==1){
				tarDebGirosAcepIndividualServicio.getTarDebGirosAcepIndividualDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		 		mensaje = tarDebGirosAcepIndividualServicio.grabaTransaccion(tipoTransaccion,tarDebGirosAcepIndividualBean);
			}
			else if(tipotarjeta ==2){			
				tarCredGirosAcepIndividualServicio.getTarCredGirosAcepIndividualDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		 		mensaje = tarCredGirosAcepIndividualServicio.grabaTransaccion(tipoTransaccion,tarDebGirosAcepIndividualBean);
			}
			
			
			
		
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
// --------------------setter---------------------
		public TarDebGirosAcepIndividualServicio getTarDebGirosAcepIndividualServicio() {
			return tarDebGirosAcepIndividualServicio;
		}

		public void setTarDebGirosAcepIndividualServicio(
				TarDebGirosAcepIndividualServicio tarDebGirosAcepIndividualServicio) {
			this.tarDebGirosAcepIndividualServicio = tarDebGirosAcepIndividualServicio;
		}

		public TarCredGirosAcepIndividualServicio getTarCredGirosAcepIndividualServicio() {
			return tarCredGirosAcepIndividualServicio;
		}

		public void setTarCredGirosAcepIndividualServicio(
				TarCredGirosAcepIndividualServicio tarCredGirosAcepIndividualServicio) {
			this.tarCredGirosAcepIndividualServicio = tarCredGirosAcepIndividualServicio;
		}
		
		
}