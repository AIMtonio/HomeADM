<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
	<link type="text/css" href="css/redmond/jquery-ui-1.8.13.custom.css" rel="stylesheet" />     
	<link rel="stylesheet" type="text/css" href="css/forma.css" media="all" />   
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
	<script type="text/javascript" src="js/tesoreria/tesoMovsConciliaSubirArch.js"></script>
	<title>Archivo Conciliaci&oacute;n de Movimientos</title>
</head>
<body>
	<c:set var="varIns"  value="<%= request.getParameter(\"ins\")  %>"/>
	<c:set var="varCtaB" value="<%= request.getParameter(\"ctaB\") %>"/>
	<c:set var="varFec"  value="<%= request.getParameter(\"fec\")  %>"/>
	<c:set var="varFecI"  value="<%= request.getParameter(\"fecI\")  %>"/>
	<c:set var="varFecF"  value="<%= request.getParameter(\"fecF\")  %>"/>
	<c:set var="varBanE" value="<%= request.getParameter(\"be\")  %>"/>
	<c:set var="varVersion" value="<%= request.getParameter(\"version\") %>"/>
	<div id="contenedorForma">
		<form:form method="POST" commandName="tesoMovsArch" enctype="multipart/form-data" name="formaGenerica2" id="formaGenerica2">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Archivo Conciliaci&oacute;n de Movimientos</legend>
				<table border="0" cellpadding="0" cellspacing="0" width="100%">			
					<tr>
						<td colspan="2">
					        <input type="hidden" id="institucionID" name="institucionID" size="20" tabindex="1" value="${varIns}"/> 
					        <input type="hidden" id="cuentaBancaria" name="cuentaBancaria" size="20" tabindex="2" value="${varCtaB}"/>
					        <input type="hidden" id="versionFormato" name="versionFormato" size="2" tabindex="2" value="${varVersion}"/>
					       	<input type="hidden" id="fechaCarga" name="fechaCarga"  size="14" tabindex="4" value="${varFec}"/>
					       	<input type="hidden" id="fechaCargaInicial" name="fechaCargaInicial" size="14" tabindex="4" value="${varFecI}"/>
					       	<input type="hidden" id="fechaCargaFinal" name="fechaCargaFinal" size="14" tabindex="4" value="${varFecF}"/>
					       	<input type="hidden" id="bancoEstandar" name="bancoEstandar"  size="14" tabindex="5" value="${varBanE}"/> 
					   	</td> 
					</tr>
					<tr>
					    <td class="label">
					         <label for="lblNombreArch">Nombre Archivo:</label> 
					    </td>
					    <td>
					         <input type="file" id="file" name="file" tabindex="6" id="file" /> 
					    </td>                                        
					</tr>
					<tr>
						<td align="right" colspan="2">									
							<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar" tabindex="7" />
							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion" />
						</td>
					</tr>
				</table>
			</fieldset>
		</form:form>
	</div>
<div id="cargando" style="display: none;"></div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
</body>
<div id="mensaje" style="display: none;"></div>
</html>