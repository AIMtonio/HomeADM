package tesoreria.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletResponse;

import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import tesoreria.bean.Acuse;
import tesoreria.bean.DetalleImpuestoBean;
import tesoreria.bean.DetallefactprovBean;
import tesoreria.bean.FacturaprovBean;
import tesoreria.dao.FacturaprovDAO;
import tesoreria.serviciosWeb.IConsultaCFDIServiceProxy;

import com.itextpdf.text.Element;
import com.sun.org.apache.xerces.internal.parsers.DOMParser;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.rmi.RemoteException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;


public class FacturaprovServicio extends BaseServicio {

	 
	//---------- Variables ------------------------------------------------------------------------
	FacturaprovDAO facturaprovDAO = null;
	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_Factura{
		int principal   = 1;
		int facturaProv = 2;
		int facturaXProv = 3;
		int facturaEstAltaParcial = 4;
		int facturaAltaParcialProveedor = 5;
		int facturaAnticipoProveedor = 6;
	}
	public static interface Enum_Tra_Factura {
		int alta = 1;
		int modificacion = 2;
		int grabarLista = 3;
		int cancelar = 4;
		int actRutaArchFac =5;
		int actUUID = 6;
	}
	
	public static interface Enum_Con_Factura {
		int principal = 1;
		int foranea =2;
		int anticipo=3;
		int polizaFactura = 4;
		int periodoConFactura = 5;
		int dispersionFactura = 6;
		int anticiposFactura = 7;
	}
	
	public static interface Enum_Rep_Factura{
		int reporteFacturasExcel=2;
		int reporteFactExcelDetallado=3;
		int listaEncabezado		=4;
	}
		
