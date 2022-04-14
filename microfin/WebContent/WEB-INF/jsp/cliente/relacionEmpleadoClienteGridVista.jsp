<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%> 
<html>
	<head>
	</head>
	<body>
		</br>
		<c:set var="relacionesCliente"  value="${relacionesCliente}"/>
		<form id="gridRelacionesCliente" name="gridRelacionesCliente">
			<input type="button" id="agregaRelacion" value="Agregar" class="botonGral"/>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a id="arbolP"><img  src="images/help-icon.gif" alt="" ></a>
			
			<div id="arbolParentesco" style="display: none;"></div>
			<table id="miTabla" border="0">
				<tbody>
					<tr>
						<td class="label" >
							<label for="lblEmpleado"><s:message code="safilocale.cliente"/></label>
						</td>						
						<td class="label">
							<label for="lblNombre">Nombre</label>
						</td>
						<td class="label">
							<label for="lblCURP">CURP</label>
						</td>
						<td class="label">
							<label for="lblRFC">RFC</label>
						</td>
						<td class="label">
							<label for="lblPuesto">Puesto</label>
						</td>
						<td class="label">
							<label for="lblPuesto">Descripci&oacute;n Puesto</label>
						</td>
						<td class="label">
							<label for="lblParentesco">Parentesco</label>
						</td>
						<td class="label">
							<label for="lblDescripcion">Descripci&oacute;n Parentesco</label>
						</td>
						<td class="label">
							<label for="lblTipo">Tipo Relaci&oacute;n</label>
						</td>
						<td class="label">
							<label for="lblGrado">Grado</label>
						</td>
						<td class="label">						
							<label for="lblLinea">L&iacute;nea</label>
						</td>						
					</tr>
				<c:forEach items="${relacionesCliente}" var="relacionCli" varStatus="status">
					<tr id="renglon${status.count}" name="renglon">
					
					<c:if test = "${relacionCli.parentescoID != '' }">
						<script type="text/javascript">
							var idParentesco = "<c:out value="${status.count}"/>";
							consultaParentesco(idParentesco);
						</script> 
					</c:if>

					<c:if test = "${relacionCli.puestoID != '' }">
						<script type="text/javascript">
							var idPuesto = "<c:out value="${status.count}"/>";
							consultaPuesto(idPuesto);
						</script> 
					</c:if>

							<c:choose>
								<c:when test="${relacionCli.tipoRelacion == 1}">
									<script type="text/javascript">
										var idCliente = "<c:out value="${status.count}"/>";
										consultaClienteRel(idCliente);
									</script>
									<td>
										<input type="text" size="13" name="idCliente" id="cliente${status.count}" onblur="consultaClienteRel(this.id)" onkeypress="listaClientes(this.id)"  value="${relacionCli.relacionadoID}" autocomplete="off" />
									</td>
									<td>
										<input type="text" size="30" name="nombre" id="nombre${status.count}" onBlur="ponerMayusculas(this)" value="${relacionCli.nombre}"  disabled="true"/>
									</td>
									<td>
										<input type="text" size="25" name="CURP" id="CURP${status.count}" maxlength="18" value="${relacionCli.CURP}" onBlur="ponerMayusculas(this)" disabled="true"/>
									</td>					
									<td>
										<input type="text" size="25" name="RFC" id="RFC${status.count}" maxlength="13" value="${relacionCli.RFC}" onBlur="ponerMayusculas(this)" disabled="true"/>
									</td>
								
								</c:when>
								<c:otherwise>
									<td>
										<input type="text" size="13" name="idCliente" id="cliente${status.count}"  value="0" readOnly="true" disabled="true" />
									</td>
									<td>
										<input type="text" size="30" name="nombre" id="nombre${status.count}" onBlur="ponerMayusculas(this)" value="${relacionCli.nombre}"  />
									</td>
									<td>
										<input type="text" size="25" name="CURP" id="CURP${status.count}" maxlength="18" value="${relacionCli.CURP}" onBlur="ponerMayusculas(this)" />
									</td>					
									<td>
										<input type="text" size="25" name="RFC" id="RFC${status.count}" maxlength="13" value="${relacionCli.RFC}" onBlur="ponerMayusculas(this)" />
									</td>
								
								</c:otherwise>
							</c:choose>							
						
						<td>
							<input id="puestoID${status.count}" name="puestoID" size="6" autocomplete="off"  value="${relacionCli.puestoID}" onchange="consultaPuesto(this.id)" onkeypress="listaPuestos(this.id)"/>
						</td>
					
						<td>
							<input id="descPuesto${status.count}" name="descPuesto" size="20" type="text" readOnly="true" disabled="true"  />
						</td>
						<td>
							<input id="parentesco${status.count}" name="parentescoID" size="10"  autocomplete="off" value="${relacionCli.parentescoID}" onchange="consultaParentesco(this.id)" onkeypress="listaParentescos(this.id)"/>
						</td>
						<td>
							<input id="descParen${status.count}" name="descParen" size="25" type="text" readonly="true" disabled="true"  />
						</td>
						<td>
							<select name="tipoRelacion" id="tipoRelacion${status.count}" disabled="true">
								<option value="C">Consanguinidad</option>
								<option value="A">Afinidad</option>
							</select>
						</td>
						<td>
							<select name="grado" id="grado${status.count}" disabled="true">
								<option value="1">1° Grado</option>
								<option value="2">2° Grado</option>
								<option value="3">3° Grado</option>
								<option value="4">4° Grado</option>
								<option value="5">5° Grado</option>
								<option value="6">6° Grado</option>
								<option value="7">7° Grado</option>
								<option value="8">8° Grado</option>
								<option value="9">9° Grado</option>
							</select>
						</td>
						<td>
							<select name="linea" id="linea${status.count}" disabled="true">
								<option value="ASC">Ascendente</option>
								<option value="DES">Descendente</option>
								<option value="COL">Colateral</option>
							</select>
						</td>						
						<td>
							<input type="button" name="elimina" id="${status.count}" class="btnElimina" onclick="eliminaRelacion(this)" />
						</td><td>
							<input type="button" name="agrega" id="${status.count}" class="btnAgrega" onclick="agregaElemento()" />							
						</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
			<input type="hidden" value="0" name="numeroRelaciones" id="numeroRelaciones" />
		</form>
	</body>
