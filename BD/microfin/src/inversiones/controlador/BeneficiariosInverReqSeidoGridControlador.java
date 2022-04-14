package inversiones.controlador;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import inversiones.bean.BeneficiariosInverBean;
import inversiones.servicio.BeneficiariosInverServicio;

public class BeneficiariosInverReqSeidoGridControlador extends  AbstractCommandController{	
	
	BeneficiariosInverServicio beneficiariosInverServicio =null;
	public BeneficiariosInverReqSeidoGridControlador() {
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
				
		return new ModelAndView("inversiones/beneficiariosInverReqSeidoGridVista", "befeficiariosInv", beneficiarios);
	}

	//------------setter-----------------
	public void setBeneficiariosInverServicio(
			BeneficiariosInverServicio beneficiariosInverServicio) {
		this.beneficiariosInverServicio = beneficiariosInverServicio;
	}

	
	

}