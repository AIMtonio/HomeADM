package cuentas.reporte;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteBean;
import cuentas.servicio.CuentasAhoServicio;

public class PDFCuentasClienteRepControlador extends AbstractCommandController{

	CuentasAhoServicio cuentasAhoServicio = null;
	String nombreReporte = null;	

 	public PDFCuentasClienteRepControlador(){
 		setCommandClass(ClienteBean.class);
 		setCommandName("cliente");
 	}

 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		ClienteBean clienteBean = (ClienteBean) command;
 		ByteArrayOutputStream htmlString = cuentasAhoServicio.reporteCuentasClientePDF(clienteBean, nombreReporte);
 		
 		response.addHeader("Content-Disposition","inline; filename=cuentasCliente.pdf");
 		response.setContentType("application/pdf");
 		byte[] bytes = htmlString.toByteArray();
 		response.getOutputStream().write(bytes,0,bytes.length);
		response.getOutputStream().flush();
		response.getOutputStream().close();

 		return null;
 	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	
	
}
