<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html"%> 
<%@page pageEncoding="UTF-8"%>

<script type="text/javascript" src="js/nomina/bitacoraConveniosGridRep.js"></script>

<c:set var="listaResultado" value="${listaPaginada.pageList}"/>
<c:set var="indiceTab" value="9"/>
<br>

<input type="hidden" id="numeroRegistros" name="numeroRegistros" value="${listaPaginada.nrOfElements}"/>

<div id="formaTabla">
	<fieldset class="ui-widget ui-widget-content ui-corner-all">
		<legend>Bit&aacute;cora Cambios</legend>
		<table id="miTabla" border="0" cellpadding="5px" cellspacing="5px" width="100%">
			<tr>
				<td><label>Fecha y Hora</label></td>
				&nbsp;
				<td><label>Empresa N&oacute;mina</label></td>
				&nbsp;
				<td><label>No. Convenio</label></td>&nbsp;
				<td><label>Num. Actualizaciones</label></td>&nbsp;
				<td><label>Usuario</label></td>&nbsp;
				<td><label>Sucursal</label></td>&nbsp;
				<td><input type="button" id="btnExcel${status.count}" name="btnExcel${status.count}" tabindex="${indiceTab}" value="" class="btnExcel" /></td>&nbsp;
				<td><input type="button" id="btnPDF${status.count}" name="btnPDF${status.count}" tabindex="${indiceTab}" value="" class="btnPDF" /></td>
			</tr>

			<c:forEach items="${listaResultado}" var="cambioConvenio" varStatus="status">
				<tr id="renglon${status.count}" name="renglon">
					<td>
						<input id="fechaRegistro${status.count}" size="20" type="text" value="${cambioConvenio.fechaCambio}" disabled="disabled" />
					</td>
					<td>
						<label>${cambioConvenio.nombreInstitNomina}</label>
					</td>
					<td>
						<input id="convenioNominaID${status.count}" size="15" type="text" value="${cambioConvenio.convenioNominaID}" disabled="disabled" />
					</td>
					<td>
						<input id="noActualizaciones${status.count}" size="10" type="text" value="${cambioConvenio.numActualizaciones}" disabled="disabled" />
					</td>
					<td>
						<input id="nombreUsuario${status.count}" size="30" type="text" value="${cambioConvenio.nombreCompleto}" disabled="disabled" />
					</td>
					<td>
						<input id="nombreSucurs${status.count}" size="25" type="text" value="${cambioConvenio.nombreSucurs}" disabled="disabled" />
					</td>
					<td>
						<c:set var="indiceTab" value="${indiceTab + 1}"/>
						<input type="button" id="btnExcel${status.count}" name="btnExcel${status.count}" tabindex="${indiceTab}" value="" class="btnExcel" onClick="generarExcelIndividual(${cambioConvenio.convenioNominaID}, ${cambioConvenio.institNominaID}, ${cambioConvenio.hisConvenioNomID}, '${cambioConvenio.nombreInstitNomina}')"/>
					</td>
					<td>
						<c:set var="indiceTab" value="${indiceTab + 1}"/>
						<input type="button" id="btnPDF${status.count}" name="btnPDF${status.count}" tabindex="${indiceTab}"value="" class="btnPDF" onClick="generarPDFIndividual(${cambioConvenio.convenioNominaID}, ${cambioConvenio.institNominaID}, ${cambioConvenio.hisConvenioNomID}, '${cambioConvenio.nombreInstitNomina}')"/>
					</td>
				</tr>
			</c:forEach>
		</table>
		<c:if test="${!listaPaginada.firstPage}">
			<input type="button" id="btnAnterior" onclick="cambioPaginaGrid('previous')" value="" tabindex="8" class="btnAnterior" />
		</c:if>
		<c:if test="${!listaPaginada.lastPage}">
			<input type="button" id="btnSiguiente" onclick="cambioPaginaGrid('next')" value="" tabindex="9" class="btnSiguiente" />
		</c:if>
		<div class="alinear">
			<c:forEach begin="1" end="${listaPaginada.pageCount}"  varStatus="loop">
				<li class="pagination" id="pag-${loop.count - 1}"><a class="active cambioColor" onclick="cambioPaginaGrid(${loop.count})">${loop.count}</a></li>
			</c:forEach>
		</div>
	</fieldset>
</div>

<script type="text/javascript">

	
function cambioPaginaGrid(valorPagina) {
	var params = {};
	params['convenioNominaID'] = $('#convenioNominaID option:selected').val();
	params['institNominaID'] = $('#institNominaID').val();
	params['tipoLista'] = tipoLista.listaPrincipal;
	params['fechaInicio'] = $('#fechaInicio').val();
	params['fechaFin'] = $('#fechaFin').val();
	params['page'] = valorPagina;
	$.post("bitacoraCambiosInstitNomGridVista.htm", params, function(data) {
		if(data.length > 0) {
			$('#formaTabla').html(data);
			$('#formaTabla').show();
		} else {
			mensajeSis("Error al generar la lista");
		}
	}).done(function() {
		asignaTabIndex();
	}).fail(function(xhr, status, error) {
		mensajeSis("Error al generar el grid");
	});
}

</script>


<style>
	li.pagination {
		display: inline-block;
		padding: 0;
		margin: 0;
	}

	li.pagination {display: inline ;}

	li.pagination a {
		color: #29a8fd;
		float: left;
		padding: 2px 4px;
		text-decoration: none;
		border-radius: 5px;
	}

	li.pagination a.cambioColor:hover {
		background-color: powderblue;
		transition: background-color .5s;
	}

	li.pagination a.active {
		background-color: white;
		color: #29a8fd;
		border-radius: 4px;
		cursor: pointer;
		white-space:nowrap;

	}

	div.alinear {
		float: right;
	}

</style>