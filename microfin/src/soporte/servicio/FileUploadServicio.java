package soporte.servicio;

import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import cliente.bean.ClienteBean;

import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.bean.ClienteArchivosBean;
import soporte.bean.CuentaArchivosBean;
import soporte.dao.FileUploadDAO;
 


public class FileUploadServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	FileUploadDAO fileUploadDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_File {
		int principalC 		= 1;
		int foraneaC 		= 2;
		int principalCta 	= 3;
		int foraneaCta 		= 4;
		int numeroSiguiencta = 5;
		int actualizar 		= 7;
		int numeroSiguien 	= 8;
		int existepld 		= 9;
		int verArchivoCte	= 10;
		int verArchivoCta	= 11;
		int verFirmasCta	= 12;
		int verImagenPerfil	= 13;
		int numDocumentos	= 14;
		
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_File {
		int principalC 			= 1;
		int archivosCliente		= 2;
		int principalCta 		= 3;
		int archivosCta			= 4;
		int archivosClienteConsulta		= 5;
		int archivosCuentas		= 6;
		
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_File {
		int altaC 			= 1;
		int modificacionC 	= 2;
		int bajaC 			= 3;
		int altaCta 		= 4; //Alta de archivos de Cuenta
		int modificacionCta = 5; // Modificacion de archivos de Cuenta
		int bajaCta 		= 6; // Baja de archivos de Cuenta
		
	}
	
	public FileUploadServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	/*Graba transaccion para archivos de los Clientes*/
	public MensajeTransaccionArchivoBean grabaTransaccion(int tipoTransaccion, ClienteArchivosBean file){
		MensajeTransaccionArchivoBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_File.altaC:		
				mensaje = altaArchivosCliente(file);				
				break;				
			case Enum_Tra_File.modificacionC:
				mensaje = altaArchivosCliente(file);				
				break;
			case Enum_Tra_File.bajaC:
				mensaje = bajaArchivosCliente(file);				
				break;
			
		}
		return mensaje;
	}
	
	public MensajeTransaccionArchivoBean altaArchivosCliente(ClienteArchivosBean file){
		MensajeTransaccionArchivoBean mensaje = null;
		mensaje = fileUploadDAO.altaArchivosCliente(file);		
		return mensaje;
	}

	
	public MensajeTransaccionArchivoBean bajaArchivosCliente(ClienteArchivosBean file){
		MensajeTransaccionArchivoBean mensaje = null;
		mensaje = fileUploadDAO.bajaArchivosCliente(file);		
		return mensaje;
	}
	
