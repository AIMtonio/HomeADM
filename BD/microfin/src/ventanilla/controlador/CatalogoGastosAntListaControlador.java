package ventanilla.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.CatalogoGastosAntBean;
import ventanilla.servicio.CatalogoGastosAntServicio;

public class CatalogoGastosAntListaControlador extends AbstractCommandController{
	
	CatalogoGastosAntServicio catalogoGastosAntServicio = null;

	public CatalogoGastosAntListaControlador(){
		setCommandClass(CatalogoGastosAntBean.class);
		setCommandName("catalogoGastosAntBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
       
		CatalogoGastosAntBean catalogoGastosAntBean = (CatalogoGastosAntBean) command;
        List listaServicios = catalogoGastosAntServicio.lista(tipoLista, catalogoGastosAntBean);
        		
        List listaResultado = (List)new ArrayList();
        listaResultado.add(tipoLista);
        listaResultado.add(controlID);
        listaResultado.add(listaServicios);
        
        
		return new ModelAndView("ventanilla/catalogoGastosAntListaVista", "listaResultado", listaResultado);
	}

	

	//----------------getter y setter-----------
	public CatalogoGastosAntServicio getCatalogoGastosAntServicio() {
		return catalogoGastosAntServicio;
	}

	public void setCatalogoGastosAntServicio(
			CatalogoGastosAntServicio catalogoGastosAntServicio) {
		this.catalogoGastosAntServicio = catalogoGastosAntServicio;
	}
	
	
	
	
	

}