</html>
<script type="text/javascript">
	var numeroCliente=0;
	var clisofiexpress = 15;
	
	$("#numeroRelaciones").val($('input[name=idCliente]').length);
	function validaDigitos(e){
		if(e.which!=8 && e.which!=0 && e.which != 46 && (e.which<48 || e.which>57)){
    		return false;
  		}
	}
	$('#gridRelacionesCliente').validate({
		rules: {
			control: {
				minlength: 1
			}
		},
		messages: {
		 	control: {
				minlength: 'Al menos un Caracter'
			}
		}
	});
	
	function eliminaRelacion(control){
		var numeroID = control.id;
		var jqTr = eval("'#renglon" + numeroID + "'");
		var jqTipo = eval("'#tipoRelacion" + numeroID + "'");
		var jqGrado = eval("'#grado" + numeroID + "'");
		var jqLinea = eval("'#linea" + numeroID + "'");
		var jqParen = eval("'#parentesco" + numeroID + "'");
		var jqElimina = eval("'#" + numeroID + "'");
		
		$(jqElimina).remove();
		$(jqTr).remove();
		
		//Reordenamiento de Controles 
		var contador = 1;
		$('input[name=idCliente]').each(function() {
			var jqCicCli = eval("'#" + this.id + "'");
			$(jqCicCli).attr("id", "cliente" + contador);
			contador = contador + 1;
		});

		var contador = 1;
		$('input[name=CURP]').each(function() {
			var jqCliCURP = eval("'#" + this.id + "'");
			$(jqCliCURP).attr("id", "CURP" + contador);
			contador = contador + 1;
		});

		var contador = 1;
		$('input[name=RFC]').each(function() {
			var jqCliRFC = eval("'#" + this.id + "'");
			$(jqCliRFC).attr("id", "RFC" + contador);
			contador = contador + 1;
		});
		

		var contador = 1;
		$('input[name=puestoID]').each(function() {
			var jqCliPuestoID = eval("'#" + this.id + "'");
			$(jqCliPuestoID).attr("id", "puestoID" + contador);
			contador = contador + 1;
		});

		var contador = 1;
		$('input[name=descPuesto]').each(function() {
			var jqCliDescPuesto = eval("'#" + this.id + "'");
			$(jqCliDescPuesto).attr("id", "descPuesto" + contador);
			contador = contador + 1;
		});

		
		//Reordenamiento de Controles 
		contador = 1;
		$('input[name=nombre]').each(function() {
			var jqCicNom = eval("'#" + this.id + "'");
			$(jqCicNom).attr("id", "nombre" + contador);
			contador = contador + 1;
		});
		contador = 1;
		$('select[name=tipoRelacion]').each(function() {
			var jqCicTr = eval("'#" + this.id + "'");
			$(jqCicTr).attr("id", "tipoRelacion" + contador);
			contador = contador + 1;
		});
		contador = 1;
		$('select[name=grado]').each(function() {
			var jqCicGra = eval("'#" + this.id + "'");
			$(jqCicGra).attr("id", "grado" + contador);
			contador = contador + 1;
		});
		contador = 1;
		$('select[name=linea]').each(function() {
			var jqCicLinea = eval("'#" + this.id + "'");
			$(jqCicLinea).attr("id", "linea" + contador);
			contador = contador + 1;
		});
		contador = 1;
		$('input[name=parentescoID]').each(function() {
			var jqPid = eval("'#" + this.id + "'");
			$(jqPid).attr("id", "parentesco" + contador);
			contador = contador + 1;
		});
		contador = 1;
		$('input[name=descParen]').each(function() {
			var jqCicPare = eval("'#" + this.id + "'");
			$(jqCicPare).attr("id", "descParen" + contador);
			contador = contador + 1;
		});
		
		contador = 1;
		//Reordenamiento de Controles 
		$('input[name=elimina]').each(function() {
			var jqCicElim = eval("'#" + this.id + "'");
			$(jqCicElim).attr("id", contador);
			contador = contador + 1;
		});
		contador = 1;
		//Reordenamiento de Controles 
		$('tr[name=renglon]').each(function() {
			var jqCicTr = eval("'#" + this.id + "'");
			$(jqCicTr).attr("id", "renglon" + contador);
			contador = contador + 1;
		});
		$('#numeroRelaciones').val($('#numeroRelaciones').val()-1);
		if ($('#numeroRelaciones').val() == 0){
		}
	}
		
	$("#agregaRelacion").click(function() {
		habilitaBoton('grabar', 'submit');
		var numeroFila = document.getElementById("numeroRelaciones").value;
		var nuevaFila = parseInt(numeroFila) + 1;
		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
		tds += '<td><input type="text" size="13" name="idCliente" id="cliente'+nuevaFila+'" autocomplete="off"  onblur= "consultaClienteGrid(this.id)" onkeypress="listaClientes(this.id)" /></td>';
  			tds += '<td><input type="text" size="30" name="nombre" id="nombre'+nuevaFila+'"   onBlur="ponerMayusculas(this)" readOnly="true" disabled="true"/></td>';
  			tds += '<td><input type="text" size="25" name="CURP" id="CURP'+nuevaFila+'" maxlength="18" onBlur="ponerMayusculas(this)" readOnly="true" disabled="true"/></td>';
  			tds += '<td><input type="text" size="25" name="RFC" id="RFC'+nuevaFila+'" maxlength="13" onBlur="ponerMayusculas(this)" readOnly="true" disabled="true"/></td>';
  			tds +='<td>';
			tds +='<input id="puestoID'+nuevaFila+'" name="puestoID" size="6"  autocomplete="off"  value="" onblur="consultaPuestoGrid(this.id)" onkeypress="listaPuestos(this.id)" />';
			tds +='</td>';
  			tds +='<td>';
			tds +='<input id="descPuesto'+nuevaFila+'" name="descPuesto" size="20" type="text"  readonly="true" disabled="true" />';
			tds +='</td>';
			tds +='<td>';
			tds +='<input id="parentesco'+nuevaFila+'" name="parentescoID" size="10" autocomplete="off"  value="" onblur="consultaParentescoGrid(this.id)" onkeypress="listaParentescos(this.id)" />';
			tds +='</td>';
			tds +='<td>';
			tds +='<input id="descParen'+nuevaFila+'" name="descParen" size="25" type="text" readOnly="true" disabled="true"/>';
			tds +='</td>';			
			tds += '<td>';
			tds +='<select name="tipoRelacion" id="tipoRelacion'+nuevaFila+'" disabled="true">';
			tds +='<option value="C">Consanguinidad</option>';
			tds +='<option value="A">Afinidad</option>';
			tds +='</select>';
			tds +='</td>';
			tds +='<td>';
				tds +='<select name="grado" id="grado'+nuevaFila+'" disabled="true">';
				tds +='<option value="1">1° Grado</option>';
				tds +='<option value="2">2° Grado</option>';
				tds +='<option value="3">3° Grado</option>';
				tds +='<option value="4">4° Grado</option>';
				tds +='<option value="5">5° Grado</option>';
				tds +='<option value="6">6° Grado</option>';
				tds +='<option value="7">7° Grado</option>';
				tds +='<option value="8">8° Grado</option>';
				tds +='<option value="9">9° Grado</option>';
				tds +='</select>';
				tds +='</td>';
				tds +='<td>';
				tds +='<select name="linea" id="linea'+nuevaFila+'" disabled="true">';
				tds +='<option value="ASC">Ascendente</option>';
				tds +='<option value="DES">Descendente</option>';
				tds +='<option value="COL">Colateral</option>';
				tds +='</select>';
				tds +='</td>';
    			tds +='<td><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaRelacion(this)" /></td><td>';
    	tds += '<input type="button" name="agrega" id="${status.count}" class="btnAgrega" onclick="agregaElemento()" />';
    	tds += '</td>';
	   	tds += '</tr>';
    	document.getElementById("numeroRelaciones").value = nuevaFila;
    	$("#miTabla").append(tds);
    	$("#cliente"+nuevaFila).focus();
    	return false;
 	});
	
	function agregaElemento(){
		var numeroFila = document.getElementById("numeroRelaciones").value;
		var nuevaFila = parseInt(numeroFila) + 1;
		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
		tds += '<td><input type="text" size="13" name="idCliente" id="cliente'+nuevaFila+'" onblur= "consultaClienteGrid(this.id)" onkeypress="listaClientes(this.id)" /></td>';
  			tds += '<td><input type="text" size="30" name="nombre" id="nombre'+nuevaFila+'"  onBlur="ponerMayusculas(this)" readOnly="true" disabled="true"/></td>';
  			tds += '<td><input type="text" size="25" name="CURP" id="CURP'+nuevaFila+'" maxlength="18" onBlur="ponerMayusculas(this)" readOnly="true" disabled="true"/></td>';
  			tds += '<td><input type="text" size="25" name="RFC" id="RFC'+nuevaFila+'" maxlength="13" onBlur="ponerMayusculas(this)" readOnly="true" disabled="true"/></td>';
  			tds +='<td>';
			tds +='<input id="puestoID'+nuevaFila+'" name="puestoID" size="6"  value="" onblur="consultaPuestoGrid(this.id)" onkeypress="listaPuestos(this.id)" />';
			tds +='</td>';
  			tds +='<td>';
			tds +='<input id="descPuesto'+nuevaFila+'" name="descPuesto" size="20" type="text"  readonly="true" disabled="true" />';
			tds +='</td>';
			tds +='<td>';
			tds +='<input id="parentesco'+nuevaFila+'" name="parentescoID" size="10" value="" onblur="consultaParentescoGrid(this.id)" onkeypress="listaParentescos(this.id)" />';
			tds +='</td>';
			tds +='<td>';
			tds +='<input id="descParen'+nuevaFila+'" name="descParen" size="25" type="text"  readOnly="true" disabled="true"/>';
			tds +='</td>';
			tds += '<td>';
			tds +='<select name="tipoRelacion" id="tipoRelacion'+nuevaFila+'" disabled="true">';
			tds +='<option value="C">Consanguinidad</option>';
			tds +='<option value="A">Afinidad</option>';
			tds +='</select>';
			tds +='</td>';
			tds +='<td>';
				tds +='<select name="grado" id="grado'+nuevaFila+'" disabled="true">';
				tds +='<option value="1">1° Grado</option>';
				tds +='<option value="2">2° Grado</option>';
				tds +='<option value="3">3° Grado</option>';
				tds +='<option value="4">4° Grado</option>';
				tds +='<option value="5">5° Grado</option>';
				tds +='<option value="6">6° Grado</option>';
				tds +='<option value="7">7° Grado</option>';
				tds +='<option value="8">8° Grado</option>';
				tds +='<option value="9">9° Grado</option>';
				tds +='</select>';
				tds +='</td>';
				tds +='<td>';
				tds +='<select name="linea" id="linea'+nuevaFila+'" disabled="true">';
				tds +='<option value="ASC">Ascendente</option>';
				tds +='<option value="DES">Descendente</option>';
				tds +='<option value="COL">Colateral</option>';
				tds +='</select>';
				tds +='</td>';
				
    			tds +='<td><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaRelacion(this)" /></td><td>';
    	tds += '<input type="button" name="agrega" id="${status.count}" class="btnAgrega" onclick="agregaElemento()" />';
    	tds += '</td>';
	   	tds += '</tr>';
    	document.getElementById("numeroRelaciones").value = nuevaFila;
    	$("#miTabla").append(tds);
    	$('#cliente'+nuevaFila).focus();
    	return false;
	}

