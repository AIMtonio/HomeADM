package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.CuentaNostroBean;
import tesoreria.servicio.CuentaNostroServicio;

public class CtaNostroListaControlador extends AbstractCommandController{
     
	CuentaNostroServicio cuentaNostroServicio= null; 
	public CtaNostroListaControlador(){
		setCommandClass(CuentaNostroBean.class);
		setCommandName("numCtaInstitlista");
	}
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
    String controlID = request.getParameter("controlID");
    
    CuentaNostroBean ctaNostroBean = (CuentaNostroBean)command;
    List ctaNostroLis = cuentaNostroServicio.lista(tipoLista, ctaNostroBean);
    
    List listaResultado = (List)new ArrayList();
    listaResultado.add(tipoLista);
    listaResultado.add(controlID);
    listaResultado.add(ctaNostroLis);
    
    return new ModelAndView("tesoreria/cuentasNostroLista", "listaResultado", listaResultado);
	}
	
	public void setCuentaNostroServicio(CuentaNostroServicio cuentaNostroServicio){
		this.cuentaNostroServicio = cuentaNostroServicio;
	}
}
