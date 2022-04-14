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

public class LineasCredAltaCredListaControlador extends AbstractCommandController {

	LineasCreditoServicio lineasCreditoServicio = null;

	public LineasCredAltaCredListaControlador(){
		setCommandClass(LineasCreditoBean.class);
		setCommandName("lineasCredito");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		String tp=request.getParameter("tipoLista");
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
       String controlID = request.getParameter("controlID");
       
       LineasCreditoBean lineasCreditoBean = (LineasCreditoBean) command;
                List lineasCred = lineasCreditoServicio.lista(tipoLista, lineasCreditoBean);
                
                List listaResultado = (List)new ArrayList();
                listaResultado.add(tipoLista);
                listaResultado.add(controlID);
                listaResultado.add(lineasCred);
		return new ModelAndView("credito/lineasCredAltaCredListaVista", "listaResultado", listaResultado);
	}

	public void setLineasCreditoServicio(LineasCreditoServicio lineasCreditoServicio){
                    this.lineasCreditoServicio = lineasCreditoServicio;
	}
} 
