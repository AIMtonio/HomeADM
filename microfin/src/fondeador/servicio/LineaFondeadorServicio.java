package fondeador.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import inversiones.bean.InversionBean;

import java.io.ByteArrayOutputStream;
import java.util.List;

import reporte.ParametrosReporte;
import reporte.Reporte;

import fondeador.bean.LineaFondeadorBean;
import fondeador.dao.LineaFondeadorDAO;
 
public class LineaFondeadorServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	LineaFondeadorDAO lineaFondeadorDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_LineaFon {
		int principal = 1;
		int foranea   = 2;
		int redesCto  = 3;
		int condiLinea  = 4;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_LineaFon {
		int principal = 1;
		int lineaPorFondeador = 2;
		int foranea = 3;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_LineaFon {
		int alta = 1;
		int modificacion = 2;
		int condicionLinea = 3;
	}
	
	public LineaFondeadorServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, LineaFondeadorBean lineaFondeadorBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_LineaFon.alta:		
				mensaje = altaLineaFond(lineaFondeadorBean);				
				break;				
			case Enum_Tra_LineaFon.modificacion:
				mensaje = modificaLineaFond(lineaFondeadorBean);				
				break;
			case Enum_Tra_LineaFon.condicionLinea:
				mensaje = actualizaCondiLinea(lineaFondeadorBean);				
				break;
			
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean altaLineaFond(LineaFondeadorBean lineaFondeadorBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = lineaFondeadorDAO.alta(lineaFondeadorBean);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaLineaFond(LineaFondeadorBean lineaFondeadorBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = lineaFondeadorDAO.modifica(lineaFondeadorBean);		
		return mensaje;
	}
	
	public MensajeTransaccionBean actualizaCondiLinea(LineaFondeadorBean lineaFondeadorBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = lineaFondeadorDAO.actualiza(lineaFondeadorBean);		
		return mensaje;
	}
	
	
	
	
	public LineaFondeadorBean consulta(int tipoConsulta, LineaFondeadorBean lineaFondeadorBean){
		LineaFondeadorBean lineaFond = null;
		switch (tipoConsulta) {
			case Enum_Con_LineaFon.principal:		
				lineaFond = lineaFondeadorDAO.consultaPrincipal(lineaFondeadorBean, tipoConsulta);				
				break;	
			case Enum_Con_LineaFon.foranea:		
				lineaFond = lineaFondeadorDAO.consultaForanea(lineaFondeadorBean, tipoConsulta);				
			break;
			case Enum_Con_LineaFon.redesCto:		
				lineaFond = lineaFondeadorDAO.consultaRedesCto(lineaFondeadorBean, tipoConsulta);				
			break;
			case Enum_Con_LineaFon.condiLinea:		
				lineaFond = lineaFondeadorDAO.consultaCondiLinea(lineaFondeadorBean, tipoConsulta);				
			break;
		}
				
		return lineaFond;
	}
	
	public List lista(int tipoLista, LineaFondeadorBean lineaFondeadorBean){		
		List listaLineasFond = null;
		switch (tipoLista) {
			case Enum_Lis_LineaFon.principal:		
				listaLineasFond = lineaFondeadorDAO.listaPrincipal(lineaFondeadorBean, tipoLista);				
				break;
			case Enum_Lis_LineaFon.foranea:		
				listaLineasFond = lineaFondeadorDAO.listaForanea(lineaFondeadorBean, tipoLista);				
				break;		
			case Enum_Lis_LineaFon.lineaPorFondeador:
				listaLineasFond = lineaFondeadorDAO.listaLineaPorFondeador(lineaFondeadorBean, tipoLista);
				break;
		}		
		return listaLineasFond;
	}
	
	public ByteArrayOutputStream repLineaFonPDF(LineaFondeadorBean lineaFondeadorBean, String nombreReporte)
			throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_FechaActual",lineaFondeadorBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_InstitutFondID",Integer.parseInt(lineaFondeadorBean.getInstitutFondID()));
		parametrosReporte.agregaParametro("Par_LineaFondeoID",Integer.parseInt(lineaFondeadorBean.getLineaFondeoID()));
		parametrosReporte.agregaParametro("Par_CreditoFondeoID",Integer.parseInt(lineaFondeadorBean.getCreditoFondeoID()));

		parametrosReporte.agregaParametro("Par_NomInstitFon",(lineaFondeadorBean.getNomInstitFon()));
		parametrosReporte.agregaParametro("Par_DescripLinea",(lineaFondeadorBean.getDescripLinea()));
		parametrosReporte.agregaParametro("Par_NomUsuario",(lineaFondeadorBean.getUsuario()));
		parametrosReporte.agregaParametro("Par_NomInstitucion",(lineaFondeadorBean.getNombreInstitucion()));
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public String repLinFonPDF(LineaFondeadorBean lineaFondeadorBean, String nombreReporte)
			throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
				
		parametrosReporte.agregaParametro("Par_FechaActual",lineaFondeadorBean.getFechaActual());
		parametrosReporte.agregaParametro("Par_InstitutFondID",Integer.parseInt(lineaFondeadorBean.getInstitutFondID()));
		parametrosReporte.agregaParametro("Par_LineaFondeoID",Integer.parseInt(lineaFondeadorBean.getLineaFondeoID()));
		parametrosReporte.agregaParametro("Par_CreditoFondeoID",Integer.parseInt(lineaFondeadorBean.getCreditoFondeoID()));

		parametrosReporte.agregaParametro("Par_NomInstitFon",(lineaFondeadorBean.getNomInstitFon()));
		parametrosReporte.agregaParametro("Par_DescripLinea",(lineaFondeadorBean.getDescripLinea()));
		parametrosReporte.agregaParametro("Par_NomUsuario",(lineaFondeadorBean.getUsuario()));
		parametrosReporte.agregaParametro("Par_NomInstitucion",(lineaFondeadorBean.getNombreInstitucion()));
		
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	
	public void setLineaFondeadorDAO(LineaFondeadorDAO lineaFondeadorDAO) {
		this.lineaFondeadorDAO = lineaFondeadorDAO;
	}
	public LineaFondeadorDAO getLineaFondeadorDAO() {
		return lineaFondeadorDAO;
	}	
			
}

