package cuentas.controlador; 

  import java.util.ArrayList;
  import java.util.List;
 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;

 import general.bean.MensajeTransaccionBean;

 import org.springframework.validation.BindException;
 import org.springframework.web.servlet.ModelAndView;
 import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.CuentasFirmaBean;
 import cuentas.bean.CuentasPersonaBean;
import cuentas.servicio.CuentasFirmaServicio;
import cuentas.servicio.CuentasPersonaServicio;

 public class CuentasFirmaListaControlador extends AbstractCommandController {

 	CuentasFirmaServicio cuentasFirmaServicio = null;

 	public CuentasFirmaListaControlador(){
 		setCommandClass(CuentasFirmaBean.class);
 		setCommandName("cuentasFirmaBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        CuentasFirmaBean cuentasFirmaBean = (CuentasFirmaBean) command;

                 List cuentasFirma = cuentasFirmaServicio.lista(tipoLista, cuentasFirmaBean);
                 
                 List listaResultado = (List)new ArrayList();
                 listaResultado.add(tipoLista);
                 listaResultado.add(controlID);
                 listaResultado.add(cuentasFirma);
 		return new ModelAndView("cuentas/cuentasFirmaListaVista", "listaResultado", listaResultado);
 	}

 	public void setCuentasFirmaServicio(CuentasFirmaServicio cuentasFirmaServicio){
                     this.cuentasFirmaServicio = cuentasFirmaServicio;
 	}
 } 
