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
	<script type="text/javascript" src="js/general.js"></script>x	
	
    <script type="text/javascript" src="js/nomina/archivoInstalCarga.js"></script>  
    

	<title>Archivo de Instalaci&oacute;</title>
</head>

<body>
	<c:set var="folioID" value="<%= request.getParameter(\"folioID\") %>"/>
	<div id="contenedorForma" style="top:0px; padding:10px; left:0px; width: 98%; height: 90%; ">
		<form:form method="POST" commandName="ArchivoInstalBean" enctype="multipart/form-data" name="formaGenerica2" id="formaGenerica2">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend class="ui-widget ui-widget-header ui-corner-all">Instalaci&oacute; para Cr&eacute;ditos con incidencias</legend>
				<table border="0"  width="100%">			
					<tr>
						 <td class="label">
					         <label for="lblNombreArch">Seleccione un Archivo: </label> 
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
										<input type="hidden" id="folioID" name="folioID" size="20" value="${folioID}"/>
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