function consultaClienteGrid(idControl) {
	consultlaGrid();
	if (numeroCliente == clisofiexpress) {
		var jqCliente = eval("'#" + idControl + "'");
		var numCliente = $(jqCliente).val();
		var tipConForanea = 1;
		var id = idControl.substring(7);
		setTimeout("$('#cajaLista').hide();", 200);
		
		if(numCliente != '' && !isNaN(numCliente) && numCliente>0){
			clienteServicio.consulta(tipConForanea,numCliente,function(cliente) {
				if(cliente!=null && cliente.estatus=='A'){
					deshabilitaControl('nombre'+id);
					deshabilitaControl('CURP'+id);
					deshabilitaControl('RFC'+id);
					deshabilitaControl('descPuesto'+id);
					
					$('#nombre'+ id).attr('readOnly', true);	
					$('#CURP'+ id).attr('readOnly', true);	
					$('#RFC'+ id).attr('readOnly', true);	
					$('#descPuesto'+ id).attr('readOnly', true);			
					$('#nombre'+id).focus();


					$('#nombre'+id).val(cliente.nombreCompleto);
					$('#CURP'+id).val(cliente.CURP);
					$('#RFC'+id).val(cliente.RFC);

					$('#descPuesto'+id).val('');
				}else{
					$(jqCliente).val('');
					$(jqCliente).focus();
					$(jqCliente).select();	
					$('#nombre'+id).val('');
					$('#puesto'+id).val('');
					$('#descPuesto'+id).val('');
					mensajeSis("No Existe el Socio");	
				}
			});
		}else{
			if(isNaN(numCliente)){
				$(jqCliente).val('');
				$(jqCliente).focus();
				$(jqCliente).select();	
				$('#nombre'+id).val('');
				$('#puesto'+id).val('');
				$('#descPuesto'+id).val('');		
			}else{
				if(numCliente =='' ){
					$(jqCliente).val('');
				}
				if(numCliente == 0){				
					habilitaControl('nombre'+id);
					habilitaControl('CURP'+id);
					habilitaControl('RFC'+id);
					$('#nombre'+ id).attr('readOnly', false);	
					$('#CURP'+ id).attr('readOnly', false);	
					$('#RFC'+ id).attr('readOnly', false);	
					$('#descPuesto'+ id).attr('readOnly', false);			
					$('#nombre'+id).focus();

				}
			}
			
		}
	}else{
		var jqEmpleado = eval("'#" + idControl + "'");
		var numEmpleado = $(jqEmpleado).val();
		var tipConForanea = 1;
		var id = idControl.substring(7);
			var EmpleadoBeanCon = {
			'empleadoID' : numEmpleado
		};
		var catTipoConsultaEmpleados = {
			'principal' : 1
		};
		setTimeout("$('#cajaLista').hide();", 200);
			esTab= true;

			if (numEmpleado != '' && !isNaN(numEmpleado) && esTab) {
			empleadosServicio.consulta(catTipoConsultaEmpleados.principal,	EmpleadoBeanCon, function(empleados) {
				if(empleados!=null && empleados.estatus=='A'){
					deshabilitaControl('nombre'+id);
					deshabilitaControl('CURP'+id);
					deshabilitaControl('RFC'+id);
					deshabilitaControl('descPuesto'+id);
					
					$('#nombre'+ id).attr('readOnly', true);	
					$('#CURP'+ id).attr('readOnly', true);	
					$('#RFC'+ id).attr('readOnly', true);	
					$('#descPuesto'+ id).attr('readOnly', true);			
					$('#nombre'+id).focus();


					$('#nombre'+id).val(empleados.nombreCompleto);
					$('#CURP'+id).val(empleados.CURP);
					$('#RFC'+id).val(empleados.RFC);

					$('#descPuesto'+id).val('');
				}else{
					$(jqEmpleado).val('');
					$(jqEmpleado).focus();
					$(jqEmpleado).select();	
					$('#nombre'+id).val('');
					$('#puesto'+id).val('');
					$('#descPuesto'+id).val('');
					mensajeSis("No Existe el Socio");	
				}
			});
		}else{
			if(isNaN(numEmpleado)){
				$(jqEmpleado).val('');
				$(jqEmpleado).focus();
				$(jqEmpleado).select();	
				$('#nombre'+id).val('');
				$('#puesto'+id).val('');
				$('#descPuesto'+id).val('');		
			}else{
				if(numEmpleado =='' ){
					$(jqEmpleado).val('');
				}
				if(numEmpleado == 0){				
					habilitaControl('nombre'+id);
					habilitaControl('CURP'+id);
					habilitaControl('RFC'+id);
					$('#nombre'+ id).attr('readOnly', false);	
					$('#CURP'+ id).attr('readOnly', false);	
					$('#RFC'+ id).attr('readOnly', false);	
					$('#descPuesto'+ id).attr('readOnly', false);			
					$('#nombre'+id).focus();

				}
			}
			
		}
	}
}
function consultlaGrid(){
	var tipoConsulta = 13;
	paramGeneralesServicio.consulta(tipoConsulta,{ async: false, callback: function(valor){
			if(valor!=null){
				numeroCliente=valor.valorParametro;
			}
		}
	});
}

