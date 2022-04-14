package cuentas.servicio;

import java.util.List;
import java.io.ByteArrayOutputStream;
import reporte.ParametrosReporte;
import reporte.Reporte;
 
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import cuentas.dao.ConocimientoCtaDAO;
import cuentas.bean.ConocimientoCtaBean;
import cuentas.bean.CuentasPersonaBean;
public class ConocimientoCtaServicio  extends BaseServicio {

	private ConocimientoCtaServicio(){
		super();
	}
	CuentasPersonaServicio cuentasPersonaServicio = null;
	ConocimientoCtaDAO conocimientoCtaDAO = null;

	public static interface Enum_Tra_ConocimientoCta {
		int alta = 1;
		int modificacion = 2;
		int altaWS = 3;
	}

	public static interface Enum_Con_ConocimientoCta{
		int principal = 1;
		int foranea = 2;
		int existe = 5;
	}

	public static interface Enum_Lis_ConocimientoCta{
		int principal = 1;
		int foranea = 2;
		int apoderado = 3; //lista para apoderados de la pantalla cuentas persona y reporte conocimiento cta
		int firmantes = 4; //lista para  firmantes de la pantalla cuentas persona y reporte conocimiento cta
		int cotitulares = 5; //lista de cotitulares reporte conocimiento cta
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ConocimientoCtaBean conocimientoCta){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_ConocimientoCta.alta:
			mensaje = conocimientoCtaDAO.alta(conocimientoCta);
			break;
		case Enum_Tra_ConocimientoCta.altaWS:
			mensaje = conocimientoCtaDAO.altaWS(conocimientoCta);
			break;
		case Enum_Tra_ConocimientoCta.modificacion:
			mensaje = conocimientoCtaDAO.modifica(conocimientoCta);
			break;
		}

