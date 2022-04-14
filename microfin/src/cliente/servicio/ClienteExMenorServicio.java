package cliente.servicio;
import general.servicio.BaseServicio;
import herramientas.Utileria;
 
import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import reporte.ParametrosReporte;
import reporte.Reporte;
import cliente.bean.ActividadesCompletaBean;
import cliente.bean.ClienteBean;
import cliente.bean.ClienteExMenorBean;
import cliente.bean.ClientesCancelaBean;
import cliente.bean.ReporteClienteLocMarginadasBean;
import cliente.dao.ClienteExMenorDAO;
import cliente.servicio.ActividadesServicio.Enum_Con_Actividad;
import cliente.servicio.ClienteServicio.Enum_Con_ClienteCorpRel;
import cliente.servicio.DireccionesClienteServicio.Enum_Lis_ReporteClienteLocMarginadas;

public class ClienteExMenorServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	ClienteExMenorDAO clienteExMenorDAO = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_ExMenor {
		int principal 	= 1;
		int foranea 	= 2;
		int ctaPrincipal= 3;
	}

	public static interface Enum_Lis_ExMenor {
		int principal = 1;
		int lis_Cancelados=2;
		int lis_MenoresRepCancelados=3;
		
		int Sucursal =4; // Lista 1
		int principalVen	=5;
	}

	public ClienteExMenorServicio () {
		super();
		// TODO Auto-generated constructor stub
	}

		//Consulta Socio ExMenor
	public ClienteExMenorBean consulta(int tipoConsulta, ClienteExMenorBean clienteExMenorBean){
		ClienteExMenorBean clienteExMenor = null;		
		switch (tipoConsulta) {
			case Enum_Con_ExMenor.principal:
				clienteExMenor = clienteExMenorDAO.consultaPrincipal(clienteExMenorBean,tipoConsulta);
				break;
			case Enum_Con_ExMenor.ctaPrincipal:
				clienteExMenor = clienteExMenorDAO.consultaCtaExMenor(clienteExMenorBean,tipoConsulta);
				break;
		}
		
		return clienteExMenor;
	}
	
	
	
	
	//Lista Socio ExMenor
	public List listaPrincipal(int tipoLista,ClienteExMenorBean clienteExMenorBean){		
		List listaEstados = null;
		switch (tipoLista) {
			case Enum_Lis_ExMenor.principal:		
				listaEstados=  clienteExMenorDAO.listaPrincipal(clienteExMenorBean,tipoLista);				
				break;		
			case Enum_Lis_ExMenor.lis_Cancelados:		
				listaEstados=  clienteExMenorDAO.listaPrincipal(clienteExMenorBean,tipoLista);				
				break;
			case Enum_Lis_ExMenor.Sucursal:		
				listaEstados=  clienteExMenorDAO.listaPrincipalVentanilla(clienteExMenorBean,tipoLista);				
				break;
			case Enum_Lis_ExMenor.principalVen:		
				listaEstados=  clienteExMenorDAO.listaPrincipalVentanilla(clienteExMenorBean,tipoLista);				
				break;
		}		
		return listaEstados;
	}
	
	/* =========  Reporte PDF  Haberes de Ex-Menor  =========== */
	public ByteArrayOutputStream reporteHaberesExMenor(ClienteExMenorBean clienteExMenorBean , String nomReporte) throws Exception{
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_ClienteID",clienteExMenorBean.getClienteID() );		
		parametrosReporte.agregaParametro("Par_NombreInstitucion", clienteExMenorBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_SucursalID",clienteExMenorBean.getSucursalID());

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	/* =========  Reporte PDF ExMenores Cancelados  =========== */
	public ByteArrayOutputStream reporteExMenoresCancelados(ClienteExMenorBean clienteExMenorBean , String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_ClienteID",clienteExMenorBean.getClienteID());		
		parametrosReporte.agregaParametro("Par_NombreInstitucion", clienteExMenorBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaInicial",clienteExMenorBean.getFechaInicial());
		parametrosReporte.agregaParametro("Par_FechaFinal",clienteExMenorBean.getFechaFinal());
		parametrosReporte.agregaParametro("Par_SucursalInicial",clienteExMenorBean.getSucursalInicial());
		parametrosReporte.agregaParametro("Par_SucursalFinal",clienteExMenorBean.getSucursalFinal());
		parametrosReporte.agregaParametro("Par_NomUsuario",clienteExMenorBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_FechaEmision",clienteExMenorBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NomSucursalInicial",!clienteExMenorBean.getNomSucursalInicial().isEmpty()?clienteExMenorBean.getNomSucursalInicial():"TODAS" );
		parametrosReporte.agregaParametro("Par_NomSucursalFinal",!clienteExMenorBean.getNomSucursalFinal().isEmpty()?clienteExMenorBean.getNomSucursalFinal():"TODAS" );
		parametrosReporte.agregaParametro("Par_NomCliente",!clienteExMenorBean.getNombreCompleto().isEmpty()?clienteExMenorBean.getNombreCompleto():"TODOS" );

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	
	
	public List listaRepExMenoresCanceladosExcel(int tipoLista, ClienteExMenorBean clienteExMenorBean, HttpServletResponse response){
			 List listaExMenoresCancelados=null;
		switch(tipoLista){		
			case Enum_Lis_ExMenor.lis_MenoresRepCancelados:
				listaExMenoresCancelados = clienteExMenorDAO.listaExMenoresCancelados(clienteExMenorBean); 
				break;	
		}
		return listaExMenoresCancelados;
	}
	
	
	
	
	
	
	
	
	//------------------ Geters y Seters ------------------------------------------------------	

	public ClienteExMenorDAO getClienteExMenorDAO() {
		return clienteExMenorDAO;
	}

	public void setClienteExMenorDAO(ClienteExMenorDAO clienteExMenorDAO) {
		this.clienteExMenorDAO = clienteExMenorDAO;
	}
	
}
