package pld.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ExpedienteClienteBean;
import pld.servicio.PLDListasPersBloqServicio;
import pld.bean.PLDListasPersBloqBean;

public class PLDPersBloqConControlador extends AbstractCommandController {
	
	PLDListasPersBloqServicio pldListasPersBloqServicio = null;
	public String successView = null;

	public PLDPersBloqConControlador() {
		setCommandClass(PLDListasPersBloqBean.class);
		setCommandName("listaPersBloq");
	}

	protected ModelAndView handle(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		int tipoConsulta = 2;
		PLDListasPersBloqBean pldListasPersBloqBean = (PLDListasPersBloqBean) command;		
		return new ModelAndView(getSuccessView(), "listaPersBloq",
				pldListasPersBloqServicio.consulta(tipoConsulta, pldListasPersBloqBean));
	}

	public PLDListasPersBloqServicio getPldListasPersBloqServicio() {
		return pldListasPersBloqServicio;
	}

	public void setPldListasPersBloqServicio(
			PLDListasPersBloqServicio pldListasPersBloqServicio) {
		this.pldListasPersBloqServicio = pldListasPersBloqServicio;
	}

	public String getSuccessView() {
		return successView;
	}

	public void setSuccessView(String successView) {
		this.successView = successView;
	}

}
