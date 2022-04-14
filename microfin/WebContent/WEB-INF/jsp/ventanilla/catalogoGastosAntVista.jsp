<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head> 
		
		<script type="text/javascript" src="dwr/interface/tipoGasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/cuentasContablesServicio.js"></script> 		
		<script type="text/javascript" src="dwr/interface/tipoInstrumentosServicio.js"></script> 	
		<script type="text/javascript" src="dwr/interface/catalogoGastosAntServicios.js"></script> 		
		
		
		<script type="text/javascript" src="js/ventanilla/catalogoGastosAnt.js"></script>  
	</head>
<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="catalogoGastosAntBean">
<fieldset class="ui-widget ui-widget-content ui-corner-all">		
<legend class="ui-widget ui-widget-header ui-corner-all">Catálogo Anticipos Gastos Ventanila</legend>			
	<table border="0" cellpadding="0" cellspacing="0" width="750">
	 	
	 	<tr>
	 		<td class="label">
	 			<label for="lblCaja">Número:</label>
	 		</td>
	 		<td>
				<form:input id="tipoAntGastoID"	name="tipoAntGastoID" path="tipoAntGastoID" size="11"	tabindex="1" />
	 		</td>
	 	</tr>
	 	<tr>	 		
	 		<td class="label">
	 			<label for="lblDesc">Descripción:</label>
	 		</td>
	 		<td>
					<textarea id="descripcion" name="descripcion" path="descripcion" size="75" cols="50" rows="2"
					onblur=" ponerMayusculas(this)" tabindex="2" maxlength = "75"/></textarea>
			</td>	
		</tr>
		<tr>
			<td class="label">
				<label for="estatus">Estatus:</label>
			</td>
			<td>
				<form:select id="estatus" name="estatus" path="estatus" tabindex="3">
					<form:option value="A">ACTIVO</form:option> 1300
				    <form:option value="I">INACTIVO</form:option>
				</form:select>
			</td>		
	 		
		</tr>	
		<tr>
			<td class="label"> 
					<label for="naturaleza">Naturaleza: </label> 
			</td>
			<td class="label"> 
				<form:radiobutton id="naturaleza1" name="naturaleza1"  path="naturaleza"
						value="E" tabindex="4" checked="checked" />
				<label for="natur">Entrada</label>&nbsp;&nbsp;
				
				<form:radiobutton id="naturaleza2" name="naturaleza2"  path="naturaleza"
					value="S" tabindex="5"/>
					
				<label for="natur">Salida</label>
			</td>	
		
		</tr>
		<tr >
			<td class="label"> 
					<label for="tipoGastoTes">Relacionado a Tipo Gasto Tesorería: </label> 
			</td>
			<td class="label"> 
				<form:radiobutton id="esGasto1" name="esGasto1"  path="esGasto"
						value="S" tabindex="6"  />
				<label for="gasto">SI</label>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				
				<form:radiobutton id="esGasto2" name="esGasto2"  path="esGasto" checked="checked"
					value="N" tabindex="7"/>
					
				<label for="natur">NO</label>
			</td>	
		</tr>
		
		
		<tr id="tipoGastosTeso" style="display:none"  >	
		
			<td class="label">
				<label for="tipoGastoTesoreria">Tipo Gasto Tesorería:</label>
				
			</td>
			<td>
				<input id="tipoGastoID" name="tipoGastoID"  size="11" tabindex="8" />
	         	<input type="text" id="nombreGasto" name="nombreGasto" size="64" readOnly="true"/>   
	         
			</td>			
		
		</tr>
		<tr>
			<td class="label">
				<label for="ctaconta">Cuenta Contable:</label>
			</td>
			
			<td>
				<form:input id="ctaContable" name="ctaContable" path="ctaContable" size="25" tabindex="9" />
	         	<input type="text" id="nombreCtaContable" name="nombreCtaContable" size="50" readOnly="true"/>   
			</td>	
			
		</tr>
		
		<tr>		
			<td class="label">
				<label for="centroCos">Nomenclatura Centro de Costo:</label>
			</td>
			<td>
				<form:input id="centroCosto" name="centroCosto"  path="centroCosto" size="11"  />
	         	<input type="text" id="nombreCentroCosto" name="nombreCentroCosto" size="64" readOnly="true"/>  
	         	 <a href="javaScript:" onClick="ayudaCR();">
								  	<img src="images/help-icon.gif" >
								</a> 
	        </td>
	         
	   </tr>	   
	   <tr>
	   		<td>
	   		</td>
			<td class="label"> <i>
	        	<label for="lblClaves">
	         	<b>	
	         	<br><a href="javascript:" onClick="insertAtCaret('centroCosto','&SO');centroCostoValida();return false;	">  &SO = Sucursal Origen </a>	
	         	<!-- <br><a href="javascript:" onClick="insertAtCaret('centroCosto','&SC');centroCostoValida();return false;	">  &SC = Sucursal <s:message code="safilocale.cliente"/></a> -->
	         	<br><a href="javascript:" onClick="insertAtCaret('centroCosto','&SE');centroCostoValida();return false;	">  &SE = Sucursal Empleado  </b> </a></label> 
	     		</i>
	     	</td>
	   </tr> 
		
		<tr>
			<td class="label"> 
					<label for="reqEmp">Requiere No. Empleado: </label> 
			</td>
			<td class="label"> 
				<form:radiobutton id="reqNoEmp1" name="reqNoEmp1"  path="reqNoEmp"
						value="S" tabindex="11" checked="checked" />
				<label for="gasto">SI</label>&nbsp;&nbsp;&nbsp;&nbsp;
				
				<form:radiobutton id="reqNoEmp2" name="reqNoEmp2"  path="reqNoEmp"
					value="N" tabindex="12"/>
					
				<label for="natur">NO</label>
			</td>	
		</tr>
		<tr>
			<td class="label">
				<label for="instr">Instrumento:</label>
			</td>
			<td>
				<form:input id="tipoInstrumentoID" name="tipoInstrumentoID"  path="tipoInstrumentoID" size="6"  readOnly="true"/>
	         	<input type="text" id="nombreInstrumento" name="nombreInstrumento" size="50" readOnly="true"/>   
			</td>
			
		</tr>
		<tr>		
			<td class="label" >
				<label for="montMax">Monto Máximo Efectivo:</label>
			</td>
			<td>
				<form:input type="text" id="montoMaxEfect" name="montoMaxEfect"  path="montoMaxEfect" size="25" tabindex="14" esMoneda="true" style="text-align: right"/>
			</td>				
		</tr>
		<tr>		
			<td class="label" >
				<label for="montMaxTrs">Monto Máximo Transacción:</label>
			</td>
			<td>
				<form:input type="text"  id="montoMaxTransaccion" name="montoMaxTransaccion"  path="montoMaxTransaccion" size="25" esMoneda="true"  tabindex="15"  style="text-align: right"/>
			</td>				
		</tr>
		
		
	</table>
	<table align="right">
		<tr>
			<td align="right">
				<input type="submit" id="grabar" name="grabar" class="submit" value="Agregar" 	tabindex="16" />
				<input type="submit" id="modificar" name="modificar" class="submit" value="Modificar"tabindex="17" />
				<input type="hidden" id="tipoTransaccion" name="tipoTransaccion"/>
			</td>
		</tr>
	</table>
	</fieldset>	
</form:form>
</div>
<div id="cargando" style="display: none;">	
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"></div>
</div>
<div id="mensaje" style="display: none;"/></div>	
<div id="ContenedorAyuda" style="display: none;">
	<div id="elementoLista"/>
</div>	
</body>
</html>