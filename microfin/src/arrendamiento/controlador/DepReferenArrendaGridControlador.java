package arrendamiento.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import arrendamiento.bean.DepositoRefereArrendaBean;
import arrendamiento.servicio.DepositoRefereArrendaServicio;

public class DepReferenArrendaGridControlador extends AbstractCommandController{
	DepositoRefereArrendaServicio depositoRefereArrendaServicio = null;
	public 	DepReferenArrendaGridControlador(){
		setCommandClass( DepositoRefereArrendaBean.class);
		setCommandName("depReferenGrid");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		DepositoRefereArrendaBean depositosRefeBean = new DepositoRefereArrendaBean();
        String depRefereID 	= (request.getParameter("depRefereID")!=null) ? request.getParameter("depRefereID") : "";		
        String tipoCon   	= (request.getParameter("tipoConsulta")!=null) ? request.getParameter("tipoConsulta") : "";
        depositosRefeBean.setDepRefereID(depRefereID);
		int tipoConsulta = Integer.parseInt(tipoCon);
		List listaResul = depositoRefereArrendaServicio.lista(tipoConsulta, depositosRefeBean);
	    List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoCon);
		listaResultado.add(listaResul);
		return new ModelAndView("arrendamiento/depRefereArrendaGridVista", "listaResultado", listaResultado);
	}

	public DepositoRefereArrendaServicio getDepositoRefereArrendaServicio() {
		return depositoRefereArrendaServicio;
	}

	public void setDepositoRefereArrendaServicio(
			DepositoRefereArrendaServicio depositoRefereArrendaServicio) {
		this.depositoRefereArrendaServicio = depositoRefereArrendaServicio;
	}
}
