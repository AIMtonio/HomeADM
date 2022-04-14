package soporte.reporte;

import general.bean.ParametrosAuditoriaBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.EdoCtaEnvioCorreoBean;

public class EdoCtaEnvioCorreoXMLControlador extends AbstractCommandController{
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	String successView=null;
	public EdoCtaEnvioCorreoXMLControlador(){
		setCommandClass(EdoCtaEnvioCorreoBean.class);
		setCommandName("edoCtaEnvioCorreoBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
		
		EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean = (EdoCtaEnvioCorreoBean) command;
		
		mostrarEstadoCuentaXML(edoCtaEnvioCorreoBean, response); 
		
		return null;
	}
	
	public void mostrarEstadoCuentaXML(EdoCtaEnvioCorreoBean edoCtaEnvioCorreoBean, HttpServletResponse response){
		try{
			response.addHeader("Content-Dispositipon", "inline; filename=Estado de Cuenta");
			response.setContentType("application/xml");
			byte[] bytes = Utileria.leerArchivo(edoCtaEnvioCorreoBean.getRutaXML());
			response.getOutputStream().write(bytes,0,bytes.length);
			response.getOutputStream().flush();
			response.getOutputStream().close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public String getSuccessView() {
		return successView;
	}
	
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
	
	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}
	
	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
}
