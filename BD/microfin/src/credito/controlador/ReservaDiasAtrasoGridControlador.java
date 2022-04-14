package credito.controlador;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.PorReservaPeriodoBean;
import credito.servicio.PorReservaPeriodoServicio;

public class ReservaDiasAtrasoGridControlador extends AbstractCommandController{
	
	PorReservaPeriodoServicio porReservaPeriodoServicio = null;

	public ReservaDiasAtrasoGridControlador() {
		setCommandClass(PorReservaPeriodoBean.class);
		setCommandName("porReservaPeriodoBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
			
		PorReservaPeriodoBean porReservaPeriodoBean = (PorReservaPeriodoBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List reservaPeriodoList = porReservaPeriodoServicio.lista(tipoLista, porReservaPeriodoBean);
		
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(reservaPeriodoList);
					
		return new ModelAndView("credito/reservaDiasAtrasoGridVista", "listaResultado", listaResultado);
	}

	public PorReservaPeriodoServicio getPorReservaPeriodoServicio() {
		return porReservaPeriodoServicio;
	}

	public void setPorReservaPeriodoServicio(
			PorReservaPeriodoServicio porReservaPeriodoServicio) {
		this.porReservaPeriodoServicio = porReservaPeriodoServicio;
	}

}
