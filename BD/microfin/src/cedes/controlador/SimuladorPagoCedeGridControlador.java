package cedes.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;
import cedes.bean.CedesBean;
import cedes.servicio.CedesServicio;

public class SimuladorPagoCedeGridControlador extends AbstractCommandController{
	
	
	CedesServicio cedesServicio = null;
	public SimuladorPagoCedeGridControlador() {
		setCommandClass(CedesBean.class);
		setCommandName("cedesBean");
	}
		
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException error)
			throws Exception {
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
					0;
				
		int tipoListaSim = CedesServicio.Enum_Lis_Cedes.simulador;
		CedesBean cedes = (CedesBean) command;
		
		List listaResultado = (List)new ArrayList();
		
		List LisPagos = cedesServicio.lista(tipoListaSim, cedes);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(Constantes.ENTERO_CERO);
		
		listaResultado.add(tipoLista);
		listaResultado.add(LisPagos);
			
		return new ModelAndView("cedes/simuladorPagosCedesGridVista", "listaResultado", listaResultado);
	}

	public CedesServicio getCedesServicio() {
		return cedesServicio;
	}

	public void setCedesServicio(CedesServicio cedesServicio) {
		this.cedesServicio = cedesServicio;
	}

} 
