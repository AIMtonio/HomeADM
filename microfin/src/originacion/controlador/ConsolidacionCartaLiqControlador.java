package originacion.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.ConsolidacionCartaLiqBean;
import originacion.servicio.ConsolidacionCartaLiqServicio;

public class ConsolidacionCartaLiqControlador extends SimpleFormController{
	ConsolidacionCartaLiqServicio consolidaCartaLiqServicio;
	
	public ConsolidacionCartaLiqControlador(){
		setCommandClass(ConsolidacionCartaLiqBean.class);
		setCommandName("consolidaCartas");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		ConsolidacionCartaLiqBean conCartaLiqBean = (ConsolidacionCartaLiqBean) command;
		MensajeTransaccionBean mensaje = null;
		try {
			int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccion")) : 0;
			consolidaCartaLiqServicio.getConsolidaCartaLiqDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensaje = consolidaCartaLiqServicio.grabaTransaccion(tipoTransaccion, conCartaLiqBean, "", tipoTransaccion);
		} catch(Exception ex){
			ex.printStackTrace();
		} finally {
			if(mensaje==null){
				mensaje=new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al grabar las Cartas de Liquidación Externas. ERROR");
			}
		}
		return new ModelAndView(getSuccessView(),"mensaje", mensaje);
	}
	
	public ConsolidacionCartaLiqServicio getConsolidaCartaLiqServicio (){
		return consolidaCartaLiqServicio;
	}
	
	public void setConsolidaCartaLiqServicio (ConsolidacionCartaLiqServicio consolidaCartaLiqServicio){
		this.consolidaCartaLiqServicio = consolidaCartaLiqServicio;
	}
}
