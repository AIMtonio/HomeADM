package cliente.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;
 
import javax.servlet.http.HttpServletResponse;

import reporte.ParametrosReporte;
import reporte.Reporte;
import fondeador.bean.CreditoFondeoBean;
import fondeador.servicio.CreditoFondeoServicio.Enum_Lis_CredRep;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import cliente.bean.ApoyoEscolarSolBean;
import cliente.bean.ReporteApoyoEscolarSolBean;
import cliente.bean.ReporteClienteBean;
import cliente.dao.ApoyoEscolarSolDAO;


public class ApoyoEscolarSolServicio extends BaseServicio{

	
	/* Declaracion de Variables */
	ApoyoEscolarSolDAO apoyoEscolarSolDAO = null;
	


	public ApoyoEscolarSolServicio() {
		super();
	}
	

	/*Enumera los tipo de transaccion */
	public static interface Enum_Tra_ApoyoEscolarSol {
		int alta	 = 1;
		int modifica = 2;
		int actualiza= 3;
	}
	
	/*Enumera los tipo de actualizacion */
	public static interface Enum_Act_ApoyoEscolarSol {
		int principal= 1;  // autoriza o rechaza una solicitud
	}
	
	/* Enumera los tipo de consulta */
	public static interface Enum_Con_ApoyoEscolarSol { 
		int principal = 1;
		int estatusReg = 2;
	}

	/* Enumera los tipos de lista */
	public static interface Enum_Lis_Solicitud{
		int principal 				= 1;
		int porSolicitud			= 2;
		int Lis_PorSolicitudAut		= 3;
		int Lis_SolicitudAutCte		= 4;
		int Lis_Autorizados			= 5;
		
		int Lis_PorSolicitudAutSuc  = 6;// par la lista 3
		int Lis_PorSolicitudAutVen	= 7;
	}
	
	/* Enumera los tipos de lista para reportes */
	public static interface Enum_Tip_Reporte { 
		int excel = 1;
	}


	/* ========================== TRANSACCIONES ==============================  */


	/* Controla el tipo de transaccion que se debe ejecutar (alta,modifica,actualiza u otro que regrese datos(numError, MsjError,control y consecutivo))*/
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, ApoyoEscolarSolBean apoyoEscolarSolBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {		
			case Enum_Tra_ApoyoEscolarSol.alta:
				mensaje = apoyoEscolarSolDAO.alta(apoyoEscolarSolBean);					
				break;
			case Enum_Tra_ApoyoEscolarSol.modifica:
				mensaje = apoyoEscolarSolDAO.modificar(apoyoEscolarSolBean);					
				break;
			case Enum_Tra_ApoyoEscolarSol.actualiza:
				mensaje = grabaActualizacion(tipoActualizacion, apoyoEscolarSolBean);					
				break;
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean grabaActualizacion(int tipoActualizacion, ApoyoEscolarSolBean apoyoEscolarSolBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoActualizacion) {		
			case Enum_Act_ApoyoEscolarSol.principal:
				mensaje = apoyoEscolarSolDAO.actualiza(apoyoEscolarSolBean,tipoActualizacion);					
				break;	
		}
		return mensaje;
	}
	

	/* controla el tipo de consulta para solicitudes de apoyo escolar */
	public ApoyoEscolarSolBean consulta(int tipoConsulta,ApoyoEscolarSolBean apoyoEscolarSolBean){						
		ApoyoEscolarSolBean apoyoEscolarSolConBean = null;
		switch (tipoConsulta) {
			case Enum_Con_ApoyoEscolarSol.estatusReg:		
				apoyoEscolarSolConBean = apoyoEscolarSolDAO.consultaPrincipal(apoyoEscolarSolBean, tipoConsulta);				
				break;
			case Enum_Con_ApoyoEscolarSol.principal:		
				apoyoEscolarSolConBean = apoyoEscolarSolDAO.consultaPrincipal(apoyoEscolarSolBean, tipoConsulta);				
				break;
		}
			
		return apoyoEscolarSolConBean;
	}
	
