package tarjetas.controlador; 

 import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

 import general.bean.MensajeTransaccionBean;

 import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.LineaTarjetaCreditoBean;
import tarjetas.servicio.LineaTarjetaCreditoServicio;



 public class LineaTarjetaCredListaControlador extends AbstractCommandController {

	 LineaTarjetaCreditoServicio lineaTarjetaCreditoServicio = null;

 	public LineaTarjetaCredListaControlador(){
 		setCommandClass(LineaTarjetaCreditoBean.class);
 		setCommandName("lineaTarjetaCreditoBean");
 	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

 		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
        String controlID = request.getParameter("controlID");
        
        LineaTarjetaCreditoBean lineaTarjetaCreditoBean = (LineaTarjetaCreditoBean) command;
                 List lineaTarjeta = lineaTarjetaCreditoServicio.lista(tipoLista, lineaTarjetaCreditoBean);
                 
                 List listaResultado = (List)new ArrayList();
                 listaResultado.add(tipoLista);
                 listaResultado.add(controlID);
                 listaResultado.add(lineaTarjeta);
       
 		return new ModelAndView("tarjetas/lineaCreditoListaVista", "listaResultado", listaResultado);
 	}
	
	

	public LineaTarjetaCreditoServicio getLineaTarjetaCreditoServicio() {
		return lineaTarjetaCreditoServicio;
	}

	public void setLineaTarjetaCreditoServicio(
			LineaTarjetaCreditoServicio lineaTarjetaCreditoServicio) {
		this.lineaTarjetaCreditoServicio = lineaTarjetaCreditoServicio;
	}

 	
	
	
	
	
	
 } 
