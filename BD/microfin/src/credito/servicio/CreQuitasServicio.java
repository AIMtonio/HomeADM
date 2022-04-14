package credito.servicio;
    
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
 
import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.ReqGastosSucBean;
import credito.bean.CreQuitasBean;
import credito.dao.CreQuitasDAO;

public class CreQuitasServicio extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	CreQuitasDAO creQuitasDAO = null;			
	
	//------------Constantes------------------
	 
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_CreQuitas {
		int principal 			= 1;
		int numQuitaXCredito	= 2;		
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_CreQuitas {
		int principal 			= 1;
	}
	
	//---------- Tipo de Transacciones ----------------------------------------------------------------	
	public static interface Enum_Tra_CreQuitas {
		int alta = 1;
	}
	
	public static interface Enum_Act_CreQuitas {
		int autoriza = 1;
	}
	
	public CreQuitasServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CreQuitasBean creQuitasBean){
		MensajeTransaccionBean mensaje = null;		
		switch (tipoTransaccion) {
			case Enum_Tra_CreQuitas.alta:		
				mensaje = creQuitasDAO.quitasCredito(creQuitasBean);				
				break;		
		}
		return mensaje;
	}

	public CreQuitasBean consulta(int tipoConsulta, CreQuitasBean creQuitasBean){
		CreQuitasBean creQuitasCon = null;
		switch (tipoConsulta) {
			case Enum_Con_CreQuitas.numQuitaXCredito:		
				creQuitasCon = creQuitasDAO.consultaNumQuitasXCredito(creQuitasBean, tipoConsulta);				
				break;	
		}
		return creQuitasCon;
	}
	
	
	public List lista(int tipoLista, CreQuitasBean creQuitasBean){		
		List listaCreQuitas = null;
		switch (tipoLista) {
			case Enum_Lis_CreQuitas.principal:		
			//	listaCreditos = creditosDAO.listaPrincipal(creditosBean, tipoLista);				
				break;	
		}		
		return listaCreQuitas;
	}
	
	
	// Funciones para reportes en credito.reporte.ReporteQuitasCondControlador
	
	
	 
	 	public ByteArrayOutputStream reporteQuitasCondPDF(CreQuitasBean creQuitasBean, String nomReporte) throws Exception{
	
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio", creQuitasBean.getFechaInicio() );
		parametrosReporte.agregaParametro("Par_FechaFin", creQuitasBean.getFechaFin() );
		parametrosReporte.agregaParametro("Par_ProductoCreditoID",Utileria.convierteEntero(creQuitasBean.getProducCreditoID()));
		parametrosReporte.agregaParametro("Par_CreditoID",Utileria.convierteLong(creQuitasBean.getCreditoID()));
		parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero( creQuitasBean.getSucursal()));
		parametrosReporte.agregaParametro("Par_FechaEmision", creQuitasBean.getParFechaEmision() );
			
		parametrosReporte.agregaParametro("Par_NomSucursal",(!creQuitasBean.getNombreSucursal().isEmpty())?creQuitasBean.getNombreSucursal():"TODAS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!creQuitasBean.getNombreUsuario().isEmpty())?creQuitasBean.getNombreUsuario(): "");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!creQuitasBean.getNombreInstitucion().isEmpty())?creQuitasBean.getNombreInstitucion(): "");
		parametrosReporte.agregaParametro("Par_NomProductoCre",(!creQuitasBean.getNombreProducto().isEmpty())?creQuitasBean.getNombreProducto() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomCredito",(!creQuitasBean.getNomCredito().isEmpty())?creQuitasBean.getNomCredito() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomCliente",(!creQuitasBean.getNomCliente().isEmpty())?creQuitasBean.getNomCliente() : "");
		
		parametrosReporte.agregaParametro("Par_InstitucionID",(!creQuitasBean.getInstitucionNominaID().isEmpty())?creQuitasBean.getInstitucionNominaID() : "0");
		parametrosReporte.agregaParametro("Par_ConvenioNominaID",(!creQuitasBean.getConvenioNominaID().isEmpty())?creQuitasBean.getConvenioNominaID() : "0");
		parametrosReporte.agregaParametro("Par_NombreEmpresa",creQuitasBean.getNombreInstit());
		parametrosReporte.agregaParametro("Par_NombreConvenio",creQuitasBean.getDesConvenio());
		parametrosReporte.agregaParametro("Par_EsproducNomina",creQuitasBean.getEsproducNomina());
		parametrosReporte.agregaParametro("Par_ManejaConvenio",creQuitasBean.getManejaConvenio());
		
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public String reporteQuitasCondPantalla(CreQuitasBean creQuitasBean , String nomReporte) throws Exception{
		
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio", creQuitasBean.getFechaInicio() );
		parametrosReporte.agregaParametro("Par_FechaFin", creQuitasBean.getFechaFin() );
		parametrosReporte.agregaParametro("Par_ProductoCreditoID",Utileria.convierteEntero(creQuitasBean.getProducCreditoID()));
		parametrosReporte.agregaParametro("Par_CreditoID",creQuitasBean.getCreditoID());
		parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero( creQuitasBean.getSucursal()));
		parametrosReporte.agregaParametro("Par_FechaEmision", creQuitasBean.getParFechaEmision() );
			
		parametrosReporte.agregaParametro("Par_NomSucursal",(!creQuitasBean.getNombreSucursal().isEmpty())?creQuitasBean.getNombreSucursal():"TODAS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!creQuitasBean.getNombreUsuario().isEmpty())?creQuitasBean.getNombreUsuario(): "");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!creQuitasBean.getNombreInstitucion().isEmpty())?creQuitasBean.getNombreInstitucion(): "");
		parametrosReporte.agregaParametro("Par_NomProductoCre",(!creQuitasBean.getNombreProducto().isEmpty())?creQuitasBean.getNombreProducto() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomCredito",(!creQuitasBean.getNomCredito().isEmpty())?creQuitasBean.getNomCredito() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomCliente",(!creQuitasBean.getNomCliente().isEmpty())?creQuitasBean.getNomCliente() : "");

				
		return Reporte.creaHtmlReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	} // fin metodos para reporte
	 
	public List listaReportesCreditos(int tipoLista,
			CreQuitasBean creQuitasBean, HttpServletResponse response) {
		// TODO Auto-generated method stub
		List listaCreQuitas = null;
		listaCreQuitas = creQuitasDAO.consultaCreQuitasReo(creQuitasBean, tipoLista);
		return listaCreQuitas;
	}
	
	//------------------ Getters y Setters ------------------------------------------------------	
	public CreQuitasDAO getCreQuitasDAO() {
		return creQuitasDAO;
	}


	public void setCreQuitasDAO(CreQuitasDAO creQuitasDAO) {
		this.creQuitasDAO = creQuitasDAO;
	}


	
	
}

