package regulatorios.controlador;

import general.bean.ParametrosSesionBean;
import general.servicio.ParametrosAplicacionServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;
import java.util.zip.ZipOutputStream;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;

import org.apache.log4j.Logger;
import org.apache.tools.zip.ZipEntry;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;










//import contabilidad.bean.BalanzaBean;
//import contabilidad.bean.CatalogoBean;
import contabilidad.bean.CePolizasBean;
import regulatorios.bean.ContaElecCatalogoContaBean;
import contabilidad.bean.CuentasContablesBean;
import contabilidad.bean.SaldosContablesBean;
//import contabilidad.servicio.ObjectFactoryPolizas;
import contabilidad.bean.ContaElecPolizasBean;
//import contabilidad.bean.ContaElecPolizasBean.Poliza;
//import contabilidad.bean.ContaElecPolizasBean.Poliza.Transaccion;
//import contabilidad.bean.ContaElecPolizasBean.Poliza.Transaccion.Comprobantes;
import contabilidad.servicio.CuentasContablesServicio;
import contabilidad.servicio.DetallePolizaServicio;
import contabilidad.servicio.SaldosContablesServicio;
//import contabilidad.servicio.ObjectFactoryBalanza;
//import contabilidad.servicio.ObjectFactoryCatalogo;



public class ConElectronicaXMLControlador  extends AbstractCommandController{

	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public static interface Enum_Con_TipoXml{
		  int  catalogo  = 1 ;		
		  int  balanza = 2 ;
		  int  polizas = 3 ;
		  int  auxiliarCuentas = 4 ;
		  int  auxiliarFolios = 5 ;
		}
	
	public static interface Enum_Con_CtasContables{
		  int  numCta  = 3 ;		
		  int  xmlCtas = 8 ;
		  int  debeHaber = 1; 
		  int numCtasBalanza = 4;
		}
	
	CuentasContablesServicio cuentasContablesServicio = null;
	SaldosContablesServicio saldosContablesServicio = null;
	DetallePolizaServicio detallePolizaServicio = null;
	ParametrosAplicacionServicio	parametrosAplicacionServicio	= null;
	
