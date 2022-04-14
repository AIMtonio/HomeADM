<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
 		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
 		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
	   	<script type="text/javascript" src="dwr/interface/garantiaServicioScript.js"></script>
	   	<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>
  		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
	    <script type="text/javascript" src="js/originacion/asignaGarantia.js"></script>
	</head>
<body>
<div id="contenedorForma">

<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="garantiaBean">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Asignaci&oacute;n de Garant&iacute;as</legend>
		<table>
			<tr>
				<td class="label">
		        	<label for="solicitudCreditoID">Solicitud:</label>
		        </td>
		        <td>
		        	<form:input id="solicitudCreditoID" name="solicitudCreditoID" path="solicitudCreditoID" size="18" tabindex="1" autocomplete="off"/>
		     	</td>
		     	<td class="separador"></td>
				<td class="label">
		        	<label for="lblgarantia">Cr&eacute;dito:</label>
		        </td>
		        <td>
		        	<form:input id="creditoID" name="creditoID"  readOnly="true" path="creditoID" size="18"  />
		     	</td>
		    </tr>
		</table>
		<br>
		<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<table>
			<tr>
				<td class="label">
	         		<label for="clienteID"><s:message code="safilocale.cliente"/>: </label>
	     		</td>
	     		<td>
	         		 <form:input id="clienteID" name="clienteID"  readOnly="true" path="clienteID" size="12"  />
	         		 <input id="clienteNombre" name="clienteNombre" path="clienteNombre" readOnly="true" size="48" />
	     		</td>
	     		<td class="separador"></td>
	     		<td class="label">
	         		<label for="prospectoID">Prospecto:</label>
	     		</td>
	     		<td>
	         		<form:input id="prospectoID" name="prospectoID" path="prospectoID" readOnly="true" size="12"  />
	         		<input id="prospectoNombre" name="prospectoNombre" readOnly="true" path="prospectoNombre"  size="48"  />
	     		</td>
		     </tr>
		</table>
		<br>
		<table>
			<tr>
			   <td class="label" nowrap="nowrap">
	         		<label for="montoSolici">Monto Solicitud: </label>
	     		</td>
				<td>
		     		 <input id="montoSolici" name="montoSolici" esMoneda="true" readOnly="true" path="montoSolici"  style="text-align:right;" size="18"  />
				</td>
	     		<td class="separador"></td>
				<td class="label" nowrap="nowrap">
	         		<label for="montoAutorizado">Monto Autorizado: </label>
	     		</td>
				<td>
		     		 <input id="montoAutorizado" name="montoAutorizado" esMoneda="true" readOnly="true" path="montoAutorizado"  style="text-align:right;" size="18"/>
				</td>
	     		<td class="separador"></td>
				<td class="label" nowrap="nowrap">
	         		<label for="montoCredito">Monto Cr&eacute;dito: </label>
	     		</td>
				<td>
		     		 <input id="montoCredito" name="montoCredito" esMoneda="true" readOnly="true" path="montoCredito"  style="text-align:right;" size="18"  />

				</td>
			</tr>
			<tr>
				<td class="label">
	         		<label for="fechaRegistro">Fecha Solicitud: </label>
	     		</td>
				<td>
					<input  readOnly="true" id="fechaRegistro" name="fechaRegistro" style="text-align:right;" size="18"    path="fechaRegistro"/>

				</td>
	     		<td class="separador"></td>
				<td class="label">
	         		<label for="lblgarantia">Relaci&oacute;n Garant&iacute;a <br> Cr&eacute;dito: </label>
	     		</td>
				<td>
		     		 <input id="relGarantCred" name="relGarantCred" style="text-align:right;"  readOnly="true" esMoneda="true" path="relGarantCred" size="18"  />
		     		 <label for="lblgarantia">%</label>
				</td>
	     		<td class="separador"></td>
				 <td class="label">
	         		<label for="fechaInicio">Fecha Inicio: </label>
	     		</td>
				<td>
					<input  readOnly="true" id="fechaInicio" style="text-align:right;" name="fechaInicio" size="18"  path="fechaInicio"/>
				</td>
			</tr>
			<tr>
				<td class="label">
	         		<label for="estatus">Estatus: </label>
	     		</td>
				<td>
					<input type="hidden"    id="estatus" name="estatus" size="18" value="" path="estatus"/>
				 	<input type="text" readOnly="true" style="text-align:right;" id="estatusNombre" name="estatusNombre" size="18"  path="estatusNombre"/>
				</td>
	     		<td class="separador"></td>
	     		<td class="label">
	         		<label for="productoCreditoID">Producto de Cr&eacute;dito: </label>
	     		</td>
				<td>
				 	<input type="text" readOnly="true" id="productoCreditoID" style="text-align:right;" name="productoCreditoID" size="11"  path="productoCreditoID"/>
				 	<input type="text" id="nombreProd" name="nombreProd"  readOnly="true" size="40" />
				</td>
			</tr>
		</table>
		<br>
		<table width="100%">
			<tr>
		 		<td>
		    		<input type="button" value="Agregar" id="agregar" name="agregar"   class="submit" size="14" tabindex="4" />
		  		</td>
		  		<td id="tdmensaje">
		  			<label for="lblgarantia"><h3>Garant&iacute;as Insuficientes</h3> </label>
		  		</td>
				<td id="tdPorcentaje">
					<label for="lblgarantia"><h3>0%</h3> </label>
				</td>
		  	</tr>
		</table>
		<br>
		    <div id="tableCon">
				<input type="hidden" id="numeroDetalle" name="numeroDetalle" value="-1" />
			 	<c:set var="listaResultado"  value="${listaResultado[0]}"/>
		     	<table id="miTabla">
		      		<tr>
		     			<td class="label"> <label for="lblgarantia">Garant&iacute;a: </label> </td>
		     			<td class="label"> <label for="lblgarantia">Observasiones: </label> 	</td>
		     			<td class="label"> <label for="lblgarantia">Valor Comercial: </label> </td>
				   		<td class="label"> <label for="lblgarantia">Valor Asignado: </label> </td>
		     		</tr>
		     	</table>
			</div>
		</fieldset>
			<table align="right">
				<tr>
					<td align="right">
						<input type="submit" id="grabar" name="grabar" class="submit" value="Grabar" tabindex="40"  />
						<input type="submit" id="autorizar" name="autorizar" class="submit" value="Autorizar" tabindex="41"  />
						<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" value="tipoTransaccion"/>
					</td>
				</tr>
			</table>
	</fieldset>
</form:form>
</div>
<div id="cargando" style="display: none;">
</div>
<div id="cajaLista" style="display: none;">
	<div id="elementoLista"/>
</div>
</body>
<div id="mensaje" style="display: none;"/>
</html>