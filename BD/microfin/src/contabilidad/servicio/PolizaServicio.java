package contabilidad.servicio;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import reporte.ParametrosReporte;
import reporte.Reporte;
import contabilidad.bean.DetallePolizaBean;
import contabilidad.bean.ReporteBalanzaContableBean;
import contabilidad.bean.ReportePolizaBean;
import contabilidad.dao.PolizaDAO;
import contabilidad.dao.ReportesContablesDAO;
import contabilidad.bean.PolizaBean;

public class PolizaServicio extends BaseServicio{
	//---------- Variables ------------------------------------------------------------------------
	PolizaDAO polizaDAO = null;
	
	//---------- Constructor ------------------------------------------------------------------------
	public PolizaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public static interface Enum_Tra_Poliza {
		int alta 			= 1;
		int modificacion 	= 2;
		int actualizacion 	= 3;
		int polizaPlantilla = 4;
		int plantilla	 	= 5;
		int polizaPlantillaN = 6;
		int agregarInf 		= 7;
		int modificaInf		= 8;
	}
	
	public static interface Enum_Con_Poliza {
		int principal		= 1;
		int plantilla		= 2;
		int infAdicional	= 3;
	}
	
	public static interface Enum_Lis_Poliza {
		int principal		= 1;
		int plantilla		= 2;
		}
	
	//---------- Transacciones ------------------------------------------------------------------------
	
	public MensajeTransaccionBean grabaListaPoliza(int tipoTransaccion, String desPlantilla, PolizaBean polizaBean,
			String polizaDetalle){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		switch(tipoTransaccion){
		
			case Enum_Tra_Poliza.alta:
				ArrayList listaPolizaDetallePlanUno = (ArrayList) creaListaPolizaPlan(polizaDetalle);
				mensaje = polizaDAO.grabaListaPoliza(polizaBean, listaPolizaDetallePlanUno, tipoTransaccion, desPlantilla);
			break;
			case Enum_Tra_Poliza.polizaPlantilla:
				ArrayList listaPolizaDetalleUno = (ArrayList) creaListaPoliza(polizaDetalle);
				mensaje = polizaDAO.grabaListaPoliza(polizaBean, listaPolizaDetalleUno, tipoTransaccion, desPlantilla);
					
			break;
			case Enum_Tra_Poliza.plantilla:				
				ArrayList listaPolizaDetallePlanDos = (ArrayList) creaListaPolizaPlan(polizaDetalle);
			mensaje = polizaDAO.grabaListaPlantilla(polizaBean, desPlantilla, listaPolizaDetallePlanDos);
			break;
			case Enum_Tra_Poliza.modificacion:
				ArrayList listaPolizaDetallePlanTres = (ArrayList) creaListaPolizaPlan(polizaDetalle);
				mensaje = polizaDAO.modificaListaPlantilla(polizaBean, listaPolizaDetallePlanTres);				
			break;
			case Enum_Tra_Poliza.polizaPlantillaN:
				ArrayList listaPolizaDetalleDos = (ArrayList) creaListaPoliza(polizaDetalle);
				mensaje = polizaDAO.grabaListaPoliza(polizaBean, listaPolizaDetalleDos, tipoTransaccion, desPlantilla);
			break;
			
			case Enum_Tra_Poliza.agregarInf:
				mensaje = polizaDAO.altaPolizaInfAdicional(polizaBean);				
				
			break;
			case Enum_Tra_Poliza.modificaInf:
				mensaje = polizaDAO.modificaPolizaInfAdicional(polizaBean);				
				
			break;
			
			
			
		}			
		return mensaje;		 
	}
	
