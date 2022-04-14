package soporte.beanWS;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.File;
import java.io.IOException;
import general.bean.BaseBean;
import herramientas.Utileria;

import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.Signature;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.security.spec.PKCS8EncodedKeySpec;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringWriter;

import javax.xml.soap.MessageFactory;
import javax.xml.soap.MimeHeaders;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import soporte.bean.GeneraConstanciaRetencionBean;
import soporte.servicioweb.SmartwebTimbradoRetencionesProxy;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.ssl.PKCS8Key;

import com.sun.org.apache.xerces.internal.parsers.DOMParser;

public class SmarterWebBeanWS extends BaseBean{
	private String urlSOAP;
	private String userId;
	private String userPass;
	private String rfcEmisor;
	private String soapResponse;
	public boolean generarPDF;
	public boolean generarCBB;
	public boolean error;
	public String strPdf;
	public String strXml;
	public String strCbb;
	public String strTxt;
	private String soapRequest;
	private String numero;
	private String mensaje;
	
	public SmarterWebBeanWS(){
		super();
	}
	public SmarterWebBeanWS(String urlSOAP, String userID, String userPass, String rfcEmisor) {
		this.urlSOAP = urlSOAP;
		this.userId = userID;
		this.userPass = userPass;
		this.rfcEmisor = rfcEmisor;
		this.error = false;
	}

	public SmarterWebBeanWS(String urlSOAP, String userID, String userPass, String rfcEmisor, boolean generaPDF, boolean generaCBB) {
		this.urlSOAP = urlSOAP;
		this.userId = userID;
		this.userPass = userPass;
		this.rfcEmisor = rfcEmisor;
		this.generarPDF = generaPDF;
		this.generarCBB = generaCBB;
		this.error = false;
	}
  
	public SmarterWebBeanWS timbrarFacturaSmarterWeb(GeneraConstanciaRetencionBean generaConstanciaRetencionBean) {
		SmarterWebBeanWS smarterWebBeanWS = new SmarterWebBeanWS();
		smarterWebBeanWS.generarCBB = true;
		try{			
			String layout = generaConstanciaRetencionBean.getCadenaCFDI();
			String certificado = "";
			String numCertificado = "";
			String sello = "";
			String linea, strLayout="", layoutb64="", wsresponse="Timbrado Exitoso", response = "exito";


			System.out.println("layout: "+layout);
			// OBTIENE EL VALOR DEL CAMPO CERTIFICADO EN BASE64
			certificado = generarCertificadoBase64( generaConstanciaRetencionBean.getRutaArchivosCertificado(), generaConstanciaRetencionBean.getNombreCertificado());
			System.out.println("Cert: "+certificado);
			if(certificado.equals("")){
				smarterWebBeanWS.setNumero("1");
				smarterWebBeanWS.setMensaje("Error al generar valor para el campo Certificado.");
				throw new Exception(smarterWebBeanWS.getMensaje());
			}
			
			// GENERA NUMERO DE CERTIFICADO
			numCertificado = generarNumCertificado( generaConstanciaRetencionBean.getRutaArchivosCertificado(), generaConstanciaRetencionBean.getNombreCertificado());
			System.out.println("NumCert: "+numCertificado);
			if(numCertificado.equals("")){
				smarterWebBeanWS.setNumero("2");
				smarterWebBeanWS.setMensaje("Error al generar valor para el campo Numero Certificado.");
				throw new Exception(smarterWebBeanWS.getMensaje());
			}
								
			//AGREGAN VALORES A LOS CAMPOS CERT, NUMCERT DEL XML QUE SE TIMBRARA
			String[] lineasLayout = layout.split("\n");
			
			if(lineasLayout.length > 0){
			    for (String lineaLayout: lineasLayout) {
			    	
			    	//AGREGA EL VALOR DEL CAMPO CERTIFICADO
			    	if(lineaLayout.trim().equals("Cert=\"\"")){
			    		lineaLayout = "Cert=\""+certificado+"\"";
			    	}
			    	//AGREGA EL VALOR DEL CAMPO NUMERO DE CERTIFICADO
			    	if(lineaLayout.trim().equals("NumCert=\"\"")){
			    		lineaLayout = "NumCert=\""+numCertificado+"\"";
			    	}
			    	strLayout = strLayout + lineaLayout.trim()+" ";
			    }
			}
			
			// GENERA SELLO
			sello = generarSello(strLayout,generaConstanciaRetencionBean);
			System.out.println("Sello: "+sello);
			if(sello.equals("")){
				smarterWebBeanWS.setNumero("3");
				smarterWebBeanWS.setMensaje("Error al generar valor para el campo Sello.");
				throw new Exception(smarterWebBeanWS.getMensaje());
			}
			
			lineasLayout = layout.split("\n");
			if(lineasLayout.length > 0){
				strLayout = "";
			    for (String lineaLayout: lineasLayout) {
			    	//AGREGA EL VALOR DEL CAMPO CERTIFICADO
			    	if(lineaLayout.trim().equals("Cert=\"\"")){
			    		lineaLayout = "Cert=\""+certificado+"\"";
			    	}
			    	//AGREGA EL VALOR DEL CAMPO NUMERO DE CERTIFICADO
			    	if(lineaLayout.trim().equals("NumCert=\"\"")){
			    		lineaLayout = "NumCert=\""+numCertificado+"\"";
			    	}
			    	//AGREGA EL VALOR DEL CAMPO SELLO
			    	if(lineaLayout.trim().equals("Sello=\"\"")){
			    		lineaLayout = "Sello=\""+sello+"\"";
			    	}
			    	strLayout = strLayout + lineaLayout.trim()+" ";
			    }
			    layout = strLayout;
			}
					    
			System.out.println("xmlRetencion: "+layout);

			// Inicia la petición SOAP
			SmartwebTimbradoRetencionesProxy proxy = new SmartwebTimbradoRetencionesProxy();
			try {
				proxy.setEndpoint(generaConstanciaRetencionBean.getUrlWSDL());
				String xmlRetencion=layout;
				String tokenAutenticacion = generaConstanciaRetencionBean.getTokenAcceso();
				String resp = "";
				resp = proxy.timbrarRetencionXMLV2(xmlRetencion, tokenAutenticacion);
			  
				this.soapResponse=resp;
			
				String cadenaXML = this.soapResponse;
				System.out.println("Respuesta "+cadenaXML);

				smarterWebBeanWS.strXml = cadenaXML ;
				

				smarterWebBeanWS.setNumero("0");
				smarterWebBeanWS.setMensaje("Timbrado realizado exitosamente");
					  
			}catch (Exception e) {
				System.out.println("Error Consumo WS: "+e.getMessage());

				this.error = true;
				wsresponse = e.getMessage().toString();
				response = "error";

				smarterWebBeanWS.setNumero("999");
				smarterWebBeanWS.setMensaje("Error en el Timbrado.");
			}			
			
		}catch (Exception e) {
			e.printStackTrace();

			smarterWebBeanWS.setNumero("999");
			smarterWebBeanWS.setMensaje("Error en el Timbrado.");
		}
		return smarterWebBeanWS;
	}
  

