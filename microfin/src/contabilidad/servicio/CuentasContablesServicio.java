package contabilidad.servicio;
 
import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import reporte.ParametrosReporte;
import reporte.Reporte;
import contabilidad.bean.CuentasContablesBean;
import contabilidad.bean.ReportePolizaBean;
import contabilidad.dao.CuentasContablesDAO;
import contabilidad.servicio.CuentasContablesServicio.Enum_Lis_CuentasContables;
import contabilidad.servicio.CuentasContablesServicio.Enum_Tra_CuentasContables;
import credito.beanWS.response.ConsultaDetallePagosResponse;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class CuentasContablesServicio extends BaseServicio {

	private CuentasContablesServicio(){
		super();
	}

	CuentasContablesDAO cuentasContablesDAO = null;

	public static interface Enum_Tra_CuentasContables {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
	}

	public static interface Enum_Con_CuentasContables{
		int principal 	= 1;
		int foranea 	= 2;
		int numCtas		= 3;
		int numCtasBalanza= 4;
		
	}

	public static interface Enum_Lis_CuentasContables{
		int principal   = 1;
		int encabezado  = 2;	// para la lista al escribir en una caja de texto 
		int detalle		= 3;
		int prin		= 4;	// se utiliza para que en el jsp se le pueda dar un comportamiento diferente cuando se seleccione
		int CtaDisper	= 5;	// Tipo de Lista para pantalla de Dispersion, usa rangos de  PARAMETROSSIS
		int CtaID 		= 6;
		int CtaDes		= 7;
		int xmlCtas		= 8;
		int regulatorio = 9;	// Tipo de Lista para la pantalla de Regulatorios
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,CuentasContablesBean cuentasContables){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_CuentasContables.alta:
				mensaje = cuentasContablesDAO.alta(cuentasContables);
				break;
			case Enum_Tra_CuentasContables.modificacion:
				mensaje = cuentasContablesDAO.modifica(cuentasContables);
				break;
			case Enum_Tra_CuentasContables.baja:
				mensaje = cuentasContablesDAO.baja(cuentasContables);
				break;
		}

		return mensaje;
	}
	
	public CuentasContablesBean consulta(int tipoConsulta, CuentasContablesBean cuentasContables){
		CuentasContablesBean cuentasContablesBean = null;
		switch(tipoConsulta){
			case Enum_Con_CuentasContables.principal:
				cuentasContablesBean = cuentasContablesDAO.consultaPrincipal(cuentasContables, Enum_Con_CuentasContables.principal);
			break;
			case Enum_Con_CuentasContables.foranea:
				cuentasContablesBean = cuentasContablesDAO.consultaForanea(cuentasContables, Enum_Con_CuentasContables.foranea);
			break;
			case Enum_Con_CuentasContables.numCtas:
				cuentasContablesBean = cuentasContablesDAO.consultaNumCtas(cuentasContables, Enum_Con_CuentasContables.numCtas);
			break;
			case Enum_Con_CuentasContables.numCtasBalanza:
				cuentasContablesBean = cuentasContablesDAO.consultaNumCtas(cuentasContables, Enum_Con_CuentasContables.numCtasBalanza);
			break;

		}
		return cuentasContablesBean;
	}

	public List lista(int tipoLista, CuentasContablesBean cuentasContables){		
		List listaCuentasContables = null;
		switch (tipoLista) {
			case Enum_Lis_CuentasContables.principal:		
				listaCuentasContables=  cuentasContablesDAO.listaPrincipal(cuentasContables,Enum_Lis_CuentasContables.principal);				
				break;		
			case Enum_Lis_CuentasContables.encabezado:		
				listaCuentasContables=  cuentasContablesDAO.listaEncabezado(cuentasContables,Enum_Lis_CuentasContables.encabezado);				
				break;	
			case Enum_Lis_CuentasContables.detalle:		
				listaCuentasContables=  cuentasContablesDAO.listaDetalle(cuentasContables,Enum_Lis_CuentasContables.detalle);				
				break;	
			case Enum_Lis_CuentasContables.prin:		
				listaCuentasContables=  cuentasContablesDAO.listaPrincipal(cuentasContables,Enum_Lis_CuentasContables.principal);				
				break;		
			case Enum_Lis_CuentasContables.CtaDisper:		
				listaCuentasContables=  cuentasContablesDAO.listaPrincipal(cuentasContables,Enum_Lis_CuentasContables.CtaDisper);				
				break;
			case Enum_Lis_CuentasContables.CtaID:		
				listaCuentasContables=  cuentasContablesDAO.listaDetalle(cuentasContables,Enum_Lis_CuentasContables.CtaID);				
				break;		
			case Enum_Lis_CuentasContables.CtaDes:		
				listaCuentasContables=  cuentasContablesDAO.listaPrincipal(cuentasContables,Enum_Lis_CuentasContables.CtaDes);				
				break;
			case Enum_Lis_CuentasContables.xmlCtas:		
				listaCuentasContables=  cuentasContablesDAO.listaXml(cuentasContables,Enum_Lis_CuentasContables.xmlCtas);
				break;
			case Enum_Lis_CuentasContables.regulatorio:
				listaCuentasContables=  cuentasContablesDAO.listaRegulatorio(cuentasContables,Enum_Lis_CuentasContables.regulatorio);
				break;
		}		
		return listaCuentasContables;
	}

	//---------- Reportes ------------------------------------------------------------------------
	//---------- Reportes Maestro Contable---------------------------------------------------------------
	public String reporteMaestroContable(CuentasContablesBean cuentasContablesBean, 
										 String nombreReporte) throws Exception{
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_Moneda",cuentasContablesBean.getMonedaID());
		parametrosReporte.agregaParametro("Par_TipoCuenta",cuentasContablesBean.getTipoCuenta());
		parametrosReporte.agregaParametro("Par_Usuario",cuentasContablesBean.getUsuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",cuentasContablesBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaEmision",cuentasContablesBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_ConceptoCta",cuentasContablesBean.getConceptoCta());
		parametrosReporte.agregaParametro("Par_DescripcionMoneda",cuentasContablesBean.getDescripcionMoneda());
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		
	}
	//---------- Reportes Maestro Contable PDF-----------------------------------------------------------
	public ByteArrayOutputStream reporteMaestroContablePDF(CuentasContablesBean cuentasContablesBean, 
		String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_Moneda",cuentasContablesBean.getMonedaID());
		parametrosReporte.agregaParametro("Par_TipoCuenta",cuentasContablesBean.getTipoCuenta());
		parametrosReporte.agregaParametro("Par_Usuario",cuentasContablesBean.getUsuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",cuentasContablesBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaEmision",cuentasContablesBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_ConceptoCta",cuentasContablesBean.getConceptoCta());
		parametrosReporte.agregaParametro("Par_DescripcionMoneda",cuentasContablesBean.getDescripcionMoneda());
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	

	public List<CuentasContablesBean> listaReporteMaetroContableExcel(
			CuentasContablesBean cuentasContables, HttpServletResponse response) {
		// TODO Auto-generated method stub
		List<CuentasContablesBean> listaMaestro=cuentasContablesDAO.consultaMaestroContableRep(cuentasContables);
		
		return listaMaestro;
	}
	
	public List<CuentasContablesBean> listaReportePeriodosExcel(
			CuentasContablesBean cuentasContables, HttpServletResponse response) {
		// TODO Auto-generated method stub
		List<CuentasContablesBean> listaPeriodos=cuentasContablesDAO.consultaPeriodosRep(cuentasContables);
		
		return listaPeriodos;
	}
	public List<CuentasContablesBean> listaReporteEstadosCExcel(
			CuentasContablesBean cuentasContables, HttpServletResponse response) {
		// TODO Auto-generated method stub
		List<CuentasContablesBean> listaPeriodos=cuentasContablesDAO.consultaEstadosCuentaRep(cuentasContables);
		
		return listaPeriodos;
	}
	public void setCuentasContablesDAO(CuentasContablesDAO cuentasContablesDAO ){
		this.cuentasContablesDAO = cuentasContablesDAO;
	}

	
	

}


