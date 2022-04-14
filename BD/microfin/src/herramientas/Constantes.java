package herramientas;

import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFFont;

public class Constantes {

	public static int PaginacionEstandar = 50;
	public static String salidaNO = "N";
	public static String salidaSI = "S";
	public static int IntentosPoliza = 3;
	public static int ErrorGenerico = 999;
	public static String ES_FINIQUITO_NO = "N";
	public static String ES_FINIQUITO_SI = "S";
	public static String ES_PREPAGO_NO = "N";
	public static String ES_PREPAGO_SI = "S";
	public static int CODIGO_SIN_ERROR 	= 0;

	public static String SALTO_LINEA = "\n";
	public static String NO_APLICA = "N/A";
	
	public static String RUTA_IMAGENES = 	System.getProperty("file.separator") + "opt" +
	  										System.getProperty("file.separator") + "tomcat6" +
	  										System.getProperty("file.separator") + "webapps" +
					  						System.getProperty("file.separator") + "microfin" +
					  						System.getProperty("file.separator") + "images";
	
	public static String MSG_ERROR = "Estimado Usuario(a), Ha ocurrido una falla en el sistema, " +
										"estamos trabajando para resolverla. Disculpe las molestias que " +
										"esto le ocasiona.";
	
	public static String LEYENDA_ESTADO_CUENTA = "Pagare";
	
	
	public static String 	STRING_VACIO 	= "";
	public static String 	STRING_CERO 	= "0";
	public static String 	STRING_DECIMALCERO 	= "0.00";
	public static String 	STRING_SI		= "S";
	public static String 	STRING_NO		= "N";
	public static int 		ENTERO_CERO 	= 0;
	public static int 		ENTERO_UNO 		= 1;
	public static String 	FECHA_VACIA		="1900-01-01";
	public static Double  DOUBLE_VACIO = 0.0;
	public static String PARENTESIS_ABRE = "(";
	public static String PARENTESIS_CIERRA = ")";
	public static String ASTERISCO = "****";
	public static String 	MODO_PAGO_EFECTIVO = "E";
	public static String 	ORIGEN_PAGO_VENTANILLA = "V";
	public static String 	ORIGEN_PAGO_CARGOCTA = "C";
	public static String 	ORIGEN_PAGO_WS = "W";
	public static String 	ORIGEN_PAGO_OTROS = "O";
	public static String 	ORIGEN_PAGO_COBRANZA = "B";
	public static String 	MODO_PAGO_CARGO_CUENTA = "C";
	public static String CLIENTE_SOCIO = "safilocale.cliente";
	public static int DETECCION_PLD = 50;
	public static int ESCALAMIENTO_PLD = 501;
	public static int ESCALAMIENTO_PLD_EXITO = 502;
	public static String TipoPersSAFI_CTE = "CTE";

	public static interface Enum_TipoPersonaSAFI {
		String NoAplica = "NA";		// No aplica debido a que se inicia un nuevo registro.
		String Cliente = "CTE";
	}
	
	/* Constantes para Mensajes de Correo */
	public static String CORREO_CONTACTO =""+
		"<HR width='100%'>" +
		"<FONT STYLE='font-family: arial,helvetica,tahoma,verdana; font weight: bold ;font-size: 14px ;color: 333333 ;text-decoration: none;'>" +
		"Para cualquier duda o aclaraci&oacute;n ponemos a su disposici&oacute;n " +
		"el Centro de Atenci&oacute;n a Clientes, desde la Ciudad de Puebla al 1234567 o fuera del &aacute;rea metropolitana al " +
		"01 800 ACCIONYE (56542787) , o escribir un correo electr&oacute;nico a atencion@aye.com.mx" +
		"</FONT>" +
		"<p>&nbsp;</p>" +
		"<p>&nbsp;</p>";
		