		return mensaje;
	}

	public ConocimientoCtaBean consulta(int tipoConsulta, ConocimientoCtaBean conocimientoCta){
		ConocimientoCtaBean conocimientoCtaBean = null;
		switch(tipoConsulta){
			case Enum_Con_ConocimientoCta.principal:
				conocimientoCtaBean = conocimientoCtaDAO.consultaPrincipal(conocimientoCta, Enum_Con_ConocimientoCta.principal);
			break;
			case Enum_Con_ConocimientoCta.existe:
				conocimientoCtaBean = conocimientoCtaDAO.consultaExiste(conocimientoCta, Enum_Con_ConocimientoCta.existe);
			break;			
		}
		return conocimientoCtaBean;
	}

	// reporte de conocimiento de cuenta persona Fisica
	public String reporteFormatoConocimientoCtaPF(CuentasPersonaBean cuentasPersona, String nombreReportePF) throws Exception{
		List  listaFirmantes = null;
		List  listaCotitulares = null;
		CuentasPersonaBean personBean ;
		listaFirmantes = cuentasPersonaServicio.lista(Enum_Lis_ConocimientoCta.firmantes,cuentasPersona);
		listaCotitulares = cuentasPersonaServicio.lista(Enum_Lis_ConocimientoCta.cotitulares,cuentasPersona);
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		for(int i=0; i<listaFirmantes.size(); i++){
			personBean = (CuentasPersonaBean)listaFirmantes.get(i);
			if(i==6){
				break;
			}
			
			parametrosReporte.agregaParametro("Par_NomCompletoF" +i, personBean.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_EsFirmante" +i, personBean.getEsFirmante());
			parametrosReporte.agregaParametro("Par_TiIdentiIDF" +i, personBean.getTipoIdentiID());
														
		}
		for(int i=0; i<listaCotitulares.size(); i++){
			personBean = (CuentasPersonaBean)listaCotitulares.get(i);
			if(i==4){
				break;
			}
			
			parametrosReporte.agregaParametro("Par_NomCompletoC" +i, personBean.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_EsCotitular" +i, personBean.getEsFirmante());
			parametrosReporte.agregaParametro("Par_TiIdentiIDC" +i, personBean.getTipoIdentiID());
					
			}
		parametrosReporte.agregaParametro("Par_NomInstitucion",cuentasPersona.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_CuentaAhoID", cuentasPersona.getCuentaAhoID());
		
		return Reporte.creaHtmlReporte(nombreReportePF, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		
	}
	// reporte de conocimiento de cuenta persona Moral
	public String reporteFormatoConocimientoCtaPM(CuentasPersonaBean cuentasPersona,String nombreReportePM) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		List  listaAPoderados = null;
		CuentasPersonaBean personBean ;
		listaAPoderados = cuentasPersonaServicio.lista(Enum_Lis_ConocimientoCta.apoderado,cuentasPersona);
		
		for(int i=0; i<listaAPoderados.size(); i++){
			personBean = (CuentasPersonaBean)listaAPoderados.get(i);
			if(i==4){
				break;
			}
			
			parametrosReporte.agregaParametro("Par_Nombre" +i, personBean.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_Identificacion" +i, personBean.getTipoIdentiID());
			parametrosReporte.agregaParametro("Par_PuestoAp" +i, personBean.getPuestoA());
													
		}
		parametrosReporte.agregaParametro("Par_NomInstitucion",cuentasPersona.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_CuentaAhoID",cuentasPersona.getCuentaAhoID() );
		
		return Reporte.creaHtmlReporte(nombreReportePM, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		
	}
	
	public ByteArrayOutputStream reporteFormatoConocimientoCtaPFPDF(CuentasPersonaBean cuentasPersona, String nombreReportePF) throws Exception{
		List  listaFirmantes = null;
		List  listaCotitulares = null;
		CuentasPersonaBean personBean ;
		listaFirmantes = cuentasPersonaServicio.lista(Enum_Lis_ConocimientoCta.firmantes,cuentasPersona);
		listaCotitulares = cuentasPersonaServicio.lista(Enum_Lis_ConocimientoCta.cotitulares,cuentasPersona);
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		for(int i=0; i<listaFirmantes.size(); i++){
			personBean = (CuentasPersonaBean)listaFirmantes.get(i);
			if(i==6){
				break;
			}
			
			parametrosReporte.agregaParametro("Par_NomCompletoF" +i, personBean.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_EsFirmante" +i, personBean.getEsFirmante());
			parametrosReporte.agregaParametro("Par_TiIdentiIDF" +i, personBean.getTipoIdentiID());		
														
		}
		for(int i=0; i<listaCotitulares.size(); i++){
			personBean = (CuentasPersonaBean)listaCotitulares.get(i);
			if(i==4){
				break;
			}
			
			parametrosReporte.agregaParametro("Par_NomCompletoC" +i, personBean.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_EsCotitular" +i, personBean.getEsFirmante());
			parametrosReporte.agregaParametro("Par_TiIdentiIDC" +i, personBean.getTipoIdentiID());
					
			}
		parametrosReporte.agregaParametro("Par_NomInstitucion",cuentasPersona.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_CuentaAhoID", cuentasPersona.getCuentaAhoID());
		
		return Reporte.creaPDFReporte(nombreReportePF, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		
	}
	// reporte de conocimiento de cuenta persona Moral
	public ByteArrayOutputStream reporteFormatoConocimientoCtaPMPDF(CuentasPersonaBean cuentasPersona,String nombreReportePM) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		List  listaAPoderados = null;
		CuentasPersonaBean personBean ;
		listaAPoderados = cuentasPersonaServicio.lista(Enum_Lis_ConocimientoCta.apoderado,cuentasPersona);
		
		for(int i=0; i<listaAPoderados.size(); i++){
			personBean = (CuentasPersonaBean)listaAPoderados.get(i);
			if(i==4){
				break;
			}
			
			parametrosReporte.agregaParametro("Par_Nombre" +i, personBean.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_Identificacion" +i, personBean.getTipoIdentiID());
			parametrosReporte.agregaParametro("Par_PuestoAp" +i, personBean.getPuestoA());
													
		}
		parametrosReporte.agregaParametro("Par_NomInstitucion",cuentasPersona.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_CuentaAhoID",cuentasPersona.getCuentaAhoID() );
		
		return Reporte.creaPDFReporte(nombreReportePM, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		
	}
	
	public void setConocimientoCtaDAO(ConocimientoCtaDAO conocimientoCtaDAO ){
		this.conocimientoCtaDAO = conocimientoCtaDAO;
	}

	public void setCuentasPersonaServicio(
			CuentasPersonaServicio cuentasPersonaServicio) {
		this.cuentasPersonaServicio = cuentasPersonaServicio;
	}

	public ConocimientoCtaDAO getConocimientoCtaDAO() {
		return conocimientoCtaDAO;
	}
}