	/*Graba transaccion para archivos de las cuentas*/
	public MensajeTransaccionArchivoBean grabaTransaccionCta(int tipoTransaccion, CuentaArchivosBean file){
		MensajeTransaccionArchivoBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_File.altaCta:		
				mensaje = altaArchivosCta(file);				
				break;				
			case Enum_Tra_File.modificacionCta:
				mensaje = altaArchivosCta(file);				
				break;
			case Enum_Tra_File.bajaCta:
				mensaje = bajaArchivosCta(file);				
				break;
			
		}
		return mensaje;
	}
	
	
	
	
	public MensajeTransaccionArchivoBean altaArchivosCta(CuentaArchivosBean file){
		MensajeTransaccionArchivoBean mensaje = null;
		mensaje = fileUploadDAO.altaArchivosCta(file);		
		return mensaje;
	}

	
	public MensajeTransaccionArchivoBean bajaArchivosCta(CuentaArchivosBean file){
		MensajeTransaccionArchivoBean mensaje = null;
		mensaje = fileUploadDAO.procBajaArchivosCta(file);		
		return mensaje;
	}
	
	/*Consulta para archivos de cliente*/
	public ClienteArchivosBean consultaArCliente(int tipoConsulta, ClienteArchivosBean fileBean){
		ClienteArchivosBean file = null;
		switch (tipoConsulta) {
			case Enum_Con_File.principalC:		
				file = fileUploadDAO.consultaPrincipalArchivosCliente(fileBean, tipoConsulta);	
				break;	
			case Enum_Con_File.foraneaC:		
				file = fileUploadDAO.consultaForanea(fileBean, tipoConsulta);				
			break;	
			case Enum_Con_File.numeroSiguien:		
				file = fileUploadDAO.consultaNumeroSiguien(fileBean, tipoConsulta);				
			break;		
			case Enum_Con_File.existepld:		
				file = fileUploadDAO.consultaArcPLD(fileBean, tipoConsulta);				
			break;			
			case Enum_Con_File.verArchivoCte:		
				file = fileUploadDAO.consultaArchivoCte(fileBean, tipoConsulta);				
			break;
			case Enum_Con_File.verImagenPerfil:		
				file = fileUploadDAO.verImagenPerfil(fileBean, tipoConsulta);				
			break;
		}
				
		return file;
	}
	
	/*Consulta para archivos de cuentas*/
	public CuentaArchivosBean consultaArCuenta(int tipoConsulta, CuentaArchivosBean ctaBean){
		CuentaArchivosBean cta = null;
		switch (tipoConsulta) {
			case Enum_Con_File.principalCta:		
				cta = fileUploadDAO.consultaPrincipalArchivosCta(ctaBean, tipoConsulta);	
				break;	
			case Enum_Con_File.foraneaCta:		
				cta = fileUploadDAO.consultaForaneaArchivosCta(ctaBean, tipoConsulta);				
			break;	
			case Enum_Con_File.numeroSiguiencta:		
				cta = fileUploadDAO.consultaNumeroSiguienCta(ctaBean, tipoConsulta);				
			break;	
			case Enum_Con_File.verArchivoCta:		
				cta = fileUploadDAO.consultaArchivoCta(ctaBean, tipoConsulta);				
			break;	
			case Enum_Con_File.verFirmasCta:		
				cta = fileUploadDAO.consultaFirmaCta(ctaBean, tipoConsulta);				
			break;
			case Enum_Con_File.numDocumentos:
				cta = fileUploadDAO.consultaDocumentosPorCuenta(ctaBean, tipoConsulta);
			
		}
				
		return cta;
	}
	
	/*Lista de archivos del Cliente*/
	public List listaArchivosCliente(int tipoLista, ClienteArchivosBean fileBean){		
		List listaArchClient = null;
		switch (tipoLista) {
			case Enum_Lis_File.archivosCliente:		
				listaArchClient = fileUploadDAO.listaArchivosCliente(fileBean, tipoLista);				
				break;			
				// se ocupa para mostrar la lista de archivos sin la opcion de eliminar.
			case Enum_Lis_File.archivosClienteConsulta:		
				listaArchClient = fileUploadDAO.listaArchivosCliente(fileBean, Enum_Lis_File.archivosCliente);				
				break;				
		}		
		return listaArchClient;
	}	
	
	
	/*Lista de archivos de Cuenta*/
	public List listaArchivosCta(int tipoLista, CuentaArchivosBean fileBean){		
		List listaArchCta = null;
		switch (tipoLista) {
			case Enum_Lis_File.archivosCta:		
				listaArchCta = fileUploadDAO.listaArchivosCta(fileBean, tipoLista);				
				break;	
			case Enum_Lis_File.archivosCuentas:
				listaArchCta = fileUploadDAO.listaArchivosCta(fileBean, tipoLista);
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
	public ByteArrayOutputStream reporteArchivosCuentasPDF(CuentaArchivosBean fileBean, String nombreCliente, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_Cuenta", fileBean.getCuentaAhoID());
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
	public void setFileUploadDAO(FileUploadDAO fileUploadDAO) {
		this.fileUploadDAO = fileUploadDAO;
	}

	public FileUploadDAO getFileUploadDAO() {
		return fileUploadDAO;
	}


}