	public String timbrarFacturaSmarterWeb2(String layout) {
		System.out.println("MD1sm: layout: "+layout);
		String layoutAux = layout;

		File f = null;
		String linea, strLayout="", layoutb64="", wsresponse="Timbrado Exitoso", response = "exito";
		SOAPMessage soapResp;
		f = new File(layout);
		if (f.exists()) {
		  try {
		    BufferedReader buffer = new BufferedReader(new InputStreamReader(new FileInputStream(layout), "utf-8"));
		    while ((linea = buffer.readLine()) != null)   {
		      strLayout = strLayout + linea;
		    }
		  } catch(Exception ex) {return "Error al leer el layout";}
		  layout = strLayout;
		}
		System.out.println("MD2: layout: "+layout);
		// Convertir a base 64 el layout.
		try {
		  String ly = layout;
		  layoutb64 = Base64.encodeBase64String(ly.getBytes("UTF-8"));
		  //layoutb64 = new sun.misc.BASE64Encoder().encode(ly.getBytes("UTF-8"));  
		  System.out.println("MD3: layoutb64: "+layoutb64);
		}
		catch (Exception ex) { }

		// Inicia la petición SOAP
		try {
			SOAPConnectionFactory soapConnectionFactory = SOAPConnectionFactory.newInstance();
			SOAPConnection soapConnection = soapConnectionFactory.createConnection();
			// Enviar mensaje al servidor
			MessageFactory messageFactory = MessageFactory.newInstance();
			SOAPMessage soapMessage = messageFactory.createMessage();
			SOAPPart soapPart = soapMessage.getSOAPPart();
			SOAPEnvelope envelope = soapPart.getEnvelope();
			System.out.println("MD4: this.urlSOAP: "+this.urlSOAP);
			
			envelope.addNamespaceDeclaration("xmlns",this.urlSOAP);
			envelope.addNamespaceDeclaration("xmlns:tem=","http://tempuri.org/");
			SOAPBody soapBody = envelope.getBody();
			SOAPElement soapBodyElem  = 	soapBody.addChildElement("tem:TimbrarRetencionXMLV2","");
			SOAPElement soapBodyElem1 = soapBodyElem.addChildElement("tem:xmlRetencion");
			soapBodyElem1.addTextNode(layoutAux);
			SOAPElement soapBodyElem3 = soapBodyElem.addChildElement("tem:tokenAutenticacion");
			soapBodyElem3.addTextNode("T2lYQ0t4L0RHVkR4dHZ5Nkk1VHNEakZ3Y0J4Nk9GODZuRyt4cE1wVm5tbXB3YVZxTHdOdHAwVXY2NTdJb1hkREtXTzE3dk9pMmdMdkFDR2xFWFVPUXpTUm9mTG1ySXdZbFNja3FRa0RlYURqbzdzdlI2UUx1WGJiKzViUWY2dnZGbFloUDJ6RjhFTGF4M1BySnJ4cHF0YjUvbmRyWWpjTkVLN3ppd3RxL0dJPQ");
  
			MimeHeaders headers = soapMessage.getMimeHeaders();
			headers.addHeader("SOAPAction", "tem:TimbrarRetencionXMLV2");
			soapMessage.saveChanges();
			System.out.println("MD5: ");

			/* Dscomentar la siguiente linea si desea visualizar el request*/
			this.soapRequest=this.soapMessageToString(soapMessage);

			//System.out.println(soapConnection.call(soapMessage, this.urlSOAP));
			soapResp = soapConnection.call(soapMessage, this.urlSOAP);

			this.soapResponse=this.soapMessageToString(soapResp);
			soapConnection.close();


			String cadenaXML = this.soapResponse;
			System.out.println("Respuesta "+cadenaXML);
			DOMParser parser = new DOMParser();
			parser.parse(new InputSource(new java.io.StringReader(cadenaXML)));

			Document doc = parser.getDocument();

			if (doc.getElementsByTagName("SOAP-ENV:Fault").getLength() > 0) {
				NodeList nodeLst = doc.getElementsByTagName("SOAP-ENV:Body");
				for (int i = 0; i < nodeLst.getLength(); i++) {
					Element ele = (Element) nodeLst.item(i);

					NodeList nlsCode = ele.getElementsByTagName("faultcode");
					Element eleCode = (Element) nlsCode.item(0);
					String strCode = eleCode.getFirstChild().getNodeValue();

					NodeList nlsMessage = ele.getElementsByTagName("faultstring");
					Element eleMsg = (Element) nlsMessage.item(0);
					String strMessage = eleMsg.getFirstChild().getNodeValue();

					wsresponse = "Error: " + strCode + "\n";
					wsresponse = wsresponse + "Mensaje: " + strMessage;
					response = "error";
					this.error = true;
				}
			} else {
				if (this.generarCBB) {
					this.generarPDF = false;
				}
				NodeList nodeLst = doc.getElementsByTagName("ns1:requestTimbrarCFDIResponse");
				for (int i = 0; i < nodeLst.getLength(); i++) {
					Element ele = (Element) nodeLst.item(i);

					NodeList nlsxml = ele.getElementsByTagName("xml");
					Element elexml = (Element) nlsxml.item(0);
					this.strXml = elexml.getFirstChild().getNodeValue();

					if (this.generarPDF) {
						NodeList nlspdf = ele.getElementsByTagName("pdf");
						Element elepdf = (Element) nlspdf.item(0);
						this.strPdf = elepdf.getFirstChild().getNodeValue();
					}
					if (this.generarCBB) {
						NodeList nlscbb = ele.getElementsByTagName("png");
						Element elecbb = (Element) nlscbb.item(0);
						this.strCbb = elecbb.getFirstChild().getNodeValue();
					}
				}
			}
		}catch (Exception e) {
			this.error = true;
			wsresponse = e.getMessage().toString();
			response = "error";
		}
		return response;
	}
  

