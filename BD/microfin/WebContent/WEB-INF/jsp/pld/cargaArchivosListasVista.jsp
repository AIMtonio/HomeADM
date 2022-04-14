<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
<head>
	<script type="text/javascript" src="js/pld/cargaArchivosListas.js"></script>
	<script type="text/javascript" src="dwr/interface/cargaListasPLDServicio.js"></script>
</head>
<body>
	<div id="contenedorForma">
		<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="cargaListasPLDBean">
			<fieldset class="ui-widget ui-widget-content ui-corner-all">
				<legend
					class="ui-widget ui-widget-content ui-widget-header ui-corner-all">Carga de Listas</legend>

				<table border="0" width="100%">
					<tr>
						<td class="label">
							<label for="fechaCarga">Fecha de Carga:</label>
						</td>
						<td>
							<form:input id="fechaCarga" name="fechaCarga" tabindex="3" path="fechaCarga" readOnly="true" size="10"/>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="incluyeEncabezadoSi">Incluye Encabezado:</label>
						</td>
						<td nowrap="nowrap">
							<form:radiobutton id="incluyeEncabezadoSi" name="incluyeEncabezado" tabindex="3" path="incluyeEncabezado" value="S" checked="true"/><label for="incluyeEncabezadoSi"> Si</label>
							<form:radiobutton id="incluyeEncabezadoNo" name="incluyeEncabezado" tabindex="3" path="incluyeEncabezado" value="N"/><label for="incluyeEncabezadoNo"> No</label>
							<a href="javaScript:" onclick="ayuda()"> <img src="images/help-icon.gif"></a>
						</td>
					</tr>
					<tr>
						<td class="label">
							<label for="tipoLista">Tipo de Lista:</label>
						</td>
						<td nowrap="nowrap">
							<form:radiobutton id="tipoListaN" name="tipoLista"  tabindex="15" path="tipoLista" value="LN" checked="checked"/>
								<label for="tipoListaN">Listas Negras</label>

							<form:radiobutton id="tipoListaB" name="tipoLista"  tabindex="16" path="tipoLista" value="LPB" />
								<label for="tipoListaB">Lista de Personas Bloq.</label>
						</td>
					</tr>
				</table>
				<table border="0" width="100%">
					<tr>
						<td class="label">
							<div class="label">
								<label style="width: 520px; text-align:justify; display: inline-block;"><b>Nota:</b> Este proceso carga las listas desde un archivo de texto plano separado por TABS al cat&aacute;logo de Listas Negras o Lista de Personas Bloqueadas, seg&uacute;n corresponda. </br>
En caso de que el archivo cargado contenga errores en alguno de los registros, favor de cargar nuevamente el archivo corrigiendo dichos errores para que se puedan guardar los registros correspondientes. </br>Tenga en cuenta que este proceso puede tardar varios minutos dependiendo del n&uacute;mero de registros que contenga el archivo.</label>
							</div>
						</td>
					</tr>
					<br>
					<tr>
						<td class="label" align="right">
							<input type="submit" id="consultar" name="consultar" class="submit" value="Consultar Formato del Archivo" tabindex="4" />
						</td>
					</tr>
					<table width="100%">
						<tr>
							<td class="label"> 
								<label id="labelNombreArchivo" for="nombreArchivo">Nombre del Archivo :&nbsp;</label> 
							</td>
							<td>
								<form:input type="hidden" id="nombreArchivo" name="nombreArchivo" path="" size="35" maxlength="50" tabindex="2" disabled="true" />
								<form:input type="text" id="rutaArchivoSubido" name="rutaArchivoSubido" path="" size="30"  maxlength="200" readOnly="true" value="/opt/SAFI/PLD/FormatoTerceros.txt"/>	
							</td>
							<td>
								<input type="submit" id="procesar" name="procesar" class="submit" value="Procesar Archivo"
										tabindex="7" style="float: right;"/> 
								<input type="hidden" id="numError" name="numError" size="10" tabindex="4" disabled="true"/>
      							<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="2" />	
      							<input type="hidden" id="cargaListasID" name="cargaListasID" value=""  />	
							</td>
						</tr>
					</table>
				</table>
			</fieldset>
		</form:form>
		</div>
		<div id="ejemploArchivo" style="display: none"></div>
		<div id="cargando" style="display: none;"></div>
		<div id="cajaLista" style="display: none;">
			<div id="elementoLista"></div>
		</div>
	<div id="ContenedorAyuda" style="display: none;">
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
			<legend class="ui-widget ui-widget-header ui-corner-all">Incluye Encabezado</legend>
			<div>
				<p>Indica si incluye o no el primer registro del archivo a cargar (encabezado).</p>
			</div>
		</fieldset>
	</div>
	<div id="mensaje" style="display: none;"></div>
</body>
</html>