	private List creaListaPoliza(String detalle){		
		StringTokenizer tokensBean = new StringTokenizer(detalle, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaDetalle = new ArrayList();
		DetallePolizaBean detallePolizaBean;
		
		while(tokensBean.hasMoreTokens()){
		detallePolizaBean = new DetallePolizaBean();
		
		stringCampos = tokensBean.nextToken();		
		tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");

		detallePolizaBean.setFecha(tokensCampos[0]);
		detallePolizaBean.setCentroCostoID(tokensCampos[1]);
		detallePolizaBean.setCuentaCompleta(tokensCampos[2]);
		detallePolizaBean.setInstrumento(tokensCampos[3]);
		detallePolizaBean.setReferencia(tokensCampos[4]);
		detallePolizaBean.setDescripcion(tokensCampos[5]);
		detallePolizaBean.setMonedaID(tokensCampos[6]);
		detallePolizaBean.setRFC(tokensCampos[7]);
		detallePolizaBean.setTotalFactura(tokensCampos[8]);
		detallePolizaBean.setFolioUUID(tokensCampos[9]);
		detallePolizaBean.setCargos(tokensCampos[10]);
		detallePolizaBean.setAbonos(tokensCampos[11]);
	
		listaDetalle.add(detallePolizaBean);
		
		}
		
		return listaDetalle;
	}
	
	private List creaListaPolizaPlan(String detalle){		
		StringTokenizer tokensBean = new StringTokenizer(detalle, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaDetalle = new ArrayList();
		DetallePolizaBean detallePolizaBean;
		
		while(tokensBean.hasMoreTokens()){
		detallePolizaBean = new DetallePolizaBean();
		
		stringCampos = tokensBean.nextToken();		
		tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");

		detallePolizaBean.setFecha(tokensCampos[0]);
		detallePolizaBean.setCentroCostoID(tokensCampos[1]);
		detallePolizaBean.setCuentaCompleta(tokensCampos[2]);
		detallePolizaBean.setInstrumento(tokensCampos[3]);
		detallePolizaBean.setReferencia(tokensCampos[4]);
		detallePolizaBean.setDescripcion(tokensCampos[5]);
		detallePolizaBean.setMonedaID(tokensCampos[6]);
		detallePolizaBean.setCargos(tokensCampos[7]);
		detallePolizaBean.setAbonos(tokensCampos[8]);
		
		listaDetalle.add(detallePolizaBean);
	
		}
		
		return listaDetalle;
	}
	
	public PolizaBean consulta(int tipoConsulta, PolizaBean polizaBean){
		PolizaBean poliza = null;
		switch(tipoConsulta){
			case Enum_Con_Poliza.principal:
				poliza = polizaDAO.consultaPrincipal(polizaBean, Enum_Con_Poliza.principal);
			break;
			case Enum_Con_Poliza.plantilla:
				poliza = polizaDAO.consultaPrincipalPlantilla(polizaBean, Enum_Con_Poliza.plantilla);
			break;
			case Enum_Con_Poliza.infAdicional:	
				poliza = polizaDAO.consultaPolizaInfAdicional(polizaBean, Enum_Con_Poliza.infAdicional);
			break;
		}
		return poliza;
	}
	
	public List lista(int tipoLista, PolizaBean polizaBean ){
		List polizaLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_Poliza.plantilla:
	        	polizaLista = polizaDAO.listaPlantillaPoliza(polizaBean, Enum_Lis_Poliza.plantilla);
	        break;
	        case  Enum_Lis_Poliza.principal:
	        	polizaLista = polizaDAO.listaPolizaContable(polizaBean, Enum_Lis_Poliza.principal);
	        break;
	        
		}
		return polizaLista;
	}
	
	//---------- Reportes ------------------------------------------------------------------------
	public String reportePoliza(ReportePolizaBean reportePolizaBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
										   
		parametrosReporte.agregaParametro("Par_FechaInicial", reportePolizaBean.getFechaInicial());
		parametrosReporte.agregaParametro("Par_FechaFinal", reportePolizaBean.getFechaFinal());
		parametrosReporte.agregaParametro("Par_Poliza", reportePolizaBean.getPolizaID());
		parametrosReporte.agregaParametro("Par_Transaccion",reportePolizaBean.getNumeroTransaccion());
		parametrosReporte.agregaParametro("Par_Sucursal",reportePolizaBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_Moneda",reportePolizaBean.getMonedaID());
		parametrosReporte.agregaParametro("Par_NombreUsuario",reportePolizaBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",reportePolizaBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaEmision",reportePolizaBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NombreSucursal",reportePolizaBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_DescripMoneda",reportePolizaBean.getDescripMoneda());
		parametrosReporte.agregaParametro("Par_ValorTransaccion ",reportePolizaBean.getValorTransaccion());
		parametrosReporte.agregaParametro("Par_ValorPoliza",reportePolizaBean.getValorPoliza());
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public ByteArrayOutputStream reportePolizaPDF(ReportePolizaBean reportePolizaBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();										   
		parametrosReporte.agregaParametro("Par_FechaInicial", reportePolizaBean.getFechaInicial());
		parametrosReporte.agregaParametro("Par_FechaFinal", reportePolizaBean.getFechaFinal());
		parametrosReporte.agregaParametro("Par_Poliza", reportePolizaBean.getPolizaID());
		parametrosReporte.agregaParametro("Par_Transaccion",reportePolizaBean.getNumeroTransaccion());
		parametrosReporte.agregaParametro("Par_Sucursal",reportePolizaBean.getSucursalID());
		parametrosReporte.agregaParametro("Par_Moneda",reportePolizaBean.getMonedaID());
		parametrosReporte.agregaParametro("Par_NombreUsuario",reportePolizaBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",reportePolizaBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaEmision",reportePolizaBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NombreSucursal",reportePolizaBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_DescripMoneda",reportePolizaBean.getDescripMoneda());
		parametrosReporte.agregaParametro("Par_ValorTransaccion ",reportePolizaBean.getValorTransaccion());
		parametrosReporte.agregaParametro("Par_ValorPoliza",reportePolizaBean.getValorPoliza());
		
		parametrosReporte.agregaParametro("Par_PrimerRango",reportePolizaBean.getPrimerRango());
		parametrosReporte.agregaParametro("Par_SegundoRango", reportePolizaBean.getSegundoRango());
		parametrosReporte.agregaParametro("Par_PrimerCentroCostos",reportePolizaBean.getPrimerCentroCostos());
		parametrosReporte.agregaParametro("Par_SegundoCentroCostos",reportePolizaBean.getSegundoCentroCostos());
		parametrosReporte.agregaParametro("Par_TipoInstrumentoID",reportePolizaBean.getTipoInstrumentoID());
		parametrosReporte.agregaParametro("Par_DescTipoInstrumento", reportePolizaBean.getDescTipoInstrumento());
		parametrosReporte.agregaParametro("Par_UsuarioID", reportePolizaBean.getUsuarioID());
		parametrosReporte.agregaParametro("Par_NomUsuario", reportePolizaBean.getNomUsuario());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public List<ReportePolizaBean> listaReportePolizaExcel(
			ReportePolizaBean reportePolizaBean, HttpServletResponse response) {
		List<ReportePolizaBean> listaPoliza=null;
		
		listaPoliza = polizaDAO.consultaPolizaContable(reportePolizaBean); 
		
		return listaPoliza;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}	
	
	
}