function consultaParentescoGrid(idControl) {
	var jqParentesco = eval("'#" + idControl + "'");
	var numParentesco = $(jqParentesco).val();
	var id = idControl.substring(10);
	var tipConPrincipal = 3;
	var ParentescoBean = {
		'parentescoID' : numParentesco
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numParentesco != '' && !isNaN(numParentesco) && numParentesco > 0){
		parentescosServicio.consultaParentesco(tipConPrincipal, ParentescoBean, function(parentesco) {
			if(parentesco!=null){
				$('#descParen'+id).val(parentesco.descripcion);
				$('#tipoRelacion'+id).val(parentesco.tipo);
				$('#grado'+id).val(parentesco.grado);
				$('#linea'+id).val(parentesco.linea);				

			}else{
				$(jqParentesco).val('');
				$(jqParentesco).focus();	
				$(jqParentesco).select();	
				
				mensajeSis("No Existe el Parentesco");
			}
		});
	}else{
		if(isNaN(numParentesco)){
			$(jqParentesco).val('');
			$('#descParen'+id).val('');	
		}else{
			if(numParentesco =='' || numParentesco == 0){
				$(jqParentesco).val('');
			}
		}			
	}
}	


function consultaPuestoGrid(idControl) {
	var jqPuesto = eval("'#" + idControl + "'");
	var numPuesto = $(jqPuesto).val();
	var id = idControl.replace(/\D/g,'');
	var conPuesto = 1;
	var PuestoBeanCon = {
		'puestoRelID' : numPuesto
	};
	setTimeout("$('#cajaLista').hide();", 200);
	if(numPuesto != '' && !isNaN(numPuesto)){
		puestosRelacionadoServicio.consulta(conPuesto,PuestoBeanCon, function(puestos) {
			if(puestos!=null){
				$('#descPuesto'+id).val(puestos.descripcionPuesto);
			}else{
				$(jqPuesto).val('');
				$(jqPuesto).focus();	
				$(jqPuesto).select();	
				$('#descPuesto'+id).val('');
				mensajeSis("No Existe el Puesto");
			}
		});
	}else{
		if(isNaN(numPuesto)){
			$(jqPuesto).val('');
			$('#descPuesto'+id).val('');	
		}else{
			if(numPuesto =='' || numPuesto == 0){
				$(jqPuesto).val('');
			}
		}			
	}
}	