	public static String CORREO_APERTURA_CUENTA = "" +
	"<TABLE WIDTH='600' style='border:solid 1px #242424' CELLSPACING='1' CELLPADDING='1' ALIGN='left' VALIGN='TOP'>" +
		"<TR><TD><img src='cid:logoPeq'></TD></TR>" +
		"<TR><TD>" + 
		"<TABLE BORDER='0' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1'>" +
		"<TR>" +
			"<TD ALIGN='CENTER' BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: CCCCCC ;text-decoration: none;'>" +
	      	"BIENVENIDO A %NombreEmpresa%" +
	      "</TD>" +
		"</TR>" +
		"<TR>" +
    		"<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>" +
    			"ESTIMADO(A): %NombreCliente%" +
    		"</TD>" +
		"</TR>" +
		"<TR>" +
    		"<TD>&nbsp;</TD>" +
		"</TR>" +
		"<TR>" +	    		
			"<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>" +	    			
    			"Gracias por aperturar una cuenta en %NombreEmpresa%. Como uno de los lideres en el Medio " +
    			"de las MicroFinanzas, podemos asegurarle que nuestras soluciones y productos financieros " +
    			"lo sastifaceran." +
    		"</TD>" +
    	"</TR>" +
		"<TR>" +
    		"<TD>&nbsp;</TD>" +
		"</TR>" +
    	"<TR>" +
			"<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>" +	    			
    			"Sabemos que quedara realmente conforme con la excelencia y calidad en el servicio que " +
    			"brindamos a nuestros Clientes." +
    		"</TD>" +
		"</TR>" +
		"<TR>" +
    		"<TD>&nbsp;</TD>" +
		"</TR>" +			
		"<TR>" +
    		"<TD>" +
    			"<TABLE BORDER='0' CELLSPACING='1'  ALIGN='LEFT' VALIGN='CENTER' CELLPADDING='1'>" +
					"<TR>" +	    		
						"<TD ALIGN='LEFT' WIDTH='150px' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 11px;color: 333333 ;text-decoration: none;'>" +	    			
			    			"Numero de Cuenta:" +
			    		"</TD>" +
			    		"<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>" +	    			
			    			"%Cuenta%" +
			    		"</TD>" +
			    	"</TR>" +
					"<TR>" +	    		
						"<TD ALIGN='LEFT' WIDTH='150px' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 11px;color: 333333 ;text-decoration: none;'>" +	    			
			    			"Cuenta CLABE:" +
			    		"</TD>" +
			    		"<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>" +	    			
			    			"%CuentaCLABE%" +
			    		"</TD>" +
			    	"</TR>" +				    	
				"</TABLE>" +
    		"</TD>" +
		"</TR>" +
	"</TABLE>" +
	"</TD></TR>" +
	"</TABLE>" +
	"<p>&nbsp;</p><p>&nbsp;</p>" +
	"<p>&nbsp;</p><p>&nbsp;</p>" +
	"<p>&nbsp;</p><p>&nbsp;</p>" +
	"<p>&nbsp;</p><p>&nbsp;</p>" +
	"</BR></BR>" +
	"</BR></BR>" +
	"</BR></BR>" + CORREO_CONTACTO;
	
	
	public static String CORREO_OPE_INTERNAS= "" +


"<TABLE BORDER='1' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1'>"+
"<TR>"+
	"<TD ALIGN='CENTER' BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color:"+ "FFFFFF ;text-decoration: none;'>"+
	"Reporte Operaciones Internas Preocupantes"+
	"</TD>"+
"</TR>"+
"<TABLE BORDER='1' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1'>"+
"<TR>"+
	"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;'>Folio</TD>"+
	"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;'>Empleado Reportado</TD>"+
	"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;'>Cte./Socio Involucrado</TD>"+
	"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;'>Fecha</TD>"+
	"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;'>Motivo/Descripci&oacute;n</TD>"+
"</TR>"+
"<TR>"+
"	<TD STYLE='font-family: arial,helvetica,tahoma,verdana; font-size: 13px;color: 000000 ;text-decoration: none;'> %NumeroFolio%</TD>"+
"	<TD STYLE='font-family: arial,helvetica,tahoma,verdana; font-size: 13px;color: 000000 ;text-decoration: none;'>  %PersonaRep%</TD>"+
"	<TD STYLE='font-family: arial,helvetica,tahoma,verdana; font-size: 13px;color: 000000 ;text-decoration: none;'> %CteInv%</TD>"+
"	<TD STYLE='font-family: arial,helvetica,tahoma,verdana; font-size: 13px;color: 000000 ;text-decoration: none;'> %Fecha%</TD>"+
"	<TD STYLE='font-family: arial,helvetica,tahoma,verdana; font-size: 13px;color: 000000 ;text-decoration: none;'> Ha sido reportada una Operaci&oacute;n preocupante:<BR>%Motivo%<BR><BR>%Descripcion%</TD>"+
"</TR>"+
"</TABLE>"+
"</TABLE></TABLE>";
	

	public static String CORREO_OPE_INUSUAL= "" +
			"<TABLE BORDER='1' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1'>"+
			"<TR>"+
				"<TD ALIGN='CENTER' BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color:"+ "FFFFFF ;text-decoration: none;'>"+
				"Reporte Operaciones Inusuales"+
				"</TD>"+
			"</TR>"+
			"<TABLE BORDER='1' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1'>"+
			"<TR>"+
				"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;'>Folio</TD>"+
				"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;'>Cte./Socio Reportado</TD>"+
				"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;'>Empleado Involucrado</TD>"+
				"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;'>Fecha</TD>"+
				"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;'>Motivo/Descripci&oacute;n</TD>"+
			"</TR>"+
			"<TR>"+
			"<TD STYLE='font-family: arial,helvetica,tahoma,verdana; font-size: 13px;color: 000000 ;text-decoration: none;'> %NumeroFolio%</TD>"+
			"<TD STYLE='font-family: arial,helvetica,tahoma,verdana; font-size: 13px;color: 000000 ;text-decoration: none;'> %PersonaRep%</TD>"+
			"<TD STYLE='font-family: arial,helvetica,tahoma,verdana; font-size: 13px;color: 000000 ;text-decoration: none;'> %EmpInv%</TD>"+
			"<TD STYLE='font-family: arial,helvetica,tahoma,verdana; font-size: 13px;color: 000000 ;text-decoration: none;'> %Fecha%</TD>"+
			"<TD STYLE='font-family: arial,helvetica,tahoma,verdana; font-size: 13px;color: 000000 ;text-decoration: none;'> Ha sido reportada una Operaci&oacute;n Inusual:<BR>%Motivo%<BR><BR>%Descripcion%<BR></TD>"+
			"</TR>"+
			"</TABLE>"+
			"</TABLE>";
	
