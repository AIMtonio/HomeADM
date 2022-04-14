package arrendamiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import arrendamiento.bean.ProductoArrendaBean;
import arrendamiento.servicio.ProductoArrendaServicio;

public class ProductoArrendaListaControlador extends AbstractCommandController {
	
	ProductoArrendaServicio productoArrendaServicio = null;
	
	public ProductoArrendaListaControlador() {
		setCommandClass(ProductoArrendaBean.class);
		setCommandName("productoArrendaBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {

	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	ProductoArrendaBean producto = (ProductoArrendaBean) command;
	
	List lineaArrenda =	 productoArrendaServicio.lista(tipoLista, producto);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(lineaArrenda);
			
	return new ModelAndView("arrendamiento/productoArrendaListaVista", "listaResultado", listaResultado);
	}

	public ProductoArrendaServicio getProductoArrendaServicio() {
		return productoArrendaServicio;
	}

	public void setProductoArrendaServicio(
			ProductoArrendaServicio productoArrendaServicio) {
		this.productoArrendaServicio = productoArrendaServicio;
	}


	
}
