<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
</head>
<body>
</br>
<c:set var="ciclo" value="1"/>

<form id="gridDiasInv" name="gridDiasInv">
<input type="button" tabindex="1" id="agregaPlazo" value="Agregar" class="botonGral"/>

<table id="miTabla" border="0">
<tbody>
	<tr>
		<td class="label">
			<label for="cuenta">
				Cuenta
			</label>		
		</td>
		<td class="label">
			<label for="tipoCuentaID">
				Tipo de Cuenta
			</label>		
		</td>
		<td class="label">
			<label for="fechaApertura">
				Fecha de Apertura
			</label>		
		</td>
		<td class="label">
			<label for="sucursal">
				Sucursal
			</label>		
		</td>
	</tr>
	
	<c:forEach items="${cuentasOrigenList}" var="cuentasOrigenList" varStatus="status">
		<tr id="renglon${status.count}" name="renglon">
			<td>
				<c:choose>
					<c:when test="${status.count == 1}">
						<input type="text" size="16" name="cuentasOrigen" id="cuenta${status.count}"
								 value="${cuentasOrigenList.cuentaAhoID}" 
								 style="text-align: right" readOnly="true" disabled="true"/>
					</c:when>				
					<c:otherwise>					
						<input type="text" size="16" name="cuentasOrigen" id="cuenta${status.count}"
								  value="${cuentasOrigenList.cuentaAhoID}" 
								  style="text-align: right" readOnly="true" disabled="true"/>
					</c:otherwise>
				</c:choose>
			</td>
			<td>
				<c:choose>
					<c:when test="${status.count == 1}">
						<input type="text" size="22" name="descripcionCuenta" id="descripcion${status.count}"
								  value="${cuentasOrigenList.descripcion}"
								 style="text-align: right" readOnly="true" disabled="true" />
					</c:when>				
					<c:otherwise>					
						<input type="text" size="22" name="descripcionCuenta" id="descripcion${status.count}"
								  value="${cuentasOrigenList.descripcion}" 
								  style="text-align: right" readOnly="true" disabled="true" />
					</c:otherwise>
				</c:choose>
			</td>
			<td>
				<c:choose>
					<c:when test="${status.count == 1}">
						<input type="text" size="16" name="fechaApertura" id="fechaA${status.count}"
								 value="${cuentasOrigenList.fechaApertura}" 
								 style="text-align: right" readOnly="true" disabled="true" />
					</c:when>				
					<c:otherwise>					
						<input type="text" size="16" name="fechaApertura" id="fechaA${status.count}"
								  value="${cuentasOrigenList.fechaApertura}"
								  style="text-align: right" readOnly="true" disabled="true" />
					</c:otherwise>
				</c:choose>
			</td>
			<td>
				<c:choose>
					<c:when test="${status.count == 1}">
						<input type="text" size="16" name="sucursalNombre" id="sucursal${status.count}"
								 value="${cuentasOrigenList.nombreSucursal}" 
								 style="text-align: right" readOnly="true" disabled="true" />
					</c:when>				
					<c:otherwise>					
						<input type="text" size="16" name="sucursalNombre" id="sucursal${status.count}"
								  value="${cuentasOrigenList.nombreSucursal}"
								  style="text-align: right" readOnly="true" disabled="true" />
					</c:otherwise>
				</c:choose>
			</td>
			<td>
				<input type="button" tabindex="2" name="elimina" id="${status.count}" class="btnElimina"
						 onclick="eliminaPlazo(this)"  style="text-align: right"/>
			</td>
		</tr>
	</c:forEach>	
	
</tbody>
</table>
<input type="hidden" value="0" name="numeroPlazos" id="numeroPlazos" />
</form>
</body>
</html>

