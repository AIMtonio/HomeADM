package seguimiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import seguimiento.bean.CatTiposGestionBean;
import seguimiento.bean.RegistroGestorBean;
import seguimiento.bean.SegtoRealizadosBean;
import seguimiento.servicio.CatTiposGestionServicio;
import seguimiento.servicio.RegistroGestorServicio;
import seguimiento.servicio.SegtoRealizadosServicio;

public class TipoGestionListaControlador extends AbstractCommandController {

	CatTiposGestionServicio catTiposGestionServicio= null;

 	public TipoGestionListaControlador(){
 		setCommandClass(CatTiposGestionBean.class);
		setCommandName("tipoGestionBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
        CatTiposGestionBean catTiposGestionBean = (CatTiposGestionBean) command;
        List listaTipoGestion = catTiposGestionServicio.lista(tipoLista, catTiposGestionBean);
        
        List listaResultado = (List)new ArrayList();
        listaResultado.add(tipoLista);
        listaResultado.add(controlID);
        listaResultado.add(listaTipoGestion);
        return new ModelAndView("seguimiento/tipoGestionListaVista", "listaResultado", listaResultado);
 	}
	
	// Getter y Setter
	public CatTiposGestionServicio getCatTiposGestionServicio() {
		return catTiposGestionServicio;
	}
	
	public void setCatTiposGestionServicio(
			CatTiposGestionServicio catTiposGestionServicio) {
		this.catTiposGestionServicio = catTiposGestionServicio;
	}
}
