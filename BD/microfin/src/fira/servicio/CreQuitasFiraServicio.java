package fira.servicio;
    
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
 
import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import reporte.ParametrosReporte;
import reporte.Reporte;
import fira.bean.CreQuitasFiraBean;
import fira.dao.CreQuitasFiraDAO;

public class CreQuitasFiraServicio extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	CreQuitasFiraDAO creQuitasFiraDAO = null;			
	
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
		int altaContingente = 2; // CarteraContingente 
	}
	
	public static interface Enum_Act_CreQuitas {
		int autoriza = 1;
	}	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CreQuitasFiraBean creQuitasFiraBean){
		MensajeTransaccionBean mensaje = null;		
		switch (tipoTransaccion) {
			case Enum_Tra_CreQuitas.alta:		
				mensaje = creQuitasFiraDAO.quitasCredito(creQuitasFiraBean,tipoTransaccion);				
				break;	
			case Enum_Tra_CreQuitas.altaContingente:		
				mensaje = creQuitasFiraDAO.quitasCredito(creQuitasFiraBean,tipoTransaccion);				
				break;	
		}
		return mensaje;
	}

	public CreQuitasFiraBean consulta(int tipoConsulta, CreQuitasFiraBean creQuitasFiraBean){
		CreQuitasFiraBean creQuitasCon = null;
		switch (tipoConsulta) {
			case Enum_Con_CreQuitas.numQuitaXCredito:		
				creQuitasCon = creQuitasFiraDAO.consultaNumQuitasXCredito(creQuitasFiraBean, tipoConsulta);				
				break;	
		}
		return creQuitasCon;
	}
	
	
	public List lista(int tipoLista, CreQuitasFiraBean creQuitasFiraBean){		
		List listaCreQuitas = null;
		switch (tipoLista) {
			case Enum_Lis_CreQuitas.principal:		
			//	listaCreditos = creditosDAO.listaPrincipal(creditosBean, tipoLista);				
				break;	
		}		
		return listaCreQuitas;
	}
	
	
	// Funciones para reportes en credito.reporte.ReporteQuitasCondControlador
	
	
	 
	 	public ByteArrayOutputStream reporteQuitasCondPDF(CreQuitasFiraBean creQuitasFiraBean, String nomReporte) throws Exception{
	
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio", creQuitasFiraBean.getFechaInicio() );
		parametrosReporte.agregaParametro("Par_FechaFin", creQuitasFiraBean.getFechaFin() );
		parametrosReporte.agregaParametro("Par_ProductoCreditoID",Utileria.convierteEntero(creQuitasFiraBean.getProducCreditoID()));
		parametrosReporte.agregaParametro("Par_CreditoID",Utileria.convierteLong(creQuitasFiraBean.getCreditoID()));
		parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero( creQuitasFiraBean.getSucursal()));
		parametrosReporte.agregaParametro("Par_FechaEmision", creQuitasFiraBean.getParFechaEmision() );
			
		parametrosReporte.agregaParametro("Par_NomSucursal",(!creQuitasFiraBean.getNombreSucursal().isEmpty())?creQuitasFiraBean.getNombreSucursal():"TODAS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!creQuitasFiraBean.getNombreUsuario().isEmpty())?creQuitasFiraBean.getNombreUsuario(): "");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!creQuitasFiraBean.getNombreInstitucion().isEmpty())?creQuitasFiraBean.getNombreInstitucion(): "");
		parametrosReporte.agregaParametro("Par_NomProductoCre",(!creQuitasFiraBean.getNombreProducto().isEmpty())?creQuitasFiraBean.getNombreProducto() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomCredito",(!creQuitasFiraBean.getNomCredito().isEmpty())?creQuitasFiraBean.getNomCredito() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomCliente",(!creQuitasFiraBean.getNomCliente().isEmpty())?creQuitasFiraBean.getNomCliente() : "");
	
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public String reporteQuitasCondPantalla(CreQuitasFiraBean creQuitasFiraBean , String nomReporte) throws Exception{
		
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio", creQuitasFiraBean.getFechaInicio() );
		parametrosReporte.agregaParametro("Par_FechaFin", creQuitasFiraBean.getFechaFin() );
		parametrosReporte.agregaParametro("Par_ProductoCreditoID",Utileria.convierteEntero(creQuitasFiraBean.getProducCreditoID()));
		parametrosReporte.agregaParametro("Par_CreditoID",creQuitasFiraBean.getCreditoID());
		parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero( creQuitasFiraBean.getSucursal()));
		parametrosReporte.agregaParametro("Par_FechaEmision", creQuitasFiraBean.getParFechaEmision() );
			
		parametrosReporte.agregaParametro("Par_NomSucursal",(!creQuitasFiraBean.getNombreSucursal().isEmpty())?creQuitasFiraBean.getNombreSucursal():"TODAS");
		parametrosReporte.agregaParametro("Par_NomUsuario",(!creQuitasFiraBean.getNombreUsuario().isEmpty())?creQuitasFiraBean.getNombreUsuario(): "");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!creQuitasFiraBean.getNombreInstitucion().isEmpty())?creQuitasFiraBean.getNombreInstitucion(): "");
		parametrosReporte.agregaParametro("Par_NomProductoCre",(!creQuitasFiraBean.getNombreProducto().isEmpty())?creQuitasFiraBean.getNombreProducto() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomCredito",(!creQuitasFiraBean.getNomCredito().isEmpty())?creQuitasFiraBean.getNomCredito() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomCliente",(!creQuitasFiraBean.getNomCliente().isEmpty())?creQuitasFiraBean.getNomCliente() : "");

				
		return Reporte.creaHtmlReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	} // fin metodos para reporte
	 
	public List listaReportesCreditos(int tipoLista,
			CreQuitasFiraBean creQuitasFiraBean, HttpServletResponse response) {
		// TODO Auto-generated method stub
		List listaCreQuitas = null;
		listaCreQuitas = creQuitasFiraDAO.consultaCreQuitasRep(creQuitasFiraBean, tipoLista);
		return listaCreQuitas;
	}


	public CreQuitasFiraDAO getCreQuitasFiraDAO() {
		return creQuitasFiraDAO;
	}


	public void setCreQuitasFiraDAO(CreQuitasFiraDAO creQuitasFiraDAO) {
		this.creQuitasFiraDAO = creQuitasFiraDAO;
	}
	
	//------------------ Getters y Setters ------------------------------------------------------	


	
	
}

