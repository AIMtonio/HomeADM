package cuentas.controlador; 

  import java.util.ArrayList;
  import java.util.List;
 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;

 import general.bean.MensajeTransaccionBean;

 import org.springframework.validation.BindException;
 import org.springframework.web.servlet.ModelAndView;
 import org.springframework.web.servlet.mvc.AbstractCommandController;

 import cuentas.bean.CuentasPersonaBean;
import cuentas.servicio.CuentasPersonaServicio;

 public class CuentasPersonaListaControlador extends AbstractCommandController {

 	CuentasPersonaServicio cuentasPersonaServicio = null;

 	public CuentasPersonaListaControlador(){
 		setCommandClass(CuentasPersonaBean.class);
 		setCommandName("cuentasPersonaBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
 		CuentasPersonaBean cuentasPersonaBean = (CuentasPersonaBean) command;

                 List cuentasPersona = cuentasPersonaServicio.lista(tipoLista, cuentasPersonaBean);
                 
                 List listaResultado = (List)new ArrayList();
                 listaResultado.add(tipoLista);
                 listaResultado.add(controlID);
                 listaResultado.add(cuentasPersona);
 		return new ModelAndView("cuentas/cuentasPersonaListaVista", "listaResultado", listaResultado);
 	}

 	public void setCuentasPersonaServicio(CuentasPersonaServicio cuentasPersonaServicio){
                     this.cuentasPersonaServicio = cuentasPersonaServicio;
 	}
 } 
