package cliente.controlador;
   
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteBean;
import cliente.bean.ClienteExMenorBean;
import cliente.servicio.ClienteExMenorServicio;
import  cliente.servicio.ClienteServicio;

public class ClienteExMenorControlador extends SimpleFormController {
	ClienteExMenorServicio clienteExMenorServicio = null;
	String nombreReporte = null;
	String successView = null;		

 	public ClienteExMenorControlador(){
 		setCommandClass(ClienteExMenorBean.class);
 		setCommandName("clienteExmenorBean");
 	}
    
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		ClienteExMenorBean clienteExmenorBean = (ClienteExMenorBean) command;
 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
			
						   
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte Perfil Cliente");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}




	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public void setClienteExMenorServicio(
			ClienteExMenorServicio clienteExMenorServicio) {
		this.clienteExMenorServicio = clienteExMenorServicio;
	}

}
 
 
