package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import com.google.gson.Gson;

import credito.bean.CarCreditoSuspendidoBean;
import credito.servicio.CarCreditoSuspendidoServicio;

public class CarCreditoSuspListaControlador extends AbstractCommandController{
	CarCreditoSuspendidoServicio carCreditoSuspendidoServicio = null;
	
	public CarCreditoSuspListaControlador(){
		setCommandClass(CarCreditoSuspendidoBean.class);
		setCommandName("CarCreditoSuspendidoBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		CarCreditoSuspendidoBean carCreditoSuspendidoBean = (CarCreditoSuspendidoBean) command;
		
		List listCreditosSup = carCreditoSuspendidoServicio.lista(tipoLista, carCreditoSuspendidoBean);

		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listCreditosSup);
		
		return new ModelAndView("credito/carCreditoSuspendidoListaVista", "listaResultado", listaResultado);
	}

	public CarCreditoSuspendidoServicio getCarCreditoSuspendidoServicio() {
		return carCreditoSuspendidoServicio;
	}

	public void setCarCreditoSuspendidoServicio(
			CarCreditoSuspendidoServicio carCreditoSuspendidoServicio) {
		this.carCreditoSuspendidoServicio = carCreditoSuspendidoServicio;
	}
	
}