	public String soapMessageToString(SOAPMessage message){
		System.out.println("mensajje->>>" + message.toString());

		String result = null;
		if(message != null){
			ByteArrayOutputStream baos = null;
			try{
				baos = new ByteArrayOutputStream();
				message.writeTo(baos);
				result = baos.toString();
				System.out.println("Peticion->>>" + result);
			}catch(Exception e){
			}finally{
				if(baos != null){
					try{
						baos.close();
					}catch(IOException ioe){
					}
				}
      		}
		}
		return result;
	}  
	
	// GENERA EL VALOR DEL CERTIFICADO CONVRTIDO A BASE64
	public String generarCertificadoBase64(String rutaArchivo,String nombreArchivo){
		String certificadoBase64 = "";
		File originalFile = new File(rutaArchivo + nombreArchivo);
		try {
			FileInputStream fileInputStreamReader = new FileInputStream(originalFile);
			byte[] bytes = new byte[(int)originalFile.length()];
			fileInputStreamReader.read(bytes);
			Base64 base64 = new Base64 ();
			certificadoBase64 = new String(base64.encode(bytes));
			fileInputStreamReader.close();
		} catch (FileNotFoundException e) {
			certificadoBase64 = "";
			e.printStackTrace();
		} catch (IOException e) {
			certificadoBase64 = "";
			e.printStackTrace();
		}
		return certificadoBase64;
	} 
	
