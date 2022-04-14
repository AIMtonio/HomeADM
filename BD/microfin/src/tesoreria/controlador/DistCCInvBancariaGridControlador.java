package tesoreria.controlador;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.DistCCInvBancariaBean;
import tesoreria.servicio.DistCCInvBancariaServicio;
public class DistCCInvBancariaGridControlador extends AbstractCommandController{
		
	DistCCInvBancariaServicio distCCInvBancariaServicio = null;
	public DistCCInvBancariaGridControlador() {
		setCommandClass(DistCCInvBancariaBean.class);
		setCommandName("distCCInvBancaria");
	}
		
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {			
		DistCCInvBancariaBean distCCInvBancaria = (DistCCInvBancariaBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String inversionID= request.getParameter("inversionID");
		distCCInvBancaria=new DistCCInvBancariaBean();
		distCCInvBancaria.setInversionID(inversionID);
		List<DistCCInvBancariaBean> distCCInvBancariaList = distCCInvBancariaServicio.lista(tipoLista, distCCInvBancaria);
		return new ModelAndView("tesoreria/detalleInvBancariaGridVista", "listaResultado", distCCInvBancariaList);
	}

	public DistCCInvBancariaServicio getDistCCInvBancariaServicio() {
		return distCCInvBancariaServicio;
	}

	public void setDistCCInvBancariaServicio(
			DistCCInvBancariaServicio distCCInvBancariaServicio) {
		this.distCCInvBancariaServicio = distCCInvBancariaServicio;
	}
}