	public static String htmlErrorReporte = ""+
	"<TABLE WIDTH='600' style='border:solid 1px #242424' CELLSPACING='1' CELLPADDING='1' ALIGN='left' VALIGN='TOP'>" +
	"<TR><TD>" + 
	"<TABLE BORDER='0' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1'>" +
		"<TR>" +
			"<TD ALIGN='CENTER' BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: CCCCCC ;text-decoration: none;'>" +
				"Error al Procesar el Reporte" +
			"</TD>" +
		"</TR>" +
		"<TR>" +
			"<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>" +
				"Ha ocurrido Un Error al generar el Reporte. Le sugerimos contactar a la Mesa de Ayuda o Help Desk " +
			"</TD>" +
		"</TR>" +
		"<TR>" +
			"<TD>&nbsp;</TD>" +
		"</TR>" +
	"</TABLE>" +
	"</TD>" +
	"</TR>" +
	"</TABLE>";
	
	public static String htmlErrorEdoCtaPDF = ""+
			"<TABLE WIDTH='600' style='border:solid 1px #242424' CELLSPACING='1' CELLPADDING='1' ALIGN='left' VALIGN='TOP'>" +
			"<TR><TD>" + 
			"<TABLE BORDER='0' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1'>" +
				"<TR>" +
					"<TD ALIGN='CENTER' BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: CCCCCC ;text-decoration: none;'>" +
						"Informaci&oacute;n no Encontrada"+
					"</TD>" +
				"</TR>" +
				"<TR>" +
					"<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>" +
						"No Existe Informaci&oacute;n Para Generar el Estado de Cuenta Unico. </br>" +
						"Para el Cliente y Periodo Seleccionado" +
					"</TD>" +
				"</TR>" +
				"<TR>" +
					"<TD>&nbsp;</TD>" +
				"</TR>" +
			"</TABLE>" +
			"</TD>" +
			"</TR>" +
			"</TABLE>";	
	
	public static String htmlErrorVerArchivoCliente = ""+
			"<TABLE WIDTH='600' style='border:solid 1px #242424' CELLSPACING='1' CELLPADDING='1' ALIGN='left' VALIGN='TOP'>" +
			"<TR><TD>" + 
			"<TABLE BORDER='0' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1'>" +
				"<TR>" +
					"<TD ALIGN='CENTER' BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: CCCCCC ;text-decoration: none;'>" +
						"Informaci&oacute;n no Encontrada"+
					"</TD>" +
				"</TR>" +
				"<TR>" +
					"<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>" +
						"El Archivo no esta Disponible. </br>" +
						"Para el Cliente seleccionado" +
					"</TD>" +
				"</TR>" +
				"<TR>" +
					"<TD>&nbsp;</TD>" +
				"</TR>" +
			"</TABLE>" +
			"</TD>" +
			"</TR>" +
			"</TABLE>";	
	public static String htmlErrorReporteOperVulnerables= ""+
			"<TABLE WIDTH='600' style='border:solid 1px #242424' CELLSPACING='1' CELLPADDING='1' ALIGN='left' VALIGN='TOP'>" +
			"<TR><TD>" + 
			"<TABLE BORDER='0' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1'>" +
				"<TR>" +
					"<TD ALIGN='CENTER' BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: CCCCCC ;text-decoration: none;'>" +
						"Ocurrio un error al generar el reporte"+
					"</TD>" +
				"</TR>" +
				"<TR>" +
					"<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>" +
						"En reporte ya fue generado o no existe informaci&oacute;n a reportar del año y mes seleccionado. </br>" +
					"</TD>" +
				"</TR>" +
				"<TR>" +
					"<TD>&nbsp;</TD>" +
				"</TR>" +
			"</TABLE>" +
			"</TD>" +
			"</TR>" +
			"</TABLE>";	
	
	public static String htmlErrorReporteCirculo = ""+
			"<TABLE WIDTH='600' style='border:solid 1px #242424' CELLSPACING='1' CELLPADDING='1' ALIGN='left' VALIGN='TOP'>" +
			"<TR><TD>" + 
			"<TABLE BORDER='0' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1'>" +
				"<TR>" +
					"<TD ALIGN='CENTER' BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: CCCCCC ;text-decoration: none;'>" +
						"Informaci&oacute;n no Encontrada"+
					"</TD>" +
				"</TR>" +
				"<TR>" +
					"<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>" +
						"Ocurrio un error al generar el reporte. </br>" +
					"</TD>" +
				"</TR>" +
				"<TR>" +
					"<TD>&nbsp;</TD>" +
				"</TR>" +
			"</TABLE>" +
			"</TD>" +
			"</TR>" +
			"</TABLE>";	
	