<script type="text/javascript">

	$("#numeroPlazos").val($('input[name=cuentasOrigen]').length);	
	
	function validaDigitos(e){
		if(e.which!=8 && e.which!=0 && (e.which<48 || e.which>57)){
    		return false;
  		}
	}
	$('#gridDiasInv').validate({
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
	
	asignarTabs();
	
	function eliminaPlazo(control){	
		var numeroID = control.id;
		
		var jqTr = eval("'#renglon" + numeroID + "'");
		$(jqTr).remove();
		
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
			 var jqRenglonReajuste = eval("'#" + this.id + "'");
			
			$(jqRenglonReajuste).attr("id", "renglon"+contador);
			console.log("lalolnada: " + jqRenglonReajuste);
			contador = contador + 1;	
		});
		
		contador = 1;
		//Reordenamiento de Controles
		$('input[name=cuentasOrigen]').each(function() {
			var jqCicElim = eval("'#" + this.id + "'");
			$(jqCicElim).attr("id", "cuenta"+contador);
			contador = contador + 1;	
		});
		
		$('#numeroPlazos').val($('#numeroPlazos').val()-1);
		
		asignarTabs();
	}
	
	function checarCajaLista(control){
		var numeroID = control.id;
		var numeroIDconcaTenado = "#"+ numeroID;

		if(control.value.length >= 3){
			
			var camposLista = new Array();
			var parametrosLista = new Array();
			camposLista[0] = "clienteID";
			parametrosLista[0] = $('#clienteID').val();
			lista(numeroID, '0', '9',
					camposLista, parametrosLista,
					'cuentasAhoListaVista.htm');
			
		}	
	}
	
	function rellenaCampos(control){
		var numeroID = control.id;
		console.log(numeroID);
		var numeroIDconcaTenado = "#"+ numeroID;
		var auxNumero="";
		
		if(esTab){
			for(var i =6; i<numeroID.length; i++){
				auxNumero=auxNumero + numeroID[i];
			}
			var cuentaID = $(numeroIDconcaTenado).val();
			console.log(cuentaID);
			if($(numeroIDconcaTenado).val() ==''){
				alert("El identificador de la cuenta está vacío");
				$(numeroIDconcaTenado).focus();
			}else{
				
				var cuentaBean = {
					"cuentaAhoID" : cuentaID,
					"clienteID" : $('#clienteID').val()
				}
				
				cuentasAhoServicio.consultaCuentasAho(34, cuentaBean, function (cuentasAho){
					if(cuentasAho != null){
						$("#descripcion" + auxNumero).val(cuentasAho.descripcionTipoCta);
						$("#fechaA" 	 + auxNumero).val(cuentasAho.fechaApertura);
						$("#sucursal"    + auxNumero).val(cuentasAho.nombreSucursal);
						
						habilitaBoton('agregarCuen', 'submit');
					}else{
						alert("La cuenta ingresada, no existe");
						$(numeroIDconcaTenado).focus();
					}
				});
			}
		}
	}
	
	$("#agregaPlazo").click(function() {
		var numeroFila = document.getElementById("numeroPlazos").value;
		var nuevaFila = parseInt(numeroFila) + 1;	
		var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
		
		tds += '<td><input type="text" size="16" tabindex="2"  name="cuentasOrigen" 		id="cuenta'+nuevaFila+'"  		style="text-align: right" onkeyup="checarCajaLista(this)" onblur="rellenaCampos(this)"/></td>';	
		tds += '<td><input type="text" size="22" tabindex="3"  name="descripcionCuenta" 	id="descripcion'+nuevaFila+'"   style="text-align: right" disabled="true" /></td>';
		tds += '<td><input type="text" size="16" tabindex="4"  name="fechaApertura"	 	id="fechaA'+nuevaFila+'"  		style="text-align: right" disabled="true"/></td>';
		tds += '<td><input type="text" size="16" tabindex="5"  name="sucursalNombre" 	id="sucursal'+nuevaFila+'"  	style="text-align: right" disabled="true"/></td>';
		
		tds += '<td><input type="button" tabindex="6" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaPlazo(this)"/></td>';
		tds += '</tr>';
		
    	document.getElementById("numeroPlazos").value = nuevaFila;    	
    	$("#miTabla").append(tds);
    	
    	$(':text').bind('keydown', function(e) {
    		if (e.which == 9 && !e.shiftKey) {
    			esTab = true;
    		}
    	});
    	
    	$(':text').focus(function() {
    		esTab = false;
    	});
    	
    	deshabilitaBoton('agregarCuen', 'submit');
    	asignarTabs();
    	return false;
 	});
	
	var tabGeneral = 10;
	
	function asignarTabs(){
		tabGeneral = 19;
		asignarTabIndexCuentas();
		tabGeneral++;
		$('#agregarCuen').attr('tabindex' , tabGeneral);
	}
	
	function asignarTabIndexCuentas(){
		var numeroTab = tabGeneral;
		
		$('#miTabla tr').each(function(index) {
			if(index > 0){
				numeroTab++;
				$('#' + $(this).find("input[name^='cuentasOrigen']").attr('id')).attr('tabindex' , numeroTab);
				numeroTab++;
				$('#' + $(this).find("input[name^='descripcionCuenta']").attr('id')).attr('tabindex' , numeroTab);
				numeroTab++;
				$('#' + $(this).find("input[name^='fechaApertura']").attr('id')).attr('tabindex' , numeroTab);
				numeroTab++;
				$('#' + $(this).find("input[name^='sucursalNombre']").attr('id')).attr('tabindex' , numeroTab);
				numeroTab++;
				$('#' + $(this).find("input[name^='elimina']").attr('id')).attr('tabindex' , numeroTab);
			}
		});
		
		tabGeneral = numeroTab;
	}
	
</script>