	/* controla los tipos de listas para solicitudes de apoyo escolar */
	public List lista(int tipoLista, ApoyoEscolarSolBean apoyoEscolarSolBean){		
		List listaSolicitudes = null;
		switch (tipoLista) {
			case Enum_Lis_Solicitud.principal:		
				listaSolicitudes = apoyoEscolarSolDAO.listaPrincipal(apoyoEscolarSolBean, tipoLista);				
				break;
			case Enum_Lis_Solicitud.porSolicitud:		
				listaSolicitudes = apoyoEscolarSolDAO.listaPorSolicitud(apoyoEscolarSolBean, tipoLista);				
				break;
			case Enum_Lis_Solicitud.Lis_PorSolicitudAut:		
				listaSolicitudes = apoyoEscolarSolDAO.listaClientesSolAut(apoyoEscolarSolBean, tipoLista);				
				break;
			case Enum_Lis_Solicitud.Lis_PorSolicitudAutSuc:		
				listaSolicitudes = apoyoEscolarSolDAO.listaClientesSolAut(apoyoEscolarSolBean, tipoLista);				
				break;
			case Enum_Lis_Solicitud.Lis_PorSolicitudAutVen:		
				listaSolicitudes = apoyoEscolarSolDAO.listaClientesSolAut(apoyoEscolarSolBean, tipoLista);				
				break;
		}
				
		return listaSolicitudes;
	}
	
	/* Controla los tipos de lista para reportes de solicitudes de apoyo escolar*/
	public List listaReporte(int tipoLista, ReporteApoyoEscolarSolBean reporteApoyoEscolarSolBean , HttpServletResponse response){

		// List listaCreditos = null;
		 List listasolicitudesAE=null;
	
		switch(tipoLista){		
			case  Enum_Tip_Reporte.excel:
				listasolicitudesAE = apoyoEscolarSolDAO.listaReporte(reporteApoyoEscolarSolBean, tipoLista);
				break;				
		}
		
		return listasolicitudesAE;
	}
	
	
	/* =========  Reporte de Solicitudes de Apoyo Escolar PDF  =========== */
		public ByteArrayOutputStream reporteApoyoEscolar(int tipoReporte, ReporteApoyoEscolarSolBean reporteApoyoEscolarSolBean , String nomReporte) throws Exception{
			
			ParametrosReporte parametrosReporte = new ParametrosReporte();

			parametrosReporte.agregaParametro("Par_FechaInicio",Utileria.convierteFecha(reporteApoyoEscolarSolBean.getFechaInicio()) );
			parametrosReporte.agregaParametro("Par_FechaFin",Utileria.convierteFecha(reporteApoyoEscolarSolBean.getFechaFin()) );
			parametrosReporte.agregaParametro("Par_Estatus",reporteApoyoEscolarSolBean.getEstatus());
			parametrosReporte.agregaParametro("Par_SucursalRegistroID",reporteApoyoEscolarSolBean.getSucursalRegistroID());
			parametrosReporte.agregaParametro("Par_NumRep",tipoReporte);
			
			parametrosReporte.agregaParametro("Par_NombreInstitucion", reporteApoyoEscolarSolBean.getNombreInstitucion());
			parametrosReporte.agregaParametro("Par_FechaSistema",Utileria.convierteFecha(reporteApoyoEscolarSolBean.getFechaSistema()));
			parametrosReporte.agregaParametro("Par_Usuario",reporteApoyoEscolarSolBean.getNombreUsuario());

			return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}
		

		public Object[] listaCombo(int tipoLista,  ApoyoEscolarSolBean apoyoEscolarSolBean){		
			List listaSolicitudes = null;
			
			switch (tipoLista) {
				case Enum_Lis_Solicitud.Lis_SolicitudAutCte:		
					listaSolicitudes=  apoyoEscolarSolDAO.solicitudesListaCombo(apoyoEscolarSolBean, tipoLista);				
					break;				
			}		
			return listaSolicitudes.toArray();
		}

	
	/* ===================== GETTER's Y SETTER's ======================= */

	public ApoyoEscolarSolDAO getApoyoEscolarSolDAO() {
		return apoyoEscolarSolDAO;
	}


	public void setApoyoEscolarSolDAO(ApoyoEscolarSolDAO apoyoEscolarSolDAO) {
		this.apoyoEscolarSolDAO = apoyoEscolarSolDAO;
	}

		
}// fin de la clase
