package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.CuentasBCAMovilBean;
import cliente.servicio.CuentasBCAMovilServicio;

public class CtaUsuaBCAMovilGridControlador extends AbstractCommandController{
	
	CuentasBCAMovilServicio cuentasBCAMovilServicio = null;

 	public CtaUsuaBCAMovilGridControlador(){
 		setCommandClass(CuentasBCAMovilBean.class);
 		setCommandName("cuentasBCAMovilBean");
 	}
 	
 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		CuentasBCAMovilBean cuentasBCAMovilBean = (CuentasBCAMovilBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List consultaRegistro = cuentasBCAMovilServicio.lista(tipoLista, cuentasBCAMovilBean);
		
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(consultaRegistro);
		
		return new ModelAndView("cliente/ctaUsuaBCAMovilGridVista", "listaResultado", listaResultado);

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
