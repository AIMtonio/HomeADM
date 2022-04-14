package pld.reporte;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.Calendar;
import java.util.List;
import java.util.zip.ZipOutputStream;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import herramientas.Constantes;
import herramientas.Utileria;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.stream.StreamResult;

import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFDataFormat;
import org.apache.poi.xssf.usermodel.XSSFFont;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.tools.zip.ZipEntry;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;
import org.springframework.web.servlet.mvc.SimpleFormController;
import pld.bean.OperVulnerablesBean;
import pld.servicio.OperVulnerablesServicio;
import soporte.servicio.ParametrosSisServicio;


public class RepOperVulnerablesControlador extends AbstractCommandController{
	

	OperVulnerablesServicio operVulnerablesServicio = null;
	String successView = null;	
	public static interface Enum_Con_TipRepor {
		  int  ReporXML	= 1 ;
		  
	}
	
	public RepOperVulnerablesControlador() {
		setCommandClass(OperVulnerablesBean.class);
		setCommandName("operVulnerablesBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		String contentOriginal = response.getContentType();
			
		OperVulnerablesBean operVulnerablesBean = (OperVulnerablesBean) command;
		int tipoReporte =(request.getParameter("tipoReporte")!=null)?Integer.parseInt(request.getParameter("tipoReporte")):0;
		
		switch(tipoReporte){
			case Enum_Con_TipRepor.ReporXML:
				return reporteOperacionesVulnerablesXML(operVulnerablesBean, contentOriginal, tipoReporte, response);
			default:
				String htmlString = Constantes.htmlErrorReporteCirculo;
	 			response.addHeader("Content-Disposition","");
		 		response.setContentType(contentOriginal);
		 		response.setContentLength(htmlString.length());
	 			return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
		}
		
		//return null;
	}
	
	@SuppressWarnings("unchecked")
	// Reporte de OPERACIONES VULNERABLES XML
	public ModelAndView reporteOperacionesVulnerablesXML(OperVulnerablesBean operVulnerables, String contentOriginal, final int tipoRep, HttpServletResponse response){						
		try{ 

			  List <OperVulnerablesBean> listaOperVulnerables= null;
			  
			  OperVulnerablesBean operVul = new OperVulnerablesBean();			 
			  operVul = operVulnerablesServicio.consulta(1, operVulnerables);
			  
			  String directorio = operVul.getRutaArchivo();
			  String nombreXml = operVulnerables.getAnio() + operVulnerables.getMes()+"_OperVulnerables.xml";
			  String rutaCompleta = directorio + nombreXml;
			  
			  
			  borrarArchivo(rutaCompleta);
			                
			  escribeArchivo(rutaCompleta, "<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
			  escribeArchivo(rutaCompleta, " <informe>");
			  escribeArchivo(rutaCompleta,"  <mes_reportado>"+operVulnerables.getAnio() + operVulnerables.getMes()+"</mes_reportado>\n" +
										  "   <sujeto_obligado>\n" +
										  "    <clave_entidad_colegiada>"+operVul.getClaveEntidadColegiada()+"</clave_entidad_colegiada>\n" +
										  "    <clave_sujeto_obligado>"+operVul.getClaveSujetoObligado() +"</clave_sujeto_obligado>\n" +
										  "    <clave_actividad>"+operVul.getClaveActividad()+"</clave_actividad>\n" +
										  "    <exento>"+operVul.getExento()+"</exento>\n"+
										  "    <dominio_plataforma>"+operVul.getDominioPlataforma()+"</dominio_plataforma>\n"+
										  "   </sujeto_obligado>\n");
			  escribeArchivo(rutaCompleta,"   <aviso>\n"+
					  					  "    <referencia_aviso>"+operVul.getReferenciaAviso()+"</referencia_aviso>\n" +
					  					  "    <prioridad>"+operVul.getPrioridad()+"</prioridad>\n" +
		    							  "    <modificatorio>\n" +
		    							  "     <folio_modificacion>"+operVul.getFolioModificacion()+"</folio_modificacion>\n" +
		    							  "     <descripcion_modificacion>"+operVul.getDescripcionModificacion()+"</descripcion_modificacion>\n" +
		    							  "    </modificatorio>\n"+
		    							  "    <alerta>\n" +
		    							  "     <tipo_alerta>"+operVul.getTipoAlerta()+"</tipo_alerta>\n" +
		    							  "     <descripcion_alerta>"+operVul.getDescripcionAlerta()+"</descripcion_alerta>\n" +
		    							  "    </alerta>\n");
			  
			  listaOperVulnerables=operVulnerablesServicio.lista(tipoRep, operVulnerables);
			 
			  for (OperVulnerablesBean operVulnerablesBean : listaOperVulnerables) {
			    escribeArchivo(rutaCompleta,"    <operaciones_persona>\n" +
			    							"     <persona_aviso>\n" +
			    							//DATOS DE CTA PLATAFORMA
			    							"      <datos_cuenta_plataforma>\n" +
			    							"       <id_usuario>"+operVulnerablesBean.getClienteID()+"</id_usuario>\n" +
			    							"       <cuenta_relacionada>"+operVulnerablesBean.getCuentaRelacionada()+"</cuenta_relacionada>\n" +
			    							"       <clabe_interbancaria>"+operVulnerablesBean.getClabeInterbancaria()+"</clabe_interbancaria>\n" +
			    							"       <moneda_cuenta>"+operVulnerablesBean.getMonedaCuenta()+"</moneda_cuenta>\n" +
			    							"      </datos_cuenta_plataforma>\n" +
			    							//TIPO DE PERSONA
			    							"      <tipo_persona>\n" +
			    							"       <persona_fisica>\n" +
			    							"        <nombre>"+operVulnerablesBean.getNombrePF()+"</nombre>\n" +
			    							"        <apellido_paterno>"+operVulnerablesBean.getApellidoPaternoPF()+"</apellido_paterno>\n" +
			    							"        <apellido_materno>"+operVulnerablesBean.getApellidoMaternoPF()+"</apellido_materno>\n" +
			    							"        <fecha_nacimiento>"+operVulnerablesBean.getFechaNacimientoPF()+"</fecha_nacimiento>\n" +
			    							"        <rfc>"+operVulnerablesBean.getrFCPF()+"</rfc>\n" +
			    							"        <curp>"+operVulnerablesBean.getcURPPF()+"</curp>\n" +
			    							"        <pais_nacionalidad>"+operVulnerablesBean.getPaisNacionalidadPF()+"</pais_nacionalidad>\n" +
			    							"        <actividad_economica>"+operVulnerablesBean.getActividadEconomicaPF()+"</actividad_economica>\n" +
			    							"        <documento_identificacion>\n" +
			    							"         <tipo_identificacion>"+operVulnerablesBean.getTipoIdentificacionPF()+"</tipo_identificacion>\n" +
			    							"         <numero_identificacion>"+operVulnerablesBean.getNumeroIdentificacionPF()+"</numero_identificacion>\n" +
			    							"        </documento_identificacion>\n" +			    							
			    							"       </persona_fisica>\n" +
			    							"       <persona_moral>\n" +
			    							"        <denominacion_razon>"+operVulnerablesBean.getDenominacionRazonPM()+"</denominacion_razon>\n" +
			    							"        <fecha_constitucion>"+operVulnerablesBean.getFechaConstitucionPM()+"</fecha_constitucion>\n" +
			    							"        <rfc>"+operVulnerablesBean.getrFCPM()+"</rfc>\n" +
			    							"        <pais_nacionalidad>"+operVulnerablesBean.getPaisNacionalidadPM()+"</pais_nacionalidad>\n" +
			    							"        <giro_mercantil>"+operVulnerablesBean.getGiroMercantilPM()+"</giro_mercantil>\n" +
			    							"        <representante_apoderado>\n" +
			    							"         <nombre>"+operVulnerablesBean.getNombreRL()+"</nombre>\n" +
			    							"         <apellido_paterno>"+operVulnerablesBean.getApellidoPaternoRL()+"</apellido_paterno>\n" +
			    							"         <apellido_materno>"+operVulnerablesBean.getApellidoMaternoRL()+"</apellido_materno>\n" +
			    							"         <fecha_nacimiento>"+operVulnerablesBean.getFechaNacimientoRL()+"</fecha_nacimiento>\n" +
			    							"         <rfc>"+operVulnerablesBean.getrFCRL()+"</rfc>\n" +
			    							"         <curp>"+operVulnerablesBean.getcURPRL()+"</curp>\n" +
			    							"         <documento_identificacion>\n" +
			    							"          <tipo_identificacion>"+operVulnerablesBean.getTipoIdentificacionRL()+"</tipo_identificacion>\n" +
			    							"          <numero_identificacion>"+operVulnerablesBean.getNumeroIdentificacionRL()+"</numero_identificacion>\n" +
			    							"         </documento_identificacion>\n" +
			    							"        </representante_apoderado>\n" +
			    							"       </persona_moral>\n" +
			    							"       <fideicomiso>\n" +
			    							"        <denominacion_razon>"+operVulnerablesBean.getDenominacionRazonFedi()+"</denominacion_razon>\n" +
			    							"        <rfc>"+operVulnerablesBean.getrFCFedi()+"</rfc>\n" +
			    							"        <identificador_fideicomiso>"+operVulnerablesBean.getFideicomisoIDFedi()+"</identificador_fideicomiso>\n" +
			    							"        <apoderado_delegado>\n" +
			    							"         <nombre>"+operVulnerablesBean.getNombreApo()+"</nombre>\n" +
			    							"         <apellido_paterno>"+operVulnerablesBean.getApellidoPaternoApo()+"</apellido_paterno>\n" +
			    							"         <apellido_materno>"+operVulnerablesBean.getApellidoMaternoApo()+"</apellido_materno>\n" +
			    							"         <fecha_nacimiento>"+operVulnerablesBean.getFechaNacimientoApo()+"</fecha_nacimiento>\n" +
			    							"         <rfc>"+operVulnerablesBean.getrFCApo()+"</rfc>\n" +
			    							"         <curp>"+operVulnerablesBean.getcURPApo()+"</curp>\n" +
			    							"         <documento_identificacion>\n" +
			    							"          <tipo_identificacion>"+operVulnerablesBean.getTipoIdentificacionApo()+"</tipo_identificacion>\n" +
			    							"          <numero_identificacion>"+operVulnerablesBean.getNumeroIdentificacionApo()+"</numero_identificacion>\n" +
			    							"         </documento_identificacion>\n" +
			    							"        </apoderado_delegado>\n" +			    							
			    							"       </fideicomiso>\n" +//FIN FIDECOMISO
			    							"      </tipo_persona>\n" +
			    							//TIPO DE DOMICILIO
			    							"      <tipo_domicilio>\n" +
			    							"       <nacional>\n" +
			    							"        <colonia>"+operVulnerablesBean.getColoniaN()+"</colonia>\n" +
			    							"        <calle>"+operVulnerablesBean.getCalleN()+"</calle>\n" +
			    							"        <numero_exterior>"+operVulnerablesBean.getNumeroExteriorN()+"</numero_exterior>\n" +
			    							"        <numero_interior>"+operVulnerablesBean.getNumeroInteriorN()+"</numero_interior>\n" +
			    							"        <codigo_postal>"+operVulnerablesBean.getCodigoPostalN()+"</codigo_postal>\n" +
			    							"       </nacional>\n" +
			    							"       <extranjero>\n" +
			    							"        <pais>"+operVulnerablesBean.getPaisE()+"</pais>\n" +
			    							"        <estado_provincia>"+operVulnerablesBean.getEstadoProvinciaE()+"</estado_provincia>\n" +
			    							"        <ciudad_poblacion>"+operVulnerablesBean.getCiudadPoblacionE()+"</ciudad_poblacion>\n" +
			    							"        <colonia>"+operVulnerablesBean.getColoniaE()+"</colonia>\n" +
			    							"        <calle>"+operVulnerablesBean.getCalleE()+"</calle>\n" +
			    							"        <numero_exterior>"+operVulnerablesBean.getNumeroExteriorE()+"</numero_exterior>\n" +
			    							"        <numero_interior>"+operVulnerablesBean.getNumeroInteriorE()+"</numero_interior>\n" +
			    							"        <codigo_postal>"+operVulnerablesBean.getCodigoPostalE()+"</codigo_postal>\n" +
			    							"       </extranjero>\n" +
			    							"      </tipo_domicilio>\n" +
			    							//TELEFONO
			    							"      <telefono>\n" +
			    							"       <clave_pais>"+operVulnerablesBean.getClavePaisPer()+"</clave_pais>\n" +
			    							"       <numero_telefono>"+operVulnerablesBean.getNumeroTelefonoPer()+"</numero_telefono>\n" +
			    							"       <correo_electronico>"+operVulnerablesBean.getCorreoElectronicoPer()+"</correo_electronico>\n" +
			    							"      </telefono>\n" +
			    							"     </persona_aviso>\n" +
			    							"     <dueno_beneficiario>\n" + 			    							
			    							"      <persona_fisica>\n" +
			    							"       <nombre>"+operVulnerablesBean.getNombreDuePF()+"</nombre>\n" +
			    							"       <apellido_paterno>"+operVulnerablesBean.getApellidoPaternoDuePF()+"</apellido_paterno>\n" +
			    							"       <apellido_materno>"+operVulnerablesBean.getApellidoMaternoDuePF()+"</apellido_materno>\n" +
			    							"       <fecha_nacimiento>"+operVulnerablesBean.getFechaNacimientoDuePF()+"</fecha_nacimiento>\n" +
			    							"       <rfc>"+operVulnerablesBean.getrFCDuePF()+"</rfc>\n" +
			    							"       <curp>"+operVulnerablesBean.getcURPDuePF()+"</curp>\n" +
			    							"       <pais_nacionalidad>"+operVulnerablesBean.getPaisNacionalidadDuePF()+"</pais_nacionalidad>\n" +	    							
			    							"      </persona_fisica>\n" +
			    							"      <persona_moral>\n" +
			    							"       <denominacion_razon>"+operVulnerablesBean.getDenominacionRazonDuePM()+"</denominacion_razon>\n" +
			    							"       <fecha_constitucion>"+operVulnerablesBean.getFechaConstitucionDuePM()+"</fecha_constitucion>\n" +
			    							"       <rfc>"+operVulnerablesBean.getrFCDuePM()+"</rfc>\n" +
			    							"       <pais_nacionalidad>"+operVulnerablesBean.getPaisNacionalidadDuePM()+"</pais_nacionalidad>\n" +    							
			    							"      </persona_moral>\n" +
			    							"      <fideicomiso>\n" +//--ACTUALMENTE EL SAFI NO CEUNTA CON LA INFO DE FIDECOMMISO
			    							"       <denominacion_razon>"+operVulnerablesBean.getDenominacionRazonDueFid()+"</denominacion_razon>\n" +
			    							"       <rfc>"+operVulnerablesBean.getrFCDueFid()+"</rfc>\n" +
			    							"       <identificador_fideicomiso>"+operVulnerablesBean.getFideicomisoIDDueFid()+"</identificador_fideicomiso>\n" + 							
			    							"      </fideicomiso>\n" +
			    							"     </dueno_beneficiario>\n" +
			    							"     <detalle_operaciones>\n" +
			    							//OPERACIONES DE COMPRA--ACTUALMENTE EL SAFI NO CEUNTA CON OPERACIONES DE COMPRA    							
			    							"      <operaciones_compra>\n" +
			    							"       <compra>\n" +
			    							"        <fecha_hora_operacion>"+operVulnerablesBean.getFechaHoraOperacionCom()+"</fecha_hora_operacion>\n" +
			    							"        <moneda_operacion>"+operVulnerablesBean.getMonedaOperacionCom()+"</moneda_operacion>\n" +
			    							"        <monto_operacion>"+operVulnerablesBean.getMontoOperacionCom()+"</monto_operacion>\n" +
			    							"        <activo_virtual>\n" +
			    							"         <activo_virtual_operado>"+operVulnerablesBean.getActivoVirtualOperadoAV()+"</activo_virtual_operado>\n" +
			    							"         <descripcion_activo_virtual>"+operVulnerablesBean.getDescripcionActivoVirtualAV()+"</descripcion_activo_virtual>\n" +
			    							"         <tipo_cambio_mn>"+operVulnerablesBean.getTipoCambioMnAV()+"</tipo_cambio_mn>\n" +
			    							"         <cantidad_activo_virtual>"+operVulnerablesBean.getCantidadActivoVirtualAV()+"</cantidad_activo_virtual>\n" +
			    							"         <hash_operacion>"+operVulnerablesBean.getHashOperacionAV()+"</hash_operacion>\n" +
			    							"        </activo_virtual>\n" +
			    							"       </compra>\n" +
			    							"      </operaciones_compra>\n" +
			    							//OPERACIONES DE VENTA
			    							"      <operaciones_venta>\n" +//--ACTUALMENTE EL SAFI NO CEUNTA CON OPERACIONES DE VENTA
			    							"       <venta>\n" +
			    							"        <fecha_hora_operacion>"+operVulnerablesBean.getFechaHoraOperacionV()+"</fecha_hora_operacion>\n" +
			    							"        <moneda_operacion>"+operVulnerablesBean.getMonedaOperacionV()+"</moneda_operacion>\n" +
			    							"        <monto_operacion>"+operVulnerablesBean.getMontoOperacionV()+"</monto_operacion>\n" +
			    							"        <activo_virtual>\n" +
			    							"         <activo_virtual_operado>"+operVulnerablesBean.getActivoVirtualOperadoVAV()+"</activo_virtual_operado>\n" +
			    							"         <descripcion_activo_virtual>"+operVulnerablesBean.getDescripcionActivoVirtualVAV()+"</descripcion_activo_virtual>\n" +
			    							"         <tipo_cambio_mn>"+operVulnerablesBean.getTipoCambioMnVAV()+"</tipo_cambio_mn>\n" +
			    							"         <cantidad_activo_virtual>"+operVulnerablesBean.getCantidadActivoVirtualVAV()+"</cantidad_activo_virtual>\n" +
			    							"         <hash_operacion>"+operVulnerablesBean.getHashOperacionVAV()+"</hash_operacion>\n" +
			    							"        </activo_virtual>\n" +
			    							"       </venta>\n" +
			    							"      </operaciones_venta>\n" +
			    							//OPERACIONES DE INTERCAMBIO
			    							"      <operaciones_intercambio>\n" +//--ACTUALMENTE EL SAFI NO CEUNTA CON OPERACIONES DE INTERCAMBIO
			    							"       <intercambio>\n" +
			    							"        <fecha_hora_operacion>"+operVulnerablesBean.getFechaHoraOperacionOI()+"</fecha_hora_operacion>\n" +
			    							"        <activo_virtual_enviado>\n" +
			    							"         <activo_virtual>\n" +
			    							"          <activo_virtual_operado>"+operVulnerablesBean.getActivoVirtualOperadoOIAV()+"</activo_virtual_operado>\n" +
			    							"          <descripcion_activo_virtual>"+operVulnerablesBean.getDescripcionActivoVirtualOIAV()+"</descripcion_activo_virtual>\n" +
			    							"          <tipo_cambio_mn>"+operVulnerablesBean.getTipoCambioMnOIAV()+"</tipo_cambio_mn>\n" +
			    							"          <cantidad_activo_virtual>"+operVulnerablesBean.getCantidadActivoVirtualOIAV()+"</cantidad_activo_virtual>\n" +
			    							"          <monto_operacion_mn>"+operVulnerablesBean.getMontoOperacionMnOIAV()+"</monto_operacion_mn>\n" +
			    							"         </activo_virtual>\n" +
			    							"        </activo_virtual_enviado>\n" +
			    							"         <activo_virtual>\n" +
			    							"          <activo_virtual_operado>"+operVulnerablesBean.getActivoVirtualOperadoOIAR()+"</activo_virtual_operado>\n" +
			    							"          <tipo_cambio_mn>"+operVulnerablesBean.getTipoCambioMnOIAR()+"</tipo_cambio_mn>\n" +
			    							"          <cantidad_activo_virtual>"+operVulnerablesBean.getCantidadActivoVirtualOIAR()+"</cantidad_activo_virtual>\n" +
			    							"          <monto_operacion_mn>"+operVulnerablesBean.getMontoOperacionMnOIAR()+"</monto_operacion_mn>\n" +
			    							"          <hash_operacion>"+operVulnerablesBean.getHashOperacionOIAR()+"</hash_operacion>\n" +
			    							"          <descripcion_activo_virtual>"+operVulnerablesBean.getDescripcionActivoVirtualOIAR()+"</descripcion_activo_virtual>\n" +
			    							"         </activo_virtual>\n" +
			    							"        <activo_virtual_recibido>\n" +
			    							"        </activo_virtual_recibido>\n" +
			    							"       </intercambio>\n" +
			    							"      </operaciones_intercambio>\n" +
			    							//OPERACIONES DE TRANSFERENCIA
			    							"      <operaciones_transferencia>\n" +//--ACTUALMENTE EL SAFI NO CEUNTA CON OPERACIONES DE TRANFERENCIAS
			    							"       <transferencias_enviadas>\n" +//TRANSFERENCIAS ENVIADAS
			    							"        <envio>\n" +
			    							"         <fecha_hora_operacion>"+operVulnerablesBean.getFechaHoraOperacionOTE()+"</fecha_hora_operacion>\n" +
			    							"         <monto_operacion_mn>"+operVulnerablesBean.getMontoOperacionMnOTE()+"</monto_operacion_mn>\n" +
			    							"        </envio>\n" +
			    							"        <activo_virtual>\n" +
			    							"         <activo_virtual_operado>"+operVulnerablesBean.getActivoVirtualOperadoOTAV()+"</activo_virtual_operado>\n" +
			    							"         <descripcion_activo_virtual>"+operVulnerablesBean.getDescripcionActivoVirtualOTAV()+"</descripcion_activo_virtual>\n" +
			    							"         <tipo_cambio_mn>"+operVulnerablesBean.getTipoCambioMnOTAV()+"</tipo_cambio_mn>\n" +
			    							"         <cantidad_activo_virtual>"+operVulnerablesBean.getCantidadActivoVirtualOTAV()+"</cantidad_activo_virtual>\n" +
			    							"         <hash_operacion>"+operVulnerablesBean.getHashOperacionOTAV()+"</hash_operacion>\n" +
			    							"        </activo_virtual>\n" +
			    							"       </transferencias_enviadas>\n" +		
			    							"       <transferencias_recibidas>\n" +//TRANSFERENCIAS RECIBIDAS
			    							"        <recepcion>\n" +
			    							"         <fecha_hora_operacion>"+operVulnerablesBean.getFechaHoraOperacionTR()+"</fecha_hora_operacion>\n" +
			    							"         <monto_operacion_mn>"+operVulnerablesBean.getMontoOperacionMnTR()+"</monto_operacion_mn>\n" +
			    							"         <activo_virtual>\n" +
			    							"          <activo_virtual_operado>"+operVulnerablesBean.getActivoVirtualOperadoTRA()+"</activo_virtual_operado>\n" +
			    							"          <descripcion_activo_virtual>"+operVulnerablesBean.getDescripcionActivoVirtualTRA()+"</descripcion_activo_virtual>\n" +
			    							"          <tipo_cambio_mn>"+operVulnerablesBean.getTipoCambioMnTRA()+"</tipo_cambio_mn>\n" +
			    							"          <cantidad_activo_virtual>"+operVulnerablesBean.getCantidadActivoVirtualTRA()+"</cantidad_activo_virtual>\n" +
			    							"          <hash_operacion>"+operVulnerablesBean.getHashOperacionTRA()+"</hash_operacion>\n" +
			    							"         </activo_virtual>\n" +
			    							"        </recepcion>\n" +
			    							"       </transferencias_recibidas>\n" +
			    							"      </operaciones_transferencia>\n" +
			    							//OPERACIONES DE FONDOS
			    							"      <operaciones_fondos>\n" +
			    							"       <fondos_retirados>\n" +//FONDOS DE RETIRO
			    							"        <retiro>\n" +
			    							"         <fecha_hora_operacion>"+operVulnerablesBean.getFechaHoraOperacionFR()+"</fecha_hora_operacion>\n" +
			    							"         <instrumento_monetario>"+operVulnerablesBean.getInstrumentoMonetarioFR()+"</instrumento_monetario>\n" +
			    							"         <moneda_operacion>"+operVulnerablesBean.getMonedaOperacionFR()+"</moneda_operacion>\n" +
			    							"         <monto_operacion>"+operVulnerablesBean.getMontoOperacionFR()+"</monto_operacion>\n" +
			    							"         <datos_beneficiario>\n" +
			    							"          <tipo_persona>\n" +
			    							"           <persona_fisica>\n" +
			    							"            <nombre>"+operVulnerablesBean.getNombreFRPF()+"</nombre>\n" +
			    							"            <apellido_paterno>"+operVulnerablesBean.getApellidoPaternoFRPF()+"</apellido_paterno>\n" +
			    							"            <apellido_materno>"+operVulnerablesBean.getApellidoMaternoFRPF()+"</apellido_materno>\n" +
			    							"           </persona_fisica>\n" +
			    							"           <persona_moral>\n" +
			    							"            <denominacion_razon>"+operVulnerablesBean.getDenominacionRazonFRPF()+"</denominacion_razon>\n" +
			    							"           </persona_moral>\n" +
			    							"          </tipo_persona>\n" +
			    							"          <nacionalidad_cuenta>\n" +
			    							"           <nacional>\n" +
			    							"            <clabe_destino>"+operVulnerablesBean.getClabeDestinoFRN()+"</clabe_destino>\n" +
			    							"            <clave_institucion_financiera>"+operVulnerablesBean.getClaveInstitucionFinancieraFRN()+"</clave_institucion_financiera>\n" +
			    							"           </nacional>\n" +
			    							"           <extranjero>\n" +
			    							"            <numero_cuenta>"+operVulnerablesBean.getNumeroCuentaFRE()+"</numero_cuenta>\n" +
			    							"            <nombre_banco>"+operVulnerablesBean.getNombreBancoFRE()+"</nombre_banco>\n" +
			    							"           </extranjero>\n" +
			    							"          </nacionalidad_cuenta>\n" +
			    							"         </datos_beneficiario>\n" +
			    							"        </retiro>\n" +
			    							"       </fondos_retirados>\n" +
			    							"       <fondos_depositados>\n" +//FONDOS DE DEPOSITOS
			    							"        <deposito>\n" +
			    							"         <fecha_hora_operacion>"+operVulnerablesBean.getFechaHoraOperacionFD()+"</fecha_hora_operacion>\n" +
			    							"         <instrumento_monetario>"+operVulnerablesBean.getInstrumentoMonetarioFD()+"</instrumento_monetario>\n" +
			    							"         <moneda_operacion>"+operVulnerablesBean.getMonedaOperacionFD()+"</moneda_operacion>\n" +
			    							"         <monto_operacion>"+operVulnerablesBean.getMontoOperacionFD()+"</monto_operacion>\n" +
			    							"         <datos_ordenante>\n" +
			    							"          <tipo_persona>\n" +
			    							"           <persona_fisica>\n" +
			    							"            <nombre>"+operVulnerablesBean.getNombreFDPF()+"</nombre>\n" +
			    							"            <apellido_paterno>"+operVulnerablesBean.getApellidoPaternoFDPF()+"</apellido_paterno>\n" +
			    							"            <apellido_materno>"+operVulnerablesBean.getApellidoMaternoFDPF()+"</apellido_materno>\n" +
			    							"           </persona_fisica>\n" +
			    							"           <persona_moral>\n" +
			    							"            <denominacion_razon>"+operVulnerablesBean.getDenominacionRazonFDPM()+"</denominacion_razon>\n" +
			    							"           </persona_moral>\n" +
			    							"          </tipo_persona>\n" +
			    							"          <nacionalidad_cuenta>\n" +
			    							"           <nacional>\n" +
			    							"            <clabe_destino>"+operVulnerablesBean.getClabeDestinoFDN()+"</clabe_destino>\n" +
			    							"            <clave_institucion_financiera>"+operVulnerablesBean.getClaveInstitucionFinancieraFDN()+"</clave_institucion_financiera>\n" +
			    							"           </nacional>\n" +
			    							"           <extranjero>\n" +
			    							"            <numero_cuenta>"+operVulnerablesBean.getNumeroCuentaFDE()+"</numero_cuenta>\n" +
			    							"            <nombre_banco>"+operVulnerablesBean.getNombreBancoFDE()+"</nombre_banco>\n" +
			    							"           </extranjero>\n" +
			    							"          </nacionalidad_cuenta>\n" +
			    							"         </datos_ordenante>\n" +
			    							"        </deposito>\n" +
			    							"       </fondos_depositados>\n" +
			    							"      </operaciones_fondos>\n" +
			    							"     </detalle_operaciones>\n" +
			    							"    </operaciones_persona>\n"
			    							);
			  }
			  escribeArchivo(rutaCompleta,"   </aviso>");
			  escribeArchivo(rutaCompleta, " </informe>");
			  
			  File archivoFile = new File(rutaCompleta);
			  FileInputStream fileInputStream = new FileInputStream(archivoFile);
			  response.addHeader("Content-Disposition","attachment; filename="+nombreXml);
			  response.setContentType("application/xml");
			  response.setContentLength((int) archivoFile.length());
			
			  int bytes;
			
			  while ((bytes = fileInputStream.read()) != -1) {
				response.getOutputStream().write(bytes);
			  }
			  fileInputStream.close();
			  response.getOutputStream().flush();
			  response.getOutputStream().close();
			  //Borramos el archivo para que no consuma memoria del servidor
			  borrarArchivo(rutaCompleta);
			  
			  return null;
			}
			catch (Exception e)
			{
			  e.printStackTrace();
			  String htmlString = Constantes.htmlErrorReporteOperVulnerables;
			  response.addHeader("Content-Disposition", "");
			  response.setContentType(contentOriginal);
			  response.setContentLength(htmlString.length());
			  return new ModelAndView("resultadoTransaccionReporteVista", "reporte", htmlString);
	    }
		
	}
	
	 public void borrarArchivo(String fileName){
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
	 
	public OperVulnerablesServicio getOperVulnerablesServicio() {
		return operVulnerablesServicio;
	}
	public void setOperVulnerablesServicio(
			OperVulnerablesServicio operVulnerablesServicio) {
		this.operVulnerablesServicio = operVulnerablesServicio;
	}
	public String getSuccessView() {
		return successView;
	}
	public void setSuccessView(String successView) {
		this.successView = successView;
	}
		
	
}
