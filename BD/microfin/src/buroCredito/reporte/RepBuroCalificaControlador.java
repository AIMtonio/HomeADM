package buroCredito.reporte;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import buroCredito.bean.BuroCalificaBean;
import buroCredito.servicio.BuroCalificaServicio;

public class RepBuroCalificaControlador extends AbstractCommandController{
	BuroCalificaServicio buroCalificaServicio = null;

	public RepBuroCalificaControlador(){
		setCommandClass(BuroCalificaBean.class);
		setCommandName("buroCalificaBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		BuroCalificaBean buroCalificaBean = (BuroCalificaBean) command;
		int tipoReporte = (request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
		
		buroCalificaServicio.listaBuroCalifica(tipoReporte, buroCalificaBean, response);
		
		return null;
	}
	
	
	public BuroCalificaServicio getBuroCalificaServicio() {
		return buroCalificaServicio;
	}

	public void setBuroCalificaServicio(BuroCalificaServicio buroCalificaServicio) {
		this.buroCalificaServicio = buroCalificaServicio;
	}

}
