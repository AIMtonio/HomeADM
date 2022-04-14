package cuentas.reporte;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.ClienteBean;
import cuentas.servicio.CuentasAhoServicio;

public class CuentasClienteRepControlador extends SimpleFormController {

	CuentasAhoServicio cuentasAhoServicio = null;
	String nombreReporte = null;	

 	public CuentasClienteRepControlador(){
 		setCommandClass(ClienteBean.class);
 		setCommandName("cliente");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		ClienteBean clienteBean = (ClienteBean) command;
 		clienteBean.setSucursalOrigen(request.getParameter("nomEmpresa"));
 		String htmlString = cuentasAhoServicio.reporteCuentasCliente(clienteBean, nombreReporte);
 		

 		return new ModelAndView(getSuccessView(), "reporte", htmlString);
 	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	
	
}
