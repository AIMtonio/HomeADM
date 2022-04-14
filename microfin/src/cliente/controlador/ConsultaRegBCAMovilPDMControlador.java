package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.CuentasBCAMovilBean;
import cliente.servicio.CuentasBCAMovilServicio;

public class ConsultaRegBCAMovilPDMControlador extends AbstractCommandController{
	
	CuentasBCAMovilServicio cuentasBCAMovilServicio = null;

 	public ConsultaRegBCAMovilPDMControlador(){
 		setCommandClass(CuentasBCAMovilBean.class);
 		setCommandName("cuentasBCAMovilBean");
 	}
 	
 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		CuentasBCAMovilBean cuentasBCAMovilBean = (CuentasBCAMovilBean) command;	
		
		return new ModelAndView("cliente/consultaRegBCAMovilPDMVista", "cuentasBCAMovilBean", cuentasBCAMovilBean);

	}
 	
 	 
 	// ---------------  getter y setter -------------------- 
 	public CuentasBCAMovilServicio getCuentasBCAMovilServicio() {
 		return cuentasBCAMovilServicio;
 	}
 	
 	public void setCuentasBCAMovilServicio(
 			CuentasBCAMovilServicio cuentasBCAMovilServicio) {
 		this.cuentasBCAMovilServicio = cuentasBCAMovilServicio;
 	}

}
