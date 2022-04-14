package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.CatCajerosATMBean;
import tesoreria.servicio.CatCajerosATMServicio;

public class CatCajerosATMListaControlador  extends AbstractCommandController{
    
	CatCajerosATMServicio catCajerosATMServicio= null; 
	public CatCajerosATMListaControlador(){
		setCommandClass(CatCajerosATMBean.class);
		setCommandName("catCajerosATMBean");
	}
	@Override
	protected ModelAndView handle(HttpServletRequest request,
								HttpServletResponse response,
								Object command,
								BindException errors) throws Exception {

			int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		   String controlID = request.getParameter("controlID");
		   
		   CatCajerosATMBean catCajerosATMBean = (CatCajerosATMBean)command;
		   List listaCajerosATM = catCajerosATMServicio.lista(tipoLista, catCajerosATMBean);
		   
		   List listaResultado = (List)new ArrayList();
		   listaResultado.add(tipoLista);
		   listaResultado.add(controlID);
		   listaResultado.add(listaCajerosATM);
		   
		   return new ModelAndView("tesoreria/catCajerosATMListaVista", "listaResultado", listaResultado);
	}
	
	//------------------setter---------------
	public void setCatCajerosATMServicio(CatCajerosATMServicio catCajerosATMServicio) {
		this.catCajerosATMServicio = catCajerosATMServicio;
	}
	
	
}