//Lista de Empleados
function listaEmpleados(idControl){
	var jq = eval("'#" + idControl + "'");

		var num = $(jq).val();

		var camposLista = new Array();
		var parametrosLista = new Array();			
		camposLista[0] = "nombreCompleto"; 
		parametrosLista[0] = num;
		lista(idControl, '2', '1', camposLista, parametrosLista, 'listaEmpleados.htm');
}


//Lista de Clientes
function listaClientes(idControl){
	var jq = eval("'#" + idControl + "'");

		var num = $(jq).val();

		var camposLista = new Array();
		var parametrosLista = new Array();			
		camposLista[0] = "nombreCompleto"; 
		parametrosLista[0] = num;
		lista(idControl, '2', '1', camposLista, parametrosLista, 'listaCliente.htm');
}


//Lista de Puestos
function listaPuestos(idControl){
	var jq = eval("'#" + idControl + "'");

		var num = $(jq).val();

		var camposLista = new Array();
		var parametrosLista = new Array();			
		camposLista[0] = "descripcionPuesto"; 
		parametrosLista[0] = num;
		lista(idControl, '2', '1', camposLista, parametrosLista, 'listaPuestosRelacionado.htm');
}


function listaParentescos(idControl){
	
	var jqParentesco = eval("'#" + idControl + "'");
	var caract = $(jqParentesco).val();

   	if(caract.length >= 2){
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "descripcion";
			parametrosLista[0] = caract;
			listaAlfanumerica(idControl, '2', '3', camposLista, parametrosLista, 'listaParentescos.htm'); 
		}
}

$('#arbolP').click(function() {
	arbolParentesco();
});
function arbolParentesco(){
	var data;
	data = '<table align="center" width="100%">'+
				'<tr align="center"> '+
					'<td id="encabezadoLista">Arbol Parentescos'+
				'</tr>'+
				'<tr>'+
					'<td>'+
						'<img src="images/Parentescos.png" alt="" width="600px" height="400px"/>'+
					'</td>'+
				'</tr>'+
			'</table>';
	$('#arbolParentesco').html(data);
	$.blockUI({
          message: $('#arbolParentesco'),
          css: {top:  '20%', left: '20%',	width: '45%' }
  	});
	$('.blockOverlay').attr('title','Clic para Desbloquear').click($.unblockUI);
}
</script>
