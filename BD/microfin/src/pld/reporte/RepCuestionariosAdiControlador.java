package pld.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ClienteBean;

import pld.servicio.CuestionariosAdicionalesServicio;

public class RepCuestionariosAdiControlador extends AbstractCommandController {
	
	CuestionariosAdicionalesServicio cuestionariosAdicionalesServicio = null;
	String nombreReporte = null;
	String successView = null;
	
	public RepCuestionariosAdiControlador(){
		setCommandClass(ClienteBean.class);
		setCommandName("cliente");
	}
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)
			throws Exception {

		ClienteBean clienteBean = (ClienteBean) command;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
		
		ByteArrayOutputStream htmlStringPDF = cuestionariosAdicionalesServicio.cuestionariosAdicionales(clienteBean,nombreReporte, response, tipoReporte);

		return null;

	}
		
	public CuestionariosAdicionalesServicio getCuestionariosAdicionalesServicio() {
		return cuestionariosAdicionalesServicio;
	}

	public void setCuestionariosAdicionalesServicio(CuestionariosAdicionalesServicio cuestionariosAdicionalesServicio) { 
		this.cuestionariosAdicionalesServicio = cuestionariosAdicionalesServicio;
	}
	
	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}	

}
