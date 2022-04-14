package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;
import credito.bean.AmortizacionCreditoBean;
import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;

public class SimuladorConsultaControlador extends AbstractCommandController{
	
	CreditosServicio creditosServicio = null;
	
	public SimuladorConsultaControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditos");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException error)
			throws Exception {
		int tipoLista =(request.getParameter("tipoLista")!=null)?Integer.parseInt(request.getParameter("tipoLista")):0;
		int tipoListaSim = CreditosServicio.Enum_Sim_PagAmortizaciones.tmpPagAmort;
		String cobraSeguroCuota = request.getParameter("cobraSeguroCuota");
		String cobraAccesorios = request.getParameter("cobraAccesorios");
		CreditosBean creditos = (CreditosBean) command;
		
		List listaResultado = (List)new ArrayList();
		
		List<AmortizacionCreditoBean> LisCreditos = creditosServicio.simuladorAmortizaciones(tipoListaSim, creditos);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(Constantes.ENTERO_CERO);
		
		listaResultado.add(tipoLista);
		listaResultado.add(mensaje);
		listaResultado.add(LisCreditos);
		listaResultado.add(0);
		listaResultado.add("");
		listaResultado.add(cobraSeguroCuota);
		listaResultado.add(cobraAccesorios);

		return new ModelAndView("credito/simuladorPagosLibresGridVista", "listaResultado", listaResultado);		
	}	

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}
}
