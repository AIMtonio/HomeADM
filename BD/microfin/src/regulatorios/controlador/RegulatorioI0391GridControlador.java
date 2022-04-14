package regulatorios.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import regulatorios.bean.RegulatorioI0391Bean;
import regulatorios.servicio.RegulatorioI0391Servicio;
import regulatorios.servicio.RegulatorioInsServicio;

public class RegulatorioI0391GridControlador extends AbstractCommandController{
	RegulatorioI0391Servicio	regulatorioI0391Servicio=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public RegulatorioI0391GridControlador() {
		setCommandClass(RegulatorioI0391Bean.class);
		setCommandName("regulatorioI0391");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {	
		
		RegulatorioI0391Bean regulatorioI0391Bean = (RegulatorioI0391Bean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));		
	
		int tipoInstitucion = Integer.parseInt(regulatorioI0391Bean.getInstitucionID());
		
		List listaResultado = regulatorioI0391Servicio.lista(tipoLista,tipoInstitucion, regulatorioI0391Bean);
		String nombreVista = "";
		if(tipoInstitucion == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.sofipo){
			nombreVista = "regulatorios/regulatorioI0391GridSofipoVista";
		}
		
		if(tipoInstitucion == RegulatorioInsServicio.Enum_Lis_TiposInstitucion.scap){
			nombreVista = "regulatorios/regulatorioI0391GridVista";
		}

		return new ModelAndView(nombreVista, "listaResultado", listaResultado);
	}
//------------------setter-------------
	public void setRegulatorioI0391Servicio(
			RegulatorioI0391Servicio regulatorioI0391Servicio) {
		this.regulatorioI0391Servicio = regulatorioI0391Servicio;
	}
	
	
}
