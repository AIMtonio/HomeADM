package cliente.servicio;
 
import general.bean.MensajeTransaccionArchivoBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import reporte.ParametrosReporte;
import reporte.Reporte;
import cliente.bean.ClienteArchivosBean;
import cliente.dao.ClienteArchivosDAO;

public class ClienteArchivosServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	ClienteArchivosDAO clienteArchivosDAO = null;		
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Archivo {
		int numeroDocXCte 	= 3;
		int existepld 		= 9;
		int verImagenPerfil	= 13;
		
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Archivo {
		int principal 			= 1;
		int porInstrumento		= 2;
		int reportePDF			= 3; //opción de lista para crear el expediente del cliente en formato pdf
		int reportePDFp			= 4; //opción de lista para crear el expediente del cliente en formato pdf
		int archivosPLD			= 5; //opción de lista para PLD
	}
	
	public static interface Enum_Rep_Archivo {
		int documentosExpPLD 			= 1;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_File {
		int altaC 			= 1;
		int modificacionC 	= 2;
		int bajaC 			= 3;
		int altaCta  		= 4; //Alta de archivos de Cuenta
		int modificacionCta = 5; // Modificacion de archivos de Cuenta
		int bajaCta 		= 6; // Baja de archivos de Cuenta
		int altaArchivo		= 7; // alta de archivo agregando el campo instrumento 
	}
	
	public static interface Enum_Tra_ArchivoClienteBaja{
		int bajaPorFolio    = 1; //baja principal de archivos de crédito
	}
	
	
	public ClienteArchivosServicio() {
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
			case Enum_Tra_File.altaArchivo: 
				mensaje = altaArchivoCliente(file);			
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionArchivoBean altaArchivosCliente(ClienteArchivosBean file){
		MensajeTransaccionArchivoBean mensaje = null;
		mensaje = clienteArchivosDAO.altaArchivosCliente(file);		
		return mensaje;
	}
	
	/* se agrego metodo para poder insertar en la tabla CLIENTEARCHIVOS el campo Instrumento y fechaRegistro*/
	public MensajeTransaccionArchivoBean altaArchivoCliente(ClienteArchivosBean file){
		MensajeTransaccionArchivoBean mensaje = null;
		mensaje = clienteArchivosDAO.altaArchivo(file);		
		return mensaje;
	}

	
	public MensajeTransaccionArchivoBean bajaArchivosCliente(int tipoBaja,ClienteArchivosBean file){
		MensajeTransaccionArchivoBean mensaje = null;
		try{
			switch (tipoBaja) {
			case Enum_Tra_ArchivoClienteBaja.bajaPorFolio:		
				mensaje = clienteArchivosDAO.procBajaArchivosCliente(file);		
				break;				
		}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en transaccion de cliente", e);
		}
		
		return mensaje;
	}
	
	/*Consulta para archivos de cliente*/
	public ClienteArchivosBean consulta(int tipoConsulta, ClienteArchivosBean fileBean){
		ClienteArchivosBean file = null;
		switch (tipoConsulta) {
			case Enum_Con_Archivo.numeroDocXCte:		
				file = clienteArchivosDAO.consultaDocumentosPorCliente(fileBean, tipoConsulta);				
			break;				
			case Enum_Con_Archivo.existepld:		
				file = clienteArchivosDAO.consultaArcPLD(fileBean, tipoConsulta);				
			break;
			case Enum_Con_Archivo.verImagenPerfil:						
				file = clienteArchivosDAO.verImagenPerfil(fileBean, tipoConsulta);				
			break;
		}
		return file;
	}
	
	/*Lista de archivos del Cliente*/
	public List listaArchivosCliente(int tipoLista, ClienteArchivosBean fileBean) {
		List listaArchClient = null;
		switch (tipoLista) {
			case Enum_Lis_Archivo.principal :
				listaArchClient = clienteArchivosDAO.listaArchivosCliente(fileBean, tipoLista);
				break;
			case Enum_Lis_Archivo.porInstrumento :
				listaArchClient = clienteArchivosDAO.listaArchivos(fileBean, tipoLista);
				break;
			case Enum_Lis_Archivo.reportePDF :
				listaArchClient = clienteArchivosDAO.listaArchivosReporte(fileBean, tipoLista);
				break;
			case Enum_Lis_Archivo.reportePDFp :
				listaArchClient = clienteArchivosDAO.listaArchivosReporte(fileBean, tipoLista);
				break;
			case Enum_Lis_Archivo.archivosPLD :
				listaArchClient = clienteArchivosDAO.listaArchivosCliente(fileBean, tipoLista);
				break;
		}
		return listaArchClient;
	}
	
	//Reporte de Archivos de cliente PDF
	public ByteArrayOutputStream reporteArchivosClientePDF(ClienteArchivosBean fileBean, String nombreCliente, String nombreProspecto,String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_Cliente", Utileria.convierteEntero(fileBean.getClienteID()));
		parametrosReporte.agregaParametro("Par_ProspectoID", Utileria.convierteEntero(fileBean.getProspectoID()));
		parametrosReporte.agregaParametro("Par_NombreProspecto",nombreProspecto);
		parametrosReporte.agregaParametro("Par_TipoDocumen", fileBean.getTipoDocumento());
		parametrosReporte.agregaParametro("Par_NombreCliente", nombreCliente);	
		parametrosReporte.agregaParametro("Par_FechaEmision",fileBean.getFechaEmision());			
		parametrosReporte.agregaParametro("Par_NomUsuario",(!fileBean.getNombreUsuario().isEmpty())?fileBean.getNombreUsuario(): " ");
		parametrosReporte.agregaParametro("Par_NomInstitucion",fileBean.getNombreInstitucion());
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public List<ClienteArchivosBean> listaArchivosReportePLD(int tipoLista, ClienteArchivosBean fileBean) {
		List<ClienteArchivosBean> listaArchClient = null;
		switch (tipoLista) {
			case Enum_Rep_Archivo.documentosExpPLD :
				listaArchClient = clienteArchivosDAO.listaArcExpirarPLD(fileBean, tipoLista);
				break;
		}
		return listaArchClient;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public ClienteArchivosDAO getClienteArchivosDAO() {
		return clienteArchivosDAO;
	}

	public void setClienteArchivosDAO(ClienteArchivosDAO clienteArchivosDAO) {
		this.clienteArchivosDAO = clienteArchivosDAO;
	}
	
}