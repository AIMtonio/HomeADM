package credito.controlador;


import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.LineasCreditoBean;
import credito.servicio.LineasCreditoServicio;

public class LineasCreditoListaControlador extends AbstractCommandController {

	LineasCreditoServicio lineasCreditoServicio = null;

	public LineasCreditoListaControlador(){
		setCommandClass(LineasCreditoBean.class);
		setCommandName("lineasCreditoBean");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		String tp=request.getParameter("tipoLista");

		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
       String controlID = request.getParameter("controlID");
       
       LineasCreditoBean lineasCreditoBean = (LineasCreditoBean) command;
                List lineasCredito = lineasCreditoServicio.lista(tipoLista, lineasCreditoBean);
                
                List listaResultado = (List)new ArrayList();
                listaResultado.add(tipoLista);
                listaResultado.add(controlID);
                listaResultado.add(lineasCredito);
		return new ModelAndView("credito/lineasCreditoListaVista", "listaResultado", listaResultado);
	}

	public void setLineasCreditoServicio(LineasCreditoServicio lineasCreditoServicio){
                    this.lineasCreditoServicio = lineasCreditoServicio;
	}
} 
