package inversiones.controlador;

import inversiones.bean.BeneficiariosInverBean;
import inversiones.servicio.BeneficiariosInverServicio;


import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class BeneficiariosInverGridControlador extends  AbstractCommandController{
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	BeneficiariosInverServicio beneficiariosInverServicio =null;
	public BeneficiariosInverGridControlador() {
		setCommandClass(BeneficiariosInverBean.class);
		setCommandName("beneficiariosInverBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		BeneficiariosInverBean beneficiariosInverBean = (BeneficiariosInverBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List beneficiarios = beneficiariosInverServicio.lista(tipoLista, beneficiariosInverBean);
				
		return new ModelAndView("inversiones/beneficiariosInverGridVista", "listaResultado", beneficiarios);
	}

	//------------setter-----------------
	public void setBeneficiariosInverServicio(
			BeneficiariosInverServicio beneficiariosInverServicio) {
		this.beneficiariosInverServicio = beneficiariosInverServicio;
	}

	
	

}