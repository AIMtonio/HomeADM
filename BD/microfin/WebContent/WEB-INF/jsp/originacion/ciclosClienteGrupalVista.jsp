<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<html>
	<head>
		<script type="text/javascript" src="dwr/interface/calendarioProdServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/gruposCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/plazosCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/productosCreditoServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/solicitudCredServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/operacionesFechasServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/creditosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaGarantiaLiqServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaSeguroVidaServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/paramGeneralesServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/esquemaOtrosAccesoriosServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/clienteServicio.js"></script>
		<script type="text/javascript" src="dwr/interface/prospectosServicio.js"></script>

		<script type="text/javascript" src="js/originacion/ciclosClienteGrupal.js"></script>
	</head>

<body>
<div id="contenedorForma">
<form:form id="formaGenerica" name="formaGenerica" method="POST" commandName="solicitudCredito">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend class="ui-widget ui-widget-header ui-corner-all">Ciclo Clientes Por Grupo</legend>
		<table border="0">
			<tr>
				<td class="label">
					<label for="lblGrupo">Grupo:</label>
				</td>
				<td nowrap="nowrap">
					<form:input type="text" id="grupoID" name="grupoID"  path="grupoID" size="12" tabindex="1"  />
					<input type="text" id="nombreGrupo" name="nombreGrupo"  size="40"   disabled="disabled" />
				</td>
				<td class="label">
					<label for="lblCicloActual">Ciclo Actual:</label>
				</td>
				<td>
					<input type="text" id="cicloActual" name="cicloActual" size="8" tabindex="14" disabled="true" >
				</td>
			</tr>
			<tr>
				<td class="label">
				   <label for="estatus">Estado del Ciclo:</label>
			   </td>
			   <td>
					<form:input type="text" id="estatusCiclo" name="estatusCiclo" path="estatus" tabindex="7" disabled="true" />
				</td>
				<td class="label">
					<label for="fechaReg">Fecha de Registro: </label>
				</td>
				<td>
					<form:input type="text" id="fechaRegistro" name="fechaRegistro" path="fechaRegistro" size="25" disabled="true" tabindex="3" iniforma="false" />
				</td>
			</tr>
			<tr>
				<td colspan="5">
					<div id="gridIntegrantes" style="display: none;" ></div>
				</td>
			</tr>
			<tr>
			<tr>
				<td colspan="5">
					<div id="fieldOtrasComisiones" style="display: none;">
						<br>
						<fieldset class="ui-widget ui-widget-content ui-corner-all" >
						<legend >Otras Comisiones</legend>
							<table align="right">
								<tr>
									<div id="divAccesoriosCred"></div>
								</tr>
							</table>
						</fieldset>
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="5">
					<div id="contenedorSimulador" style="display: none;"></div>
				</td>
			</tr>
			<tr>
				<td colspan="5">
					<div id="contenedorSimuladorLibre" style="overflow: scroll; width: 100%; height: 300px;display: none;"></div>
				</td>
			</tr>
			<tr>
				<td align="right" colspan="5">
					<input type="hidden" id="tipoTransaccion" name="tipoTransaccion" />
					<input type="hidden" id="forCoSegu" name="forCoSegu" />
					<input type="hidden" id="modalid" name="modalid" />
					<input type="hidden" id="proCre" name="proCre" />
					<input type="hidden" id="conProd" name="conProd" />
					<input type="hidden" id="conProduc" name="conProduc" />
					<input type="hidden" id="calificaCredito" name="calificaCredito" />
					<input id="numTransacSim" name="numTransacSim" path="numTransacSim" size="5" disabled ="true" type="hidden" value="0" readonly="true" disabled="disabled" />
					<input type="hidden" id="nombreCte" name="nombreCte" readonly="true"  disabled="disabled"/>
					<input type="hidden" id="nombreProspecto" name="nombreProspecto" readonly="true" disabled="disabled"/>
					<input type="hidden" id="frecuenciaCapDes" name="frecuenciaCapDes" readonly="true" disabled="disabled"/>
					<form:input type="hidden" id="esGrupal" name="esGrupal" path="esGrupal" size="6"/>
						<form:input type="hidden" id="tasaPonderaGru" name="tasaPonderaGru" path="tasaPonderaGru" size="6" />
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