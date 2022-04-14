package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.NomClasifClavePresupBean;
import nomina.bean.NomDetCapacidadPagoSolBean;
import nomina.servicio.NomClasifClavePresupServicio;
import nomina.servicio.NomDetCapacidadPagoSolServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class ClavesConvCapacidadPagoConvGridControlador extends AbstractCommandController{
	private NomClasifClavePresupServicio nomClasifClavePresupServicio = null;
	private NomDetCapacidadPagoSolServicio nomDetCapacidadPagoSolServicio = null;
	
	public ClavesConvCapacidadPagoConvGridControlador() {
		setCommandClass(NomClasifClavePresupBean.class);
		setCommandName("nomClasifClavePresupBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
	
		NomClasifClavePresupBean clasificacionClavePresup = (NomClasifClavePresupBean) command;
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String nomCapacidadPagoSolID = request.getParameter("nomCapacidadPagoSolID");
		
		List clasificacionClaveLis = null;
		
		if(tipoLista == 2){
			NomDetCapacidadPagoSolBean nomDetCapacidadPagoSolBean = new NomDetCapacidadPagoSolBean();
			nomDetCapacidadPagoSolBean.setNomCapacidadPagoSolID(nomCapacidadPagoSolID);
			nomDetCapacidadPagoSolBean.setClasifClavePresupID(clasificacionClavePresup.getNomClasifClavPresupID());
			
			clasificacionClaveLis = nomDetCapacidadPagoSolServicio.lista(tipoLista, nomDetCapacidadPagoSolBean);
			
		}else{
			clasificacionClaveLis = nomClasifClavePresupServicio.lista(tipoLista, clasificacionClavePresup);
		}
				 
		List listaResultado = (List)new ArrayList();
		
		listaResultado.add(tipoLista); // 0
		listaResultado.add(clasificacionClaveLis); // 1
		
		return new ModelAndView("nomina/clavesConvCapacidadPagoConvGridVista", "listaResultado", listaResultado);
	}

	public NomClasifClavePresupServicio getNomClasifClavePresupServicio() {
		return nomClasifClavePresupServicio;
	}

	public void setNomClasifClavePresupServicio(
			NomClasifClavePresupServicio nomClasifClavePresupServicio) {
		this.nomClasifClavePresupServicio = nomClasifClavePresupServicio;
	}

	public NomDetCapacidadPagoSolServicio getNomDetCapacidadPagoSolServicio() {
		return nomDetCapacidadPagoSolServicio;
	}

	public void setNomDetCapacidadPagoSolServicio(
			NomDetCapacidadPagoSolServicio nomDetCapacidadPagoSolServicio) {
		this.nomDetCapacidadPagoSolServicio = nomDetCapacidadPagoSolServicio;
	}
	
	
}
