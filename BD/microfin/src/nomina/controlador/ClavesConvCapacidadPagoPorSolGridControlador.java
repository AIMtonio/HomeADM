package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.NomCapacidadPagoSolBean;
import nomina.bean.NomClavesConvenioBean;
import nomina.bean.NomDetCapacidadPagoSolBean;
import nomina.servicio.NomCapacidadPagoSolServicio;
import nomina.servicio.NomClavesConvenioServicio;
import nomina.servicio.NomDetCapacidadPagoSolServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class ClavesConvCapacidadPagoPorSolGridControlador extends AbstractCommandController{
	private NomClavesConvenioServicio nomClavesConvenioServicio = null;
	private NomCapacidadPagoSolServicio nomCapacidadPagoSolServicio = null;
	private NomDetCapacidadPagoSolServicio nomDetCapacidadPagoSolServicio = null;
	
	public ClavesConvCapacidadPagoPorSolGridControlador() {
		setCommandClass(NomClavesConvenioBean.class);
		setCommandName("nomClavesConvenioBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
	
		NomClavesConvenioBean nomClavesConvenio = (NomClavesConvenioBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		String solicitudCreditoID = request.getParameter("solicitudCreditoID");
		String nomCapacidadPagoSolID = request.getParameter("nomCapacidadPagoSolID");
		
		List lisCasaComercialPorSol = null;
		if (solicitudCreditoID != null && solicitudCreditoID != ""){
			NomCapacidadPagoSolBean nomCapacidadPagoSolBean = new NomCapacidadPagoSolBean();
			nomCapacidadPagoSolBean.setSolicitudCreditoID(solicitudCreditoID);
			
			lisCasaComercialPorSol = nomCapacidadPagoSolServicio.lista(1, nomCapacidadPagoSolBean);
		}
		
		List claveConvPorSolLis = null;
		
		if(tipoLista == 1){
			NomDetCapacidadPagoSolBean nomDetCapacidadPagoSolBean = new NomDetCapacidadPagoSolBean();
			nomDetCapacidadPagoSolBean.setNomCapacidadPagoSolID(nomCapacidadPagoSolID);
		
			claveConvPorSolLis = nomDetCapacidadPagoSolServicio.lista(tipoLista, nomDetCapacidadPagoSolBean);
		}else{
			claveConvPorSolLis = nomClavesConvenioServicio.lista(tipoLista, nomClavesConvenio);
		}
		 
		List listaResultado = (List)new ArrayList();
		
		listaResultado.add(tipoLista); // 0
		listaResultado.add(claveConvPorSolLis); // 1
		listaResultado.add(lisCasaComercialPorSol); // 2
		
		return new ModelAndView("nomina/clavesConvCapacidadPagoPorSolGridVista", "listaResultado", listaResultado);
	}

	public NomClavesConvenioServicio getNomClavesConvenioServicio() {
		return nomClavesConvenioServicio;
	}

	public void setNomClavesConvenioServicio(
			NomClavesConvenioServicio nomClavesConvenioServicio) {
		this.nomClavesConvenioServicio = nomClavesConvenioServicio;
	}

	public NomCapacidadPagoSolServicio getNomCapacidadPagoSolServicio() {
		return nomCapacidadPagoSolServicio;
	}

	public void setNomCapacidadPagoSolServicio(
			NomCapacidadPagoSolServicio nomCapacidadPagoSolServicio) {
		this.nomCapacidadPagoSolServicio = nomCapacidadPagoSolServicio;
	}

	public NomDetCapacidadPagoSolServicio getNomDetCapacidadPagoSolServicio() {
		return nomDetCapacidadPagoSolServicio;
	}

	public void setNomDetCapacidadPagoSolServicio(
			NomDetCapacidadPagoSolServicio nomDetCapacidadPagoSolServicio) {
		this.nomDetCapacidadPagoSolServicio = nomDetCapacidadPagoSolServicio;
	}
	
	
}






