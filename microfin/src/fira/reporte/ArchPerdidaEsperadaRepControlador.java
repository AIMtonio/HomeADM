package fira.reporte;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import fira.bean.ArchPerdidaEsperadaBean;
import fira.servicio.ArchPerdidaEsperadaServicio;

public class ArchPerdidaEsperadaRepControlador extends AbstractCommandController {
	
	ArchPerdidaEsperadaServicio	archPerdidaEsperadaServicio;
	
	public ArchPerdidaEsperadaRepControlador() {
		setCommandClass(ArchPerdidaEsperadaBean.class);
		setCommandName("archPerdidaEsperadaBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response,Object command, BindException errors)throws Exception {
		ArchPerdidaEsperadaBean archPerdidaEsperadaBean = (ArchPerdidaEsperadaBean) command;
		archPerdidaEsperadaServicio.ejecutaKTRArchivosPerdida(archPerdidaEsperadaBean, response);
		return null;
	}

	public ArchPerdidaEsperadaServicio getArchPerdidaEsperadaServicio() {
		return archPerdidaEsperadaServicio;
	}

	public void setArchPerdidaEsperadaServicio(ArchPerdidaEsperadaServicio archPerdidaEsperadaServicio) {
		this.archPerdidaEsperadaServicio = archPerdidaEsperadaServicio;
	}

}