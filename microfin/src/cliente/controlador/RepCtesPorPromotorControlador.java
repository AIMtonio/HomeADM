package cliente.controlador;
   
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteBean;
import cliente.bean.ReporteIDEBean;
import cliente.servicio.ClienteServicio;

public class RepCtesPorPromotorControlador extends SimpleFormController {
	ClienteServicio clienteServicio = null;

 	public RepCtesPorPromotorControlador(){
 		setCommandClass(ClienteBean.class);
 		setCommandName("reporteBean");
 	}
    
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		ClienteBean clienteBean = (ClienteBean) command;
 		
 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
				
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
						   Integer.parseInt(request.getParameter("tipoActualizacion")) : 0;
						   
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte Clientes Por Promotor");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}

	public ClienteServicio getClienteServicio() {
		return clienteServicio;
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}

}
