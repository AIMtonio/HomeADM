package nomina.controlador;

import herramientas.Utileria;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.NomClavePresupBean;
import nomina.bean.NomTipoClavePresupBean;
import nomina.servicio.NomClavePresupServicio;
import nomina.servicio.NomTipoClavePresupServicio;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import com.google.gson.Gson;

import originacion.bean.FrecuenciaBean;

public class NomClavePresupGridControlador  extends AbstractCommandController  {
	NomClavePresupServicio nomClavePresupServicio = null;
	NomTipoClavePresupServicio nomTipoClavePresupServicio = null;
	
	public NomClavePresupGridControlador() {
		setCommandClass(NomClavePresupBean.class);
		setCommandName("nomClavePresupBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors) throws Exception {
				
		int tipoLista = (request.getParameter("tipoLista")!=null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;		

			NomTipoClavePresupBean nomTipoClavePresupBean = new NomTipoClavePresupBean();
			List tipoClavePresup = nomTipoClavePresupServicio.lista(NomTipoClavePresupServicio.Enum_Lis_TiposClavePresup.listaCombTipoClavePresup, nomTipoClavePresupBean);
			NomTipoClavePresupBean tipoClavePresupvacio = new NomTipoClavePresupBean();
			tipoClavePresupvacio.setDescripcion("SELECCIONE");
			tipoClavePresup.add(0,tipoClavePresupvacio);
		
			request.getSession().setAttribute("GridTipoClavePresup", tipoClavePresup);
			
			NomClavePresupBean nomClavePresupBean = (NomClavePresupBean) command;
			List listaClavePresup = nomClavePresupServicio.lista(tipoLista, nomClavePresupBean);
			
			List listaResultado = new ArrayList();
			
			listaResultado.add(tipoLista);//0
			listaResultado.add(tipoClavePresup);//2
			listaResultado.add(listaClavePresup);//Lista completa
						
			request.getSession().setAttribute("GridClavePresup", listaResultado);
			return new ModelAndView("nomina/clavePresupGridVista", "listaResultado", listaResultado);

	}

	public NomClavePresupServicio getNomClavePresupServicio() {
		return nomClavePresupServicio;
	}

	public void setNomClavePresupServicio(
			NomClavePresupServicio nomClavePresupServicio) {
		this.nomClavePresupServicio = nomClavePresupServicio;
	}

	public NomTipoClavePresupServicio getNomTipoClavePresupServicio() {
		return nomTipoClavePresupServicio;
	}

	public void setNomTipoClavePresupServicio(
			NomTipoClavePresupServicio nomTipoClavePresupServicio) {
		this.nomTipoClavePresupServicio = nomTipoClavePresupServicio;
	}
	
}


