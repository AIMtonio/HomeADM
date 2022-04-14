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

public class UsuarioBCAMovilListaControlador extends AbstractCommandController{
	
CuentasBCAMovilServicio cuentasBCAMovilServicio = null;
	
	public UsuarioBCAMovilListaControlador(){
 		setCommandClass(CuentasBCAMovilBean.class);
 		setCommandName("cuentasBCAMovilBean");
 	}
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
      
		CuentasBCAMovilBean cuentasBCAMovilBean = (CuentasBCAMovilBean) command;
               List usuario = cuentasBCAMovilServicio.lista(tipoLista, cuentasBCAMovilBean);
               
               List listaResultado = (List)new ArrayList();
               listaResultado.add(tipoLista);
               listaResultado.add(controlID);
               listaResultado.add(usuario);
		return new ModelAndView("cliente/usuarioBCAMovilListaVista", "listaResultado", listaResultado);
	}

	public CuentasBCAMovilServicio getCuentasBCAMovilServicio() {
		return cuentasBCAMovilServicio;
	}

	public void setCuentasBCAMovilServicio(
			CuentasBCAMovilServicio cuentasBCAMovilServicio) {
		this.cuentasBCAMovilServicio = cuentasBCAMovilServicio;
	}

}
