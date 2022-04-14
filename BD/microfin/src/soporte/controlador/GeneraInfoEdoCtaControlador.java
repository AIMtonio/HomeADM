package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.EdoCtaPerEjecutadoBean;
import soporte.servicio.GeneraInfoEdoCtaServicio;

public class GeneraInfoEdoCtaControlador extends SimpleFormController {
	//Instancia al servicio
	GeneraInfoEdoCtaServicio generaInfoEdoCtaServicio;

	public GeneraInfoEdoCtaControlador(){
		setCommandClass(EdoCtaPerEjecutadoBean.class);
 		setCommandName("edoCtaPerEjecutadoBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		generaInfoEdoCtaServicio.getGeneraInfoEdoCtaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		//Obtenemos el tipo de transaccion a realizar
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
			Integer.parseInt(request.getParameter("tipoTransaccion")):0;
			
		//Creamos la instancia al bean referente al controlador 		
		EdoCtaPerEjecutadoBean edoCtaPerEjecutadoBean = (EdoCtaPerEjecutadoBean) command;
		
		//Setteamos el valor de anioMes al bean
		edoCtaPerEjecutadoBean.setAnioMes(request.getParameter("anioMes"));
		
		//Creamos la instancia al bean Mensaje Transaccion 
		MensajeTransaccionBean mensaje = null;
		
		//Realizamos el llamado al metodo grabaTransaccion del servicio
		mensaje = generaInfoEdoCtaServicio.grabaTransaccion(tipoTransaccion, edoCtaPerEjecutadoBean);
		
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	//-------- Metodos Getter's and Setter's de nuestro servicio --------//
	public GeneraInfoEdoCtaServicio getGeneraInfoEdoCtaServicio() {
		return generaInfoEdoCtaServicio;
	}

	public void setGeneraInfoEdoCtaServicio(
			GeneraInfoEdoCtaServicio generaInfoEdoCtaServicio) {
		this.generaInfoEdoCtaServicio = generaInfoEdoCtaServicio;
	}
}