	public static String htmlErrorVerArchivoCuenta = ""+
			"<TABLE WIDTH='600' style='border:solid 1px #242424' CELLSPACING='1' CELLPADDING='1' ALIGN='left' VALIGN='TOP'>" +
			"<TR><TD>" + 
			"<TABLE BORDER='0' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1'>" +
				"<TR>" +
					"<TD ALIGN='CENTER' BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: CCCCCC ;text-decoration: none;'>" +
						"Informaci&oacute;n no Encontrada"+
					"</TD>" +
				"</TR>" +
				"<TR>" +
					"<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>" +
						"El Archivo no esta Disponible. </br>" +
						"Para la Cuenta seleccionada" +
					"</TD>" +
				"</TR>" +
				"<TR>" +
					"<TD>&nbsp;</TD>" +
				"</TR>" +
			"</TABLE>" +
			"</TD>" +
			"</TR>" +
			"</TABLE>";	
	
	public static String htmlErrorVerArchivoFactura = ""+
			"<TABLE WIDTH='600' style='border:solid 1px #242424' CELLSPACING='1' CELLPADDING='1' ALIGN='left' VALIGN='TOP'>" +
			"<TR><TD>" + 
			"<TABLE BORDER='0' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1'>" +
				"<TR>" +
					"<TD ALIGN='CENTER' BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: CCCCCC ;text-decoration: none;'>" +
						"Informaci&oacute;n no Encontrada"+
					"</TD>" +
				"</TR>" +
				"<TR>" +
					"<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>" +
						"El Archivo no esta Disponible. </br>" +
						"Para la Factura seleccionada" +
					"</TD>" +
				"</TR>" +
				"<TR>" +
					"<TD>&nbsp;</TD>" +
				"</TR>" +
			"</TABLE>" +
			"</TD>" +
			"</TR>" +
			"</TABLE>";	
	public static String ACTUALIZA_EMPLEADO_NOMINA =""+
			"<HR width='100%'>" +
			"<FONT STYLE='font-family: arial,helvetica,tahoma,verdana; font weight: bold ;font-size: 14px ;color: 333333 ;text-decoration: none;'>" +
			"Se ha realizado una modificaci&oacute;n en el cambio " +
			"de estatus de un empleado de N&oacute;mina " +
			"</FONT>" +
			"<p>&nbsp;</p>" +
			"<p>&nbsp;</p>";
	
	public static String CORREO_SEGTO_SUPERV= "" +
			"<TABLE WIDTH='600' style='border:solid 1px #242424' CELLSPACING='1' CELLPADDING='1' ALIGN='left' VALIGN='TOP'>" +
			"<TR><TD><img src='cid:logoPeq'></TD></TR>" +
			"<TR><TD>" + 
			"<TABLE BORDER='0' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1'>" +
			"<TR>" +
				"<TD ALIGN='CENTER' BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: CCCCCC ;text-decoration: none;'>" +
		      	"%NombreEmpresa%" +
		      "</TD>" +
			"</TR>" +
			"<TR>" +
	    		"<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>" +
	    		"</TD>" +
			"</TR>" +
			"<TR>" +
	    		"<TD>&nbsp;</TD>" +
			"</TR>" +
			"<TR>" +	    		
				"<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>" +	    			
	    			"Ha sido requerida su intervencion en el Seguimiento: %NumeroSeguimiento%, con numero consecutivo: %Consecutivo% "+
				"<BR>"+
					"Referencia: %NomCliente%      Gestor: %NomGestor%"+
	    		"</TD>" +
	    	"</TR>" +
			"<TR>" +
	    		"<TD>&nbsp;</TD>" +
			"</TR>" +
			"<TR>" +
	    		"<TD>&nbsp;</TD>" +
			"</TR>" +
		"</TABLE>" +
		"</TD></TR>" +
		"</TABLE>" +
		"<p>&nbsp;</p><p>&nbsp;</p>" +
		"<p>&nbsp;</p><p>&nbsp;</p>" +
		"<p>&nbsp;</p><p>&nbsp;</p>" +
		"<p>&nbsp;</p><p>&nbsp;</p>" +
		"</BR></BR>" +
		"</BR></BR>" ;

	public static String CORREO_EDO_CTA= "" +
			"<TABLE WIDTH='600' style='border:solid 1px #242424' CELLSPACING='1' CELLPADDING='1' ALIGN='left' VALIGN='TOP'>" +
			"<TR><TD><img src='cid:logoPeq'></TD></TR>" +
			"<TR><TD>" + 
			"<TABLE BORDER='0' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1'>" +
			"<TR>" +
				"<TD ALIGN='CENTER' BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: CCCCCC ;text-decoration: none;'>" +
		      	"%NombreEmpresa%" +
		      "</TD>" +
			"</TR>" +
			"<TR>" +
	    		"<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>" +
	    		"</TD>" +
			"</TR>" +
			"<TR>" +
	    		"<TD>&nbsp;</TD>" +
			"</TR>" +
			"<TR>" +	    		
				"<TD ALIGN='LEFT' BGCOLOR='FFFFFF' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: normal;font-size: 11px;color: 333333 ;text-decoration: none;'>" +	    			
	    			"La generaci&oacute;n de Estados de Cuenta ha Finalizado Correctamente."+
	    		"<BR>"+
					"Total de Estados de Cuenta Generados: %NumTotalEdoCta%"+
				"<BR>"+
					"Total Timbrados Exitosos: %NumTotalTimbres%"+
	    		"</TD>" +
	    	"</TR>" +
			"<TR>" +
	    		"<TD>&nbsp;</TD>" +
			"</TR>" +
			"<TR>" +
	    		"<TD>&nbsp;</TD>" +
			"</TR>" +
		"</TABLE>" +
		"</TD></TR>" +
		"</TABLE>" +
		"<p>&nbsp;</p><p>&nbsp;</p>" +
		"<p>&nbsp;</p><p>&nbsp;</p>" +
		"<p>&nbsp;</p><p>&nbsp;</p>" +
		"<p>&nbsp;</p><p>&nbsp;</p>" +
		"</BR></BR>" +
		"</BR></BR>" ;
	

