package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.AmortizacionCreditoBean;
import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;
import credito.servicio.CreditosServicio.Enum_Sim_PagAmortizaciones;

public class SimuladorPagLibresControlador  extends AbstractCommandController {

	CreditosServicio creditosServicio = null;
	
	public SimuladorPagLibresControlador() {
		setCommandClass(CreditosBean.class);
		setCommandName("creditos");
	}
	
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		List listaResultado = (List)new ArrayList();
		try{
		int tipoLista =(request.getParameter("tipoLista")!=null)?Integer.parseInt(request.getParameter("tipoLista")):0;
		String montosCapital = request.getParameter("montosCapital");
		String cobraSeguroCuota = request.getParameter("cobraSeguroCuota");
		String cobraAccesorios = request.getParameter("cobraAccesorios");
		
		CreditosBean creditos = (CreditosBean) command;
		List LisCreditos = (List)new ArrayList();
		
		switch (tipoLista) {
			case Enum_Sim_PagAmortizaciones.pagosLibresTasaFija:		
				LisCreditos = creditosServicio.grabaListaSimPagLib(creditos, montosCapital);
		        listaResultado.add(tipoLista);
		        listaResultado.add(LisCreditos.get(0));
		        listaResultado.add(LisCreditos.get(1));
		        break;	
			case Enum_Sim_PagAmortizaciones.pagosLibresTasaVar:	
				LisCreditos = creditosServicio.grabaListaSimPagLibTasaVar(creditos, montosCapital);
		        listaResultado.add(tipoLista);
		        listaResultado.add(LisCreditos.get(0));
		        listaResultado.add(LisCreditos.get(1));
				break;
			case Enum_Sim_PagAmortizaciones.pagLibFecCapTasaFija:			

				LisCreditos = creditosServicio.grabaListaSimPagLibFecCap(creditos, montosCapital);
		        listaResultado.add(tipoLista);
		        listaResultado.add(LisCreditos.get(0));
		        listaResultado.add(LisCreditos.get(1));
				break;
			case Enum_Sim_PagAmortizaciones.pagLibFecCapTasaVar:			

				LisCreditos = creditosServicio.grabaListaSimPagLibFecCapTasVar(creditos, montosCapital);
		        listaResultado.add(tipoLista);
		        listaResultado.add(LisCreditos.get(0));
		        listaResultado.add(LisCreditos.get(1));
				break;
		}
		
	     if(LisCreditos!=null && LisCreditos.size()>=1){
	    	 List<AmortizacionCreditoBean> lista=(List<AmortizacionCreditoBean>) LisCreditos.get(1);
	    	 if(lista!=null){
		    	 String numeroError=lista.get(0).getCodigoError();
		    	 String messError=lista.get(0).getMensajeError();
			     listaResultado.add(numeroError);
			     listaResultado.add(messError);
			     listaResultado.add(cobraSeguroCuota);
			     listaResultado.add(cobraAccesorios);
		     } else {
		    	 listaResultado.add("999");
			     listaResultado.add("Ocurrio un Error al Simular.");
			     listaResultado.add("N");
		     }
	     } else {
	    	 listaResultado.add("999");
		     listaResultado.add("Ocurrio un Error al Simular.");
		     listaResultado.add("N");
	     }
	        
	        
		} catch(Exception ex){
			ex.printStackTrace();
			listaResultado.add(0); //Tipo de Lista
			listaResultado.add(null); //Mensaje
			listaResultado.add(null); //Listaresultado
			listaResultado.add("999");
		    listaResultado.add("Ocurrio un Error al Simular.");
		}

		return new ModelAndView("credito/simuladorPagosLibresGridVista", "listaResultado", listaResultado);
								
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	

		
}

