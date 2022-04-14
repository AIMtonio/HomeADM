<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
 <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>

<head>
	
	<link type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" rel="stylesheet" />     
	<link rel="stylesheet" type="text/css" href="css/forma.css" media="all"  >   
   	
   	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script> 
   	<script type="text/javascript" src="dwr/interface/cuentasAhoServicio.js"></script>
   	<script type="text/javascript" src="dwr/interface/tiposDocumentosServicio.js"></script> 
   	<script type="text/javascript" src="dwr/interface/fileServicio.js"></script> 
	<script type="text/javascript" src="dwr/engine.js"></script>
    <script type="text/javascript" src="dwr/util.js"></script>         
    <script type='text/javascript' src='js/jquery-1.5.1.min.js'></script>
	<script type='text/javascript' src='js/jquery.jmpopups-0.5.1.js'></script> 
    <script type="text/javascript" src="js/jquery.blockUI.js"></script>             		          
	<script type='text/javascript' src='js/jquery.validate.js'></script>
    <script type="text/javascript" src="js/forma.js"></script> 
	<script type="text/javascript" src="js/general.js"></script>
	
	<script type="text/javascript" src="dwr/interface/tesoMovsServicio.js"></script>
	<script type="text/javascript" src="dwr/interface/institucionesServicio.js"></script> 
	<script type="text/javascript" src="dwr/interface/operDispersionServicio.js"></script>
    <script type="text/javascript" src="js/tesoreria/depReferenSubirArc.js"></script>  

	<title>Deposito Referenciado</title>
</head>

<body>
	<c:set var="varIns" value="<%= request.getParameter(\"ins\") %>"/>
	<c:set var="varCtaB" value="<%= request.getParameter(\"ctaB\") %>"/>
	<c:set var="varCta" value="<%= request.getParameter(\"cta\") %>"/>
	<c:set var="varFecIni" value="<%= request.getParameter(\"fecIni\") %>"/>
	<c:set var="varFecFin" value="<%= request.getParameter(\"fecFin\") %>"/>
	<c:set var="varTipC" value="<%= request.getParameter(\"tipC\") %>"/>
	<c:set var="varBancoEstandar" value="<%= request.getParameter(\"be\") %>"/>
	<div id="contenedorForma">
		<form:form method="POST" commandName="depRefereArrenda" enctype="multipart/form-data" name="formaGenerica2" id="formaGenerica2">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Archivo Dep&oacute;sito Referenciado</legend>
				<table border="0" width="100%">			
					<tr>
					    <td >
					        <input type="hidden" id="institucionID" name="institucionID"  size="20" tabindex="5" value="${varIns}"/>
					    </td>                                            
					</tr>         
					<tr>
					   <td>
					    <input type="hidden" id="cuentaBancaria" name="cuentaBancaria"  size="20" tabindex="5" value="${varCtaB}"/>
					    <input type="hidden" id="cuentaAhoID" name="cuentaAhoID"  size="20" value="${varCta}"/>
					   </td>
					</tr>
					<tr> 
						<td> 
					    	<form:input type="hidden" id="fechaCargaInicial" name="fechaCargaInicial"  size="14" tabindex="8" value="${varFecIni}" 
					    		path="fechaCargaInicial" esCalendario="true"/> 
					    	<form:input type="hidden" id="fechaCargaFinal" name="fechaCargaFinal"  size="14" tabindex="8" value="${varFecFin}" 
					    		path="fechaCargaFinal" esCalendario="true"/>
					    	<form:input type="hidden" id="tipoCanal" name="tipoCanal"  size="14" tabindex="8" value="${varTipC}" 
					    		path="tipoCanal" esCalendario="true"/>
					    	<form:input type="hidden" id="numCtaInstit" name="numCtaInstit"  size="14" tabindex="8" value="${varCtaB}" 
					    		path="numCtaInstit" esCalendario="true"/>
					    	<form:input type="hidden" id="bancoEstandar" name="bancoEstandar"  size="14" tabindex="8" value="${varBancoEstandar}" 
					    		path="bancoEstandar" esCalendario="true"/>					    	
					   	</td> 
					</tr>
					<tr>
						 <td class="label">
					         <label for="lblNombreArch">Seleccione un archivo: </label> 
					     </td>
					     <td>
					         <input type="file" id="file" name="file" tabindex="4" path="file" /> 
					     </td>                                        
					</tr>		
					<tr>
						<td colspan="5">
							<table align="right">
								<tr>
									<td align="right">									
										<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="5" />
										<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion" />
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
	
	<div id="cargando" style="display: none;"></div>
	<div id="cajaLista" style="display: none;">
		<div id="elementoLista"> </div>
	</div>
	
</body>
<div id="mensaje" style="display: none;" ></div>
</html>