	// GENERA EL VALOR DEL NUMERO DE CERTIFICADO 
	public String generarNumCertificado(String rutaArchivo,String nombreArchivo){
		String numCert = "";
		try{
			InputStream is = new FileInputStream(rutaArchivo+nombreArchivo);
	        CertificateFactory cf = CertificateFactory.getInstance("X.509");
	        X509Certificate certificado = (X509Certificate)cf.generateCertificate(is);
	        byte[] byteArray= certificado.getSerialNumber().toByteArray();
	        numCert = new String(byteArray);
			
		}catch(Exception e){
			e.printStackTrace();
		}
        
		return numCert;
	}
	
	// GENERA SELLO CERTIFICADO 
	public String generarSello(String xml,GeneraConstanciaRetencionBean generaConstanciaRetencionBean){
		String sello = "";
		String cadenaOriginal = "";
		String rutaArchivoXSLT = generaConstanciaRetencionBean.getRutaArchivosXSLT();
		try{
			// OBTENEMOS CADENA ORIGINAL
			 // cargar el archivo XSLT
	        File xslt = new File(rutaArchivoXSLT);
	        StreamSource sourceXSL = new StreamSource(xslt);
	 
	        File cfdi = new File(generaConstanciaRetencionBean.getRutaXML()+generaConstanciaRetencionBean.getAnioProceso()+"/"+Utileria.completaCerosIzquierda(generaConstanciaRetencionBean.getSucursal(), 3) +"/"+ Utileria.completaCerosIzquierda(generaConstanciaRetencionBean.getClienteID(),10)+"-"+generaConstanciaRetencionBean.getAnioProceso()+".xml" );
			FileWriter escribir = new FileWriter(cfdi);
			escribir.write(xml);
			escribir.close();
			
	        // cargar el CFDI
	        StreamSource sourceXML = new StreamSource(cfdi);
	 
	        // crear el procesador XSLT que nos ayudará a generar la cadena original
	        // con base en las reglas del archivo XSLT
	        TransformerFactory tFactory = TransformerFactory.newInstance();
	        Transformer transformer = tFactory.newTransformer(sourceXSL);
	 
	        StringWriter str = new StringWriter();

	        // aplicar las reglas del XSLT con los datos del CFDI y escribir el resultado en output
	        transformer.transform(sourceXML, new StreamResult(str));
	        cadenaOriginal = str.toString();
	        System.out.println("Cadena original : "+cadenaOriginal);
	        
	        // ARCHIVO QUE CONTIENE LA LLAVE PRIVADA
	        FileInputStream fin = null;
	        fin = new FileInputStream (generaConstanciaRetencionBean.getRutaArchivosCertificado()+generaConstanciaRetencionBean.getNombreLlavePriv());
            PKCS8Key pkcs8 = new PKCS8Key(fin, generaConstanciaRetencionBean.getPassCertificado().toCharArray());
           
            //obtiene clave privada
            java.security.PrivateKey pk = pkcs8.getPrivateKey();
            Signature firma;
           
            firma = Signature.getInstance("SHA1withRSA");           
            firma.initSign(pk);
           
            //pasamos firma original
            firma.update(cadenaOriginal.getBytes("UTF-8"));
           
            //cadena encriptada
            byte[] cadenaFirmada = firma.sign();
           
            //sello digital
            sello = new String(Base64.encodeBase64(cadenaFirmada));
			
		}catch(Exception e){
			e.printStackTrace();
		}
        
		return sello;
	}
	
	// Metodos para configurar los parametros de conexión
	public void setUrlTimbrado(String url) {
		this.urlSOAP = url;
	}
	public void setUserId(String user) {
		this.userId = user;
	}
	public void setUserPass(String pass) {
		this.userPass = pass;
	}
	public void setRfcEmisor(String rfc) {
		this.rfcEmisor = rfc;
	}
	public void setGenerarPDF(boolean pdf) {
		this.generarPDF = pdf;
	}
	public void setGenerarCBB(boolean cbb) {
		this.generarCBB = cbb;
	}

	public String getNumero() {
		return numero;
	}

	public void setNumero(String numero) {
		this.numero = numero;
	}

	public String getMensaje() {
		return mensaje;
	}

	public void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}
}
