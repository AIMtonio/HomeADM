package cuentas.controlador; 

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import cuentas.bean.TiposCuentaBean;
import cuentas.servicio.TiposCuentaServicio;

public class TiposCuentaListaControlador extends AbstractCommandController{

 	TiposCuentaServicio tiposCuentaServicio = null;

 	public TiposCuentaListaControlador(){
 		setCommandClass(TiposCuentaBean.class);
 		setCommandName("tiposCuenta");
 	}

 	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {


 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
        TiposCuentaBean tiposCuentaBean = (TiposCuentaBean) command;
                 List tiposCtasAho = tiposCuentaServicio.lista(tipoLista, tiposCuentaBean);
                 List listaResultado = (List)new ArrayList();
                 listaResultado.add(tipoLista);
                 listaResultado.add(controlID);
                 listaResultado.add(tiposCtasAho);
 		return new ModelAndView("cuentas/tiposCuentaListaVista", "listaResultado", listaResultado);
 	}

	public void setTiposCuentaServicio(TiposCuentaServicio tiposCuentaServicio) {
		this.tiposCuentaServicio = tiposCuentaServicio;
	}

 } 
