package originacion.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.AsignaCartaLiqBean;
import originacion.servicio.AsignaCartaLiqServicio;

public class AsignaCartaLiqInternaControlador extends SimpleFormController{
	AsignaCartaLiqServicio asignaCartaLiqServicio;
	
	public AsignaCartaLiqInternaControlador(){
		setCommandClass(AsignaCartaLiqBean.class);
		setCommandName("asignaCartaInterna");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		AsignaCartaLiqBean cartaLiqBean = (AsignaCartaLiqBean) command;
		MensajeTransaccionBean mensaje = null;
		try{
			int tipoTransaccion = (request.getParameter("tipoTransaccionInt") != null) ? Utileria.convierteEntero(request.getParameter("tipoTransaccionInt")) : 0;
			String solicitudID = (request.getParameter("solicitudID") != null) ? request.getParameter("solicitudID") : "";		
			String consolidaID = (request.getParameter("consolidaID") != null) ? request.getParameter("consolidaID") : "";
			String rutaArchivos = (request.getParameter("rutaArchivosInt") != null) ? request.getParameter("rutaArchivosInt") : "";	
			cartaLiqBean.setSolicitudCreditoID(solicitudID);
			cartaLiqBean.setConsolidacionID(consolidaID);
			cartaLiqBean.setRutaArchivos(rutaArchivos);
			String datosGridInt = (request.getParameter("datosGridInt") != null) ? request.getParameter("datosGridInt") : "";
			asignaCartaLiqServicio.getAsignaCartaLiqDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
			mensaje = asignaCartaLiqServicio.grabaDetalleInt(cartaLiqBean,datosGridInt);
		} catch(Exception ex){
			ex.printStackTrace();
		} finally {
			if(mensaje==null){
				mensaje=new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al Grabar las Cartas de Liquidacion.");
			}
		}
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public AsignaCartaLiqServicio getAsignaCartaLiqServicio(){
		return asignaCartaLiqServicio;
	}
	
	public void setAsignaCartaLiqServicio(AsignaCartaLiqServicio asignaCartaLiqServicio){
		this.asignaCartaLiqServicio = asignaCartaLiqServicio;
	}
}