	public FacturaprovServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,FacturaprovBean facturaprovBean, String detalleFactura,String detalleFacturaImp, int tipoActualizacion){
		ArrayList listaDetalleFactura = (ArrayList) creaListaDetalle(detalleFactura);
		ArrayList listaDetalleFacturaImp = (ArrayList) creaListaDetalleImp(detalleFacturaImp);
		
	
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_Factura.alta:
				mensaje = altaFactura(facturaprovBean);
			break;
			case Enum_Tra_Factura.modificacion:
				mensaje = facturaprovDAO.modificaListaDetalleFactura(facturaprovBean,listaDetalleFactura,listaDetalleFacturaImp);
			break;
			case Enum_Tra_Factura.grabarLista:
				mensaje = facturaprovDAO.grabaListaDetalleFactura(facturaprovBean,listaDetalleFactura,listaDetalleFacturaImp);	
				break;
			case Enum_Tra_Factura.cancelar:
				mensaje = cancelarFactura(facturaprovBean,tipoActualizacion);
				break;
			case Enum_Tra_Factura.actRutaArchFac:
				mensaje = actualizaRutaArchivoFactura(facturaprovBean,tipoActualizacion);
			break;
			
			case Enum_Tra_Factura.actUUID:
				mensaje = actualizaFolioUUIDFact(facturaprovBean,tipoActualizacion);
			break;
		}
		return mensaje;
	}
	
	

	public MensajeTransaccionBean altaFactura(FacturaprovBean facturaprovBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = facturaprovDAO.altaFactura(facturaprovBean);		
		return mensaje;
	}
	
	public MensajeTransaccionBean cancelarFactura(FacturaprovBean facturaprovBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		mensaje = facturaprovDAO.cancelarFactura(facturaprovBean,tipoActualizacion);		
		return mensaje;
	}
	
	public MensajeTransaccionBean actualizaRutaArchivoFactura(FacturaprovBean facturaprovBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		mensaje = facturaprovDAO.actualizaRutaArchivoFactura(facturaprovBean,tipoActualizacion);		
		return mensaje;
	}
		
	public MensajeTransaccionBean actualizaFolioUUIDFact(FacturaprovBean facturaprovBean, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		mensaje = facturaprovDAO.actualizaFolioUUID(facturaprovBean,tipoActualizacion);		
		return mensaje;
	}
	
	// Consulta principal de factura proveedor 
	public FacturaprovBean consulta(int tipoConsulta, FacturaprovBean facturaprovBean){
		FacturaprovBean facturaprov= null;
		switch(tipoConsulta){
			case Enum_Con_Factura.principal:
				facturaprov = facturaprovDAO.consultaPrincipal(facturaprovBean, tipoConsulta);
			break;
			case Enum_Con_Factura.foranea:
				facturaprov = facturaprovDAO.consultaForanea(facturaprovBean, tipoConsulta);
			break;
			case Enum_Con_Factura.anticipo:
				facturaprov = facturaprovDAO.consultaAnticipo(facturaprovBean, tipoConsulta);
			break;
			case Enum_Con_Factura.polizaFactura:
				facturaprov = facturaprovDAO.consultaPolizaFactura(facturaprovBean, tipoConsulta);
			break;
			case Enum_Con_Factura.periodoConFactura:
				facturaprov = facturaprovDAO.consultaPeriodoConFactura(facturaprovBean, tipoConsulta);
			break;
			case Enum_Con_Factura.dispersionFactura:
				facturaprov = facturaprovDAO.consultaDispersionFactura(facturaprovBean, tipoConsulta);
			break;
			case Enum_Con_Factura.anticiposFactura:
				facturaprov = facturaprovDAO.consultaAnticipoFactura(facturaprovBean, tipoConsulta);
			break;
		}
		return facturaprov;
	}
	
	// Lista principal de factura proveedor
	public List lista(int tipoLista, FacturaprovBean facturaprovBean){
		List facturasLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_Factura.principal:
	        	//facturasLista = facturaprovDAO.listaFactura(facturaprovBean, tipoLista);
	        break;
	        case  Enum_Lis_Factura.facturaProv:
	        	facturasLista = facturaprovDAO.listaFacturaProveedor(facturaprovBean, tipoLista);
	        break;
	        case  Enum_Lis_Factura.facturaXProv:
	        	facturasLista = facturaprovDAO.listaFacturaPorProveedor(facturaprovBean, tipoLista);
	        break;
	        case  Enum_Lis_Factura.facturaEstAltaParcial:
	        	facturasLista = facturaprovDAO.listaFacturaEstAltaParcial(facturaprovBean, tipoLista);
	        break;
	        case  Enum_Lis_Factura.facturaAltaParcialProveedor:
	        	facturasLista = facturaprovDAO.listaFacturaEstAltaParcialProve(facturaprovBean, tipoLista);
	        break;
	        case  Enum_Lis_Factura.facturaAnticipoProveedor:
	        	facturasLista = facturaprovDAO.listaFacturaProveedor(facturaprovBean, tipoLista);
	        break;	        
		}
		return facturasLista;
	}

	
	// Crea la lista de detalle de factura
	private List creaListaDetalle(String detalleFactura){	
		StringTokenizer tokensBean = new StringTokenizer(detalleFactura, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaDetalleFactura = new ArrayList();
		DetallefactprovBean detallefactprovBean;
		while(tokensBean.hasMoreTokens()){
			detallefactprovBean = new DetallefactprovBean();
		
		stringCampos = tokensBean.nextToken();		
		tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
				
		detallefactprovBean.setTipoGastoID(tokensCampos[0]);
		detallefactprovBean.setCentroCostoID(tokensCampos[1]);
		detallefactprovBean.setCantidad(tokensCampos[2]);
		detallefactprovBean.setDescripcion(tokensCampos[3]);
		detallefactprovBean.setGravable(tokensCampos[4]);
		detallefactprovBean.setGravaCero(tokensCampos[5]);
		detallefactprovBean.setPrecioUnitario(tokensCampos[6]);
		detallefactprovBean.setImporte(tokensCampos[7]);
	
		
		listaDetalleFactura.add(detallefactprovBean);
		
		}
		
		return listaDetalleFactura;
	}
	
	// Crea la lista de detalle de impuestos de la factura
	private List creaListaDetalleImp(String detalleFacturaImp){	
		
		StringTokenizer tokensBean = new StringTokenizer(detalleFacturaImp, "[");
		String stringCampos;

		String tokensCampos[];
		ArrayList listaDetalleFacturaImp = new ArrayList();
		
		DetalleImpuestoBean detalleImpBean;
		
		while(tokensBean.hasMoreTokens()){
			detalleImpBean = new DetalleImpuestoBean();
		
			stringCampos = tokensBean.nextToken();	
			
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
		
			detalleImpBean.setNoPartidaID(tokensCampos[0]);
			detalleImpBean.setImpuestoID(tokensCampos[1]);
			detalleImpBean.setImporteImpuesto(tokensCampos[2]);
			detalleImpBean.setCentroCostoID(tokensCampos[3]);

			
			listaDetalleFacturaImp.add(detalleImpBean);
			
		
		}
		
		return listaDetalleFacturaImp;
	}
	
	
	// **********  servicios para reportes *****************
	// Reporte  de facturas en formato PDF
		public ByteArrayOutputStream reporteFacturasPDF(FacturaprovBean facturaprovBean, String nomReporte) throws Exception{
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				parametrosReporte.agregaParametro("Par_FechaInicio",facturaprovBean.getFechaInicio());
				parametrosReporte.agregaParametro("Par_FechaFin",facturaprovBean.getFechaFin());
				parametrosReporte.agregaParametro("Par_Estatus",facturaprovBean.getEstatus());
				parametrosReporte.agregaParametro("Par_ProveedorID",Utileria.convierteEntero(facturaprovBean.getProveedorID()));
				parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(facturaprovBean.getSucursal()));
				parametrosReporte.agregaParametro("Par_FechaEmision",facturaprovBean.getParFechaEmision());
				parametrosReporte.agregaParametro("Par_OrigenDatos",parametrosAuditoriaBean.getOrigenDatos());
				parametrosReporte.agregaParametro("Par_TipoCaptura",Utileria.convierteEntero(facturaprovBean.getTipoCaptura()));
				parametrosReporte.agregaParametro("Par_DesTipoCaptura",facturaprovBean.getDesTipoCaptura());
				
				parametrosReporte.agregaParametro("Par_NomSucursal",(!facturaprovBean.getNombreSucursal().isEmpty())? facturaprovBean.getNombreSucursal():"TODOS");
				parametrosReporte.agregaParametro("Par_NomProveedor",(!facturaprovBean.getNombreProveedor().isEmpty())? facturaprovBean.getNombreProveedor() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomUsuario",(!facturaprovBean.getNombreUsuario().isEmpty())?facturaprovBean.getNombreUsuario(): "TODOS");
				parametrosReporte.agregaParametro("Par_NomInstitucion",(!facturaprovBean.getNombreInstitucion().isEmpty())?facturaprovBean.getNombreInstitucion(): "TODOS");
				parametrosReporte.agregaParametro("Par_NomEstatus",(!facturaprovBean.getNombreEstatus().isEmpty())?facturaprovBean.getNombreEstatus(): "TODOS");
				
				return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}
		
		
		// Reporte  de facturas en formato Pantalla
		public  String  reporteFacturasPantalla(FacturaprovBean facturaprovBean, String nomReporte) throws Exception{
				ParametrosReporte parametrosReporte = new ParametrosReporte();
				parametrosReporte.agregaParametro("Par_FechaInicio",facturaprovBean.getFechaInicio());
				parametrosReporte.agregaParametro("Par_FechaFin",facturaprovBean.getFechaFin());
				parametrosReporte.agregaParametro("Par_Estatus",facturaprovBean.getEstatus());
				parametrosReporte.agregaParametro("Par_ProveedorID",Utileria.convierteEntero(facturaprovBean.getProveedorID()));
				parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(facturaprovBean.getSucursal()));
				parametrosReporte.agregaParametro("Par_FechaEmision",facturaprovBean.getParFechaEmision());
				parametrosReporte.agregaParametro("Par_OrigenDatos",parametrosAuditoriaBean.getOrigenDatos());
				
				parametrosReporte.agregaParametro("Par_NomSucursal",(!facturaprovBean.getNombreSucursal().isEmpty())? facturaprovBean.getNombreSucursal():"TODOS");
				parametrosReporte.agregaParametro("Par_NomProveedor",(!facturaprovBean.getNombreProveedor().isEmpty())? facturaprovBean.getNombreProveedor() : "TODOS");
				parametrosReporte.agregaParametro("Par_NomUsuario",(!facturaprovBean.getNombreUsuario().isEmpty())?facturaprovBean.getNombreUsuario(): "TODOS");
				parametrosReporte.agregaParametro("Par_NomInstitucion",(!facturaprovBean.getNombreInstitucion().isEmpty())?facturaprovBean.getNombreInstitucion(): "TODOS");
				parametrosReporte.agregaParametro("Par_NomEstatus",(!facturaprovBean.getNombreEstatus().isEmpty())?facturaprovBean.getNombreEstatus(): "TODOS");
				
				return Reporte.creaHtmlReporte (nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			}
		
			public List reporteExcel(int tipoLista,FacturaprovBean facturaprovBean, HttpServletResponse response) throws Exception{				
				List reporExcel=null;
				switch(tipoLista){
					case Enum_Rep_Factura.listaEncabezado:
						reporExcel=facturaprovDAO.listaEncabezados(facturaprovBean, tipoLista);
					break;
				}							
				return reporExcel;
			}
			
			public String reporteExcelLista(int tipoLista,FacturaprovBean facturaprovBean, HttpServletResponse response) throws Exception{				
				String reporExcel=null;
				switch(tipoLista){
					case Enum_Rep_Factura.reporteFacturasExcel:
						reporExcel = facturaprovDAO.conFacturaExcel(facturaprovBean,tipoLista);
					break;
					case Enum_Rep_Factura.reporteFactExcelDetallado:
						reporExcel=facturaprovDAO.conFacExcelDetallado(facturaprovBean,tipoLista);
					break;
				}							
				return reporExcel;
			}

			public FacturaprovBean leeXMLFactura(String rutaArchivo){
				FacturaprovBean facturBean = new FacturaprovBean();
				try {
			    	File fXmlFile = new File(rutaArchivo);
					DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
					DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
					Document doc = dBuilder.parse(fXmlFile);
					facturBean.setMontoTotal( doc.getDocumentElement().getAttribute("Total"));
					//Seccion TimbreFiscalDigital
					if(doc.getElementsByTagName("tfd:TimbreFiscalDigital").getLength() > 0){
						
						NodeList nodeLst = doc.getElementsByTagName("tfd:TimbreFiscalDigital");
						
						facturBean.setFolioUUID(nodeLst.item(0).getAttributes().getNamedItem("UUID").getNodeValue());
						
					}
					if(doc.getElementsByTagName("cfdi:Emisor").getLength() > 0){
						NodeList nEmisor = doc.getElementsByTagName("cfdi:Emisor");
						facturBean.setRfcEmisor(nEmisor.item(0).getAttributes().getNamedItem("Rfc").getNodeValue());
					}
					if(doc.getElementsByTagName("cfdi:Receptor").getLength() > 0){
						NodeList nReceptor = doc.getElementsByTagName("cfdi:Receptor");
						facturBean.setRfcReceptor(nReceptor.item(0).getAttributes().getNamedItem("Rfc").getNodeValue());
					}
					
				 }catch (Exception e) {
				    	e.printStackTrace();
				  
				}			
				return facturBean;
			}
			
	public FacturaprovBean validaCFDI(FacturaprovBean facturaBean,String urlWS,String timeWS){
		FacturaprovBean facturBean = facturaBean;
		IConsultaCFDIServiceProxy iConsultaCFDIServiceProxy = null;
		 long start = 0;
		 long end = 0;
		 String endPointWS = urlWS.trim();
		 String  timeOut = timeWS.trim();
		try{
			  String expresionImpresa = "re="+facturBean.getRfcEmisor()+"&rr="+facturBean.getRfcReceptor()+"&tt="+facturBean.getMontoTotal()+"&id="+facturBean.getFolioUUID();
			  Acuse acuse = new Acuse();
			  

			  start = Calendar.getInstance().getTimeInMillis();
			  iConsultaCFDIServiceProxy = new IConsultaCFDIServiceProxy(endPointWS,timeOut);
			  loggerSAFI.info("Accediendo al endpoint WS: " + endPointWS +"  Con timeout "+timeOut);
			  loggerSAFI.info("expresionImpresa: "+expresionImpresa);
			  acuse = iConsultaCFDIServiceProxy.consulta(expresionImpresa);				  
			  if(!acuse.equals(null)){
				  String estatusRespuesta = acuse.getCodigoEstatus().trim().substring(0,1);
				  //Valida que la respuesta del WS para validar el CFDI
				  if(!estatusRespuesta.equalsIgnoreCase( "S")){
					  facturBean.setNumErrFacWS(999);
					  facturBean.setMensajeSalidaWS(acuse.getCodigoEstatus());
				  }else{
					  facturBean.setNumErrFacWS(0);
					  facturBean.setMensajeSalidaWS(acuse.getCodigoEstatus());
				  }
			  }
			  end = Calendar.getInstance().getTimeInMillis();
		  }catch (RemoteException e) {
				if (e.getCause() != null && (e.getCause().getLocalizedMessage().startsWith("Read timed out")) || e.getCause().getLocalizedMessage().startsWith("Connection timed out")) {
					facturBean.setNumErrFacWS(998);
					 facturBean.setMensajeSalidaWS("Tiempo de Respuesta del Web Service Excedido.");

				}
				else {
					facturBean.setNumErrFacWS(999);
					 facturBean.setMensajeSalidaWS("El SAFI ha tenido un problema al concretar la operacion." + "Disculpe las molestias que esto le ocasiona. Ref: WS-ConsultaCFDI");
				}
				loggerSAFI.info("Error en comprobar archivo CFD WS. " + " Tiempo: " + ((end - start) / (1000)) + " Seg");
				loggerSAFI.error(e.getMessage());
				

			}catch (Exception ex) {
				facturBean.setNumErrFacWS(998);
				 facturBean.setMensajeSalidaWS("Ha Ocurrido un Error al Intentar llamar al Servicio de Consulta de CFDI.");
				ex.printStackTrace();	
			}
		return facturBean;
	}
	//------------------ Geters y Seters ------------------------------------------------------	
	
	public FacturaprovDAO getFacturaprovDAO() {
		return facturaprovDAO;
	}

	public void setFacturaprovDAO(FacturaprovDAO facturaprovDAO) {
		this.facturaprovDAO = facturaprovDAO;
	}
}
