package tarjetas.controlador;

import java.util.List;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tarjetas.bean.TarDebGiroxTipoCliCorpBean;
import tarjetas.servicio.TarDebGiroxTipoCliCorpServicio;




public class TarDebGiroxTipoCliCorpControlador extends SimpleFormController  {
	
	TarDebGiroxTipoCliCorpServicio  tarDebGiroxTipoCliCorpServicio= null;
		
		public TarDebGiroxTipoCliCorpControlador() {
			setCommandClass(TarDebGiroxTipoCliCorpBean.class);
			setCommandName("tarDebGiroxTipoCliCorpBean");
		}	
		
		protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
										BindException errors) throws Exception {
			TarDebGiroxTipoCliCorpBean giroNegocioTarDebBean = (TarDebGiroxTipoCliCorpBean) command;
			tarDebGiroxTipoCliCorpServicio.getTarDebGiroxTipoCliCorpDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
	 								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
	
			MensajeTransaccionBean mensaje = null;
		

			
			
	 		mensaje = tarDebGiroxTipoCliCorpServicio.grabaTransaccion(tipoTransaccion ,giroNegocioTarDebBean);
		
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}
// --------------------setter---------------------

		public void setTarDebGiroxTipoCliCorpServicio(
				TarDebGiroxTipoCliCorpServicio tarDebGiroxTipoCliCorpServicio) {
			this.tarDebGiroxTipoCliCorpServicio = tarDebGiroxTipoCliCorpServicio;
		}

	
	
		
		

		
		
}