	public static String CORREO_OPE_ESCALAMIENTO = "" +
		"<TABLE BORDER='0' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1'>"+
		"<TR>"+
			"<TD ALIGN='CENTER' BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color:"+ "FFFFFF ;text-decoration: none;'>"+
			"Aviso por Gesti&oacute;n Escalamiento Interno"+
			"</TD>"+
		"</TR>"+
		"<TABLE BORDER='0' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1'>"+
		"<TR>"+
			"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;'>Folio</TD>"+
			"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;'>%PersInvolucrada%</TD>"+
			"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;'>Usuario Gesti&oacute;n</TD>"+
			"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;'>Fecha de Gesti&oacute;n</TD>"+
			"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px;color: FFFFFF ;text-decoration: none;'>Motivo/Descripci&oacute;n</TD>"+
		"</TR>"+
		"<TR>"+
			"<TD STYLE='font-family: arial,helvetica,tahoma,verdana; font-size: 13px;color: 000000 ;text-decoration: none; white-space: nowrap;'> %NumeroFolio%</TD>"+
			"<TD STYLE='font-family: arial,helvetica,tahoma,verdana; font-size: 13px;color: 000000 ;text-decoration: none;'> %CteInv%</TD>"+
			"<TD STYLE='font-family: arial,helvetica,tahoma,verdana; font-size: 13px;color: 000000 ;text-decoration: none;'> %UsuarioGestion%</TD>"+
			"<TD STYLE='font-family: arial,helvetica,tahoma,verdana; font-size: 13px;color: 000000 ;text-decoration: none; white-space: nowrap;'> %Fecha%</TD>"+
			"<TD STYLE='font-family: arial,helvetica,tahoma,verdana; font-size: 13px;color: 000000 ;text-decoration: none;'> "+
				"<b>Ha sido autorizada una Operaci&oacute;n de Gesti&oacute;n Escalamiento Interno:</b>"+
				"<BR>Proceso: %Proceso%<BR>Justificaci&oacute;n: %Justificacion%<BR>Detalle de la decisi&oacute;n: %Comentarios%</TD>"+
		"</TR>"+
		"</TABLE>"+
		"</TABLE></TABLE>";
	
	public static String CORREO_SOL_ESCALAMIENTO = "" +
			"<TABLE BORDER='0' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1' STYLE='font-family: arial,helvetica,tahoma,verdana;'>"+
				"<TR>"+
					"<TD ALIGN='CENTER' BGCOLOR='04B431' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px; color: FFFFFF ;text-decoration: none;'>"+
						"Solicitud para Gesti&oacute;n de Escalamiento Interno"+
					"</TD>"+
				"</TR>"+
				"<TABLE BORDER='0' WIDTH='100%' CELLSPACING='1'  ALIGN='CENTER' VALIGN='CENTER' CELLPADDING='1' STYLE='font-family: arial,helvetica,tahoma,verdana;'>"+
					"<TR>"+
						"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px; color: FFFFFF ;text-decoration: none; white-space: nowrap;'>No. Operaci&oacute;n</TD>"+
						"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px; color: FFFFFF ;text-decoration: none;'>No. Cliente</TD>"+
						"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px; color: FFFFFF ;text-decoration: none;'>Fecha</TD>"+
						"<TD BGCOLOR='0182C4' STYLE='font-family: arial,helvetica,tahoma,verdana; font-weight: bold;font-size: 13px; color: FFFFFF ;text-decoration: none;'>Descripci&oacute;n</TD>"+
					"</TR>"+
					"<TR>"+
						"<TD> %NumeroOperacion%</TD>"+
						"<TD> %CteInv%</TD>"+
						"<TD STYLE='white-space: nowrap;'> %Fecha%</TD>"+
						"<TD> "+
							"Se requiere la Gesti&oacute;n de una Operaci&oacute;n en Gesti&oacute;n de Escalamiento Interno."+
							"<BR><b>Proceso:</b> %Proceso%."+
						"</TD>"+
					"</TR>"+
				"</TABLE>"+
			"</TABLE>";
	
