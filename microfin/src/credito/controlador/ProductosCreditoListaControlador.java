package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.LineasCreditoBean;
import credito.bean.ProductosCreditoBean;
import credito.servicio.LineasCreditoServicio;
import credito.servicio.ProductosCreditoServicio;

public class ProductosCreditoListaControlador extends AbstractCommandController {

	ProductosCreditoServicio productosCreditoServicio = null;

	public ProductosCreditoListaControlador(){
		setCommandClass(ProductosCreditoBean.class);
		setCommandName("productosCredito");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
       String controlID = request.getParameter("controlID");
       
       ProductosCreditoBean productoCredito = (ProductosCreditoBean) command;
                List productosCredito = productosCreditoServicio.lista(tipoLista, productoCredito);
                
                List listaResultado = (List)new ArrayList();
                listaResultado.add(tipoLista);
                listaResultado.add(controlID);
                listaResultado.add(productosCredito);
		return new ModelAndView("credito/productosCreditoListaVista", "listaResultado", listaResultado);
	}
	public void setProductosCreditoServicio(
			ProductosCreditoServicio productosCreditoServicio) {
		this.productosCreditoServicio = productosCreditoServicio;
	}

} 

