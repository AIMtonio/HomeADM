package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.servicio.IndiceNaPreConsumidorServicio;
import soporte.bean.IndiceNaPreConsumidorBean;

public class IndiceNaPreConsumidorControlador extends SimpleFormController{
	
	IndiceNaPreConsumidorServicio indiceNaPreConsumidorServicio = null;
	
	public IndiceNaPreConsumidorControlador() {
		setCommandClass(IndiceNaPreConsumidorBean.class);
		setCommandName("indiceNaPreConsumidorBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		
		indiceNaPreConsumidorServicio.getIndiceNaPreConsumidorDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		IndiceNaPreConsumidorBean edoCtaParams= (IndiceNaPreConsumidorBean) command;
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
				
		MensajeTransaccionBean mensaje = null;
		
		mensaje = indiceNaPreConsumidorServicio.grabaTransaccion(tipoTransaccion,edoCtaParams);
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	/* ============ SETTER's Y GETTER's =============== */
	
	public IndiceNaPreConsumidorServicio getIndiceNaPreConsumidorServicio() {
		return indiceNaPreConsumidorServicio;
	}

	public void setIndiceNaPreConsumidorServicio(
			IndiceNaPreConsumidorServicio indiceNaPreConsumidorServicio) {
		this.indiceNaPreConsumidorServicio = indiceNaPreConsumidorServicio;
	}
	
}