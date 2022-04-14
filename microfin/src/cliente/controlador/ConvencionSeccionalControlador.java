package cliente.controlador;
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ConvencionSeccionalBean;
import cliente.servicio.ConvencionSeccionalServicio;


public class ConvencionSeccionalControlador extends SimpleFormController {
	
	ConvencionSeccionalServicio  convencionSeccionalServicio= null;
			
			public ConvencionSeccionalControlador() {
				setCommandClass(ConvencionSeccionalBean.class);
				setCommandName("convencionSeccional");
			}	
			
			protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,							
											BindException errors) throws Exception {
				
				convencionSeccionalServicio.getConvencionSeccionalDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
				ConvencionSeccionalBean convencionSeccionalBean = (ConvencionSeccionalBean) command;
				
			
		 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
		 								Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		 	
				MensajeTransaccionBean mensaje = null;
		 		mensaje = convencionSeccionalServicio.grabaTransaccion(tipoTransaccion, convencionSeccionalBean);
			
				return new ModelAndView(getSuccessView(), "mensaje", mensaje);
			}
	// --------------------setter y getter---------------------

			public ConvencionSeccionalServicio getConvencionSeccionalServicio() {
				return convencionSeccionalServicio;
			}

			public void setConvencionSeccionalServicio(
					ConvencionSeccionalServicio convencionSeccionalServicio) {
				this.convencionSeccionalServicio = convencionSeccionalServicio;
			}
	
	

}
