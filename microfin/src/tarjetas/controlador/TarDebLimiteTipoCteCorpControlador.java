package tarjetas.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import tarjetas.bean.TarDebLimiteTipoCteCorpBean;
import tarjetas.servicio.TarDebLimiteTipoCteCorpServicio;


public class TarDebLimiteTipoCteCorpControlador extends SimpleFormController  {

	TarDebLimiteTipoCteCorpServicio  tarDebLimiteTipoCteCorpServicio= null;
		
		public TarDebLimiteTipoCteCorpControlador() {
			setCommandClass(TarDebLimiteTipoCteCorpBean.class);
			setCommandName("limiteTarjetaDebitoCteBean");
		}	
		
		protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
										BindException errors) throws Exception {
		
			TarDebLimiteTipoCteCorpBean tarDebLimiteTipoCteCorpBean = (TarDebLimiteTipoCteCorpBean) command;
			
			tarDebLimiteTipoCteCorpServicio.getTarDebLimiteTipoCteCorpDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
	 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
	 								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
	 	
			MensajeTransaccionBean mensaje = null;
	 		mensaje = tarDebLimiteTipoCteCorpServicio.grabaTransaccion(tipoTransaccion,tarDebLimiteTipoCteCorpBean);
		
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}

// --------------------setter---------------------
		public TarDebLimiteTipoCteCorpServicio getTarDebLimiteTipoCteCorpServicio() {
			return tarDebLimiteTipoCteCorpServicio;
		}

		public void setTarDebLimiteTipoCteCorpServicio(
				TarDebLimiteTipoCteCorpServicio tarDebLimiteTipoCteCorpServicio) {
			this.tarDebLimiteTipoCteCorpServicio = tarDebLimiteTipoCteCorpServicio;
		}
}