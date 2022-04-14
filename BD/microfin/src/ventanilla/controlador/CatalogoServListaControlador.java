package ventanilla.controlador;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.CatalogoServBean;
import ventanilla.servicio.CatalogoServServicio;

public class CatalogoServListaControlador extends AbstractCommandController{
	
	CatalogoServServicio catalogoServServicio = null;

	public CatalogoServListaControlador(){
		setCommandClass(CatalogoServBean.class);
		setCommandName("catalogoServBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
       
		CatalogoServBean catalogoServBean = (CatalogoServBean) command;		
        List listaServicios = catalogoServServicio.lista(tipoLista, catalogoServBean);
        		
        List listaResultado = (List)new ArrayList();
        listaResultado.add(tipoLista);
        listaResultado.add(controlID);
        listaResultado.add(listaServicios);
        
        
		return new ModelAndView("ventanilla/catalogoServiciosListaVista", "listaResultado", listaResultado);
	}
	
	
	//----------------getter y setter-----------
	public CatalogoServServicio getCatalogoServServicio() {
		return catalogoServServicio;
	}

	public void setCatalogoServServicio(CatalogoServServicio catalogoServServicio) {
		this.catalogoServServicio = catalogoServServicio;
	}
	
	

}
