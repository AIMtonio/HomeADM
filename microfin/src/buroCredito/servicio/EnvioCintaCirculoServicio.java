package buroCredito.servicio;

import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.File;
import java.io.FileOutputStream;
import java.util.Arrays;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.xml.stream.XMLEventFactory;
import javax.xml.stream.XMLEventWriter;
import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.events.Attribute;
import javax.xml.stream.events.Characters;
import javax.xml.stream.events.EndElement;
import javax.xml.stream.events.StartDocument;
import javax.xml.stream.events.StartElement;

import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import sms.servicio.SMSEnvioMensajeServicio;
import soporte.PropiedadesBuroCreditoBean;
import soporte.bean.ParametrosSisBean;
import soporte.dao.ParametrosSisDAO;
import soporte.servicio.ParametrosSisServicio;
import buroCredito.bean.EnvioCintaCirculoBean;
import buroCredito.dao.EnvioCintaCirculoDAO;

public class EnvioCintaCirculoServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	EnvioCintaCirculoDAO envioCintaCirculoDAO = null;
	SMSEnvioMensajeServicio smsEnvioMensajeServicio = null;
	ParametrosSesionBean parametrosSesionBean = null;
	ParametrosSisDAO parametrosSisDAO = null;
	
	
	public EnvioCintaCirculoServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	// Metodo que Crea la Cinta de Consulta para el envío a Circulo de Crédito
	//Este proceso arma el XML con la información de los Creditos y lo guarda en Cierta ruta del Servidor
	//Como evidencia de su generación y para que sea consultado y exportado desde esa ruta
	//Devuelve un String con la ruta donde guardo el Archivo, de otra forma devuele un string "vacio"
	public String generaArchivoEnvioCirculoCredito(EnvioCintaCirculoBean cintaCirculoBean){
 		
		String origenDatos =  parametrosSesionBean.getOrigenDatos();
		origenDatos = origenDatos+".";
		PropiedadesBuroCreditoBean.cargaPropiedadesBuroCredito();
		String fechaConsulta = formatoFecha(cintaCirculoBean.getFechaConsulta());
		String claveOtorgante = PropiedadesBuroCreditoBean.propiedadesBuroCredito.getProperty(origenDatos+"NumeroInstitucionCirculo");
		String nombreOtorgante = PropiedadesBuroCreditoBean.propiedadesBuroCredito.getProperty(origenDatos+"NombreOtorganteCirculo");
		String configFile = PropiedadesBuroCreditoBean.propiedadesBuroCredito.getProperty(origenDatos+"RutaArchivoEnvioCirculo") + 
							claveOtorgante + "_" + nombreOtorgante + "_" +  fechaConsulta + ".xml";

		

		String directorio = PropiedadesBuroCreditoBean.propiedadesBuroCredito.getProperty(origenDatos+"RutaArchivoEnvioCirculo");
		boolean exists = (new File(directorio)).exists();
		if (!exists) {
			File aDir = new File(directorio);
			aDir.mkdirs();
		}	
		String nombreArchivo = claveOtorgante + "_" + nombreOtorgante + "_" +  fechaConsulta + ".xml";

		try {
			XMLOutputFactory outputFactory = XMLOutputFactory.newInstance();
			XMLEventWriter eventWriter = outputFactory.createXMLEventWriter(new FileOutputStream(configFile), "ISO-8859-1");
			XMLEventFactory eventFactory = XMLEventFactory.newInstance();

			// create and write Start Tag
			StartDocument startDocument = eventFactory.createStartDocument();
			eventWriter.add(startDocument);
			
			// create config open tag
			Attribute[] atributos = new Attribute[2]; 
			Attribute nameSapeceAtt = eventFactory.createAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
			Attribute schemaAtt = eventFactory.createAttribute("xsi:noNamespaceSchemaLocation", "/Carga.xsd;");
			atributos[0] = nameSapeceAtt; 
			atributos[1] = schemaAtt; 
			
		    List attributeList = Arrays.asList(atributos);
		    List nsList = Arrays.asList();
		    
			StartElement cargaElement = eventFactory.createStartElement("",  "", "Carga",attributeList.iterator(), nsList.iterator());
			eventWriter.add(cargaElement);
			//Crea el Elemento Encabezado y sus Nodos
			creaEncabezado(eventFactory, eventWriter,fechaConsulta, origenDatos);
			//Crea el Elemento Personas(Datos de la Cartera)
			creaElementoPersonas(eventFactory, eventWriter, cintaCirculoBean,claveOtorgante, nombreOtorgante);
			//Crea el Elemento Raiz de "Carga"
			eventWriter.add(eventFactory.createEndElement("", "", "Carga"));
			eventWriter.add(eventFactory.createEndDocument());
			eventWriter.close();
			
		} catch (Exception e) {			
			e.printStackTrace();
			configFile = Constantes.STRING_VACIO;
			nombreArchivo = Constantes.STRING_VACIO;
		} 		
		return nombreArchivo ;
	}

	  private void creaEncabezado(XMLEventFactory eventFactory, XMLEventWriter eventWriter, String fechaConsulta, String origenDatos)
				throws XMLStreamException {

		PropiedadesBuroCreditoBean.cargaPropiedadesBuroCredito();
		abreElemento(eventFactory, eventWriter, "Encabezado");
		creaNodo(eventFactory, eventWriter, "ClaveOtorgante", PropiedadesBuroCreditoBean.propiedadesBuroCredito.getProperty(origenDatos+"NumeroInstitucionCirculo"));
		creaNodo(eventFactory, eventWriter, "NombreOtorgante", PropiedadesBuroCreditoBean.propiedadesBuroCredito.getProperty(origenDatos+"NombreOtorganteCirculo"));
		creaNodo(eventFactory, eventWriter, "IdentificadorDeMedio", "");
		creaNodo(eventFactory, eventWriter, "FechaExtraccion", fechaConsulta);
		creaNodo(eventFactory, eventWriter, "NotaOtorgante", "");
		creaNodo(eventFactory, eventWriter, "Version", "4");
		cierraElemento(eventFactory, eventWriter, "Encabezado");
		
	  }
	
	  private void creaNodo(XMLEventFactory eventFactory, XMLEventWriter eventWriter, String name, String value) throws XMLStreamException {

		    // create Start node
		    StartElement sElement = eventFactory.createStartElement("", "", name);
		    //eventWriter.add(tab);
		    eventWriter.add(sElement);
		    // create Content
		    Characters characters = eventFactory.createCharacters(value);
		    eventWriter.add(characters);
		    // create End node
		    EndElement eElement = eventFactory.createEndElement("", "", name);
		    eventWriter.add(eElement);
		    
		    //eventWriter.add(end);

	  }
	  
	  private void abreElemento(XMLEventFactory eventFactory, XMLEventWriter eventWriter, String name) throws XMLStreamException {
		    StartElement sElement = eventFactory.createStartElement("", "", name);
		    eventWriter.add(sElement);		  
	  }

	  private void cierraElemento(XMLEventFactory eventFactory, XMLEventWriter eventWriter, String name) throws XMLStreamException {
		  // create End node
		  EndElement eElement = eventFactory.createEndElement("", "", name);
		  eventWriter.add(eElement);		  
	  }
	  
	  private void creaElementoPersonas(XMLEventFactory eventFactory, XMLEventWriter eventWriter,
			  							EnvioCintaCirculoBean cintaCirculoBean, String claveOtorgante,
			  							String nombreOtorgante) throws Exception {
		  abreElemento(eventFactory, eventWriter, "Personas");
		  consultaCartera(eventFactory, eventWriter, cintaCirculoBean, claveOtorgante, nombreOtorgante);
	  }
	  
	  private void creaElementoPersonasVtaCar(XMLEventFactory eventFactory, XMLEventWriter eventWriter,
				EnvioCintaCirculoBean cintaCirculoBean, String claveOtorgante,
				String nombreOtorgante) throws Exception {
				abreElemento(eventFactory, eventWriter, "Personas");
				consultaCarteraVtaCar(eventFactory, eventWriter, cintaCirculoBean, claveOtorgante, nombreOtorgante);
	  }
	  
	  private void consultaCartera(XMLEventFactory eventFactory, XMLEventWriter eventWriter,
			  						EnvioCintaCirculoBean cintaCirculoBean, String claveOtorgante,
			  						String nombreOtorgante) throws Exception{
		  			  		  
		  List listaResultado = envioCintaCirculoDAO.consultaCintaEnvio(cintaCirculoBean);
		  EnvioCintaCirculoBean envioCintaCirculoBean;
		  String sumatoriaSaldos = Constantes.STRING_VACIO;
		  String sumatoriaSaldosVencidos = Constantes.STRING_VACIO;
		  String numeroElementosReportados = Constantes.STRING_VACIO;
		  String domicilioMatriz = Constantes.STRING_VACIO;
		  
		  for(int i = 0; i<listaResultado.size(); i++){
			  envioCintaCirculoBean = (EnvioCintaCirculoBean)listaResultado.get(i);
			  
			  if(i == 0){
				  sumatoriaSaldos = envioCintaCirculoBean.getSumaSaldosTotales();
				  sumatoriaSaldosVencidos = envioCintaCirculoBean.getSumaSaldosVencidos();
				  numeroElementosReportados = envioCintaCirculoBean.getNumeroElementos();
				  domicilioMatriz = envioCintaCirculoBean.getDireccionMatriz();
				  
			  }
			  			  
			  abreElemento(eventFactory, eventWriter, "Persona");
			  abreElemento(eventFactory, eventWriter, "Nombre");
			  creaNodo(eventFactory, eventWriter, "ApellidoPaterno", envioCintaCirculoBean.getApellidoPaterno());
			  creaNodo(eventFactory, eventWriter, "ApellidoMaterno", envioCintaCirculoBean.getApellidoMaterno());
			  creaNodo(eventFactory, eventWriter, "ApellidoAdicional", envioCintaCirculoBean.getApellidoAdicional());
			  creaNodo(eventFactory, eventWriter, "Nombres", envioCintaCirculoBean.getNombre());
			  creaNodo(eventFactory, eventWriter, "FechaNacimiento", formatoFecha(envioCintaCirculoBean.getFechaNacimiento()));
			  creaNodo(eventFactory, eventWriter, "RFC", envioCintaCirculoBean.getRfc());
			  creaNodo(eventFactory, eventWriter, "CURP", envioCintaCirculoBean.getCurp());
			  creaNodo(eventFactory, eventWriter, "NumeroSeguridadSocial", Constantes.STRING_VACIO);
			  creaNodo(eventFactory, eventWriter, "Nacionalidad", envioCintaCirculoBean.getNacionalidad());
			  creaNodo(eventFactory, eventWriter, "Residencia", envioCintaCirculoBean.getTipoResidencia());			  
			  creaNodo(eventFactory, eventWriter, "NumeroLicenciaConducir", envioCintaCirculoBean.getNumeroLicenciaConducir());
			  creaNodo(eventFactory, eventWriter, "EstadoCivil", envioCintaCirculoBean.getEstadoCivil());
			  creaNodo(eventFactory, eventWriter, "Sexo", envioCintaCirculoBean.getSexo());
			  creaNodo(eventFactory, eventWriter, "ClaveElectorIFE", envioCintaCirculoBean.getClaveIFE());
			  creaNodo(eventFactory, eventWriter, "NumeroDependientes", envioCintaCirculoBean.getNumeroDependientes());
			  creaNodo(eventFactory, eventWriter, "FechaDefuncion",envioCintaCirculoBean.getFechaDefuncion());
			  creaNodo(eventFactory, eventWriter, "IndicadorDefuncion", envioCintaCirculoBean.getIndicadorDefuncion());			  
			  creaNodo(eventFactory, eventWriter, "TipoPersona", envioCintaCirculoBean.getTipoPersona());
			  cierraElemento(eventFactory, eventWriter, "Nombre");
			  
			  abreElemento(eventFactory, eventWriter, "Domicilios");
			  abreElemento(eventFactory, eventWriter, "Domicilio");
			  creaNodo(eventFactory, eventWriter, "Direccion", envioCintaCirculoBean.getCalleYNumero());
			  creaNodo(eventFactory, eventWriter, "ColoniaPoblacion", envioCintaCirculoBean.getColonia());
			  creaNodo(eventFactory, eventWriter, "DelegacionMunicipio", envioCintaCirculoBean.getMunicipio());
			  creaNodo(eventFactory, eventWriter, "Ciudad", envioCintaCirculoBean.getMunicipio());			  
			  creaNodo(eventFactory, eventWriter, "Estado", envioCintaCirculoBean.getEstado());
			  creaNodo(eventFactory, eventWriter, "CP", envioCintaCirculoBean.getCodigoPostal());
			  creaNodo(eventFactory, eventWriter, "FechaResidencia", Constantes.STRING_VACIO);
			  creaNodo(eventFactory, eventWriter, "NumeroTelefono", envioCintaCirculoBean.getTelefonoDom());
			  creaNodo(eventFactory, eventWriter, "TipoDomicilio", envioCintaCirculoBean.getTipoDomicilio());
			  creaNodo(eventFactory, eventWriter, "TipoAsentamiento", envioCintaCirculoBean.getTipoAsentamiento());
			  creaNodo(eventFactory, eventWriter, "OrigenDomicilio",envioCintaCirculoBean.getOrigenDomicilio());
			  cierraElemento(eventFactory, eventWriter, "Domicilio");
			  cierraElemento(eventFactory, eventWriter, "Domicilios");
			  
			  abreElemento(eventFactory, eventWriter, "Empleos");
			  abreElemento(eventFactory, eventWriter, "Empleo");
			  creaNodo(eventFactory, eventWriter, "NombreEmpresa", envioCintaCirculoBean.getCentroTrabajo());
			  creaNodo(eventFactory, eventWriter, "Direccion", envioCintaCirculoBean.getCalleYNumeroTra());
			  creaNodo(eventFactory, eventWriter, "ColoniaPoblacion", envioCintaCirculoBean.getColoniaTra());
			  creaNodo(eventFactory, eventWriter, "DelegacionMunicipio", envioCintaCirculoBean.getMunicipioTra());
			  creaNodo(eventFactory, eventWriter, "Ciudad", envioCintaCirculoBean.getMunicipioTra());
			  creaNodo(eventFactory, eventWriter, "Estado", envioCintaCirculoBean.getEstadoTra());
			  creaNodo(eventFactory, eventWriter, "CP", envioCintaCirculoBean.getCodigoPostalTra());
			  creaNodo(eventFactory, eventWriter, "NumeroTelefono", envioCintaCirculoBean.getTelefonoTra());
			  creaNodo(eventFactory, eventWriter, "Extension", Constantes.STRING_VACIO);
			  creaNodo(eventFactory, eventWriter, "Fax", Constantes.STRING_VACIO);			  
			  creaNodo(eventFactory, eventWriter, "Puesto", envioCintaCirculoBean.getPuestoTra());			  
			  creaNodo(eventFactory, eventWriter, "FechaContratacion", envioCintaCirculoBean.getFechaIngreso());
			  creaNodo(eventFactory, eventWriter, "ClaveMoneda", Constantes.STRING_VACIO);
			  creaNodo(eventFactory, eventWriter, "SalarioMensual", envioCintaCirculoBean.getMontoSal());
			  creaNodo(eventFactory, eventWriter, "FechaUltimoDiaEmpleo", Constantes.STRING_VACIO);
			  creaNodo(eventFactory, eventWriter, "FechaVerificacionEmpleo", Constantes.STRING_VACIO);
			  creaNodo(eventFactory, eventWriter, "OrigenRazonSocialDomicilio",envioCintaCirculoBean.getRazonSocialDomicilio());
			  cierraElemento(eventFactory, eventWriter, "Empleo");
			  cierraElemento(eventFactory, eventWriter, "Empleos");
			  
			  abreElemento(eventFactory, eventWriter, "Cuenta");
			  creaNodo(eventFactory, eventWriter, "ClaveActualOtorgante", claveOtorgante);
			  creaNodo(eventFactory, eventWriter, "NombreOtorgante", nombreOtorgante);
			  creaNodo(eventFactory, eventWriter, "CuentaActual", envioCintaCirculoBean.getCreditoID());
			  creaNodo(eventFactory, eventWriter, "TipoResponsabilidad", envioCintaCirculoBean.getTipoRespons());
			  creaNodo(eventFactory, eventWriter, "TipoCuenta", envioCintaCirculoBean.getTipoCuenta());
			  creaNodo(eventFactory, eventWriter, "TipoContrato", envioCintaCirculoBean.getTipoContrato());
			  creaNodo(eventFactory, eventWriter, "ClaveUnidadMonetaria", envioCintaCirculoBean.getMoneda());
			  creaNodo(eventFactory, eventWriter, "ValorActivoValuacion", envioCintaCirculoBean.getValorActivoValuacion());
			  creaNodo(eventFactory, eventWriter, "NumeroPagos", envioCintaCirculoBean.getNumAmortizaciones());
			  creaNodo(eventFactory, eventWriter, "FrecuenciaPagos", envioCintaCirculoBean.getFrecuenciaPago());
			  creaNodo(eventFactory, eventWriter, "MontoPagar", envioCintaCirculoBean.getMontoPagar());
			  creaNodo(eventFactory, eventWriter, "FechaAperturaCuenta", formatoFecha(envioCintaCirculoBean.getFechaInicio()));
			  creaNodo(eventFactory, eventWriter, "FechaUltimoPago", formatoFecha(envioCintaCirculoBean.getFechaUltPago()));
			  creaNodo(eventFactory, eventWriter, "FechaUltimaCompra", formatoFecha(envioCintaCirculoBean.getFechaInicio()));			  
			  creaNodo(eventFactory, eventWriter, "FechaCierreCuenta", formatoFecha(envioCintaCirculoBean.getFechaCierre()));			  
			  creaNodo(eventFactory, eventWriter, "FechaCorte", formatoFecha(cintaCirculoBean.getFechaConsulta()));			  
			  creaNodo(eventFactory, eventWriter, "Garantia", Constantes.STRING_VACIO);
			  creaNodo(eventFactory, eventWriter, "CreditoMaximo", envioCintaCirculoBean.getCreditoMaximo());
			  creaNodo(eventFactory, eventWriter, "SaldoActual", envioCintaCirculoBean.getTotalDeuda());
			  creaNodo(eventFactory, eventWriter, "LimiteCredito", Constantes.STRING_CERO);
			  creaNodo(eventFactory, eventWriter, "SaldoVencido", envioCintaCirculoBean.getTotalVencido());
			  creaNodo(eventFactory, eventWriter, "NumeroPagosVencidos", envioCintaCirculoBean.getNumeroCuotasAtraso());
			  creaNodo(eventFactory, eventWriter, "PagoActual", envioCintaCirculoBean.getPagoActual());			  
			  creaNodo(eventFactory, eventWriter, "HistoricoPagos", envioCintaCirculoBean.getHistoricoPagos());
			  creaNodo(eventFactory, eventWriter, "ClavePrevencion", envioCintaCirculoBean.getClavePrevencion());
			  creaNodo(eventFactory, eventWriter, "TotalPagosReportados", envioCintaCirculoBean.getNumeroPagosEfectuados());
			  creaNodo(eventFactory, eventWriter, "ClaveAnteriorOtorgante", Constantes.STRING_VACIO);
			  creaNodo(eventFactory, eventWriter, "NombreAnteriorOtorgante", Constantes.STRING_VACIO);
			  creaNodo(eventFactory, eventWriter, "NumeroCuentaAnterior", envioCintaCirculoBean.getNumeroCreditoAnterior());
			  creaNodo(eventFactory, eventWriter, "FechaPrimerIncumplimiento", envioCintaCirculoBean.getFechaPrimIncumplimiento());
			  creaNodo(eventFactory, eventWriter, "SaldoInsoluto", envioCintaCirculoBean.getTotalCapital());
			  creaNodo(eventFactory, eventWriter, "MontoUltimoPago", envioCintaCirculoBean.getMontoUltimoPago());
			  creaNodo(eventFactory, eventWriter, "FechaIngresoCarteraVencida",formatoFecha(envioCintaCirculoBean.getFechaCarteraVencida()));
			  creaNodo(eventFactory, eventWriter, "MontoCorrespondienteIntereses",envioCintaCirculoBean.getTotalInteres());
			  creaNodo(eventFactory, eventWriter, "FormaPagoActualIntereses",envioCintaCirculoBean.getFormaPagoInteres());
			  creaNodo(eventFactory, eventWriter, "DiasVencimiento",envioCintaCirculoBean.getDiasVencidos());
			  creaNodo(eventFactory, eventWriter, "PlazoMeses", envioCintaCirculoBean.getPlazoMeses());
			  creaNodo(eventFactory, eventWriter, "MontoCreditoOriginacion", envioCintaCirculoBean.getMontoCreditoOrig());
			  creaNodo(eventFactory, eventWriter, "CorreoElectronicoConsumidor",envioCintaCirculoBean.getCorreoElectronico());
			  cierraElemento(eventFactory, eventWriter, "Cuenta");
			  cierraElemento(eventFactory, eventWriter, "Persona");
			  
		  } //Cierre del For 
		  
		  cierraElemento(eventFactory, eventWriter, "Personas");

		  //Cifras de Control
		  abreElemento(eventFactory, eventWriter, "CifrasControl");
		  creaNodo(eventFactory, eventWriter, "TotalSaldosActuales", sumatoriaSaldos);
		  creaNodo(eventFactory, eventWriter, "TotalSaldosVencidos", sumatoriaSaldosVencidos);
		  creaNodo(eventFactory, eventWriter, "TotalElementosNombreReportados", numeroElementosReportados);
		  creaNodo(eventFactory, eventWriter, "TotalElementosDireccionReportados", numeroElementosReportados);
		  creaNodo(eventFactory, eventWriter, "TotalElementosEmpleoReportados", numeroElementosReportados);
		  creaNodo(eventFactory, eventWriter, "TotalElementosCuentaReportados", numeroElementosReportados);
		  creaNodo(eventFactory, eventWriter, "NombreOtorgante", nombreOtorgante);
		  creaNodo(eventFactory, eventWriter, "DomicilioDevolucion", domicilioMatriz);
		  cierraElemento(eventFactory, eventWriter, "CifrasControl");
		
	  }
	  
	  private void consultaCarteraVtaCar(XMLEventFactory eventFactory, XMLEventWriter eventWriter,
				EnvioCintaCirculoBean cintaCirculoBean, String claveOtorgante,
				String nombreOtorgante) throws Exception{
		  		  
		List listaResultado = envioCintaCirculoDAO.consultaCintaEnvioVtaCar(cintaCirculoBean);
		EnvioCintaCirculoBean envioCintaCirculoBean;
		String sumatoriaSaldos = Constantes.STRING_VACIO;
		String sumatoriaSaldosVencidos = Constantes.STRING_VACIO;
		String numeroElementosReportados = Constantes.STRING_VACIO;
		String domicilioMatriz = Constantes.STRING_VACIO;
		
		for(int i = 0; i<listaResultado.size(); i++){
		envioCintaCirculoBean = (EnvioCintaCirculoBean)listaResultado.get(i);
		
		if(i == 0){
		sumatoriaSaldos = envioCintaCirculoBean.getSumaSaldosTotales();
		sumatoriaSaldosVencidos = envioCintaCirculoBean.getSumaSaldosVencidos();
		numeroElementosReportados = envioCintaCirculoBean.getNumeroElementos();
		domicilioMatriz = envioCintaCirculoBean.getDireccionMatriz();
		
		}
			  
		abreElemento(eventFactory, eventWriter, "Persona");
		abreElemento(eventFactory, eventWriter, "Nombre");
		creaNodo(eventFactory, eventWriter, "ApellidoPaterno", envioCintaCirculoBean.getApellidoPaterno());
		creaNodo(eventFactory, eventWriter, "ApellidoMaterno", envioCintaCirculoBean.getApellidoMaterno());
		creaNodo(eventFactory, eventWriter, "ApellidoAdicional", envioCintaCirculoBean.getApellidoAdicional());
		creaNodo(eventFactory, eventWriter, "Nombres", envioCintaCirculoBean.getNombre());
		creaNodo(eventFactory, eventWriter, "FechaNacimiento", formatoFecha(envioCintaCirculoBean.getFechaNacimiento()));
		creaNodo(eventFactory, eventWriter, "RFC", envioCintaCirculoBean.getRfc());
		creaNodo(eventFactory, eventWriter, "CURP", envioCintaCirculoBean.getCurp());
		creaNodo(eventFactory, eventWriter, "NumeroSeguridadSocial", Constantes.STRING_VACIO);
		creaNodo(eventFactory, eventWriter, "Nacionalidad", envioCintaCirculoBean.getNacionalidad());
		creaNodo(eventFactory, eventWriter, "Residencia", envioCintaCirculoBean.getTipoResidencia());			  
		creaNodo(eventFactory, eventWriter, "NumeroLicenciaConducir", envioCintaCirculoBean.getNumeroLicenciaConducir());
		creaNodo(eventFactory, eventWriter, "EstadoCivil", envioCintaCirculoBean.getEstadoCivil());
		creaNodo(eventFactory, eventWriter, "Sexo", envioCintaCirculoBean.getSexo());
		creaNodo(eventFactory, eventWriter, "ClaveElectorIFE", envioCintaCirculoBean.getClaveIFE());
		creaNodo(eventFactory, eventWriter, "NumeroDependientes", envioCintaCirculoBean.getNumeroDependientes());
		creaNodo(eventFactory, eventWriter, "FechaDefuncion",envioCintaCirculoBean.getFechaDefuncion());
		creaNodo(eventFactory, eventWriter, "IndicadorDefuncion", envioCintaCirculoBean.getIndicadorDefuncion());			  
		creaNodo(eventFactory, eventWriter, "TipoPersona", envioCintaCirculoBean.getTipoPersona());
		cierraElemento(eventFactory, eventWriter, "Nombre");
		
		abreElemento(eventFactory, eventWriter, "Domicilios");
		abreElemento(eventFactory, eventWriter, "Domicilio");
		creaNodo(eventFactory, eventWriter, "Direccion", envioCintaCirculoBean.getCalleYNumero());
		creaNodo(eventFactory, eventWriter, "ColoniaPoblacion", envioCintaCirculoBean.getColonia());
		creaNodo(eventFactory, eventWriter, "DelegacionMunicipio", envioCintaCirculoBean.getMunicipio());
		creaNodo(eventFactory, eventWriter, "Ciudad", envioCintaCirculoBean.getMunicipio());			  
		creaNodo(eventFactory, eventWriter, "Estado", envioCintaCirculoBean.getEstado());
		creaNodo(eventFactory, eventWriter, "CP", envioCintaCirculoBean.getCodigoPostal());
		creaNodo(eventFactory, eventWriter, "FechaResidencia", Constantes.STRING_VACIO);
		creaNodo(eventFactory, eventWriter, "NumeroTelefono", envioCintaCirculoBean.getTelefonoDom());
		creaNodo(eventFactory, eventWriter, "TipoDomicilio", envioCintaCirculoBean.getTipoDomicilio());
		creaNodo(eventFactory, eventWriter, "TipoAsentamiento", envioCintaCirculoBean.getTipoAsentamiento());
		creaNodo(eventFactory, eventWriter, "OrigenDomicilio",envioCintaCirculoBean.getOrigenDomicilio());
		cierraElemento(eventFactory, eventWriter, "Domicilio");
		cierraElemento(eventFactory, eventWriter, "Domicilios");
		
		abreElemento(eventFactory, eventWriter, "Empleos");
		abreElemento(eventFactory, eventWriter, "Empleo");
		creaNodo(eventFactory, eventWriter, "NombreEmpresa", envioCintaCirculoBean.getCentroTrabajo());
		creaNodo(eventFactory, eventWriter, "Direccion", envioCintaCirculoBean.getCalleYNumeroTra());
		creaNodo(eventFactory, eventWriter, "ColoniaPoblacion", envioCintaCirculoBean.getColoniaTra());
		creaNodo(eventFactory, eventWriter, "DelegacionMunicipio", envioCintaCirculoBean.getMunicipioTra());
		creaNodo(eventFactory, eventWriter, "Ciudad", envioCintaCirculoBean.getMunicipioTra());
		creaNodo(eventFactory, eventWriter, "Estado", envioCintaCirculoBean.getEstadoTra());
		creaNodo(eventFactory, eventWriter, "CP", envioCintaCirculoBean.getCodigoPostalTra());
		creaNodo(eventFactory, eventWriter, "NumeroTelefono", envioCintaCirculoBean.getTelefonoTra());
		creaNodo(eventFactory, eventWriter, "Extension", Constantes.STRING_VACIO);
		creaNodo(eventFactory, eventWriter, "Fax", Constantes.STRING_VACIO);			  
		creaNodo(eventFactory, eventWriter, "Puesto", envioCintaCirculoBean.getPuestoTra());			  
		creaNodo(eventFactory, eventWriter, "FechaContratacion", Constantes.STRING_VACIO);
		creaNodo(eventFactory, eventWriter, "ClaveMoneda", Constantes.STRING_VACIO);
		creaNodo(eventFactory, eventWriter, "SalarioMensual", Constantes.STRING_VACIO);
		creaNodo(eventFactory, eventWriter, "FechaUltimoDiaEmpleo", Constantes.STRING_VACIO);
		creaNodo(eventFactory, eventWriter, "FechaVerificacionEmpleo", Constantes.STRING_VACIO);
		creaNodo(eventFactory, eventWriter, "OrigenRazonSocialDomicilio",envioCintaCirculoBean.getRazonSocialDomicilio());
		cierraElemento(eventFactory, eventWriter, "Empleo");
		cierraElemento(eventFactory, eventWriter, "Empleos");
		
		abreElemento(eventFactory, eventWriter, "Cuenta");
		creaNodo(eventFactory, eventWriter, "ClaveActualOtorgante", claveOtorgante);
		creaNodo(eventFactory, eventWriter, "NombreOtorgante", nombreOtorgante);
		creaNodo(eventFactory, eventWriter, "CuentaActual", envioCintaCirculoBean.getCreditoID());
		creaNodo(eventFactory, eventWriter, "TipoResponsabilidad", envioCintaCirculoBean.getTipoRespons());
		creaNodo(eventFactory, eventWriter, "TipoCuenta", envioCintaCirculoBean.getTipoCuenta());
		creaNodo(eventFactory, eventWriter, "TipoContrato", envioCintaCirculoBean.getTipoContrato());
		creaNodo(eventFactory, eventWriter, "ClaveUnidadMonetaria", envioCintaCirculoBean.getMoneda());
		creaNodo(eventFactory, eventWriter, "ValorActivoValuacion", envioCintaCirculoBean.getValorActivoValuacion());
		creaNodo(eventFactory, eventWriter, "NumeroPagos", envioCintaCirculoBean.getNumAmortizaciones());
		creaNodo(eventFactory, eventWriter, "FrecuenciaPagos", envioCintaCirculoBean.getFrecuenciaPago());
		creaNodo(eventFactory, eventWriter, "MontoPagar", envioCintaCirculoBean.getMontoPagar());
		creaNodo(eventFactory, eventWriter, "FechaAperturaCuenta", formatoFecha(envioCintaCirculoBean.getFechaInicio()));
		creaNodo(eventFactory, eventWriter, "FechaUltimoPago", formatoFecha(envioCintaCirculoBean.getFechaUltPago()));
		creaNodo(eventFactory, eventWriter, "FechaUltimaCompra", formatoFecha(envioCintaCirculoBean.getFechaInicio()));			  
		creaNodo(eventFactory, eventWriter, "FechaCierreCuenta", envioCintaCirculoBean.getFechaCierre());			  
		creaNodo(eventFactory, eventWriter, "FechaCorte", formatoFecha(cintaCirculoBean.getFechaConsulta()));			  
		creaNodo(eventFactory, eventWriter, "Garantia", Constantes.STRING_VACIO);
		creaNodo(eventFactory, eventWriter, "CreditoMaximo", envioCintaCirculoBean.getCreditoMaximo());
		creaNodo(eventFactory, eventWriter, "SaldoActual", envioCintaCirculoBean.getTotalDeuda());
		creaNodo(eventFactory, eventWriter, "LimiteCredito", Constantes.STRING_CERO);
		creaNodo(eventFactory, eventWriter, "SaldoVencido", envioCintaCirculoBean.getTotalVencido());
		creaNodo(eventFactory, eventWriter, "NumeroPagosVencidos", envioCintaCirculoBean.getNumeroCuotasAtraso());
		creaNodo(eventFactory, eventWriter, "PagoActual", envioCintaCirculoBean.getPagoActual());			  
		creaNodo(eventFactory, eventWriter, "HistoricoPagos", envioCintaCirculoBean.getHistoricoPagos());
		creaNodo(eventFactory, eventWriter, "ClavePrevencion", envioCintaCirculoBean.getClavePrevencion());
		creaNodo(eventFactory, eventWriter, "TotalPagosReportados", envioCintaCirculoBean.getNumeroPagosEfectuados());
		creaNodo(eventFactory, eventWriter, "ClaveAnteriorOtorgante", Constantes.STRING_VACIO);
		creaNodo(eventFactory, eventWriter, "NombreAnteriorOtorgante", Constantes.STRING_VACIO);
		creaNodo(eventFactory, eventWriter, "NumeroCuentaAnterior", envioCintaCirculoBean.getNumeroCreditoAnterior());
		creaNodo(eventFactory, eventWriter, "FechaPrimerIncumplimiento", envioCintaCirculoBean.getFechaPrimIncumplimiento());
		creaNodo(eventFactory, eventWriter, "SaldoInsoluto", envioCintaCirculoBean.getTotalCapital());
		creaNodo(eventFactory, eventWriter, "MontoUltimoPago", envioCintaCirculoBean.getMontoUltimoPago());
		creaNodo(eventFactory, eventWriter, "FechaIngresoCarteraVencida",formatoFecha(envioCintaCirculoBean.getFechaCarteraVencida()));
		creaNodo(eventFactory, eventWriter, "MontoCorrespondienteIntereses",envioCintaCirculoBean.getTotalInteres());
		creaNodo(eventFactory, eventWriter, "FormaPagoActualIntereses",envioCintaCirculoBean.getFormaPagoInteres());
		creaNodo(eventFactory, eventWriter, "DiasVencimiento",envioCintaCirculoBean.getDiasVencidos());
		creaNodo(eventFactory, eventWriter, "PlazoMeses", envioCintaCirculoBean.getPlazoMeses());
		creaNodo(eventFactory, eventWriter, "MontoCreditoOriginacion", envioCintaCirculoBean.getMontoCreditoOrig());
		creaNodo(eventFactory, eventWriter, "CorreoElectronicoConsumidor",envioCintaCirculoBean.getCorreoElectronico());
		cierraElemento(eventFactory, eventWriter, "Cuenta");
		cierraElemento(eventFactory, eventWriter, "Persona");

		} //Cierre del For 
		
		cierraElemento(eventFactory, eventWriter, "Personas");
		
		//Cifras de Control
		abreElemento(eventFactory, eventWriter, "CifrasControl");
		creaNodo(eventFactory, eventWriter, "TotalSaldosActuales", sumatoriaSaldos);
		creaNodo(eventFactory, eventWriter, "TotalSaldosVencidos", sumatoriaSaldosVencidos);
		creaNodo(eventFactory, eventWriter, "TotalElementosNombreReportados", numeroElementosReportados);
		creaNodo(eventFactory, eventWriter, "TotalElementosDireccionReportados", numeroElementosReportados);
		creaNodo(eventFactory, eventWriter, "TotalElementosEmpleoReportados", numeroElementosReportados);
		creaNodo(eventFactory, eventWriter, "TotalElementosCuentaReportados", numeroElementosReportados);
		creaNodo(eventFactory, eventWriter, "NombreOtorgante", nombreOtorgante);
		creaNodo(eventFactory, eventWriter, "DomicilioDevolucion", domicilioMatriz);
		cierraElemento(eventFactory, eventWriter, "CifrasControl");

	  }
	  
	// Reporte Cirdulo de Credito para Personas Morales en Excel
	public void reportePersonasMorales( EnvioCintaCirculoBean cintaCirculoBean, HttpServletResponse response, String origenDatos) {
		
		List<EnvioCintaCirculoBean> listaEnvioCintaCirculo = null;
		ParametrosSisBean parametrosSisBean = null;
		
		String nombreArchivo = "";
		String anio = "";
		String mes = "";
		String dia = "";
		String fecha = "";
		String otorgante = "";
		String nombreOtorgante = "";
		String fechaExtraccion = "";
		String periodoReporto  = "";

		try{
			fecha = cintaCirculoBean.getFechaConsulta();
			anio = fecha.substring(0, 4);
			mes  = fecha.substring(5, 7);
			dia  = fecha.substring(8, 10);
	        
			PropiedadesBuroCreditoBean.cargaPropiedadesBuroCredito();
			otorgante = PropiedadesBuroCreditoBean.propiedadesBuroCredito.getProperty(origenDatos+".ClaveCirculo");
			nombreOtorgante = PropiedadesBuroCreditoBean.propiedadesBuroCredito.getProperty(origenDatos+".NombreOtorganteCirculo");
			fechaExtraccion = dia+mes+anio;
			periodoReporto  = mes+anio;
			
			nombreArchivo = "Cinta_Circulo_PM.xls";
			
			listaEnvioCintaCirculo = envioCintaCirculoDAO.consultaCintaEnvioMoral(cintaCirculoBean);
			parametrosSisBean = new ParametrosSisBean();
			parametrosSisBean.setEmpresaID("1");
			parametrosSisBean = parametrosSisDAO.consultaPrincipal(parametrosSisBean, ParametrosSisServicio.Enum_Con_ParametrosSis.principal);
			
			XSSFWorkbook libro = new XSSFWorkbook();

			//Fuente Negrita con tamaño 10 para cabeceras del reporte.
			XSSFCellStyle estiloCabecera = Utileria.crearFuente(libro, 10, Constantes.FUENTE_CENTRADA, Constantes.FUENTE_BOLD);

			//Fuente Negrita con tamaño 10 para informacion del reporte.
			XSSFCellStyle estiloTexto = Utileria.crearFuente(libro, 10, Constantes.FUENTE_IZQUIERDA, Constantes.FUENTE_NOBOLD);

			// Creacion de hoja
			XSSFSheet hoja = libro.createSheet("ENVIO CIRCULO CRÉDITO");
			XSSFRow fila= hoja.createRow(0);

			// Encabezado
			XSSFCell celdaEncabezados = fila.createCell((short)1);
			
			celdaEncabezados = fila.createCell((short)0);
			celdaEncabezados.setCellValue("Otorgante");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)1);
			celdaEncabezados.setCellValue("Otorgante anterior");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)2);
			celdaEncabezados.setCellValue("Nombre Otorgante");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)3);
			celdaEncabezados.setCellValue("Institución");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)4);
			celdaEncabezados.setCellValue("Formato");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)5);
			celdaEncabezados.setCellValue("Fecha Generación");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)6);
			celdaEncabezados.setCellValue("Périodo que Reporta");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)7);
			celdaEncabezados.setCellValue("Versión");
			celdaEncabezados.setCellStyle(estiloCabecera);

			// Empresa (EM)
			celdaEncabezados = fila.createCell((short)8);
			celdaEncabezados.setCellValue("RFC");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)9);
			celdaEncabezados.setCellValue("CURP");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)10);
			celdaEncabezados.setCellValue("Compañía");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)11);
			celdaEncabezados.setCellValue("Nombre1");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)12);
			celdaEncabezados.setCellValue("Nombre2");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)13);
			celdaEncabezados.setCellValue("Apellido Paterno");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)14);
			celdaEncabezados.setCellValue("Apellido Materno");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)15);
			celdaEncabezados.setCellValue("Nacionalidad");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)16);
			celdaEncabezados.setCellValue("Calificación Cartera");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)17);
			celdaEncabezados.setCellValue("Clave BANXICO 1 / SCIAN");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)18);
			celdaEncabezados.setCellValue("Clave BANXICO 2 / SCIAN");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)19);
			celdaEncabezados.setCellValue("Clave BANXICO 3 / SCIAN");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)20);
			celdaEncabezados.setCellValue("Dirección 1");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)21);
			celdaEncabezados.setCellValue("Dirección 2");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)22);
			celdaEncabezados.setCellValue("Colonia");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)23);
			celdaEncabezados.setCellValue("Deleg/Mun");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)24);
			celdaEncabezados.setCellValue("Ciudad");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)25);
			celdaEncabezados.setCellValue("Estado");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)26);
			celdaEncabezados.setCellValue("CP");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)27);
			celdaEncabezados.setCellValue("Teléfono");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)28);
			celdaEncabezados.setCellValue("Extensión");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)29);
			celdaEncabezados.setCellValue("Fax");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)30);
			celdaEncabezados.setCellValue("Tipo Cliente");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)31);
			celdaEncabezados.setCellValue("Edo extranjero");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)32);
			celdaEncabezados.setCellValue("País");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)33);
			celdaEncabezados.setCellValue("Teléfono móvil");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)34);
			celdaEncabezados.setCellValue("Correo electrónico");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)35);
			celdaEncabezados.setCellValue("Salario Mensual");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)36);
			celdaEncabezados.setCellValue("Fecha Ingreso");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			// Accionistas (AC)
			celdaEncabezados = fila.createCell((short)37);
			celdaEncabezados.setCellValue("RFC");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)38);
			celdaEncabezados.setCellValue("CURP");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)39);
			celdaEncabezados.setCellValue("Nombre Compañía");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)40);
			celdaEncabezados.setCellValue("Nombre 1");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)41);
			celdaEncabezados.setCellValue("Nombre 2");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)42);
			celdaEncabezados.setCellValue("Apellido Paterno ");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)43);
			celdaEncabezados.setCellValue("Apellido Materno");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)44);
			celdaEncabezados.setCellValue("Porcentaje");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)45);
			celdaEncabezados.setCellValue("Dirección 1");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)46);
			celdaEncabezados.setCellValue("Dirección 2");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)47);
			celdaEncabezados.setCellValue("Colonia");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)48);
			celdaEncabezados.setCellValue("Deleg / Mun");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)49);
			celdaEncabezados.setCellValue("Ciudad");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)50);
			celdaEncabezados.setCellValue("Estado");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)51);
			celdaEncabezados.setCellValue("CP");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)52);
			celdaEncabezados.setCellValue("Teléfono");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)53);
			celdaEncabezados.setCellValue("Extensión");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)54);
			celdaEncabezados.setCellValue("Fax");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)55);
			celdaEncabezados.setCellValue("Tipo Cliente");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)56);
			celdaEncabezados.setCellValue("Edo extranjero");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)57);
			celdaEncabezados.setCellValue("País");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			// Crédito (CR)
			celdaEncabezados = fila.createCell((short)58);
			celdaEncabezados.setCellValue("RFC");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)59);
			celdaEncabezados.setCellValue("Número contrato");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)60);
			celdaEncabezados.setCellValue("Número contrato anterior");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)61);
			celdaEncabezados.setCellValue("Fecha apertura");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)62);
			celdaEncabezados.setCellValue("Plazo en Meses");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)63);
			celdaEncabezados.setCellValue("Tipo crédito");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)64);
			celdaEncabezados.setCellValue("Saldo Inicial");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)65);
			celdaEncabezados.setCellValue("Moneda");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)66);
			celdaEncabezados.setCellValue("Número Pagos");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)67);
			celdaEncabezados.setCellValue("Frecuencia pagos");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)68);
			celdaEncabezados.setCellValue("Importe pagos");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)69);
			celdaEncabezados.setCellValue("Fecha último pago");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)70);
			celdaEncabezados.setCellValue("Fecha reestructura");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)71);
			celdaEncabezados.setCellValue("Pago efectivo");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)72);
			celdaEncabezados.setCellValue("Fecha liquidación");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)73);
			celdaEncabezados.setCellValue("Quita");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)74);
			celdaEncabezados.setCellValue("Dación");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)75);
			celdaEncabezados.setCellValue("Quebranto o castigo");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)76);
			celdaEncabezados.setCellValue("Clave observación ");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)77);
			celdaEncabezados.setCellValue("Especiales");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)78);
			celdaEncabezados.setCellValue("Fecha 1er incumplimiento");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)79);
			celdaEncabezados.setCellValue("Saldo Insoluto");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)80);
			celdaEncabezados.setCellValue("Crédito Máximo Utilizado");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)81);
			celdaEncabezados.setCellValue("Fecha Ingreso Cartera Vencida");
			celdaEncabezados.setCellStyle(estiloCabecera);

			// Detalle Crédito (DE)
			celdaEncabezados = fila.createCell((short)82);
			celdaEncabezados.setCellValue("RFC");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)83);
			celdaEncabezados.setCellValue("Número contrato");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)84);
			celdaEncabezados.setCellValue("Días vencidos");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)85);
			celdaEncabezados.setCellValue("Cantidad");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)86);
			celdaEncabezados.setCellValue("Intereses");
			celdaEncabezados.setCellStyle(estiloCabecera);

			// Aval (AV)
			celdaEncabezados = fila.createCell((short)87);
			celdaEncabezados.setCellValue("RFC");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)88);
			celdaEncabezados.setCellValue("CURP");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)89);
			celdaEncabezados.setCellValue("Nombre Compañía");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)90);
			celdaEncabezados.setCellValue("Nombre 1");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)91);
			celdaEncabezados.setCellValue("Nombre 2");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)92);
			celdaEncabezados.setCellValue("Apellido Paterno Aval");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)93);
			celdaEncabezados.setCellValue("Apellido Materno Aval");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)94);
			celdaEncabezados.setCellValue("Dirección 1");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)95);
			celdaEncabezados.setCellValue("Dirección 2");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)96);
			celdaEncabezados.setCellValue("Colonia");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)97);
			celdaEncabezados.setCellValue("Deleg/mun");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)98);
			celdaEncabezados.setCellValue("Ciudad");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)99);
			celdaEncabezados.setCellValue("Estado");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)100);
			celdaEncabezados.setCellValue("CP");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)101);
			celdaEncabezados.setCellValue("Teléfono");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)102);
			celdaEncabezados.setCellValue("Extensión");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)103);
			celdaEncabezados.setCellValue("Fax");
			celdaEncabezados.setCellStyle(estiloCabecera);

			celdaEncabezados = fila.createCell((short)104);
			celdaEncabezados.setCellValue("Tipo Cliente");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)105);
			celdaEncabezados.setCellValue("Edo extranjero");
			celdaEncabezados.setCellStyle(estiloCabecera);
			
			celdaEncabezados = fila.createCell((short)106);
			celdaEncabezados.setCellValue("País");
			celdaEncabezados.setCellStyle(estiloCabecera);			
			
			int renglon = 1;
			int numRegistros = 0;
			int tamanioLista = listaEnvioCintaCirculo.size();
			EnvioCintaCirculoBean envioCintaCirculo = null;			
			
			for(int iteracion = 0; iteracion < tamanioLista; iteracion++){
				
				envioCintaCirculo = (EnvioCintaCirculoBean) listaEnvioCintaCirculo.get(iteracion );

				fila=hoja.createRow(renglon);
				XSSFCell celdaCuerpo = fila.createCell((short)1);
				
				celdaCuerpo = fila.createCell((short)0);
				celdaCuerpo.setCellValue(otorgante);
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)1);
				celdaCuerpo.setCellValue("    ");
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)2);
				celdaCuerpo.setCellValue(nombreOtorgante);
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)3);
				celdaCuerpo.setCellValue(parametrosSisBean.getInstitucionCirculoCredito());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)4);
				celdaCuerpo.setCellValue(parametrosSisBean.getClaveEntidadCirculo());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)5);
				celdaCuerpo.setCellValue(fechaExtraccion);
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)6);
				celdaCuerpo.setCellValue(periodoReporto);
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)7);
				celdaCuerpo.setCellValue("05");
				celdaCuerpo.setCellStyle(estiloTexto);
				
				// Encabezado				
				celdaCuerpo = fila.createCell((short)8);
				celdaCuerpo.setCellValue(envioCintaCirculo.getRfc());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)9);
				celdaCuerpo.setCellValue(envioCintaCirculo.getCurp());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)10);
				celdaCuerpo.setCellValue(envioCintaCirculo.getRazonSocial());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)11);
				celdaCuerpo.setCellValue(envioCintaCirculo.getPrimerNombre());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)12);
				celdaCuerpo.setCellValue(envioCintaCirculo.getSegundoNombre());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)13);
				celdaCuerpo.setCellValue(envioCintaCirculo.getApellidoPaterno());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)14);
				celdaCuerpo.setCellValue(envioCintaCirculo.getApellidoMaterno());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)15);
				celdaCuerpo.setCellValue(envioCintaCirculo.getNacionalidad());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)16);
				celdaCuerpo.setCellValue(envioCintaCirculo.getClasificacionCartera());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)17);
				celdaCuerpo.setCellValue(envioCintaCirculo.getClaveBanxico1());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)18);
				celdaCuerpo.setCellValue(envioCintaCirculo.getClaveBanxico2());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)19);
				celdaCuerpo.setCellValue(envioCintaCirculo.getClaveBanxico3());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)20);
				celdaCuerpo.setCellValue(envioCintaCirculo.getDireccion1());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)21);
				celdaCuerpo.setCellValue(envioCintaCirculo.getDireccion2());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)22);
				celdaCuerpo.setCellValue(envioCintaCirculo.getColonia());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)23);
				celdaCuerpo.setCellValue(envioCintaCirculo.getMunicipio());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)24);
				celdaCuerpo.setCellValue(envioCintaCirculo.getCiudad());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)25);
				celdaCuerpo.setCellValue(envioCintaCirculo.getEstado());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)26);
				celdaCuerpo.setCellValue(envioCintaCirculo.getCodigoPostal());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)27);
				celdaCuerpo.setCellValue(envioCintaCirculo.getTelefono());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)28);
				celdaCuerpo.setCellValue(envioCintaCirculo.getExtension());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)29);
				celdaCuerpo.setCellValue(envioCintaCirculo.getFax());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)30);
				celdaCuerpo.setCellValue(envioCintaCirculo.getTipoCliente());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)31);
				celdaCuerpo.setCellValue(envioCintaCirculo.getEdoExtranjero());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)32);
				celdaCuerpo.setCellValue(envioCintaCirculo.getPais());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)33);
				celdaCuerpo.setCellValue(envioCintaCirculo.getTelefonoCelular());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)34);
				celdaCuerpo.setCellValue(envioCintaCirculo.getCorreoElectronico());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)35);
				celdaCuerpo.setCellValue(envioCintaCirculo.getMontoSal());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)36);
				celdaCuerpo.setCellValue(envioCintaCirculo.getFechaIngreso());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)37);
				celdaCuerpo.setCellValue(envioCintaCirculo.getRfcCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)38);
				celdaCuerpo.setCellValue(envioCintaCirculo.getCurpCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)39);
				celdaCuerpo.setCellValue(envioCintaCirculo.getRazonSocialCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)40);
				celdaCuerpo.setCellValue(envioCintaCirculo.getPrimerNombreCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)41);
				celdaCuerpo.setCellValue(envioCintaCirculo.getSegundoNombreCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)42);
				celdaCuerpo.setCellValue(envioCintaCirculo.getApellidoPaternoCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)43);
				celdaCuerpo.setCellValue(envioCintaCirculo.getApellidoMaternoCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)44);
				celdaCuerpo.setCellValue(envioCintaCirculo.getPorcentaje());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)45);
				celdaCuerpo.setCellValue(envioCintaCirculo.getDireccionCompania1());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)46);
				celdaCuerpo.setCellValue(envioCintaCirculo.getDireccionCompania2());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)47);
				celdaCuerpo.setCellValue(envioCintaCirculo.getColoniaCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)48);
				celdaCuerpo.setCellValue(envioCintaCirculo.getMunicipioCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)49);
				celdaCuerpo.setCellValue(envioCintaCirculo.getCiudadCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)50);
				celdaCuerpo.setCellValue(envioCintaCirculo.getEstadoCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)51);
				celdaCuerpo.setCellValue(envioCintaCirculo.getCodigoPostalCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)52);
				celdaCuerpo.setCellValue(envioCintaCirculo.getTelefonoCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)53);
				celdaCuerpo.setCellValue(envioCintaCirculo.getExtensionCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)54);
				celdaCuerpo.setCellValue(envioCintaCirculo.getFaxCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)55);
				celdaCuerpo.setCellValue(envioCintaCirculo.getTipoClienteCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)56);
				celdaCuerpo.setCellValue(envioCintaCirculo.getEdoExtranjeroCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)57);
				celdaCuerpo.setCellValue(envioCintaCirculo.getPaisCompania());
				celdaCuerpo.setCellStyle(estiloTexto);

				// Crédito (CR)
				celdaCuerpo = fila.createCell((short)58);
				celdaCuerpo.setCellValue(envioCintaCirculo.getRfc());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)59);
				celdaCuerpo.setCellValue(envioCintaCirculo.getCreditoID());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)60);
				celdaCuerpo.setCellValue(envioCintaCirculo.getNumeroCreditoAnterior());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)61);
				celdaCuerpo.setCellValue(envioCintaCirculo.getFechaInicio());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)62);
				celdaCuerpo.setCellValue(envioCintaCirculo.getPlazo());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)63);
				celdaCuerpo.setCellValue(envioCintaCirculo.getTipoContrato());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)64);
				celdaCuerpo.setCellValue(envioCintaCirculo.getMontoCredito());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)65);
				celdaCuerpo.setCellValue(envioCintaCirculo.getMoneda());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)66);
				celdaCuerpo.setCellValue(envioCintaCirculo.getNumeroPagos());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)67);
				celdaCuerpo.setCellValue(envioCintaCirculo.getFrecuenciaPago());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)68);
				celdaCuerpo.setCellValue(envioCintaCirculo.getMontoPagar());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)69);
				celdaCuerpo.setCellValue(envioCintaCirculo.getFechaUltimoPago());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)70);
				celdaCuerpo.setCellValue(envioCintaCirculo.getFechaReestrucutura());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)71);
				celdaCuerpo.setCellValue(envioCintaCirculo.getPagoEfectivo());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)72);
				celdaCuerpo.setCellValue(envioCintaCirculo.getFechaLiquidacion());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)73);
				celdaCuerpo.setCellValue(envioCintaCirculo.getQuitas());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)74);
				celdaCuerpo.setCellValue(envioCintaCirculo.getCondonacion());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)75);
				celdaCuerpo.setCellValue(envioCintaCirculo.getCastigo());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)76);
				celdaCuerpo.setCellValue(envioCintaCirculo.getClaveObservacion());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)77);
				celdaCuerpo.setCellValue(envioCintaCirculo.getEspeciales());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)78);
				celdaCuerpo.setCellValue(envioCintaCirculo.getFechaPrimIncumplimiento());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)79);
				celdaCuerpo.setCellValue(envioCintaCirculo.getSaldoInsoluto());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)80);
				celdaCuerpo.setCellValue(envioCintaCirculo.getCreditoMaximo());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)81);
				celdaCuerpo.setCellValue(envioCintaCirculo.getFechaCarteraVencida());
				celdaCuerpo.setCellStyle(estiloTexto);

				// Detalle Crédito (DE)
				celdaCuerpo = fila.createCell((short)82);
				celdaCuerpo.setCellValue(envioCintaCirculo.getRfc());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)83);
				celdaCuerpo.setCellValue(envioCintaCirculo.getCreditoID());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)84);
				celdaCuerpo.setCellValue(envioCintaCirculo.getNumeroDiasAtraso());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)85);
				celdaCuerpo.setCellValue(envioCintaCirculo.getSaldoTotal());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)86);
				celdaCuerpo.setCellValue(envioCintaCirculo.getIntereses());
				celdaCuerpo.setCellStyle(estiloTexto);

				// Aval (AV)
				celdaCuerpo = fila.createCell((short)87);
				celdaCuerpo.setCellValue(envioCintaCirculo.getRfcAval());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)88);
				celdaCuerpo.setCellValue(envioCintaCirculo.getCurpAval());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)89);
				celdaCuerpo.setCellValue(envioCintaCirculo.getRazonSocialAval());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)90);
				celdaCuerpo.setCellValue(envioCintaCirculo.getPrimerNombreAval());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)91);
				celdaCuerpo.setCellValue(envioCintaCirculo.getSegundoNombreAval());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)92);
				celdaCuerpo.setCellValue(envioCintaCirculo.getApellidoPaternoAval());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)93);
				celdaCuerpo.setCellValue(envioCintaCirculo.getApellidoMaternoAval());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)94);
				celdaCuerpo.setCellValue(envioCintaCirculo.getDireccionAval1());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)95);
				celdaCuerpo.setCellValue(envioCintaCirculo.getDireccionAval2());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)96);
				celdaCuerpo.setCellValue(envioCintaCirculo.getColoniaAval());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)97);
				celdaCuerpo.setCellValue(envioCintaCirculo.getMunicipioAval());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)98);
				celdaCuerpo.setCellValue(envioCintaCirculo.getCiudadAval());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)99);
				celdaCuerpo.setCellValue(envioCintaCirculo.getEstadoAval());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)100);
				celdaCuerpo.setCellValue(envioCintaCirculo.getCodigoPostalAval());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)101);
				celdaCuerpo.setCellValue(envioCintaCirculo.getTelefonoAval());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)102);
				celdaCuerpo.setCellValue(envioCintaCirculo.getExtensionAval());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)103);
				celdaCuerpo.setCellValue(envioCintaCirculo.getFaxAval());
				celdaCuerpo.setCellStyle(estiloTexto);

				celdaCuerpo = fila.createCell((short)104);
				celdaCuerpo.setCellValue(envioCintaCirculo.getTipoClienteAval());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)105);
				celdaCuerpo.setCellValue(envioCintaCirculo.getEdoExtranjeroAval());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				celdaCuerpo = fila.createCell((short)106);
				celdaCuerpo.setCellValue(envioCintaCirculo.getPaisAval());
				celdaCuerpo.setCellStyle(estiloTexto);
				
				renglon++;
				numRegistros = numRegistros+1;
			}

