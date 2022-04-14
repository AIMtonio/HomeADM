<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 
<html>
	<head>		
<!--  	  	<script type="text/javascript" src="dwr/interface/sucursalesServicio.js"></script>  -->
<!-- 		<script type="text/javascript" src="dwr/interface/usuarioServicio.js"></script>   -->
		<script type="text/javascript" src="dwr/interface/opcionesPorCajaServicio.js"></script> 
     	 <script type="text/javascript" src="js/ventanilla/opcionesPorCaja.js"></script>     
</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="opcionesPorCaja">

<fieldset class="ui-widget ui-widget-content ui-corner-all">	
	<legend class="ui-widget ui-widget-header ui-corner-all">Opciones por Caja </legend>
		
		<table id="tablaOpcionescaja" border="0" cellpadding="0" cellspacing="0" width="100%">	
			<tr>
				<td class="label">
					<label>Tipo Caja:</label>
				</td>
				<td >
					<select id="tipoCaja" name="tipoCaja" path="tipoCaja" tabindex="1">
					<option value="">SELECCIONAR</option>	
					<option value="CA">CAJA DE ATENCIÓN AL PÚBLICO</option>
					<option value="CP">CAJA PRINCIPAL</option>																				
					</select>
				</td>				
				<td class="separador"></td>
				<td class="label"></td>
				<td></td>
			</tr>
			<tr>
				<td class="label">
					<label>Seleccionar Todo:</label>
					<input type="checkbox" id="seleccionaTodos" name="seleccionaTodos" tabindex="2">
				</td>
				<td>					
				</td>
				<td class ="separador"></td>
				<td></td>
			</tr>
		</table>
	<table border="0">	
		<tr><td width="2%"></td>
			<td>
				<div id="gridOperaciones">
					<fieldset class="ui-widget ui-widget-content ui-corner-all" >
						<legend class="label">Operaciones</legend>		
							<input type="hidden" id="lisOperaciones" name="lisOperaciones" />
								<table id="tablaOperaciones" border="0" cellpadding="0" cellspacing="0" width="100%">	
								</table>
					</fieldset>
				</div>				
			</td>
			<td  width="" style="vertical-align: top;">
				<div id="gridOperacionesR">
					<fieldset class="ui-widget ui-widget-content ui-corner-all" > <!-- style="position:absolute;top:8.5%;" style="position:absolute;top:8%;" -->
						<legend class="label">Reversas</legend>		
							<input type="hidden" id="lisReversas" name="lisReversas" />
								<table id="tablaReversas" border="0" cellpadding="0" cellspacing="0" width="100%">	
								</table>
					</fieldset>
				</div>	
			</td><td width="2%"></td>
		</tr>
	</table>
	
	
	<table width="100%">
		<tr>
			<td align="right">		
				<input type="submit" id="guardar" name="guardar" class="submit" value="Guardar" tabindex="47"/>
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
				<input type="hidden" id = "listaOpciones" name ="listaOpciones" />
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