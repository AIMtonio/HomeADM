package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.DepositosRefeBean;
import tesoreria.servicio.DepositosRefeServicio;


public class DepReferenGridControlador extends AbstractCommandController{


	DepositosRefeServicio depositosRefeServicio = null;
	public 	DepReferenGridControlador(){
		setCommandClass( DepositosRefeBean.class);
		setCommandName("DepReferenGrid");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException errors)
			throws Exception {
		
		
		DepositosRefeBean depositosRefeBean = new DepositosRefeBean();
		                                              
        String  institucionID =(request.getParameter("institucionID")!=null) ? request.getParameter("institucionID") : "";
        String  cuentaAhoID =(request.getParameter("numCtaInstit")!=null) ? request.getParameter("numCtaInstit") : "";
        String   tipoCon   =(request.getParameter("tipoConsulta")!=null) ? request.getParameter("tipoConsulta") : "";
        
        depositosRefeBean.setInstitucionID(institucionID);
        depositosRefeBean.setCuentaAhoID(cuentaAhoID);

		int tipoConsulta = Integer.parseInt(tipoCon);
		List listaResul = depositosRefeServicio.depReferenLis(depositosRefeBean, tipoConsulta);
	    List listaResultado = (List)new ArrayList();
		listaResultado.add(listaResul);
		
		return new ModelAndView("tesoreria/depReferenGridVista", "listaResultado", listaResultado);
	}

	public DepositosRefeServicio getDepositosRefeServicio() {
		return depositosRefeServicio;
		     
	}
 
	public void setDepositosRefeServicio(
			DepositosRefeServicio depositosRefeServicio) {
		this.depositosRefeServicio = depositosRefeServicio;
	}
}