	public static String ENCABEZADO_CORREO_BM="<html>"
			+ "<head>"
			+ "<meta charset=utf-8>"
			+ " <style>.invoice-box{"
			+ " max-width:800px;"
			+ " margin:auto;"
			+ "padding:30px;"
			+ " border:1px solid #eee;"
			+ "box-shadow:0 0 10px rgba(0, 0, 0, .15);"
			+ "font-size:16px;"
			+ "line-height:24px;"
			+ "font-family:'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif;"
			+ "color:#555;"
			+ "}"
			+ ".invoice-box table{"
			+ "width:100%;"
			+ "line-height:inherit;"
			+ "text-align:left;"
			+ "}"
			+ ".invoice-box table td{"
			+ "padding:5px;"
			+ "vertical-align:top;"
			+ "}"
			+ ".invoice-box table tr td:nth-child(2){"
			+ "text-align:right;"
			+ " }"
			+ ".invoice-box table tr.top table td{"
			+ "padding-bottom:20px;"
			+ "}"
			+ ".invoice-box table tr.top table td.title{"
			+ "font-size:45px;"
			+ "line-height:45px;"
			+ "color:#333;"
			+ "}"
			+ ".invoice-box table tr.information table td{"
			+ " padding-bottom:40px;"
			+ "}"
			+ ".invoice-box table tr.heading td{"
			+ "background:#eee;"
			+ " border-bottom:1px solid #ddd;"
			+ "font-weight:bold;"
			+ " }"
			+ ".invoice-box table tr.details td{"
			+ "padding-bottom:20px;"
			+ "}"
			+ ".invoice-box table tr.item td{"
			+ "border-bottom:1px solid #eee;"
			+ "}"
			+ ".invoice-box table tr.item.last td{"
			+ "border-bottom:none;"
			+ "}"
			+ ".invoice-box table tr.total td:nth-child(2){"
			+ "border-top:2px solid #eee;"
			+ "font-weight:bold;"
			+ "}"
			+ "@media only screen and (max-width: 600px) {"
			+ ".invoice-box table tr.top table td{"
			+ "width:100%;"
			+ "display:block;"
			+ "text-align:center;"
			+ "}"
			+ ".invoice-box table tr.information table td{"
			+ "width:100%;"
			+ "display:block;"
			+ "text-align:center;"
			+ "}"
			+ "}"
			+ "</style>"
			+ "</head>"
			+ "<body>"
			+ "<div class=invoice-box>"
			+ "<table cellpadding=0 cellspacing=0>"
			+ " <tr class=top>"
			+ " <td colspan=2>"
			+ " <table>"
			+ " <tr>"
			+ "<td class=title>"
			+ " <img src=http://www.efisys.com.mx/portal/images/stories/demo/logo_wlcome.png style=width:70%; max-width:300px;>"
			+ "</td>";
	
	public static String PIE_CORREO_CORREO_BM="" +
            "              <table width='650' bgcolor='#eee' align='center'> " +
            "                  <tbody> " +
            "             <tr> " +
            "                        <td>&nbsp;</td> " +
            "                      </tr> " +
            "                      <tr> " +
            "                        <td> " +
            "                          <p align='center'><font style='font-size:14px;color:#555;border-bottom: 1px solid #ddd;font-weight: bold;'>Este aviso " +
            "                              constituye un comprobante no oficial de la operación realizada.</font></p> " +
            "                        </td> " +
            "                      </tr> " +
            "                      </tbody> " +
            "            </table> " +
            " " +
            " " +
            "            <table width='650' bgcolor='#FFFFFF' align='center'> " +
            "                    <tbody> " +
            "                      <tr> " +
            "                        <td>&nbsp;</td> " +
            "                      </tr> " +
            "                      <tr> " +
            "                        <td> " +
            "                          <p align='center'>" +
            "                          <font style='font-size:14px;color:#666666;border-bottom: 1px solid #ddd;font-weight: bold;'>Nuestra empresa " +
            "                              trabaja para tu satisfacción, <br/> " +
            "                              conoce más en <a href='http://www.efisys.com.mx/' >www.efisys.com.mx " +
            "                            </a></font></p> " +
            "                        </td> " +
            "                      </tr> " +
            "                    </tbody> " +
            "                  </table> " +
            "            " +
            "        </table>" +
            "    </div>" +
            "</body>" +
            "</html>";
					
