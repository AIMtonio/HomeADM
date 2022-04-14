package fira.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.ClidatsocioeBean;
import originacion.servicio.ClidatsocioeServicio;

	public class DatosSocioEconomicosAgroControlador extends SimpleFormController {
	
		ClidatsocioeServicio clidatsocioeServicio  = null;
	
		public DatosSocioEconomicosAgroControlador(){
			setCommandClass(ClidatsocioeBean.class);
			setCommandName("clidatsocioeBean");
		}
	
		protected ModelAndView onSubmit(HttpServletRequest request,
										HttpServletResponse response,
										Object command,
										BindException errors) throws Exception {
	
			ClidatsocioeBean clidatsocioe = (ClidatsocioeBean) command;
			
			clidatsocioeServicio.getClidatsocioeDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			
			int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccion")):
					0;		
					
					String detalleSocioeconomicos = request.getParameter("detalleSocioeconomicos");
				
					
			MensajeTransaccionBean mensaje = null;
			mensaje = clidatsocioeServicio.grabaTransaccion(tipoTransaccion,clidatsocioe );
			return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		}

		public ClidatsocioeServicio getClidatsocioeServicio() {
			return clidatsocioeServicio;
		}

		public void setClidatsocioeServicio(ClidatsocioeServicio clidatsocioeServicio) {
			this.clidatsocioeServicio = clidatsocioeServicio;
		}
			
	
	}
