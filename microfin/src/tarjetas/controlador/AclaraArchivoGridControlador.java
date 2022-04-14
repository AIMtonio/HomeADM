package tarjetas.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tarjetas.bean.TarDebArchAclaBean;
import tarjetas.servicio.TarDebArchAclaServicio;

public class AclaraArchivoGridControlador extends AbstractCommandController {
	TarDebArchAclaServicio tarDebArchAclaServicio= null;
	

	public AclaraArchivoGridControlador() {
		setCommandClass(TarDebArchAclaBean.class);
		setCommandName("aclaraArchivo");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		TarDebArchAclaBean tarDebArchAclaBean = (TarDebArchAclaBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List aclaraArchivoList =	tarDebArchAclaServicio.listaAclaraArchivos(tipoLista, tarDebArchAclaBean);
		
				
		return new ModelAndView("tarjetas/aclaraArchivoGridVista", "aclaraArchivo", aclaraArchivoList);
	}

	public void setTarDebArchAclaServicio(TarDebArchAclaServicio tarDebArchAclaServicio) {
		this.tarDebArchAclaServicio = tarDebArchAclaServicio;
	}
	
	


}