	public static String CORREO_NOTIFICACION_OPERACIONES=ENCABEZADO_CORREO_BM+"<td>" +
	        "                                Prol. de Porfirio Díaz 169, Reforma, Oaxaca, Oax.<br>" +
	        "                                Telefono: 01 951 132 8536<br>" +
	        "								<strong>Notificación de operación.</strong>" +
	        "                            </td>" +
	        "                        </tr>" +
	        "                    </table>" +
	        "                </td>" +
	        "            </tr>" +
	        "            " +
	        "            <tr class=information>" +
	        "                <td colspan=2>" +
	        "                    <table>" +
	        "                        <tr>" +
	        "                            <td>" +
	        											///MUESTRA EL NOMBRE DEL CLIENTE
	        "                                Hola <strong> %NombreCliente% </strong>," +
	        "                                a continuación te informamos de la transacción que realizaste.<br>" +
	        "                            </td>" +
	        "                        </tr>" +
	        "                    </table>" +
	        "                </td>" +
	        "            </tr>" +
	        "            " +
	        "            <tr class=heading>" +
	        "                <td>" +
	        "                    Via de pago" +
	        "                </td>" +
	        "                " +
	        "                <td>" +
	        					///MUESTRA LA FORMA DE PAGO 
	        "                    Transacción móvil." +
	        "                </td>" +
	        "            </tr>" +
	        "            " +
	        "            <tr class=details>" +
	        "                <td>" +
	        "                    Folio de la operación." +
	        "                </td>" +
	        "                " +
	        "                <td>" +
	        					 ///MUESTRA EL FOLIO DE LA OPERACION
	        "                    %Folio%" +
	        "                </td>" +
	        "            </tr>" +
	        "            <tr class=details>" +
	        "                <td>" +
	        "                    Fecha de la operación." +
	        "                </td>" +
	        "                " +
	        "                <td>" +
	        					 ///MUESTRA LA FECHA DE LA OPERACION
	        "                    %Date%" +
	        "                </td>" +
	        "            </tr>" +
	        "            " +
	        "            <tr class=heading>" +
	        "                <td>" +
	        "                   Detalles " +
	        "                </td>" +
	        "                " +
	        "                <td>" +
	        "                   " +
	        "                </td>" +
	        "            </tr>" +
	        "            " +
	        "            <tr class=item>" +
	        "                <td>" +
	        "                    Cuenta de retiro:" +
	        "                </td>" +
	        "                " +
	        "                <td>" +
	        					///MUESTRA LA CUENTA CARGO
	        "                   %CuentaCargo%" +
	        "                </td>" +
	        "            </tr>" +
	        "            " +
	        "            <tr class=item>" +
	        "                <td>" +
	        "                   Destino/Referencia:" +
	        "                </td>" +
	        "                " +
	        "                <td>" +
	        					//MUESTRA LA CUENTA DESTINO
	        "                   %CuentaReferencia%" +
	        "                </td>" +
	        "            </tr>" +
	        "            " +
	       
	        "            <tr class=item>" +
	        "                <td>" +
	        "                   Beneficiario:" +
	        "                </td>" +
	        "                " +
	        "                <td>" +
	        					//MUESTRA EL BENEFICIARIO
	        "                   %Beneficiario%" +
	        "                </td>" +
	        "            </tr>" +
	        "            " +
	        
	        "            <tr class=item last>" +
	        "                <td>" +
	        "                   Concepto: " +
	        "                </td>" +
	        "                " +
	        "                <td>" +
	        					//MUESTRA EL MOTIVO DE LA TRASACCION
	        "                    %Motivo%" +
	        "                </td>" +
	        "            </tr>" +
	        "" +
	        "              <tr class=item last>" +
	        "                <td>" +
	        "                   Total(subtotal+iva+comision): " +
	        "                </td>" +
	        "                " +
	        "                <td>" +
	    					//MUESTRA EL MONTO DE LA TRASACCION
	        "                  $%Monto%" +
	        "                </td>" +
	        "            </tr>"+PIE_CORREO_CORREO_BM;
	
	public static String CORREO_ACCESO_BM=ENCABEZADO_CORREO_BM+"<td>" +
	        "                                Prol. de Porfirio Díaz 169, Reforma, Oaxaca, Oax.<br>" +
	        "                                Telefono: 01 951 132 8536<br>" +
	        "								<strong>Información para el cliente.</strong>" +
	        "                            </td>" +
	        "                        </tr>" +
	        "                    </table>" +
	        "                </td>" +
	        "            </tr>" +
	        "            " +
	        "            <tr class=information>" +
	        "                <td colspan=2>" +
	        "                    <table>" +
	        "                        <tr>" +
	        "                            <td>" +
	        								///MUESTRA EL NOMBRE DEL CLIENTE
	        "                                Hola <strong> %NombreCliente% </strong>," +
	        "                                Este es un reporte de tu acceso a SAFI Banca Móvil.<br>" +
	        "                            </td>" +
	        "                        </tr>" +
	        "                    </table>" +
	        "                </td>" +
	        "            </tr>" +
	        "            " +
	        "            <tr class=heading>" +
	        "                <td>" +
	        "                    ACCESO DESDE" +
	        "                </td>" +
	        "                " +
	        "                <td>" +
	        					///MUESTRA EL NOMBRE DEL DISPOSITIVO QUE SE ACCEDIO 
	        "                    %NombreDevice%." +
	        "                </td>" +
	        "            </tr>" +
	        "            <tr class=details>" +
	        "                <td>" +
	        "                    Fecha de la operación." +
	        "                </td>" +
	        "                " +
	        "                <td>" +
	        					 ///MUESTRA LA FECHA DE LA OPERACION
	        "                    %Date%" +
	        "                </td>" +
	        "            </tr>"+PIE_CORREO_CORREO_BM;
	
