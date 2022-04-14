package nomina.reporte;
import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import general.bean.MensajeTransaccionBean;
import nomina.bean.AfiliacionBajaCtasClabeBean;
import nomina.servicio.AfiliacionBajaCtasClabeServicio;

public class RepAfiliacionBajaCtasClabeControlador extends AbstractCommandController {

	AfiliacionBajaCtasClabeServicio afiliacionBajaCtasClabeServicio = null;
	public RepAfiliacionBajaCtasClabeControlador(){
		setCommandClass(AfiliacionBajaCtasClabeBean.class);
		setCommandName("afiliacionBajaCtasClabe");
	}
	@Override
	protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object command,
			BindException errors) throws Exception {
		try{
			MensajeTransaccionBean mensaje = null;
			AfiliacionBajaCtasClabeBean afiliacionBajaCtasClabeBean = (AfiliacionBajaCtasClabeBean) command;
			String[] listaComentario = afiliacionBajaCtasClabeBean.getLisComentario().split(",");
			String[] listaClienteID = afiliacionBajaCtasClabeBean.getLisClienteID().split(",");
			List listaGuardada = (List) request.getSession().getAttribute("listaAfilia");
			PagedListHolder listaReporte = (PagedListHolder)listaGuardada.get(0);
			
			List listaTotal = listaReporte.getSource();
			for(int i=0;i<listaTotal.size();i++){
				AfiliacionBajaCtasClabeBean afilia = (AfiliacionBajaCtasClabeBean)listaTotal.get(i);
				for(int j=0;j<listaComentario.length;j++){
					if(afilia.getClienteID().equalsIgnoreCase((String) listaClienteID[j])){
						afilia.setComentario((String)listaComentario[j]);
					}
					listaTotal.set(i, afilia);
				}
			}
			listaReporte.setSource(listaTotal);
			
			
			
			List listaReporteExcel = listaReporte.getSource();
			afiliacionBajaCtasClabeServicio.generaReporteExcel(listaReporteExcel,"ReporteAfiliacionCuentasClabe",response);
		}catch(Exception ex){
			ex.printStackTrace();
		}
		return null;
	}
	public AfiliacionBajaCtasClabeServicio getAfiliacionBajaCtasClabeServicio() {
		return afiliacionBajaCtasClabeServicio;
	}
	public void setAfiliacionBajaCtasClabeServicio(AfiliacionBajaCtasClabeServicio afiliacionBajaCtasClabeServicio) {
		this.afiliacionBajaCtasClabeServicio = afiliacionBajaCtasClabeServicio;
	}
	

}
