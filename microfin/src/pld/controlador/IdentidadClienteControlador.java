package pld.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import pld.bean.IdentidadClienteBean;
import pld.servicio.IdentidadClienteServicio;

public class IdentidadClienteControlador extends SimpleFormController{
		IdentidadClienteServicio identidadClienteServicio=null;
		
		public IdentidadClienteControlador(){
			setCommandClass(IdentidadClienteBean.class);		
			setCommandName("identiCliente");			
		}
		
		protected ModelAndView onSubmit(HttpServletRequest request, 
										HttpServletResponse response, 
										Object command,
										BindException errors) throws Exception{
			
			IdentidadClienteBean identidadClienteBean = (IdentidadClienteBean) command;
			int tipoTransaccion = (request.getParameter("tipoTransaccion")!= null 
									? Integer.parseInt(request.getParameter("tipoTransaccion")):0);
			MensajeTransaccionBean mensaje = null;
			
			System.out.println("-----> "+tipoTransaccion);
			mensaje= identidadClienteServicio.grabaTransaccion(identidadClienteBean,tipoTransaccion);
			
			return new ModelAndView(getSuccessView(),"mensaje",mensaje);
		}

		public IdentidadClienteServicio getIdentidadClienteServicio() {
			return identidadClienteServicio;
		}
		public void setIdentidadClienteServicio(
				IdentidadClienteServicio identidadClienteServicio) {
			this.identidadClienteServicio = identidadClienteServicio;
		}
		
		
}
