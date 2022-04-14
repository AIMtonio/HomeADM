package fira.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.GarantiaBean;
import originacion.servicio.GarantiaServicio;

public class AsigGarantiasAgroGridControlador extends  AbstractCommandController{

	GarantiaServicio garantiaServicio = null;

	public AsigGarantiasAgroGridControlador(){
		setCommandClass(GarantiaBean.class);
		setCommandName("garantiaBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		String tp=request.getParameter("tipoLista");
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
       String solicitudCreditoID=request.getParameter("solicitudCreditoID");
       String creditoID=request.getParameter("creditoID");
       String garantiaID=request.getParameter("garantiaID");
       
       GarantiaBean garantiaBean = new GarantiaBean();
       
       garantiaBean.setSolicitudCreditoID(solicitudCreditoID);
       garantiaBean.setCreditoID(creditoID);
       garantiaBean.setGarantiaID(garantiaID);
       
                List garantiasLista = garantiaServicio.lista(tipoLista, garantiaBean);
                	
                List listaResultado = (List)new ArrayList();
                listaResultado.add(garantiasLista);
                
		return new ModelAndView("fira/asigGarantiasAgroGridVista", "listaResultado", listaResultado);
	}
	
	public void setGarantiaServicio(
			GarantiaServicio garantiaServicio) {
		this.garantiaServicio = garantiaServicio;
	}
}
