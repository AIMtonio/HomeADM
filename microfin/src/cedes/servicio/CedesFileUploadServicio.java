package cedes.servicio;

import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import cedes.dao.CedesFileUploadDAO;
import java.io.ByteArrayOutputStream;
import java.util.List;
import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.bean.ClienteArchivosBean;
import cedes.bean.CedesArchivosBean;
 
public class CedesFileUploadServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	CedesFileUploadDAO cedesFileUploadDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_File {
		int principalCede 		= 3;
		int foraneaCede 		= 4;
		int numeroSiguienCede 	= 5;
		int verArchivoCede		= 11;
		int verFirmasCede		= 12;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_File {
		int archivosCede			= 4;
		
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_File {
		int altaCede 		 = 4; //Alta de archivos de Cede
		int modificacionCede = 5; // Modificacion de archivos de Cede
		int bajaCede		 = 6; // Baja de archivos de Cede
		
	}
	
	public CedesFileUploadServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	/*Graba transaccion para archivos de las cuentas*/
	public MensajeTransaccionArchivoBean grabaTransaccionCta(int tipoTransaccion, CedesArchivosBean file){
		MensajeTransaccionArchivoBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_File.altaCede:		
				mensaje = altaArchivosCta(file);				
				break;				
			case Enum_Tra_File.modificacionCede:
				mensaje = altaArchivosCta(file);				
				break;
			case Enum_Tra_File.bajaCede:
				mensaje = bajaArchivosCta(file);				
				break;		
		}
		return mensaje;
	}
	

	public MensajeTransaccionArchivoBean altaArchivosCta(CedesArchivosBean file){
		MensajeTransaccionArchivoBean mensaje = null;
		mensaje = cedesFileUploadDAO.altaArchivosCta(file);		
		return mensaje;
	}

	
	public MensajeTransaccionArchivoBean bajaArchivosCta(CedesArchivosBean file){
		MensajeTransaccionArchivoBean mensaje = null;
		mensaje = cedesFileUploadDAO.bajaArchivosCta(file);		
		return mensaje;
	}
	
	
	/*Consulta para archivos de cuentas*/
	public CedesArchivosBean consultaArCuenta(int tipoConsulta, CedesArchivosBean ctaBean){
		CedesArchivosBean cta = null;
		switch (tipoConsulta) {
			case Enum_Con_File.principalCede:		
				cta = cedesFileUploadDAO.consultaPrincipalArchivosCta(ctaBean, tipoConsulta);	
				break;	
			case Enum_Con_File.foraneaCede:		
				cta = cedesFileUploadDAO.consultaForaneaArchivosCta(ctaBean, tipoConsulta);				
			break;	
			case Enum_Con_File.numeroSiguienCede:		
				cta = cedesFileUploadDAO.consultaNumeroSiguienCta(ctaBean, tipoConsulta);				
			break;	
			case Enum_Con_File.verArchivoCede:		
				cta = cedesFileUploadDAO.consultaArchivoCta(ctaBean, tipoConsulta);				
			break;	
			case Enum_Con_File.verFirmasCede:		
				cta = cedesFileUploadDAO.consultaFirmaCta(ctaBean, tipoConsulta);				
			break;
		}	
		return cta;
	}
	
	
	/*Lista de archivos de Cuenta*/
	public List listaArchivosCta(int tipoLista, CedesArchivosBean fileBean){		
		List listaArchCta = null;
		switch (tipoLista) {
			case Enum_Lis_File.archivosCede:		
				listaArchCta = cedesFileUploadDAO.listaArchivosCta(fileBean, tipoLista);				
				break;		
		}		
		return listaArchCta;
	}
		
	//Reporte de Archivos de cliente PDF
	public ByteArrayOutputStream reporteArchivosClientePDF(ClienteArchivosBean fileBean, String nombreCliente, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_Cliente", fileBean.getClienteID());
		parametrosReporte.agregaParametro("Par_TipoDocumen", fileBean.getTipoDocumento());
		parametrosReporte.agregaParametro("Par_ArcClientID", fileBean.getArchivoClientID()); 
		parametrosReporte.agregaParametro("Par_NombreCliente", nombreCliente);	
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	//Reporte de Archivos de cuentas PDF
	public ByteArrayOutputStream reporteArchivosCuentasPDF(CedesArchivosBean fileBean, String cedeID, String nombreCliente, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_CedeID", cedeID);
		parametrosReporte.agregaParametro("Par_NombreCliente", nombreCliente);	
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
		
	public String reporteProcesosBatch(String fechaInicio,String fechaFin,
			   String nombreReporte)throws Exception {
			
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio",fechaInicio);
		parametrosReporte.agregaParametro("Par_FechaFinal",fechaFin);
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}
	
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setCedesFileUploadDAO(CedesFileUploadDAO cedesFileUploadDAO) {
		this.cedesFileUploadDAO = cedesFileUploadDAO;
	}

	

}


