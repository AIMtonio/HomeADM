package tesoreria.controlador;

import java.io.PrintWriter;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.DispersionBean;
import tesoreria.servicio.OperDispersionServicio;

public class ImpDisControaldor extends AbstractCommandController {

	OperDispersionServicio operDispersionServicio = null;
	String successView = null;
	
	
	public ImpDisControaldor(){
		setCommandClass(DispersionBean.class);
		setCommandName("operDispersion");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							HttpServletResponse response,
							Object command,
							BindException errors)throws Exception {

		DispersionBean dispersionBean = (DispersionBean) command;

		operDispersionServicio.getOperDispersionDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
		
		MensajeTransaccionBean mensaje = null;
				
		mensaje = operDispersionServicio.grabaTransaccion(tipoTransaccion, dispersionBean);
		mensaje.setNombreControl("folioOperacion");
		
		return new ModelAndView(getSuccessView(),"mensaje", mensaje);
	}
	
	
	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public void setOperDispersionServicio(OperDispersionServicio operDispersionServicio) {
		this.operDispersionServicio = operDispersionServicio;
	}
}