	public ConElectronicaXMLControlador () {
		setCommandClass(ContaElecCatalogoContaBean.class);
		setCommandName("regulatoriosContabilidadBean");
	}

	
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors)throws Exception {
								  	
 		String contentOriginal = response.getContentType(); 
 		
 		
		int tipoXml =(request.getParameter("generaTipoXml")!=null)?Integer.parseInt(request.getParameter("generaTipoXml")):0;		
		String mes =(request.getParameter("mes")!=null)?request.getParameter("mes"):"00";
		int anio =(request.getParameter("anio")!=null)?Integer.parseInt(request.getParameter("anio")):0;
		String tipoSolicitud =(request.getParameter("tipoSolicitud")!=null)?request.getParameter("tipoSolicitud"):"";
		String numeroOrden =(request.getParameter("numeroOrden")!=null)?request.getParameter("numeroOrden"):"";
		String numeroTramite = (request.getParameter("numeroTramite")!=null)?request.getParameter("numeroTramite"):"";
		int consecutivo1 =(request.getParameter("consecutivo")!=null)?Integer.parseInt(request.getParameter("consecutivo")):0;
		String consecutivo=Utileria.completaCerosIzquierda(consecutivo1, 2);
		String nombreUsuario=(request.getParameter("nombreUsuario")!=null)?request.getParameter("nombreUsuario"):"";
		if(Integer.parseInt(mes)<10){
			mes="0"+mes;
		}
		
		
		
		switch(tipoXml){	
			case Enum_Con_TipoXml.catalogo:
				return generaCatalogoXml(response, contentOriginal,mes,anio,consecutivo);
			case Enum_Con_TipoXml.balanza:
				return generaBalanzaXml(response, contentOriginal,mes,anio,nombreUsuario);				
			case Enum_Con_TipoXml.polizas:
				return generaPolizaXml(response, contentOriginal,mes,anio, tipoSolicitud, numeroOrden, numeroTramite);
			case Enum_Con_TipoXml.auxiliarCuentas:
				return generaAuxiliarCuentasXml(response, contentOriginal,mes,anio, tipoSolicitud, numeroOrden, numeroTramite);
			case Enum_Con_TipoXml.auxiliarFolios:
				return generaAuxiliarFoliosXml(response, contentOriginal,mes,anio, tipoSolicitud, numeroOrden, numeroTramite);
			default:
				String htmlString = Constantes.htmlErrorReporteCirculo;
	 			response.addHeader("Content-Disposition","");
		 		response.setContentType(contentOriginal);
		 		response.setContentLength(htmlString.length());
	 			return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
	 			
			
		}	
		 		
 	}

	@SuppressWarnings("unchecked")
	public ModelAndView generaCatalogoXml(HttpServletResponse response,String contentOriginal, String mes, int anio, String consecutivo){
	
		try{ CuentasContablesBean cuentasContablesBean = new CuentasContablesBean();
	      cuentasContablesBean.setFechaCreacionCta(anio + "-" + mes + "-" + "01");
	      List<CuentasContablesBean> listaCuentasContables = null;
	      
	      cuentasContablesBean = this.cuentasContablesServicio.consulta(3, cuentasContablesBean);
	      ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
	      String directorio = parametros.getRutaArchivos()+"ContabilidadElectronica/";
	      String nombreXml = cuentasContablesBean.getRfc() + anio + mes + "CT.xml";
		     String nombreZip = cuentasContablesBean.getRfc() + anio + mes + "CT.zip"; // Nombre del Archivo Xml
	      String rutaCompleta = directorio + nombreXml;
		     String rutaZip = directorio + nombreZip;
	      
	      borrarArchivo(rutaCompleta);

	      escribeArchivo(rutaCompleta, "<?xml version=\"1.0\" encoding=\"UTF-8\"?><catalogocuentas:Catalogo"
	      		+ " xsi:schemaLocation=\"http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/CatalogoCuentas"
	      		+ " http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/CatalogoCuentas/CatalogoCuentas_1_3.xsd\" "
	      		+ "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\""
	      		+ " xmlns:catalogocuentas=\"http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/CatalogoCuentas\" Version=\"1.3\" RFC=\"" + 
	      
	        cuentasContablesBean.getRfc() + "\" Mes=\"" + mes + "\" Anio=\"" + anio + "\">");
	      
	      cuentasContablesBean.setFechaCreacionCta(anio + "-" + mes + "-" + "01");
	      listaCuentasContables = this.cuentasContablesServicio.lista(8, cuentasContablesBean);
	      for (CuentasContablesBean ctaCon : listaCuentasContables) {
	        escribeArchivo(rutaCompleta, "<catalogocuentas:Ctas CodAgrup=\"" + ctaCon.getCodigoAgrupador() + "\" " + 
	          "NumCta=\"" + ctaCon.getCuentaCompleta() + "\" " + 
	          "Desc=\"" + ctaCon.getDescripcion() + "\" " + 
	          "Nivel=\"" + ctaCon.getNivel() + "\" " + 
	          "Natur=\"" + ctaCon.getNaturaleza() + "\"/>");
	      }
	      escribeArchivo(rutaCompleta, "</catalogocuentas:Catalogo>");
	      
	      File f = null;
	      boolean exists = new File(directorio).exists();
	      if (exists)
	      {
	        f = new File(rutaCompleta);
	      }
	      else
	      {
	        File aDir = new File(directorio);
	        aDir.mkdir();
	        f = new File(rutaCompleta);
	      }
		 		String inputFile = rutaCompleta;
		 		String rutaArchivo = rutaZip;
		 		FileInputStream in = new FileInputStream(inputFile);
		 		FileOutputStream out = new FileOutputStream(rutaArchivo);

		 				  	 		
		 		byte b[] = new byte[2048];
		 		ZipOutputStream zipOut = new ZipOutputStream(out);
		 		ZipEntry entry = new ZipEntry(nombreXml);
		 		zipOut.putNextEntry(entry);
		 		int len = 0;
		 		while ((len = in.read(b)) != -1) {
		 			zipOut.write(b, 0, len);
		 		}		
		 		zipOut.flush();
		 		
		 		zipOut.close();	
		 		
		 		File xml = new File(rutaCompleta);
		 		xml.delete();
		 		File archivoFile = new File(rutaZip);
	      FileInputStream fileInputStream = new FileInputStream(archivoFile);
	      
			 		response.addHeader("Content-Disposition","attachment; filename="+nombreZip);
			 		response.setContentType("application/zip");
	
	 		response.setContentLength((int) archivoFile.length()); 		
	 		int bytes;
	 		
			while ((bytes = fileInputStream.read()) != -1) {
				response.getOutputStream().write(bytes);
			}
			fileInputStream.close();
			response.getOutputStream().flush();
			response.getOutputStream().close();
	      
	      return null;
 	    }
 	    catch (Exception e)
 	    {
 	      e.printStackTrace();
 	      String htmlString = Constantes.htmlErrorReporteCirculo;
 	      response.addHeader("Content-Disposition", "");
 	      response.setContentType(contentOriginal);
 	      response.setContentLength(htmlString.length());
 	      return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
 	    }
}

	@SuppressWarnings("unchecked")
	public ModelAndView generaBalanzaXml(HttpServletResponse response,String contentOriginal, String mes, int anio,String nombreUsuario){
	
		try{
 			CuentasContablesBean cuentasContablesBean = new CuentasContablesBean();
 		      cuentasContablesBean.setFechaCreacionCta(anio + "-" + mes + "-" + "01");
 		      List<SaldosContablesBean> listaCuentasContables = null;
 		      
 		      cuentasContablesBean = this.cuentasContablesServicio.consulta(4, cuentasContablesBean);
 		      
 		      ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
 	 	      String directorio = parametros.getRutaArchivos()+"ContabilidadElectronica/";
 		      String nombreXml = cuentasContablesBean.getRfc() + anio + mes + "BN.xml";
		     String nombreZip = cuentasContablesBean.getRfc() + anio + mes + "BN.zip"; // Nombre del Archivo Xml
 		      String rutaCompleta = directorio + nombreXml;
		     String rutaZip = directorio + nombreZip;
 		      
 		      borrarArchivo(rutaCompleta); 		      
     
 		      escribeArchivo(rutaCompleta, "<?xml version=\"1.0\" encoding=\"UTF-8\"?><BCE:Balanza "
 		      		+ "xsi:schemaLocation=\"http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/BalanzaComprobacion"
 		      		+ " http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/BalanzaComprobacion/BalanzaComprobacion_1_3.xsd\" "
 		      		+ "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
 		      		+ "xmlns:BCE=\"http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/BalanzaComprobacion\" Version=\"1.3\" RFC=\"" + 
 		      
 		        cuentasContablesBean.getRfc() + "\" Mes=\"" + mes + "\" Anio=\"" + anio + "\" TipoEnvio=\"N\">");
 		      
 		      listaCuentasContables = this.saldosContablesServicio.consulta(anio + "-" + mes + "-" + "01", 1,nombreUsuario);
 		      for (SaldosContablesBean ctaCon : listaCuentasContables) {
 		        escribeArchivo(rutaCompleta, "<BCE:Ctas NumCta=\"" + ctaCon.getCuentaCompleta() + "\" " + 
 		          "SaldoIni=\"" + new BigDecimal(ctaCon.getSaldoInicial()) + "\" " + 
 		          "Debe=\"" + new BigDecimal(ctaCon.getCargos()) + "\" " + 
 		          "Haber=\"" + new BigDecimal(ctaCon.getAbonos()) + "\" " + 
 		          "SaldoFin=\"" + new BigDecimal(ctaCon.getSaldoFinal()) + "\"/>");
 		      }
 		      escribeArchivo(rutaCompleta, "</BCE:Balanza>");
 		      
 		      File f = null;
 		      boolean exists = new File(directorio).exists();
 		      if (exists)
 		      {
 		        f = new File(rutaCompleta);
 		      }
 		      else
 		      {
 		        File aDir = new File(directorio);
 		        aDir.mkdir();
 		        f = new File(rutaCompleta);
 		      }
		 		String inputFile = rutaCompleta;
		 		String rutaArchivo = rutaZip;
		 		FileInputStream in = new FileInputStream(inputFile);
		 		FileOutputStream out = new FileOutputStream(rutaArchivo);

		 				  	 		
		 		byte b[] = new byte[2048];
		 		ZipOutputStream zipOut = new ZipOutputStream(out);
		 		ZipEntry entry = new ZipEntry(nombreXml);
		 		zipOut.putNextEntry(entry);
		 		int len = 0;
		 		while ((len = in.read(b)) != -1) {
		 			zipOut.write(b, 0, len);
		 		}		
		 		zipOut.flush();
		 		
		 		zipOut.close();	
		 		
		 		File xml = new File(rutaCompleta);
		 		xml.delete();
		 		File archivoFile = new File(rutaZip);
 		      
 		      FileInputStream fileInputStream = new FileInputStream(archivoFile);
 		      
			 		response.addHeader("Content-Disposition","attachment; filename="+nombreZip);
			 		response.setContentType("application/zip");
 		
 		 		response.setContentLength((int) archivoFile.length()); 		
 		 		int bytes;
 		 		
 				while ((bytes = fileInputStream.read()) != -1) {
 					response.getOutputStream().write(bytes);
 				}
 				fileInputStream.close();
 				response.getOutputStream().flush();
 				response.getOutputStream().close();
 		      
 		      return null;
 		    }
 		    catch (Exception e)
 		    {
 		      e.printStackTrace();
 		      String htmlString = Constantes.htmlErrorReporteCirculo;
 		      response.addHeader("Content-Disposition", "");
 		      response.setContentType(contentOriginal);
 		      response.setContentLength(htmlString.length());
 		      return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
 		    }
}

	
	@SuppressWarnings("unchecked")
	public ModelAndView generaPolizaXml(HttpServletResponse response,String contentOriginal, String mes, int anio, String tipoSolicitud, String numeroOrden, String numeroTramite){
	
try{
 			
 			CuentasContablesBean cuentasContablesBean=new CuentasContablesBean();
 			cuentasContablesBean.setFechaCreacionCta(anio+"-"+mes+"-"+"01");
            
 	        cuentasContablesBean=cuentasContablesServicio.consulta(Enum_Con_CtasContables.numCta, cuentasContablesBean); // Numero de Cuentas Contables dadas de alta y RFC
  
 			
 			CePolizasBean polizasBean=new CePolizasBean();
 			polizasBean.setFecha(anio+"-"+mes+"-"+"01");
 			List<CePolizasBean> listaCePolizas = null;

 				ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
 				String directorio = parametros.getRutaArchivos()+"ContabilidadElectronica/";
		     String nombreXml = cuentasContablesBean.getRfc() + anio + mes + "PL.xml"; // Nombre del Archivo Xml
		     String nombreZip = cuentasContablesBean.getRfc() + anio + mes + "PL.zip"; // Nombre del Archivo Xml
		     String rutaCompleta = directorio + nombreXml;
		     String rutaZip = directorio + nombreZip;
		      
		     borrarArchivo(rutaCompleta);

		  		     escribeArchivo(rutaCompleta, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
		     		+ "<PLZ:Polizas xsi:schemaLocation=\"http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/PolizasPeriodo"
		     		+ " http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/PolizasPeriodo/PolizasPeriodo_1_3.xsd\" "
		     		+ "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
		     		+ "xmlns:PLZ=\"http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/PolizasPeriodo\" "
		     		+ "Version=\"1.3\" RFC=\"" + cuentasContablesBean.getRfc()  +  "\" Mes=\"" + mes + "\" Anio=\"" + anio
		     		+ "\"  TipoSolicitud=\""+tipoSolicitud + "\"" );
		     
			     if (tipoSolicitud.equals("AF") || tipoSolicitud.equals("FC")) {
			    	 escribeArchivo(rutaCompleta, " NumOrden=\""+numeroOrden  + "\">");
			    	}
			     
			     if (tipoSolicitud.equals("DE") || tipoSolicitud.equals("CO")) {
			    	 escribeArchivo(rutaCompleta, "  NumTramite=\""+numeroTramite   + "\">");
			    	}
		    
	 	    listaCePolizas=detallePolizaServicio.listaCePolizas(3, polizasBean); // Datos de la Poliza


	 	    for(CePolizasBean polizaBean:listaCePolizas){	 	    	
	 	    	if(Integer.parseInt(polizaBean.getConsecutivo())==1){		 	    		
	 	    		escribeArchivo(rutaCompleta, "<PLZ:Poliza NumUnIdenPol=\"" + polizaBean.getPolizaID()+ "\" " + 
 		 		          "Fecha=\"" +polizaBean.getFecha()+ "\" " + 
 		 		          "Concepto=\"" +polizaBean.getConceptoPoliza() + "\">");
	 	    	}
	 	    	if(Integer.parseInt(polizaBean.getConsecutivo())==2){	
	 	    		escribeArchivo(rutaCompleta, "<PLZ:Transaccion NumCta=\"" + polizaBean.getCuentaCompleta()+ "\" " +
	 		 		      "DesCta=\"" + polizaBean.getDesCorta() + "\" " + 
 		 		          "Concepto=\"" + polizaBean.getConceptoDetalle() + "\" " + 
 		 		          "Debe=\"" +polizaBean.getDebe()+ "\" " + 
 		 		          "Haber=\"" +polizaBean.getHaber() + "\" />");
	 	    	}
	 	    	if(Integer.parseInt(polizaBean.getConsecutivo())==3){
	 	    		escribeArchivo(rutaCompleta, "</PLZ:Poliza>");
	 	    	}
	 	    	
	 	    }
	 	   escribeArchivo(rutaCompleta, "</PLZ:Polizas>");
		      File f = null;
		      boolean exists = new File(directorio).exists();
		      if (exists)
		      {
		        f = new File(rutaCompleta);
		      }
		      else
		      {
		        File aDir = new File(directorio);
		        aDir.mkdir();
		        f = new File(rutaCompleta);
		      }
		      
		 		String inputFile = rutaCompleta;
		 		String rutaArchivo = rutaZip;
		 		FileInputStream in = new FileInputStream(inputFile);
		 		FileOutputStream out = new FileOutputStream(rutaArchivo);

		 				  	 		
		 		byte b[] = new byte[2048];
		 		ZipOutputStream zipOut = new ZipOutputStream(out);
		 		ZipEntry entry = new ZipEntry(nombreXml);
		 		zipOut.putNextEntry(entry);
		 		int len = 0;
		 		while ((len = in.read(b)) != -1) {
		 			zipOut.write(b, 0, len);
		 		}		
		 		zipOut.flush();
		 		
		 		zipOut.close();	
		 		
		 		File xml = new File(rutaCompleta);
		 		xml.delete();
		 		File archivoFile = new File(rutaZip);
		      FileInputStream fileInputStream = new FileInputStream(archivoFile);
		      
			 		response.addHeader("Content-Disposition","attachment; filename="+nombreZip);
			 		response.setContentType("application/zip");
		
		 		response.setContentLength((int) archivoFile.length()); 		
		 		int bytes;
		 		
				while ((bytes = fileInputStream.read()) != -1) {
					response.getOutputStream().write(bytes);
				}
				fileInputStream.close();
				response.getOutputStream().flush();
				response.getOutputStream().close();
				
		      
		      return null;
		    }
		    catch (Exception e)
		    {
		      e.printStackTrace();
		      String htmlString = Constantes.htmlErrorReporteCirculo;
		      response.addHeader("Content-Disposition", "");
		      response.setContentType(contentOriginal);
		      response.setContentLength(htmlString.length());
		      return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
		    }
}
	
	@SuppressWarnings("unchecked")
	public ModelAndView generaAuxiliarCuentasXml(HttpServletResponse response,String contentOriginal, String mes, int anio, String tipoSolicitud, String numeroOrden, String numeroTramite){
	
 		try{
 			
 			CuentasContablesBean cuentasContablesBean=new CuentasContablesBean();
 			cuentasContablesBean.setFechaCreacionCta(anio+"-"+mes+"-"+"01");
            
 	        cuentasContablesBean=cuentasContablesServicio.consulta(Enum_Con_CtasContables.numCta, cuentasContablesBean); // Numero de Cuentas Contables dadas de alta y RFC
  
 			
 			CePolizasBean polizasBean=new CePolizasBean();
 			polizasBean.setFecha(anio+"-"+mes+"-"+"01");
 			List<CePolizasBean> listaCePolizas = null;

 				ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
 				String directorio = parametros.getRutaArchivos()+"ContabilidadElectronica/";
		     String nombreXml = cuentasContablesBean.getRfc() + anio + mes + "XC.xml"; // Nombre del Archivo Xml
		     String nombreZip = cuentasContablesBean.getRfc() + anio + mes + "XC.zip"; // Nombre del Archivo Xml
		     String rutaCompleta = directorio + nombreXml;
		     String rutaZip = directorio + nombreZip;
		      
		     borrarArchivo(rutaCompleta);	
		     
		     escribeArchivo(rutaCompleta, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
		     		+ "<AuxiliarCtas:AuxiliarCtas xsi:schemaLocation = \"http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarCtas "
		     		+ "http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarCtas/AuxiliarCtas_1_3.xsd\" "
		     		+ "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
		     		+ "xmlns:AuxiliarCtas=\"http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarCtas\" "
		     		+ "Version=\"1.3\" RFC=\"" + cuentasContablesBean.getRfc()  +  "\" Mes=\"" + mes + "\" Anio=\"" + anio		     		
		     		+ "\"  TipoSolicitud=\""+tipoSolicitud + "\"" );
		     
		     if (tipoSolicitud.equals("AF") || tipoSolicitud.equals("FC")) {
		    	 escribeArchivo(rutaCompleta, " NumOrden=\""+numeroOrden  + "\">");
		    	}
		     
		     if (tipoSolicitud.equals("DE") || tipoSolicitud.equals("CO")) {
		    	 escribeArchivo(rutaCompleta, "  NumTramite=\""+numeroTramite   + "\">");
		    	}
		     
	 	    listaCePolizas=detallePolizaServicio.listaCePolizas(4, polizasBean); // Datos de la Poliza


	 	    for(CePolizasBean polizaBean:listaCePolizas){	 	    	
	 	    	if(Integer.parseInt(polizaBean.getConsecutivo())==1){		 	    		
	 	    		escribeArchivo(rutaCompleta, "<AuxiliarCtas:Cuenta NumCta=\"" + polizaBean.getCuentaCompleta()+ "\" " + 
	 	    			  "DesCta=\"" +polizaBean.getDescripcionCuenta()+ "\" " + 
 		 		          "SaldoIni=\"" +polizaBean.getSaldoInicial()+ "\" " + 
 		 		          "SaldoFin=\"" +polizaBean.getSaldoFinal() + "\">");
	 	    	}
	 	    	if(Integer.parseInt(polizaBean.getConsecutivo())==2){	
	 	    		escribeArchivo(rutaCompleta, "<AuxiliarCtas:DetalleAux Fecha=\"" + polizaBean.getFecha()+ "\" " +
	 		 		      "NumUnIdenPol=\"" + polizaBean.getPolizaID() + "\" " + 
	 		 		      "Concepto=\"" + polizaBean.getConceptoDetalle() + "\" " + 
 		 		          "Debe=\"" +polizaBean.getDebe()+ "\" " + 
 		 		          "Haber=\"" +polizaBean.getHaber() + "\" />");	 	    		
	 	    	}	
	 	    		
	 	    	if(Integer.parseInt(polizaBean.getConsecutivo())==3){
	 	    		escribeArchivo(rutaCompleta, "</AuxiliarCtas:Cuenta>");
	 	    	}
	 	    }
	 	   escribeArchivo(rutaCompleta, "</AuxiliarCtas:AuxiliarCtas>");
		      File f = null;
		      boolean exists = new File(directorio).exists();
		      if (exists)
		      {
		        f = new File(rutaCompleta);
		      }
		      else
		      { 
		        File aDir = new File(directorio);
		        aDir.mkdir();
		        f = new File(rutaCompleta);
		      }
		      
		 		String inputFile = rutaCompleta;
		 		String rutaArchivo = rutaZip;
		 		FileInputStream in = new FileInputStream(inputFile);
		 		FileOutputStream out = new FileOutputStream(rutaArchivo);

		 				  	 		
		 		byte b[] = new byte[2048];
		 		ZipOutputStream zipOut = new ZipOutputStream(out);
		 		ZipEntry entry = new ZipEntry(nombreXml);
		 		zipOut.putNextEntry(entry);
		 		int len = 0;
		 		while ((len = in.read(b)) != -1) {
		 			zipOut.write(b, 0, len);
		 		}		
		 		zipOut.flush();
		 		
		 		zipOut.close();	
		 		
		 		File xml = new File(rutaCompleta);
		 		xml.delete();
		 		File archivoFile = new File(rutaZip);
		 		
			      FileInputStream fileInputStream = new FileInputStream(archivoFile);
			      
			 		response.addHeader("Content-Disposition","attachment; filename="+nombreZip);
			 		response.setContentType("application/zip");
			
			 		response.setContentLength((int) archivoFile.length()); 		
			 		int bytes;
			 		
					while ((bytes = fileInputStream.read()) != -1) {
						response.getOutputStream().write(bytes);
					}
					fileInputStream.close();
					response.getOutputStream().flush();
					response.getOutputStream().close();
		      
		      return null;
		    }
		    catch (Exception e)
		    {
		      e.printStackTrace();
		      String htmlString = Constantes.htmlErrorReporteCirculo;
		      response.addHeader("Content-Disposition", "");
		      response.setContentType(contentOriginal);
		      response.setContentLength(htmlString.length());
		      return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
		    }
}
	
	
	
	
	@SuppressWarnings("unchecked")
	public ModelAndView generaAuxiliarFoliosXml(HttpServletResponse response,String contentOriginal, String mes, int anio, String tipoSolicitud, String numeroOrden, String numeroTramite){
	
 		try{
 			
 			CuentasContablesBean cuentasContablesBean=new CuentasContablesBean();
 			cuentasContablesBean.setFechaCreacionCta(anio+"-"+mes+"-"+"01");
            
 	        cuentasContablesBean=cuentasContablesServicio.consulta(Enum_Con_CtasContables.numCta, cuentasContablesBean); // Numero de Cuentas Contables dadas de alta y RFC
  
 			
 			CePolizasBean polizasBean=new CePolizasBean();
 			polizasBean.setFecha(anio+"-"+mes+"-"+"01");
 			List<CePolizasBean> listaCePolizas = null;

 				ParametrosSesionBean parametros = parametrosAplicacionServicio.consultaParametrosSessionLocal();
 				String directorio = parametros.getRutaArchivos()+"ContabilidadElectronica/";
		     String nombreXml = cuentasContablesBean.getRfc() + anio + mes + "XF.xml"; // Nombre del Archivo Xml
		     String rutaCompleta = directorio + nombreXml;
		      
		     borrarArchivo(rutaCompleta);	
		     
		     escribeArchivo(rutaCompleta, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
		     		+ "<RepAux:RepAuxFol xsi:schemaLocation=\"http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarFolios "
		     		+ "http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarFolios/AuxiliarFolios_1_3.xsd\" "
		     		+ "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
		     		+ "xmlns:RepAux=\"http://www.sat.gob.mx/esquemas/ContabilidadE/1_3/AuxiliarFolios\" "
		     		+ "Version=\"1.3\" RFC=\"" + cuentasContablesBean.getRfc()  +  "\" Mes=\"" + mes + "\" Anio=\"" + anio		     		
		     		+ "\"  TipoSolicitud=\""+tipoSolicitud + "\"" );  
	
		     
		     
		     if (tipoSolicitud.equals("AF") || tipoSolicitud.equals("FC")) {
		    	 escribeArchivo(rutaCompleta, " NumOrden=\""+numeroOrden  + "\">");
		    	}
		     
		     if (tipoSolicitud.equals("DE") || tipoSolicitud.equals("CO")) {
		    	 escribeArchivo(rutaCompleta, "  NumTramite=\""+numeroTramite   + "\">");
		    	}
		     
	 	    listaCePolizas=detallePolizaServicio.listaCePolizas(5, polizasBean); // Datos de la Poliza


	 	    for(CePolizasBean polizaBean:listaCePolizas){	 	    	
	 	    	if(Integer.parseInt(polizaBean.getConsecutivo())==1){		 	    		
	 	    		escribeArchivo(rutaCompleta, "<RepAux:DetAuxFol NumUnIdenPol=\"" + polizaBean.getPolizaID() + "\" " + 
 		 		          "Fecha=\"" +polizaBean.getFecha() + "\">");
	 	    	}
	 	    	if(Integer.parseInt(polizaBean.getConsecutivo())==2){	
	 	    		escribeArchivo(rutaCompleta, "<RepAux:ComprNal UUID_CFDI=\"" + polizaBean.getFolioUUID()+ "\" " +
	 		 		      "MontoTotal=\"" + polizaBean.getTotalFactura() + "\" " + 
	 		 		      "RFC=\"" + polizaBean.getRfc() + "\" " + 
 		 		          "MetPagoAux=\"" +polizaBean.getMetodoPago()+ "\" " +
 		 		          "Moneda=\"" +polizaBean.getMoneda() + "\" " +
 		 		          "TipCamb=\"" +polizaBean.getTipoCambio() + "\" />");	 	    		
	 	    	}   	
	 	    	
	 	    	if(Integer.parseInt(polizaBean.getConsecutivo())==3){
	 	    		escribeArchivo(rutaCompleta, "</RepAux:DetAuxFol>");
	 	    	}
	 	    	
	 	    }
	 	   escribeArchivo(rutaCompleta, "</RepAux:RepAuxFol>");
		      File f = null;
		      boolean exists = new File(directorio).exists();
		      if (exists)
		      {
		        f = new File(rutaCompleta);
		      }
		      else
		      {
		        File aDir = new File(directorio);
		        aDir.mkdir();
		        f = new File(rutaCompleta);
		      }
		      File archivoFile = new File(rutaCompleta);
		      
		      FileInputStream fileInputStream = new FileInputStream(archivoFile);
		      
		 		response.addHeader("Content-Disposition","attachment; filename="+nombreXml);
		 		response.setContentType(contentOriginal);
		
		 		response.setContentLength((int) archivoFile.length()); 		
		 		int bytes;
		 		
				while ((bytes = fileInputStream.read()) != -1) {
					response.getOutputStream().write(bytes);
				}
				fileInputStream.close();
				response.getOutputStream().flush();
				response.getOutputStream().close();
				
		      
		      return null;
		    }
		    catch (Exception e)
		    {
		      e.printStackTrace();
		      String htmlString = Constantes.htmlErrorReporteCirculo;
		      response.addHeader("Content-Disposition", "");
		      response.setContentType(contentOriginal);
		      response.setContentLength(htmlString.length());
		      return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
		    }
}
	
	 public void borrarArchivo(String fileName)
	  {
	    File f = new File(fileName);
	    if (f.exists()) {
	      f.delete();
	    }
	    f = null;
	  }
	 
	 public void escribeArchivo(String fileName, String linea) throws Exception { 

		 FileWriter fichero = null; 
		 PrintWriter pw = null; 
		 try{ 
		   fichero = new FileWriter(fileName,true); 
		   pw = new PrintWriter(fichero); 
		   pw.println(linea); 
           pw.flush();
           fichero.close();
		  }catch (Exception e) { 
		    e.printStackTrace();
		    throw new Exception(e);
		  }finally{ 
		    if (null != fichero){
		     try{
		       fichero.close(); 
		     }catch (Exception e2) { 
		       e2.printStackTrace(); 
		     }
		    }
		 } 
	}
	public CuentasContablesServicio getCuentasContablesServicio() {
		return cuentasContablesServicio;
	}


	public void setCuentasContablesServicio(
			CuentasContablesServicio cuentasContablesServicio) {
		this.cuentasContablesServicio = cuentasContablesServicio;
	}


	public SaldosContablesServicio getSaldosContablesServicio() {
		return saldosContablesServicio;
	}


	public void setSaldosContablesServicio(
			SaldosContablesServicio saldosContablesServicio) {
		this.saldosContablesServicio = saldosContablesServicio;
	}


	public DetallePolizaServicio getDetallePolizaServicio() {
		return detallePolizaServicio;
	}


	public void setDetallePolizaServicio(DetallePolizaServicio detallePolizaServicio) {
		this.detallePolizaServicio = detallePolizaServicio;
	}


	public ParametrosAplicacionServicio getParametrosAplicacionServicio() {
		return parametrosAplicacionServicio;
	}


	public void setParametrosAplicacionServicio(
			ParametrosAplicacionServicio parametrosAplicacionServicio) {
		this.parametrosAplicacionServicio = parametrosAplicacionServicio;
	}

}