/*
			for(int celdaAjustar=0; celdaAjustar <= 104; celdaAjustar++){
				hoja.autoSizeColumn((short)celdaAjustar);
			}*/

			//Creo la cabecera
			response.addHeader("Content-Disposition","inline; filename=" + nombreArchivo);
			response.setContentType("application/vnd.ms-excel");

			ServletOutputStream outputStream = response.getOutputStream();
			hoja.getWorkbook().write(outputStream);
			outputStream.flush();
			outputStream.close();


		} catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.info("Error en el Reporte de Cinta para Círculo de crédito de Personas Morales y Personas Físicas con Actividad " + exception);
		}
	}

	
	public static String formatoFecha(String fechaStr){
		String fecha = "";
		try{
			if(fechaStr == null || fechaStr.trim().length() <= 0){
				fecha = "";
			}else{
				String[] arreglo = fechaStr.split("-");	
				
				fecha = arreglo[0] + arreglo[1] + arreglo[2];
			}
		}catch(Exception e){
			System.out.println("Error en EnvioCintaCirculoServicio.formatoFecha. Valor" + fechaStr);
			e.printStackTrace();
		}
		
		return fecha;
	}
	
	public String generaArchivoEnvioCirculoCreditoVtaCar(EnvioCintaCirculoBean cintaCirculoBean){
 		
		String origenDatos =  parametrosSesionBean.getOrigenDatos();
		origenDatos = origenDatos+".";
		PropiedadesBuroCreditoBean.cargaPropiedadesBuroCredito();
		String fechaConsulta = formatoFecha(cintaCirculoBean.getFechaConsulta());
		String claveOtorgante = PropiedadesBuroCreditoBean.propiedadesBuroCredito.getProperty(origenDatos+"NumeroInstitucionCirculo");
		String nombreOtorgante = PropiedadesBuroCreditoBean.propiedadesBuroCredito.getProperty(origenDatos+"NombreOtorganteCirculo");
		String configFile = PropiedadesBuroCreditoBean.propiedadesBuroCredito.getProperty(origenDatos+"RutaArchivoEnvioCirculo") + 
							claveOtorgante + "_" + nombreOtorgante + "_" +  fechaConsulta + "_VtaCar.xml";

		

		String directorio = PropiedadesBuroCreditoBean.propiedadesBuroCredito.getProperty(origenDatos+"RutaArchivoEnvioCirculo");
		boolean exists = (new File(directorio)).exists();
		if (!exists) {
			File aDir = new File(directorio);
			aDir.mkdirs();
		}	
		String nombreArchivo = claveOtorgante + "_" + nombreOtorgante + "_" +  fechaConsulta + "_VtaCar.xml";

		try {
			XMLOutputFactory outputFactory = XMLOutputFactory.newInstance();
			XMLEventWriter eventWriter = outputFactory.createXMLEventWriter(new FileOutputStream(configFile), "ISO-8859-1");
			XMLEventFactory eventFactory = XMLEventFactory.newInstance();

			// create and write Start Tag
			StartDocument startDocument = eventFactory.createStartDocument();
			eventWriter.add(startDocument);
			
			// create config open tag
			Attribute[] atributos = new Attribute[2]; 
			Attribute nameSapeceAtt = eventFactory.createAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
			Attribute schemaAtt = eventFactory.createAttribute("xsi:noNamespaceSchemaLocation", "/Carga.xsd;");
			atributos[0] = nameSapeceAtt; 
			atributos[1] = schemaAtt; 
			
		    List attributeList = Arrays.asList(atributos);
		    List nsList = Arrays.asList();
		    
			StartElement cargaElement = eventFactory.createStartElement("",  "", "Carga",attributeList.iterator(), nsList.iterator());
			eventWriter.add(cargaElement);
			//Crea el Elemento Encabezado y sus Nodos
			creaEncabezado(eventFactory, eventWriter,fechaConsulta, origenDatos);
			//Crea el Elemento Personas(Datos de la Cartera)
			creaElementoPersonasVtaCar(eventFactory, eventWriter, cintaCirculoBean,claveOtorgante, nombreOtorgante);
			//Crea el Elemento Raiz de "Carga"
			eventWriter.add(eventFactory.createEndElement("", "", "Carga"));
			eventWriter.add(eventFactory.createEndDocument());
			eventWriter.close();
			
		} catch (Exception e) {			
			e.printStackTrace();
			configFile = Constantes.STRING_VACIO;
			nombreArchivo = Constantes.STRING_VACIO;
		} 		
		return nombreArchivo ;
	}

	//------------------ Geters y Seters ------------------------------------------------------
	
	public EnvioCintaCirculoDAO getEnvioCintaCirculoDAO() {
		return envioCintaCirculoDAO;
	}

	public void setEnvioCintaCirculoDAO(EnvioCintaCirculoDAO envioCintaCirculoDAO) {
		this.envioCintaCirculoDAO = envioCintaCirculoDAO;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public ParametrosSisDAO getParametrosSisDAO() {
		return parametrosSisDAO;
	}

	public void setParametrosSisDAO(ParametrosSisDAO parametrosSisDAO) {
		this.parametrosSisDAO = parametrosSisDAO;
	}
	
}