	public static String CORREO_CAMBIOS_BM=ENCABEZADO_CORREO_BM+"<td>" +
	        "                                Prol. de Porfirio Díaz 169, Reforma, Oaxaca, Oax.<br>" +
	        "                                Telefono: 01 951 132 8536<br>" +
	        "								<strong>Información para el cliente.</strong>" +
	        "                            </td>" +
	        "                        </tr>" +
	        "                    </table>" +
	        "                </td>" +
	        "            </tr>" +
	        "            " +
	        "            <tr class=information>" +
	        "                <td colspan=2>" +
	        "                    <table>" +
	        "                        <tr>" +
	        "                            <td>" +
	        											///MUESTRA EL NOMBRE DEL CLIENTE
	        "                                Hola <strong> %NombreCliente% </strong>," +
	        "                                te confirmamos el cambio realizado en tu información. Recientemente hiciste un %Operacion%.  <br>" +
	        "                            </td>" +
	        "                        </tr>" +
	        "                    </table>" +
	        "                </td>" +
	        "            </tr>" +
	        "            " +
	        "            <tr class=heading>" +
	        "                <td>" +
	        "                    ACCESO DESDE" +
	        "                </td>" +
	        "                " +
	        "                <td>" +
	        					///MUESTRA DESDE DONDE SE HICIERON LOS CAMBIOS
	        "                    %NombreDevice%." +
	        "                </td>" +
	        "            </tr>" +
	        "            " +
	        "            <tr class=details>" +
	        "                <td>" +
	        "                    Folio de la operación." +
	        "                </td>" +
	        "                " +
	        "                <td>" +
	        					 ///MUESTRA EL FOLIO DE LA OPERACION
	        "                    %Folio%" +
	        "                </td>" +
	        "            </tr>" +
	        "            <tr class=details>" +
	        "                <td>" +
	        "                    Fecha de la operación." +
	        "                </td>" +
	        "                " +
	        "                <td>" +
	        					 ///MUESTRA LA FECHA DE LA OPERACION
	        "                    %Date%" +
	        "                </td>" +
	        "            </tr>"+PIE_CORREO_CORREO_BM;;
		
	public static String CORREO_ALTA_BM=ENCABEZADO_CORREO_BM+ "<td>" +
	        "                                Prol. de Porfirio Díaz 169, Reforma, Oaxaca, Oax.<br>" +
	        "                                Telefono: 01 951 132 8536<br>" +
	        "								<strong>Información para el cliente.</strong>" +
	        "                            </td>" +
	        "                        </tr>" +
	        "                    </table>" +
	        "                </td>" +
	        "            </tr>" +
	        "            " +
	        "            <tr class=information>" +
	        "                <td colspan=2>" +
	        "                    <table>" +
	        "                        <tr>" +
	        "                            <td>" +
	        											///MUESTRA EL NOMBRE DEL CLIENTE
	        "                                Hola <strong> %NombreCliente% </strong>," +
	        "                               te damos la bienvenida al servicio de Banca Móvil que ofrece nuestra finaciera. Para continuar con el proceso de instalación de la aplicación en tu dispositivo"
	        + "								se te enviará un SMS con un código de activación. Esperamos que disfrutes el servicio.<br>" +
	        "                            </td>" +
	        "                        </tr>" +
	        "                    </table>" +
	        "                </td>" +
	        "            </tr>"+PIE_CORREO_CORREO_BM;
	
	// Fuentes para los reportes utilizados en excel
	public static short FUENTE_BOLD 		= XSSFFont.BOLDWEIGHT_BOLD;
	public static short FUENTE_NOBOLD		= XSSFFont.BOLDWEIGHT_NORMAL;
	public static short FUENTE_CENTRADA		= XSSFCellStyle.ALIGN_CENTER;
	public static short FUENTE_IZQUIERDA	= XSSFCellStyle.ALIGN_LEFT;
	public static short FUENTE_DERECHA		= XSSFCellStyle.ALIGN_RIGHT;
	
	/* Constantes para ubicar el nivel de operacion en el log del web services*/
	public static String NIVEL_DAO 			= "--- NIVEL DAO ---";
	public static String NIVEL_SERVICIO		= "--- NIVEL DE SERVICIO ---";
	public static String NIVEL_VALIDACION 	= "--- NIVEL DE VALIDACION ---";
	public static String NIVEL_CONTROLADOR	= "--- NIVEL DE CONTROLADOR ---";
	
	/* Constantes para Validar el Consumo de Web services*/
	public final static String[] STR_CODIGOEXITO 			= {"000000","PETICION EXITOSA"};
	public final static String   STR_ENMASCARADOS			= "*****[Dato enmascarado]";
	public final static String[] STR_ERROR 					= {"010000","Error"};
	public final static String[] STR_ERROR_VALIDACIONES 	= {"020000","ERROR AL REALIZAR LAS VALIDACIONES"};
	public final static String[] STR_ERROR_DAO 				= {"030000","ERROR EN CAPA DAO"};
	public final static String[] STR_ERROR_SERVICIO 		= {"040000","ERROR EN CAPA SERVICIO"};
	public final static String[] STR_ERROR_CONTROLADOR 		= {"050000","ERROR EN CAPA CONTROLADOR"};
	public final static String 	 STR_ERROR_ENMASCARADO 		= "El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que esto le ocasiona. Ref: ";

	public final static String[] STR_CODIGOEXITOISOTRX		= {"000001","OPERACION EXITOSA"};
	public final static int[] STR_ERRORISOTRX	= {900,998,901};
	public final static int TamanioTexto = 10;
	
	public static interface tipoTarjeta {
		int debito = 1;
		int cedito = 2;
	}
	
	public static interface logger {
		int SAFI 	  	= 1;
		int Vent 		= 2;
		int ISOTRX		= 3;
	}

	public static interface leerExcel {
		int cabecera = 0;
		int cuerpo = 1;
	}

	public static interface ClienteEspecifico {
		int NatGas	= 48;
	}
}
