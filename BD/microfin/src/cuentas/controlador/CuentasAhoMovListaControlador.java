package cuentas.controlador; 

  import java.util.ArrayList;
  import java.util.List;
 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;

 import general.bean.MensajeTransaccionBean;

 import org.springframework.validation.BindException;
 import org.springframework.web.servlet.ModelAndView;
 import org.springframework.web.servlet.mvc.AbstractCommandController;

 import cuentas.bean.CuentasAhoMovBean;
import cuentas.servicio.CuentasAhoMovServicio;

 public class CuentasAhoMovListaControlador extends AbstractCommandController {

 	CuentasAhoMovServicio cuentasAhoMovServicio = null;

 	public CuentasAhoMovListaControlador(){
 		setCommandClass(CuentasAhoMovBean.class);
 		setCommandName("cuentasAhoMovBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
 		CuentasAhoMovBean cuentasAhoMovBean = (CuentasAhoMovBean) command;
        
            List cuentasAhoMov = cuentasAhoMovServicio.lista(tipoLista, cuentasAhoMovBean);
            
            List listaResultado = (List)new ArrayList();
            listaResultado.add(tipoLista);
            listaResultado.add(controlID);
            listaResultado.add(cuentasAhoMov);
 		return new ModelAndView("cuentas/cuentasAhoMovListaVista", "listaResultado", listaResultado);
 	}

 	public void setCuentasAhoMovServicio(CuentasAhoMovServicio cuentasAhoMovServicio){
                     this.cuentasAhoMovServicio = cuentasAhoMovServicio;
 	}
 } 
