package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.MovimientosGridBean;
import tesoreria.servicio.MovimientosGridServicio;


public class MovimientosGridControlador extends AbstractCommandController {
	
	MovimientosGridServicio movimientosGridServicio = null;

	public MovimientosGridControlador() {
		setCommandClass(MovimientosGridBean.class);
		setCommandName("Movimientos");
	}

	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		
		MovimientosGridBean movimientosGridBean = (MovimientosGridBean) command;
		int tipoLista =(request.getParameter("tipoLista")!=null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		List listaMovimientos = movimientosGridServicio.movimientos(tipoLista,movimientosGridBean);
         
        List listaResultado = (List)new ArrayList();
        listaResultado.add(listaMovimientos);;
       
		return new ModelAndView("tesoreria/movimientosGridVista", "listaResultado", listaResultado);
	}

	public MovimientosGridServicio getMovimientosGridServicio() {
		return movimientosGridServicio;
	}

	public void setMovimientosGridServicio(
			MovimientosGridServicio movimientosGridServicio) {
		this.movimientosGridServicio = movimientosGridServicio;
	}

	
	
}
