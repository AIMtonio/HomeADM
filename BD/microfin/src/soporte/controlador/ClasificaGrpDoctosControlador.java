package soporte.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.ClasificaGrpDoctosBean;
import soporte.servicio.ClasificaGrpDoctosServicio;
import soporte.servicio.GrupoDocumentosServicio;

public class ClasificaGrpDoctosControlador extends SimpleFormController {
	
	ClasificaGrpDoctosServicio clasificaGrpDoctosServicio = null;
	GrupoDocumentosServicio grupoDocumentosServicio = null;
 	private ParametrosSesionBean parametrosSesionBean = null;

	public ClasificaGrpDoctosControlador() {
		setCommandClass(ClasificaGrpDoctosBean.class);
		setCommandName("clasificaGrpDocto");
	}
		
	public static interface Enum_Trans {
		int altagrupoDocumentos = 1;
		int modificaGrupoDoctos=2;
		int altaClasificaGrupos=3;
		int eliminaGrupoDoctos =4;
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		clasificaGrpDoctosServicio.getClasificaGrpDoctosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		grupoDocumentosServicio.getGrupoDocumentosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		ClasificaGrpDoctosBean clasifica = (ClasificaGrpDoctosBean) command;
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));	
		String ListaAlta = (request.getParameter("datosTipoDoc")!=null)?
							request.getParameter("datosTipoDoc"):"";	
				
		String ListaBaja = (request.getParameter("datosGridBaja")!=null)?
							request.getParameter("datosGridBaja"):"";
			
			
		MensajeTransaccionBean mensaje = null;
		
		switch (tipoTransaccion) {
			case Enum_Trans.altagrupoDocumentos:		
				mensaje = grupoDocumentosServicio.grabaTransaccion(tipoTransaccion,clasifica);		
				break;			
				
			case Enum_Trans.modificaGrupoDoctos:		
				mensaje = grupoDocumentosServicio.grabaTransaccion(tipoTransaccion,clasifica);		
				break;	
				
			case Enum_Trans.altaClasificaGrupos:		
				mensaje = clasificaGrpDoctosServicio.grabaTransaccion(tipoTransaccion,ListaAlta,ListaBaja);			
				break;		
				
			case Enum_Trans.eliminaGrupoDoctos:		
				mensaje = grupoDocumentosServicio.grabaTransaccion(tipoTransaccion,clasifica);		
				break;		
		}													
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}


	public ClasificaGrpDoctosServicio getClasificaGrpDoctosServicio() {
		return clasificaGrpDoctosServicio;
	}


	public void setClasificaGrpDoctosServicio(
			ClasificaGrpDoctosServicio clasificaGrpDoctosServicio) {
		this.clasificaGrpDoctosServicio = clasificaGrpDoctosServicio;
	}


	public GrupoDocumentosServicio getGrupoDocumentosServicio() {
		return grupoDocumentosServicio;
	}


	public void setGrupoDocumentosServicio(
			GrupoDocumentosServicio grupoDocumentosServicio) {
		this.grupoDocumentosServicio = grupoDocumentosServicio;
	}
	
}
