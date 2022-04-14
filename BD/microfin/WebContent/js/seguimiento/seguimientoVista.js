$(document).ready(function(){
	
	esTab = true;
	
	$(':text').focus(function() {	
		esTab = false; 
	});
	
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	
	var catTipoCategoriaCon ={
		'principal'	: 1
	};
			
	var catTipoTranSegto = { 
  		'agrega'	: 1, 
  		'modifica'	: 2
	};
	var catTipoConsultaCredito = {
		'principal' : 1	
	};
	
	var catTipoSegtoCon ={
		'principal' : 1	
	};
	
	var catConTipoGestion = {
		'foranea'	: 2
	};
//-----------------------Métodovalidas y manejo de eventos-----------------------
	agregaFormatoControles('formaGenerica');
	deshabilitaBoton('grabar', 'submit');
	deshabilitaBoton('modifica', 'submit');	
	consultaProductos();
	scrollFondeador("");
	$('#prograPeriodicidad').attr('disabled', 'true');
	$('#prograAvanceCredito').attr('disabled', 'true');
	$('#prograDiasOtorga').attr('disabled', 'true');
	$('#prograDiasAntLiq').attr('disabled', 'true');
	$('#prograDiasAntCuota').attr('disabled', 'true');
	$('#seguimientoID').focus();
	
	$.validator.setDefaults({		
	    submitHandler: function(event) {  
	    		grabaFormaTransaccionRetrollamada(event, 'formaGenerica', 'contenedorForma', 'mensaje','true','seguimientoID',
		    			'funcionExitoTransaccion','funcionFalloTransaccion'); 
	    }
	 });
	

	$('#seguimientoID').bind('keyup',function(e) { 		
		lista('seguimientoID', '1', '2', 'seguimientoID', $('#seguimientoID').val(),'listaSeguimiento.htm');
	});

	$('#seguimientoID').blur(function(){
		validaSeguimiento(this.id);
	});
	
	$('#categoriaID').bind('keyup',function(e) { 		
		lista('categoriaID', '2', '1', 'categoriaID', $('#categoriaID').val(),'listaSegtoCategoria.htm');
	});

	$('#categoriaID').blur(function(){
		validaCategoria(this.id);
	});
	
	$('#ejecutorID').bind('keyup',function(e) {
		listaAlfanumerica('ejecutorID', '2', '1','tipoGestionID', $('#ejecutorID').val(),'listaTipoGestion.htm');
	});
	
	$('#ejecutorID').blur(function() {
  		consultaGestion(this.id);
	});
	
	
	$('#producCreditoID').bind('keyup',function(e){  
		lista('producCreditoID', '1', '1', 'descripcion', $('#producCreditoID').val(), 'listaProductosCredito.htm');
	});

	$('#producCreditoID').blur(function() {
		consultaProducCredito(this.id);
	});
	
	$('#grabar').click(function(){
		creaListas();
		$('#tipoTransaccion').val(catTipoTranSegto.agrega);
	});
		
	$('#modifica').click(function(){
		creaListas();
		$('#tipoTransaccion').val(catTipoTranSegto.modifica);

	});
	
	$('#carteraNoAplica').click(function () {
		$('#aplicaCarteraVig').removeAttr('checked');
		$('#aplicaCarteraAtra').removeAttr('checked');
		$('#aplicaCarteraVen').removeAttr('checked');
	});
	$('#aplicaCarteraVig').click(function () {
		$('#carteraNoAplica').removeAttr('checked');
	});
	
	$('#aplicaCarteraAtra').click(function () {
		$('#carteraNoAplica').removeAttr('checked');
	});
	$('#aplicaCarteraVen').click(function () {
		$('#carteraNoAplica').removeAttr('checked');
	});
	
	$('#porcentaje').click(function () {
		habilitaControl('basePorcentaje');
		deshabilitaControl('baseNumero');
		$('#baseNumero').val('');
		$('#basePorcentaje').focus();
	});

	$('#basePorcentaje').bind('keyup',function(e){
		$('#porcentaje').attr('checked', 'true');
		$('#baseNumero').val('');		
	});
	
	$('#numero').click(function () {
		deshabilitaControl('basePorcentaje');
		habilitaControl('baseNumero');
		$('#basePorcentaje').val('');
		$('#baseNumero').focus();
	});
	
	$('#baseNumero').bind('keyup',function(e){
		$('#numero').attr('checked', 'true');
		$('#basePorcentaje').val('');		
	});

	$('#numSelect').val(0);
	$('#numClasifica').val(0);
	$('#numProgram').val(0);
	
	$('#alcGlobal').click(function (){
		$('#contenedorPlazas').hide();
		$('#contenedorPlazas').html('');
		$('#contenedorSucursal').hide();
		$('#contenedorSucursal').html('');
		$('#contenedorEjecutivo').hide();
		$('#contenedorEjecutivo').html('');
	});
	
	$('#alcPlazas').click(function (){
		scrollPlazas();
		$('#contenedorPlazas').show();
		$('#contenedorSucursal').hide();
		$('#contenedorSucursal').html('');
		$('#contenedorEjecutivo').hide();
		$('#contenedorEjecutivo').html('');
	});
	
	$('#alcSucursal').click(function (){
		scrollSucursal();
		$('#contenedorPlazas').hide();
		$('#contenedorPlazas').html('');
		$('#contenedorSucursal').show();
		$('#contenedorEjecutivo').hide();
		$('#contenedorEjecutivo').html('');
	});
	
	$('#alcEjecutivo').click(function (){
		scrollEjecutivo();
		$('#contenedorPlazas').hide();
		$('#contenedorPlazas').html('');
		$('#contenedorSucursal').hide();
		$('#contenedorSucursal').html('');
		$('#contenedorEjecutivo').show();
	});
	//------------ Validaciones de la Forma ---------------select * from SEGUIMIENTOCAMPO;

	$('#formaGenerica').validate({
		rules: {			
			seguimientoID: {
				required: true,
				numeroPositivo: true
			}, 
			descripcion: {
					required : true				
			}, 
			categoriaID :{
				required : true
			},
			cicloCteInicio :{
				required : true
			},
			cicloCteFinal :{
				required : true
			},
			ejecutorID :{
				required : true
			},
			productosID :{
				required : true
			}
		},		
		messages: {
			seguimientoID: {
				required: 'Especificar Número de Seguimiento',
				numeroPositivo: 'Sólo Números Positivos',
			}, 
			descripcion: {
					required : 'Especifique la descripción del Seguimiento'				
			},
			categoriaID :{
				required : 'Especifique la Categoría'
			},
			cicloCteInicio :{
				required : 'Especifique el Ciclo Inicial'
			},
			cicloCteFinal :{
				required : 'Especifique el Ciclo Final'
			},
			ejecutorID :{
				required : 'Especifique el Tipo Gestión'
			},
			productosID :{
				required : 'Especifique el Producto de Crédito'
			}
		}
	});
	
	//-------------Validaciones de controles---------------------
	function scrollFondeador(checkRecPropios) {
		var numCon = 3;
		var FondeoBeanCon={
			'institutFondID' : 0
		};
		fondeoServicio.listaConsulta(numCon, FondeoBeanCon,function(fondeador) {
			if (fondeador != null) {
					var tds = "";
					tds += '<table id="tablaFondeador">';
					tds += '<tr>';
					tds += '<td colspan="2">';
					tds += '<input type="checkbox" id="selecTodosFondeo" name="selecTodos" onclick="selecTodoFondeo(this.id)" tabindex="27" /><label>Selecciona Todos</label>';
					tds += '</td>';
					tds += '</tr>';
					tds += '<tr>';
					tds += '<td>';
					tds += '</td>';
					tds += '<td>';
					tds += '<label>No. Institución</label>';
					tds += '</td>';
					tds += '<td>';
					tds += '<label>Nombre</label>';
					tds += '</td>';
					tds += '<td class="separador"></td>';
					tds += '<td>';
					tds += '</td>';
					tds += '<td>';
					tds += '<label>No. Institución</label>';
					tds += '</td>';
					tds += '<td>';
					tds += '<label>Nombre</label>';
					tds += '</td>';
					tds += '</tr>';
					tds += '<tr>';
					tds += '<td>';
					if (checkRecPropios == 'S'){
						tds += '<input type="checkbox" id="recPropios" name="recPropios" checked="true"/>';	
					}else{
						tds += '<input type="checkbox" id="recPropios" name="recPropios"/>';
					}
					tds += '</td>';
					tds += '<td></td>';
					tds += '<td><input type="text" id="propios" name="propios" value="RECURSOS PROPIOS" size="40" disabled="true"/></td>';					 
					tds += '</tr>';
					tds += '<tr>';
				for (var i=0; i< fondeador.length; i++) {
					if ( (i>0) &&  ((i%2) == 0)) {
						tds += '<tr>';
					}
					if ( (i>0) && ((i%2) == 1)) {
						tds += '<td class="separador"></td>';
					}
					tds += '<td>';
					tds += '<input type="checkbox" id="checkFondeo'+i+'" name="checkFondeo"/>';
					tds += '</td>';
					tds += '<td>';
					tds += '<input type="text" id="fondeo'+i+'" name="fondeo" value="'+fondeador[i].institutFondID+'" size="3" disabled="true">';
					tds += '</td>';
					tds += '<td>';
					tds += '<input type="text" id="nomFondeo'+i+'" name="nomFondeo" value="'+fondeador[i].nombreInstitFon+'" size="40" disabled="true" />';
					tds += '</td>';
					if ( (i>0) && ((i%2) == 1)) {
						tds += '</tr>';
					}
				}
				tds += '</table>';
				$('#contenedorFondeador').html(tds);
			}
		});
	}

	function consultaFondeador(){
		var numCon = 9;
		var id;
		var segtoID = $('#seguimientoID').val();
		var SegtoBeanCon ={
			'seguimientoID' : segtoID
		};
		seguimientoServicio.listaConsulta(numCon, SegtoBeanCon,function(fondeador) {
			if (fondeador!=null){
				for(var i=0; i< fondeador.length; i++){
					$('input[name=checkFondeo]').each(function (){
						id = this.id.substring(11);
						if ($('#fondeo'+id).val() == fondeador[i].fondeadorID ){
							$(this).attr('checked', 'true');
						}
					});
				}
			}
		});
	}

	
	function consultaPlazas(){
		var numCon = 6;
		var id;
		var segtoID = $('#seguimientoID').val();
		var SegtoBeanCon ={
			'seguimientoID' : segtoID	
		};
		seguimientoServicio.listaConsulta(numCon, SegtoBeanCon,function(plazas) {
			if (plazas !=null){
				for(var i=0; i< plazas.length; i++){
					$('input[name=checkPlaza]').each(function (){
						id = this.id.substring(10);
						if ($('#plaza'+id).val() == plazas[i].plazaID ){
							$(this).attr('checked', 'true');
						}
					});
				}
			}
		});
	}
	
	function consultaSucursales(){
		var numCon = 7;
		var id;
		var segtoID = $('#seguimientoID').val();
		var SegtoBeanCon ={
			'seguimientoID' : segtoID	
		};
		seguimientoServicio.listaConsulta(numCon, SegtoBeanCon,function(sucursal) {
			if(sucursal != null){
				for(var i=0; i< sucursal.length; i++){
					$('input[name=checkSucur]').each(function (){
						id = this.id.substring(10);
						if ($('#sucursal'+id).val() == sucursal[i].sucursalID ){
							$(this).attr('checked', 'true');
						}
					});
				}
			}
		});
	}
	
	function consultaEjecutivos(){
		var numCon = 8;
		var id;
		var segtoID = $('#seguimientoID').val();
		var SegtoBeanCon ={
			'seguimientoID' : segtoID	
		};
		seguimientoServicio.listaConsulta(numCon, SegtoBeanCon,function(ejecutivo) {
			if(ejecutivo != null){
				for(var i=0; i< ejecutivo.length; i++){
					$('input[name=checkEjec]').each(function (){
						id = this.id.substring(9);
						if ($('#ejecutivo'+id).val() == ejecutivo[i].ejecutivoID ){
							$(this).attr('checked', 'true');
						}
					});
				}
			}
		});
	}
	
	function creaListas(){
		var contador = 1;
		var id;
		$('#lisPlazas').val("");
		$('#lisSucursal').val("");
		$('#lisEjecutivo').val("");
		$('input[name=prograPlazoMaximo]').each(function() {
			habilitaControl(this.id);
		});
		$('input[name=checkPlaza]').each(function() {
			id = this.id.substring(10);
			if ($(this).is(':checked')) {
				if (contador != 1){
					$('#lisPlazas').val($('#lisPlazas').val() + ','  + $('#plaza'+id).val());
				}else{
					$('#lisPlazas').val($('#plaza'+id).val());
				}
				contador = contador + 1;
			}
		});
		contador = 1;
		$('input[name=checkSucur]').each(function() {
			id = this.id.substring(10);
			if ($(this).is(':checked')) {
				if (contador != 1){
					$('#lisSucursal').val($('#lisSucursal').val() + ','  + $('#sucursal'+id).val());
				}else{
					$('#lisSucursal').val($('#sucursal'+id).val());
				}
				contador = contador + 1;
			}
		});
		contador = 1;
		$('input[name=checkEjec]').each(function() {
			id = this.id.substring(9);
			if ($(this).is(':checked')) {
				if (contador != 1){
					$('#lisEjecutivo').val($('#lisEjecutivo').val() + ','  + $('#ejecutivo'+id).val());
				}else{
					$('#lisEjecutivo').val($('#ejecutivo'+id).val());
				}
				contador = contador + 1;
			}
		});
		contador = 1;
		$('input[name=checkFondeo]').each(function() {
			id = this.id.substring(11);
			if ($(this).is(':checked')) {
				if (contador != 1){
					$('#lisFondeo').val($('#lisFondeo').val() + ','  + $('#fondeo'+id).val());
				}else{
					$('#lisFondeo').val($('#fondeo'+id).val());
				}
				contador = contador + 1;
			}
		});
	}
	
	
	function scrollEjecutivo() {
		var numCon = 4;
		var EjecutivoBeanLis={
			'clavePuestoID' : ''
		};
		puestosServicio.listaConsulta(numCon, EjecutivoBeanLis,function(ejecutivo) {
			if (ejecutivo != null) {
					var tds = "";
					tds += '<fieldset class="ui-widget ui-widget-content ui-corner-all">';
					tds += '<legend>Ejecutivos</legend>';
					tds += '<table id="tablaEjecutivo">';
					tds += '<tr>';
					tds += '<td colspan="2">';
					tds += '<input type="checkbox" id="selecTodosEjecu" name="selecTodos" onclick="selecTodoEjecutivo(this.id)" /><label>Selecciona Todos</label>';
					tds += '</td>';
					tds += '</tr>';
					tds += '<tr>';
					tds += '<td>';
					tds += '</td>';
					tds += '<td>';
					tds += '<label>Clave Puesto</label>';
					tds += '</td>';
					tds += '<td>';
					tds += '<label>Descripción</label>';
					tds += '</td>';
					tds += '<td class="separador"></td>';
					tds += '<td>';
					tds += '</td>';
					tds += '<td>';
					tds += '<label>Clave Puesto</label>';
					tds += '</td>';
					tds += '<td>';
					tds += '<label>Descripción</label>';
					tds += '</td>';
					tds += '</tr>';
					tds += '<tr>';
				for (var i=0; i< ejecutivo.length; i++) {
					if ( (i>0) &&  ((i%2) == 0)) {
						tds += '<tr>';
					}
					if ( (i>0) &&  ((i%2) == 1)) {
						tds += '<td class="separador"></td>';
					}
					tds += '<td>';
					tds += '<input type="checkbox" id="checkEjec'+i+'" name="checkEjec"/>';
					tds += '</td>';
					tds += '<td>';
					tds += '<input type="text" id="ejecutivo'+i+'" name="alcanceEjecu" value="'+ejecutivo[i].clavePuestoID+'" size="15" disabled="true">';
					tds += '</td>';
					tds += '<td>';
					tds += '<input type="text" id="nomEjecutivo'+i+'" name="nomEjecutivo" value="'+ejecutivo[i].descripcion+'" size="40" disabled="true" />';
					tds += '</td>';
					if ( (i>0) &&  ((i%2) == 1)) {
						tds += '</tr>';
					}
					
				}
				tds += '</fieldset>';
				tds += '</table>';
				$('#contenedorEjecutivo').html(tds);
			}
		});
	}

	function scrollSucursal() {
		var numCon = 2;
		var SucursalBeanLis={
			'nombreSucurs' : ''
		};
		sucursalesServicio.listaCombo(numCon, SucursalBeanLis,function(sucursal) {
			if (sucursal != null) {
				var tds = "";
				tds += '<fieldset class="ui-widget ui-widget-content ui-corner-all">';
				tds += '<legend>Sucursales</legend>';
				tds += '<table id="tablaSucursal">';
				tds += '<tr>';
				tds += '<td colspan="2">';
				tds += '<input type="checkbox" id="selecTodosSucur" name="selecTodos" onclick="selecTodoSucursal(this.id)" /><label>Selecciona Todos</label>';
				tds += '</td>';
				tds += '</tr>';
				tds += '<tr>';
				tds += '<td>';
				tds += '</td>';
				tds += '<td>';
				tds += '<label>No.Sucursal</label>';
				tds += '</td>';
				tds += '<td>';
				tds += '<label>Nombre</label>';
				tds += '</td>';
				tds += '<td class="separador"></td>';
				tds += '<td>';
				tds += '</td>';
				tds += '<td>';
				tds += '<label>No.Sucursal</label>';
				tds += '</td>';
				tds += '<td>';
				tds += '<label>Nombre</label>';
				tds += '</td>';
				tds += '</tr>';
				tds += '<tr>';
				for (var i=0; i< sucursal.length; i++) {
					if ( (i>0) &&  ((i%2) == 0)) {
						tds += '<tr>';
					}
					if ( (i>0) &&  ((i%2) == 1)) {
						tds += '<td class="separador"></td>';
					}
					tds += '<td>';
					tds += '<input type="checkbox" id="checkSucur'+i+'" name="checkSucur"/>';
					tds += '</td>';
					tds += '<td>';
					tds += '<input type="text" id="sucursal'+i+'" name="alcanceSucur" value="'+sucursal[i].sucursalID+'" size="5" disabled="true">';
					tds += '</td>';
					tds += '<td>';
					tds += '<input type="text" id="nomSucursal'+i+'" name="nomSucursal" value="'+sucursal[i].nombreSucurs+'" size="30" disabled="true" />';
					tds += '</td>';
					if ( (i>0) &&  ((i%2) == 1)) {
						tds += '</tr>';
					}
				}
				tds += '</table>';
				tds += '</fieldset>';
				$('#contenedorSucursal').html(tds);
			}
		});
	}
	function scrollPlazas() {
		var numCon = 3;
		var PlazasBeanLis={
			'plazaID' : ''
		};
		plazasServicio.listaConsulta(numCon, PlazasBeanLis,function(plazas) {
			if (plazas != null) {
				var tds = "";
				tds += '<fieldset class="ui-widget ui-widget-content ui-corner-all">';
				tds += '<legend>Plazas</legend>';
				tds += '<table id="tablaPlazas">';
				tds += '<tr>';
				tds += '<td colspan="2">';
				tds += '<input type="checkbox" id="selecTodosPlazas" name="selecTodos" onclick="selecTodoPlazas(this.id)" /><label>Selecciona Todos</label>';
				tds += '</td>';
				tds += '</tr>';
				tds += '<tr>';
				tds += '<td>';
				tds += '</td>';
				tds += '<td>';
				tds += '<label>No.Plaza</label>';
				tds += '</td>';
				tds += '<td>';
				tds += '<label>Descripción</label>';
				tds += '</td>';
				tds += '<td class="separador"></td>';
				tds += '<td></td>';
				tds += '<td>';
				tds += '<label>No.Plaza</label>';
				tds += '</td>';
				tds += '<td>';
				tds += '<label>Descripción</label>';
				tds += '</td>';
				tds += '</tr>';
				tds += '<tr>';
				for (var i=0; i< plazas.length; i++) {
					if ( (i>0) &&  ((i%2) == 0)) {
						tds += '<tr>';
					}
					if ( (i>0) &&  ((i%2) == 1)) {
						tds += '<td class="separador"></td>';
					}
					tds += '<td>';
					tds += '<input type="checkbox" id="checkPlaza'+i+'" name="checkPlaza"/>';
					tds += '</td>';
					tds += '<td>';
					tds += '<input type="text" id="plaza'+i+'" name="alcancePlaza" value="'+plazas[i].plazaID+'" size="5" disabled="true">';
					tds += '</td>';
					tds += '<td>';
					tds += '<input type="text" id="nomPlaza'+i+'" name="nomPlaza" value="'+plazas[i].nombre+'" size="30" disabled="true" />';
					tds += '</td>';
					if ( (i>0) &&  ((i%2) == 1)) {
						tds += '</tr>';
					}
				}
				tds += '</table>';
				tds += '</fieldset>';
				$('#contenedorPlazas').html(tds);
			}
		});
	}	
	
	function consultaGridClasifica(){
		var segtoID = $('#seguimientoID').val();
		var numCon = 5;
		var SegtoBeanCon  = {
				'seguimientoID' : segtoID
		};
		seguimientoServicio.listaConsulta(numCon, SegtoBeanCon,function(clasifica) {
			if (clasifica != null){
			var tds = '';
			var aux = 1;
			for (var i = 0; i < clasifica.length; i++){
				
				tds += '<tr id="renglonClasifica' + i + '" name="renglonClasifica">';	
 				tds += '<td>';
				tds += '	<input type="text" id="consecutivo'+i+'" name="consecutivo1" value="'+aux+'" size="5" disabled="true" />';
				aux++;
				tds += '			</td>';
				tds += '			<td>';
				tds += '		<select id="clasifCondicion'+i+'" name="clasifCondicion" path="clasifCondicion" tabindex="">';
				tds += '			<option value="">SELECCIONA</option>';
				if (clasifica[i].claCondicion == '1'){
					tds += '			<option value="1" selected>REGIÓN</option>';
				}else {
					tds += '			<option value="1">REGIÓN</option>';
				}
				if (clasifica[i].claCondicion == '2'){
					tds += '			<option value="2" selected>SUCURSAL</option>';
				}else {
					tds += '			<option value="2">SUCURSAL</option>';
				}
				if (clasifica[i].claCondicion == '3'){
					tds += '			<option value="3" selected>OFICIAL</option>';
				}else {
					tds += '			<option value="3">OFICIAL</option>';
				}
				if (clasifica[i].claCondicion == '4'){
					tds += '			<option value="4" selected>MUNICIPIO</option>';
				}else {
					tds += '			<option value="4">MUNICIPIO</option>';
				}
				if (clasifica[i].claCondicion == '5'){
					tds += '			<option value="5" selected>GÉNERO</option>';
				}else {
					tds += '			<option value="5">GÉNERO</option>';
				}
				if (clasifica[i].claCondicion == '6'){
					tds += '			<option value="6" selected>MONTO ORIGINAL CRÉDITO</option>';
				}else {
					tds += '			<option value="6">MONTO ORIGINAL CRÉDITO</option>';
				}
				if (clasifica[i].claCondicion == '7'){
					tds += '			<option value="7" selected>SALDO DEL CREDITO</option>';
				}else {
					tds += '			<option value="7">SALDO DEL CREDITO</option>';
				}
				if (clasifica[i].claCondicion == '8'){
					tds += '			<option value="8" selected>SALDO MORA + CARGOS</option>';
				}else {
					tds += '			<option value="8">SALDO MORA + CARGOS</option>';
				}
				if (clasifica[i].claCondicion == '9'){
					tds += '			<option value="9" selected>FECHA PRÓXIMO VENCIMIENTO</option>';
				}else {
					tds += '			<option value="9">FECHA PRÓXIMO VENCIMIENTO</option>';
				}
				if (clasifica[i].claCondicion == '10'){
					tds += '			<option value="10" selected>FECHA OTORGAMIENTO CRÉDITO</option>';
				}else{
					tds += '			<option value="10">FECHA OTORGAMIENTO CRÉDITO</option>';
				}
				if (clasifica[i].claCondicion == '11'){
					tds += '			<option value="11" selected>FECHA LIQUIDACIÓN CRÉDITO</option>';
				}else {
					tds += '			<option value="11">FECHA LIQUIDACIÓN CRÉDITO</option>';
				}
				if (clasifica[i].claCondicion == '12'){
					tds += '			<option value="12" selected>DÍAS DE ATRASO</option>';
				}else {
					tds += '			<option value="12">DÍAS DE ATRASO</option>';
				}
				tds += '		</select>';
				tds += '	</td>';
				tds += '	<td>';
				tds += '		<select id="clasifOperador'+i+'" name="clasifOperador" path="clasifOperador" tabindex="">';
				tds += '			<option value="">SELECCIONA</option>';
				if (clasifica[i].claOperador == 'ASC'){
					tds += '			<option value="ASC" selected>ASCENDENTE</option>';
				}else {
					tds += '			<option value="ASC">ASCENDENTE</option>';
				}
				if (clasifica[i].claOperador == 'DESC'){
					tds += '			<option value="DESC" selected>DESCENDENTE</option>';
				}else {
					tds += '			<option value="DESC">DESCENDENTE</option>';
				}
				tds += '		</select>';
				tds += '	</td>';
    			tds += '<td><input type="button" name="elimina" id="'+i +'" value="" class="btnElimina" onclick="eliminaClasifica(this)"/>';
    			tds += '<input type="button" name="agrega" id="'+i+'" class="btnAgrega" onclick="agregaElementoClasifica()"/></td>';
    			tds += '</tr>';
			}
			document.getElementById("numClasifica").value = clasifica.length;
   	 		$("#tableClasifica").append(tds);
   	 	}
		});
		
	}


	function consultaGridPrograma() {
		var segtoID = $('#seguimientoID').val();
		var numCon = 4;
		var SegtoBeanCon  = {
				'seguimientoID' : segtoID
		};
		seguimientoServicio.listaConsulta(numCon, SegtoBeanCon,function(programa) {
			if (programa != null){
				var numRenglon = 1;
			var tds = '';
			for (var i = 0; i < programa.length; i++){
				tds += '<tr id="renglonPrograma' +numRenglon+ '" name="renglonPrograma">';
				tds += '<td>';
				tds += '	<fieldset class="ui-widget ui-widget-content ui-corner-all">';
				tds += '		<legend class="label">Criterio</legend>';
				tds += '		<table border="0" cellpadding="0" cellspacing="0" width="100%">';
				tds += '<tr>';
				tds += '<td>';
				tds += '		<select id="criterio'+numRenglon+'" name="comboCriterio" onchange="comboCambio(this.id)">';
				tds += '											<option value="">SELECCIONA</option>';
				if (programa[i].periodicidad != ''){
						tds += '	<option value="1" selected>PERIODICIDAD</option>';
				}else{
					tds += '		<option value="1">PERIODICIDAD</option>';
				}
				if (programa[i].avanceCredito != 0){
					tds += '		<option value="2" selected>% DE AVANCE DEL PLAN DE CRÉDITO</option>';
				}else {
					tds += '		<option value="2">% DE AVANCE DEL PLAN DE CRÉDITO</option>';
				}
				if (programa[i].diasOtorga != 0){
					tds += '	<option value="3" selected>DÍAS POSTERIOR OTORGAMIENTO</option>';
				}else{
					tds += '	<option value="3">DÍAS POSTERIOR OTORGAMIENTO</option>';
				}
				if (programa[i].diasAntLiq != 0){
					tds += '	<option value="4" selected>DÍAS ANTERIOR A LA LIQUIDACIÓN</option>';
				}else {
					tds += '	<option value="4">DÍAS ANTERIOR A LA LIQUIDACIÓN</option>';
				}
				if (programa[i].diasAntCuota != 0){
					tds += '		<option value="5" selected>DIAS ANTERIOR PAGO CUOTA</option>';
				}else {
					tds += '		<option value="5">DIAS ANTERIOR PAGO CUOTA</option>';
				}
						tds += '							</select>';
						tds += '						</td>';
				if (programa[i].periodicidad != ''){		
					tds += '<td id="trPeriodo'+numRenglon+'">';
				}else {
					tds += '<td id="trPeriodo'+numRenglon+'" style="display:none">';
				}
				tds += '		<select id="prograPeriodicidad'+numRenglon+'" name="prograPeriodicidad" path="prograPeriodicidad" tabindex="" onchange="cambioPeriodo(this.id)">';
				tds += '						<option value="">SELECCIONA</option>';
				if (programa[i].periodicidad == 'D'){
					tds += '		<option value="D" selected>DIARIO</option>';
				}else {
					tds += '		<option value="D">DIARIO</option>';
				}
				if (programa[i].periodicidad == 'S'){
					tds += '<option value="S" selected>SEMANAL</option>';
				}else{
					tds += '<option value="S">SEMANAL</option>';
				}
				if (programa[i].periodicidad == 'C'){
					tds += '		<option value="C" selected>CATORCENAL</option>';
				}else {
					tds += '		<option value="C">CATORCENAL</option>';
				}
				if (programa[i].periodicidad == 'Q'){
					tds += '			<option value="Q" selected>QUINCENAL</option>';
				}else{
					tds += '			<option value="Q">QUINCENAL</option>';
				}
				if (programa[i].periodicidad == 'M'){
					tds += '	<option value="M" selected>MENSUAL</option>';
				}else {
					tds += '	<option value="M">MENSUAL</option>';
				}
				if (programa[i].periodicidad == 'B'){
					tds += '	<option value="B" selected>BIMESTRAL</option>';
				}else{
					tds += '	<option value="B">BIMESTRAL</option>';
				}
				if (programa[i].periodicidad == 'T'){
					tds += '			<option value="T" selected>TRIMESTRAL</option>';
				}else {
					tds += '			<option value="T">TRIMESTRAL</option>';
				}
				if (programa[i].periodicidad == 'U'){
					tds += '			<option value="U" selected>CUATRIMESTRAL</option>';
				}else{
					tds += '			<option value="U">CUATRIMESTRAL</option>';
				}
				if (programa[i].periodicidad == 'I'){
					tds += '			<option value="I" selected>QUINCOMENSUAL</option>';
				}else {
					tds += '			<option value="I">QUINCOMENSUAL</option>';
				}
				if (programa[i].periodicidad == 'E'){
					tds += '			<option value="E" selected>SEMESTRAL</option>';
				}else {
					tds += '			<option value="E">SEMESTRAL</option>';
				}
				if (programa[i].periodicidad == 'A'){
					tds += '			<option value="A" selected>ANUAL</option>';
				}else {
					tds += '			<option value="A">ANUAL</option>';
				}
				if (programa[i].periodicidad == 'N'){
					tds += '			<option value="N" selected>NO APLICA</option>';
				}else {
					tds += '			<option value="N">NO APLICA</option>';
				}
				tds += '	</select>';
				tds += '						</td>';
				if (programa[i].avanceCredito != 0){
					tds += '	<td id="tdAvance'+numRenglon+'">';
				}else {
					tds += ' <td id="tdAvance'+numRenglon+'" style="display:none">';
				}
				tds += '							<input type="text" id="prograAvanceCredito'+numRenglon+'" name="prograAvanceCredito" path="prograAvanceCredito" value="'+programa[i].avanceCredito+'"size="5" tabindex="" onkeypress="validaSoloNumeros();"/><label>%</label>';
				tds += '						</td>';
				if (programa[i].diasOtorga != 0){
					tds += '<td id="tdOtorga'+numRenglon+'">';
				}else {
					tds += '	<td id="tdOtorga'+numRenglon+'" style="display:none">';
				}
				tds += '							<input type="text" id="prograDiasOtorga'+numRenglon+'" name="prograDiasOtorga" path="prograDiasOtorga" value="'+programa[i].diasOtorga+'" size="5" tabindex="" onkeypress="validaSoloNumeros();" />';
				tds += '						</td>';
				if (programa[i].diasAntLiq != 0){	
					tds += '	<td id="tdLiquida'+numRenglon+'">';
				}else{
					tds += ' <td id="tdLiquida'+numRenglon+'" style="display:none">';
				}
				tds += '							<input type="text" id="prograDiasAntLiq'+numRenglon+'" name="prograDiasAntLiq" path="prograDiasAntLiq" value="'+programa[i].diasAntLiq+'" size="5" tabindex="" onkeypress="validaSoloNumeros();"/>';
				tds += '						</td>';
				if (programa[i].diasAntCuota != 0){
					tds += '	<td id="tdCuota'+numRenglon+'" >';
				}else {
					tds += '	<td id="tdCuota'+numRenglon+'" style="display:none">';
				}
				tds += '							<input type="text" id="prograDiasAntCuota'+numRenglon+'" name="prograDiasAntCuota" path="prograDiasAntCuota" value="'+programa[i].diasAntCuota+'" size="5" tabindex="" onkeypress="validaSoloNumeros();"/>';
				tds += '						</td>';
				tds += '			</tr>';
				tds += '			<tr>';
				
				tds += '<tr>';
				tds += '	<td>';
				tds += '		<label>Días Máximos desde Último Segto.:</label>';
				tds += '	</td>';
				tds += '	<td>';
				if (programa[i].maxUltSegto != 0){
					tds += '<input type="text" id="prograMaxUltSegto'+numRenglon+'" name="prograMaxUltSegto" path="prograMaxUltSegto" size="5" tabindex="" value="'+programa[i].maxUltSegto+'" onkeypress="validaSoloNumeros()"/>';
				}else{
					tds += '<input type="text" id="prograMaxUltSegto'+numRenglon+'" name="prograMaxUltSegto" path="prograMaxUltSegto" size="5" tabindex="" onkeypress="validaSoloNumeros()"/>';
				}
				tds += '												</td>';
				tds += '									<td class="separador"></td>';
				tds += '									<td>';
				tds += '										<label>Días Mínimos desde Último Segto.:</label>';
				tds += '									</td>';
				tds += '									<td>';
				if (programa[i].minUltSegto != 0){
					tds += '		<input type="text" id="prograMinUltSegto'+numRenglon+'" name="prograMinUltSegto" path="prograMinUltSegto" size="5" tabindex="" value="'+programa[i].minUltSegto+'" onkeypress="validaSoloNumeros()"/>';
				}else{
					tds += ' 	<input type="text" id="prograMinUltSegto'+numRenglon+'" name="prograMinUltSegto" path="prograMinUltSegto" size="5" tabindex="" onkeypress="validaSoloNumeros()"/>';
				}
				tds += '									</td>';
				tds += '								</tr>';
				tds += '								<tr>';
				tds += '									<td>';
				tds += '										<label>Máximo de Eventos:</label>';
				tds += '									</td>';
				tds += '									<td>';
				if (programa[i].plazoMaximo != 0){
					tds += '	<input type="text" id="prograPlazoMaximo'+numRenglon+'" name="prograPlazoMaximo" path="prograPlazoMaximo" value="'+programa[i].plazoMaximo+'" size="5" tabindex="" onkeypress="validaSoloNumeros()"/>';
				}else{
					tds += '	<input type="text" id="prograPlazoMaximo'+numRenglon+'" name="prograPlazoMaximo" path="prograPlazoMaximo" size="5" tabindex="" onkeypress="validaSoloNumeros()"/>';
				}
				tds += '									</td>';
				tds += '								</tr>';
				tds += '							</table>';
				tds += '						</fieldset>';
				tds += '		</td>';
				tds += '		<td>';
				tds += '			<fieldset class="ui-widget ui-widget-content ui-corner-all">';
				tds += '										<legend class="label">Día Fijo</legend>';
				tds += '							<table border="0" cellpadding="0" cellspacing="0" width="100%">';
				tds += '								<tr>';
				tds += '									<td class="label">';
				tds += '										<select id="comboDia'+numRenglon+'" name="comboDia" onchange="cambioDia(this.id)">';
				tds += '											<option value="">SELECCIONA</option>';
				if (programa[i].diaMes != '') {
				tds += '											<option value="1" selected>DÍA DEL MES</option>';
				}else {
					tds += '											<option value="1">DÍA DEL MES</option>';
				}
				if (programa[i].diaSemana != '') {
					tds += '											<option value="2" selected>DÍA SEMANA</option>';
				}else {
					tds += '											<option value="2">DÍA SEMANA</option>';
				}
				tds += '										</select>';
				tds += '									</td>';
				if (programa[i].diaMes != 0) {
					tds += '									<td id="diaMes'+numRenglon+'">';
				}else {
					tds += '									<td id="diaMes'+numRenglon+'" style="display:none">';
				}
				if (programa[i].diaMes != 0){
					tds += '	<input type="text" id="prograDiaMes'+numRenglon+'" name="prograDiaMes" path="prograDiaMes" value="'+programa[i].diaMes+'" size="5" tabindex="" onkeypress="validaSoloNumeros();" onblur="validaDias(this.id)"/>';
				}else {
					tds += '	<input type="text" id="prograDiaMes'+numRenglon+'" name="prograDiaMes" path="prograDiaMes" size="5" tabindex="" onkeypress="validaSoloNumeros()" onblur="validaDias(this.id)"/>';
				}
				tds += '				</td>';
				if (programa[i].diaSemana == ''){
					tds += '				<td id="diaSemana'+numRenglon+'" style="display:none">';
				}else {
					tds += '				<td id="diaSemana'+numRenglon+'">';
				}
				tds += '	<select id="prograDiaSemana'+numRenglon+'" name="prograDiaSemana" path="prograDiaSemana" tabindex="">';
				if (programa[i].diaSemana == 0){
					tds += '											<option value="" selected>SELECCIONA</option>';
				}else {
					tds += '											<option value="">SELECCIONA</option>';
				}
				if (programa[i].diaSemana == 'L'){
					tds += '											<option value="L" selected>LUNES</option>';
				}else {
					tds += '											<option value="L">LUNES</option>';
				}
				if (programa[i].diaSemana == 'M'){
					tds += '											<option value="M" selected>MARTES</option>';
				}else {
					tds += '											<option value="M">MARTES</option>';
				}
				if (programa[i].diaSemana == 'MI'){
					tds += '											<option value="MI" selected>MIÉRCOLES</option>';
				}else{
					tds += '											<option value="MI">MIÉRCOLES</option>';
				}
				if (programa[i].diaSemana == 'J'){
					tds += '								<option value="J" selected>JUEVES</option>';
				}else{
					tds += '								<option value="J">JUEVES</option>';
				}
				if (programa[i].diaSemana == 'V'){	
					tds += '								<option value="V" selected>VIERNES</option>';
				}else {
					tds += '								<option value="V">VIERNES</option>';
				}
				if (programa[i].diaSemana == 'I'){
					tds += '								<option value="I" selected>INDISTINTO</option>';
				}else {
					tds += '								<option value="I">INDISTINTO</option>';
				}
				tds += '							</select>';
				tds += '						</td>';
				tds += '					</tr>';
				tds += '					<tr>';
				tds += '						<td class="label">';
				tds += '							<label>Día hábil Sig./Ant.:</label>';
				tds += '						</td>';
				tds += '						<td>';
				tds += '							<select id="prograDiaHabil'+numRenglon+'" name="prograDiaHabil" path="prograDiaHabil" tabindex="">';
				tds += '						<option value="">SELECCIONA</option>';
				if (programa[i].diaHabil == 'S'){
					tds += '								<option value="S" selected>SIGUIENTE</option>';
				}else {
					tds += '								<option value="S">SIGUIENTE</option>';
				}
				if (programa[i].diaHabil == 'A'){
					tds += '								<option value="A" selected>ANTERIOR</option>';
				}else {
					tds += '								<option value="A">ANTERIOR</option>';
				}
				tds += '								</select>';
				tds += '							</td>';
				tds += '						</tr>';
				tds += '					</table>';
				tds += '				</fieldset>';
				tds += '			</td>';
				tds += '<td><input type="button" name="elimina" id="'+numRenglon+'" value="" class="btnElimina" onclick="eliminaPrograma(this)"/>';
		    	tds += '<input type="button" name="agrega" id="${status.count}" class="btnAgrega" onclick="agregaElementoPrograma()"/></td>';
	   		tds += '</tr>';
	   		numRenglon++;
			}
			document.getElementById("numProgram").value = programa.length;
    		$("#tablePrograma").append(tds);
    	}
		});		
	}	
	
	function consultaGridSeleccion() {
		var segtoID = $('#seguimientoID').val();
		var numCon = 3;
		var SegtoBeanCon  = {
				'seguimientoID' : segtoID
		};
		seguimientoServicio.listaConsulta(numCon, SegtoBeanCon,function(criterios) {
			if (criterios != null){
				$("tableSelec").show();
				$("#tableSelec").append(tds);
			var tds = '';
			for (var i = 0; i < criterios.length; i++){
				tds += '<tr id="renglonSeleccion'+i+'" name="renglonSeleccion">';
				tds += '<td>';
				if (criterios[i].compuerta == 'OR'){
					tds += '	<select id="compuerta'+i+'" name="selecCompuerta" path="selecCompuerta" tabindex="">';
					tds += '		<option value="">SELECCIONA</option>';
					tds += '		<option value="OR" selected>O</option>';
					tds += '		<option value="AND">Y</option>';
					tds += '	</select>';
				}else if (criterios[i].compuerta == 'AND') {
					tds += '	<select id="compuerta'+i+'" name="selecCompuerta" path="selecCompuerta" tabindex="">';
					tds += '		<option value="">SELECCIONA</option>';
					tds += '		<option value="OR" >O</option>';
					tds += '		<option value="AND" selected>Y</option>';
					tds += '	</select>';
				}
				tds += '</td>';
				tds += '<td>';
				tds += '	<select id="condicion'+i+'" name="selecCondi1" path="selecCondi1" tabindex="" onchange="cambioCondicionUno(this.id)">';
				tds += '		<option value="">SELECCIONA</option>';
				if (criterios[i].condici1 == 1) {
					tds += '		<option value="1" selected>SALDO TOTAL CRÉDITO</option>';
				}else{
					tds += '		<option value="1">SALDO TOTAL CRÉDITO</option>';
				}
				if (criterios[i].condici1 == 2){
					tds += '<option value="2" selected>MONTO ORIGINAL CRÉDITO</option>';
				}else{
					tds += '<option value="2">MONTO ORIGINAL CRÉDITO</option>';
				}
				if (criterios[i].condici1 == 3){
					tds += '<option value="3" selected>SALDO DE CAPITAL</option>';
				}else{
					tds += '<option value="3">SALDO DE CAPITAL</option>';
				}
				if (criterios[i].condici1 == 4){
					tds += '		<option value="4" selected>CAPITAL ATRASADO</option>';
				}else{
					tds += '		<option value="4">CAPITAL ATRASADO</option>';
				}
				if (criterios[i].condici1 == 5){
					tds += '		<option value="5" selected>DÍAS DE ATRASO</option>';					
				}else{
					tds += '		<option value="5" >DÍAS DE ATRASO</option>';
				}
				if (criterios[i].condici1 == 6){
					tds += '		<option value="6" selected>DÍAS DE LIQUIDACIÓN</option>';
				}else{
					tds += '		<option value="6">DÍAS DE LIQUIDACIÓN</option>';
				}
				if (criterios[i].condici1 == 7){
					tds += '		<option value="7" selected>DÍAS DEL OTORGAMIENTO</option>';
				}else{
					tds += '		<option value="7">DÍAS DEL OTORGAMIENTO</option>';
				}
				if (criterios[i].condici1 == 8){
					tds += '		<option value="8" selected>DÍAS PARA EL PRÓXIMO VENCIMIENTO</option>';
				}else{
					tds += '		<option value="8">DÍAS PARA EL PRÓXIMO VENCIMIENTO</option>';
				}
				tds += '	</select>';
				tds += '</td>			';					
				tds += '<td>';
				tds += '		<select id="operador'+i+'" name="selecOperador" path="selecOperador" tabindex="">';
				tds += '			<option value="">SELECCIONA</option>';
				if (criterios[i].operador == 1){
					tds += '			<option value="1" selected>MAYOR QUE</option>';
				}else{
					tds += '			<option value="1">MAYOR QUE</option>';	
				}
				if (criterios[i].operador == 2){
					tds += '			<option value="2" selected>MENOR QUE</option>';
				}else{
					tds += '			<option value="2">MENOR QUE</option>';
				}
				if (criterios[i].operador == 3){
					tds += '			<option value="3" selected>IGUAL QUE</option>';
				}else {
					tds += '			<option value="3">IGUAL QUE</option>';
				}
				if (criterios[i].operador == 4){
					tds += '			<option value="4" selected>DIFERENTE QUE</option>';
				}else{
					tds += '			<option value="4">DIFERENTE QUE</option>';
				}
				tds += '		</select>';
				tds += '	</td>';
				tds += '	<td>';
				tds += '		<select id="condici'+i+'" name="selecCondi2" path="selecCondi2" tabindex="" onchange="cambioCondicionDos(this.id)">';
				tds += '			<option value="">SELECCIONA</option>';
				if (criterios[i].condici2 == 1){
					tds += '		<option value="1" selected>NÚMERO FIJO</option>';
				}else{
					tds += '		<option value="1">NÚMERO FIJO</option>';
				}
				if (criterios[i].condici2 == 2){
					tds += '		<option value="2" selected>MONTO FIJO</option>';
				}else {
					tds += '		<option value="2">MONTO FIJO</option>';
				}
				if (criterios[i].condici2 == 3){
					tds += '		<option value="3" selected>SALDO CRÉDITO</option>';
				}else{
					tds += '		<option value="3">SALDO CRÉDITO</option>';
				}
				if (criterios[i].condici2 == 4){
					tds += '			<option value="4" selected>MONTO CRÉDITO</option>';
				}else{
					tds += '			<option value="4" >MONTO CRÉDITO</option>';
				}
				if (criterios[i].condici2 == 5){
					tds += '		<option value="5" selected>DÍAS DE ATRASO</option>';
				}else {
					tds += '		<option value="5">DÍAS DE ATRASO</option>';
				}
				if (criterios[i].condici2 == 6){
					tds += '			<option value="6" selected>DÍAS DE LIQUIDACIÓN</option>';
				}else {
					tds += '			<option value="6">DÍAS DE LIQUIDACIÓN</option>';
				}
				if (criterios[i].condici2 == 7){
					tds += '		<option value="7" selected>DÍAS DEL OTORGAMIENTO</option>';
				}else{
					tds += '		<option value="7">DÍAS DEL OTORGAMIENTO</option>';
				}
				if (criterios[i].condici2 == 8){
					tds += '		<option value="8" selected>DÍAS PARA EL PRÓXIMO VENCIMIENTO</option>';
				}else{
					tds += '		<option value="8">DÍAS PARA EL PRÓXIMO VENCIMIENTO</option>';
				}

				tds += '	</select>';
				if ((criterios[i].condici2 == 1) || criterios[i].condici2 == 2 ){
					tds += '	<input type="text" id="condiciOpc'+i+'" name="condiciOpc" size="8" onkeypress="validaSoloNumeros()" value="'+criterios[i].conOpc +'" onblur="generaFormato(this.id)" />';
				}else {
					tds += '	<input type="text" id="condiciOpc'+i+'" name="condiciOpc" size="8" onkeypress="validaSoloNumeros()" style="display:none" onblur="generaFormato(this.id)"/>';
				}
				tds += '		</td>';
				
				tds += '<td><input type="button" name="elimina" id="'+i +'" value="" class="btnElimina" onclick="eliminaSeleccion(this)"/>';
    			tds += '<input type="button" name="agregaSeleccion" id="'+i +'" class="btnAgrega" onclick="agregaElementoSeleccion()"/></td>';
				tds += '<tr>';	
			}
			document.getElementById("numSelect").value = criterios.length;
    		$("#tableSelec").append(tds);
    	}
		});
	}
	
	function validaCategoria(idControl){
		var jqCatego  = eval("'#" + idControl + "'");
		var categoID = $(jqCatego).val();
		var CategoBeanCon = {
			'categoriaID': categoID
		};
		if(categoID != '' && !isNaN(categoID) && esTab){
			catSegtoCategoriasServicio.consulta(catTipoCategoriaCon.principal,CategoBeanCon,function(categorias) {
				if(categorias != null){
					$('#descCategoria').val(categorias.descripcion);
				}else{
					alert("La Categoría No Existe");
					$(jqCatego).focus();
					$('#categoriaID').val('');
					$('#descCategoria').val('');
				}
			});
		}else{
			if(isNaN(categoID) && esTab){
				alert("La Categoría No Existe");
				$(jqCatego).focus();
				$('#categoriaID').val('');
				$('#descCategoria').val('');
				
			}
		}
	}
	
	function validaSeguimiento(idControl){
		var jqSegto  = eval("'#" + idControl + "'");
		var segtoID = $(jqSegto).val();
		var SegtoBeanCon = {
				'seguimientoID': segtoID
		};
		if(segtoID != '' && !isNaN(segtoID) && esTab){
			if(segtoID == 0){
				$("#tableSelec").show();
				$("#tablePrograma").show();
				$("#tableClasifica").show();
				habilitaBoton('grabar', 'submit');
				deshabilitaBoton('modifica', 'submit');
				$('#estatus').val('V');
				$('#descripcion').val('');
				$('#categoriaID').val('');
				$('#cicloCteInicio').val('');
				$('#cicloCteFinal').val('');
				$('#ejecutorID').val('');
				$('#descCategoria').val('');
				$('#descejecutorID').val('');
				$('#descsupervisorID').val('');
				$('#productosID').val('');
				$('input[name=nivelAplicacion]').each(function () {
					$(this).removeAttr('checked');
				});
				$('#aplicaCarteraVig').removeAttr('checked');
				$('#aplicaCarteraAtra').removeAttr('checked');
				$('#aplicaCarteraVen').removeAttr('checked');
				$('#carteraNoAplica').removeAttr('checked');
				
				$('input[name=permiteManual]').each(function () {
					
					$(this).removeAttr('checked');
				});
					
				$('input[name=base]').each(function () {
					$(this).removeAttr('checked');
				});
				$('#basePorcentaje').val('');
				$('#baseNumero').val('');
				eliminaFilas();
				$('#contenedorPlazas').html('');
				$('#contenedorSucursal').html('');
				$('#contenedorEjecutivo').html('');
				$('#contenedorPlazas').hide();
				$('#contenedorSucursal').hide();
				$('#contenedorEjecutivo').hide();
				$('input[name=alcance]').each(function () {
					$(this).removeAttr('checked');
				});
				$('#numClasifica').val(0);
				$('#numProgram').val(0);
				$('#numSelect').val(0);
				$('#estatus').val("").selected = true;
				$('#recPropios').removeAttr('checked');
				$('#selecTodosFondeo').removeAttr('checked');
				$('input[name=checkFondeo]').each(function () {
					$(this).removeAttr('checked');
				});
			}else{
				$('#productosID').val('');
				$('#contenedorPlazas').html('');
				$('#contenedorSucursal').html('');
				$('#contenedorEjecutivo').html('');
				$('#contenedorPlazas').hide();
				$('#contenedorSucursal').hide();
				$('#contenedorEjecutivo').hide();
				seguimientoServicio.consulta(catTipoSegtoCon.principal,SegtoBeanCon,function(seguimiento) {
					if (seguimiento != null){
						$("#tableSelec").show();
						$("#tablePrograma").show();
						$("#tableClasifica").show();
						habilitaBoton('modifica', 'submit');
						deshabilitaBoton('grabar', 'submit');
						eliminaFilas();
						consultaComboProductos();
						consultaGridSeleccion();
						consultaGridPrograma();
						consultaGridClasifica();
						$('#descripcion').val(seguimiento.descripcion);
						$('#categoriaID').val(seguimiento.categoriaID);
						$('#cicloCteInicio').val(seguimiento.cicloCteInicio);
						$('#cicloCteFinal').val(seguimiento.cicloCteFinal);
						$('#ejecutorID').val(seguimiento.ejecutorID);
						esTab = true;
						consultaGestion('ejecutorID');
						validaCategoria('categoriaID');
						$('#estatus').val(seguimiento.estatus);
						if (seguimiento.nivelAplicacion == 'G'){
							$('#nivelGlobal').attr('checked', 'true');
						}else if (seguimiento.nivelAplicacion == 'R'){
							$('#nivelRegion').attr('checked', 'true');
						}else if(seguimiento.nivelAplicacion == 'S'){
							$('#nivelSucursal').attr('checked', 'true');
						}else if(seguimiento.nivelAplicacion == 'O'){
							$('#nivelOficial').attr('checked', 'true');
						}
						if (seguimiento.aplicaCarteraVig != null ){
							$('#aplicaCarteraVig').attr('checked', 'true');
						}else {
							$('#aplicaCarteraVig').removeAttr('checked');
						}
						if (seguimiento.aplicaCarteraAtra != null){
							$('#aplicaCarteraAtra').attr('checked', 'true');
						}else {
							$('#aplicaCarteraAtra').removeAttr('checked');
						}
						if (seguimiento.aplicaCarteraVen != null ){
							$('#aplicaCarteraVen').attr('checked', 'true');
						}else {
							$('#aplicaCarteraVen').removeAttr('checked');
						}
						if (seguimiento.carteraNoAplica != null ){
							$('#carteraNoAplica').attr('checked', 'true');
						}else {
							$('#carteraNoAplica').removeAttr('checked');
						}
						if (seguimiento.permiteManual == 'S' ){
							$('#generaManualSI').attr('checked', 'true');	
						}else if (seguimiento.permiteManual == 'N' ) {
							$('#generaManualNO').attr('checked', 'true');
						}
						if (seguimiento.base == 'P'){
							$('#porcentaje').attr('checked', 'true');
							$('#basePorcentaje').val(seguimiento.baseNumero);
							$('#baseNumero').val('');
						}else if (seguimiento.base == 'N'){
							$('#numero').attr('checked', 'true');
							$('#baseNumero').val(seguimiento.baseNumero);
							$('#basePorcentaje').val('');
						}
						if(seguimiento.alcance == 'G'){
							$('#alcGlobal').attr('checked', 'true');
						}else if(seguimiento.alcance == 'P'){
							$('#alcPlazas').attr('checked', 'true');
							$('#contenedorPlazas').show();
							scrollPlazas();
							consultaPlazas();
						}else if (seguimiento.alcance == 'S'){
							$('#alcSucursal').attr('checked', 'true');
							$('#contenedorSucursal').show();
							scrollSucursal();
							consultaSucursales();
						}else if (seguimiento.alcance == 'E'){
							$('#alcEjecutivo').attr('checked', 'true');
							$('#contenedorEjecutivo').show();
							scrollEjecutivo();
							consultaEjecutivos();
						}
						consultaFondeador();
						scrollFondeador(seguimiento.recPropios);
					}else {
						alert("El Número de Seguimiento No Existe");
						$('#descripcion').val('');
						$('#categoriaID').val('');
						$('#cicloCteInicio').val('');
						$('#cicloCteFinal').val('');
						$('#ejecutorID').val('');
						$('#descCategoria').val('');
						$('#descejecutorID').val('');
						$('#descsupervisorID').val('');
						$('input[name=nivelAplicacion]').each(function () {
							$(this).removeAttr('checked');
						});
						$('#aplicaCarteraVig').removeAttr('checked');
						$('#aplicaCarteraAtra').removeAttr('checked');
						$('#aplicaCarteraVen').removeAttr('checked');
						$('#carteraNoAplica').removeAttr('checked');
						
						$('input[name=permiteManual]').each(function () {
							$(this).removeAttr('checked');
						});
						
						$('input[name=base]').each(function () {
							$(this).removeAttr('checked');
						});
						$('#basePorcentaje').val('');
						$('#baseNumero').val('');
						eliminaFilas();						
						$('#seguimientoID').focus();
						$('#seguimientoID').val('');
						$('#alcGlobal').removeAttr('checked');
						$('#alcPlazas').removeAttr('checked');
						$('#alcSucursal').removeAttr('checked');
						$('#alcEjecutivo').removeAttr('checked');
						$('#estatus').val("").selected = true;
						$('#recPropios').removeAttr('checked');
						$('#selecTodosFondeo').removeAttr('checked');
						$('input[name=checkFondeo]').each(function () {
							$(this).removeAttr('checked');
						});
						deshabilitaBoton('modifica', 'submit');
						deshabilitaBoton('grabar', 'submit');
					}
				});
			}				
		}
		
	}

	function eliminaFilas() {
		var trs=$("#tableClasifica tr").length;
      if(trs > 0){
         $("#tableClasifica tr").remove();
      }
		var trs=$("#tableSelec tr").length;
      if(trs > 0){
         $("#tableSelec tr").remove();
      }
  		var trs=$("#tablePrograma tr").length;
      if(trs > 0){
         $("#tablePrograma tr").remove();
      }
  		
	}

	// consulta de productos de credito
	function consultaProducCredito(idControl) {
		var jqProdCred  = eval("'#" + idControl + "'");
		var ProdCred = $(jqProdCred).val();
		var ProdCredBeanCon = {
				'producCreditoID':ProdCred
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if(ProdCred != '' && !isNaN(ProdCred) && esTab){
			productosCreditoServicio.consulta(catTipoConsultaCredito.principal,ProdCredBeanCon,function(prodCred) {
				if(prodCred!=null){
					$('#nombreProd').val(prodCred.descripcion);					
				}else{
					alert("No Existe el Producto de Crédito");
					$('#producCreditoID').focus();
				}
			});
		}
	}

	function consultaGestion(idControl) {
		var jqTipoGestion = eval("'#" + idControl + "'");
		var numTipoGestion = $(jqTipoGestion).val();
		var catTiposGestorBean = {
				'tipoGestionID' : numTipoGestion
			};
		if (numTipoGestion != '' && !isNaN(numTipoGestion) && esTab){
		catTiposGestionServicio.consulta(catConTipoGestion.foranea,catTiposGestorBean, function (catTiposGestores) {
				if (catTiposGestores != null) {
					$('#descejecutorID').val(catTiposGestores.descripcion);					
				}else {
					alert("El Tipo de Gestión No Existe");
					$('#ejecutorID').focus();
					$('#ejecutorID').val('');
					$('#descejecutorID').val('');
				}
			});
			
		}
	}
	

	function consultaComboProductos() {
		var segtoID = $('#seguimientoID').val();
		var numCon = 2;
		var SegtoBeanCon  = {
				'seguimientoID' : segtoID
		};
		seguimientoServicio.listaConsulta(numCon, SegtoBeanCon,function(productos) {
			for (var i = 0; i < productos.length; i++){
				var jqPlazo = eval("'#productosID option[value="+productos[i].productoID+"]'");
				$(jqPlazo).attr("selected","selected");
			}
		}); 
	}
	
	function consultaProductos(){
		var tipoCon=2;
		dwr.util.removeAllOptions('');
		//dwr.util.addOptions( 'plazoID', {'0':'SELECCIONAR'});
		productosCreditoServicio.listaCombo(tipoCon, function(productos){
			dwr.util.addOptions('productosID', productos, 'producCreditoID', 'descripcion');
		});
	}

	

	function validaForma(){
		var cont = 0;
		$('input[name=nivelAplicacion]').each(function () {
			var valor = $(this).is(':checked');
			if (valor == true){
				cont ++;
			}
		});
		if (cont == 0 ){
			alert("Especifique el Nivel de Aplicación");
			$('#nivelGlobal').focus();
			return false;
		}
		var vigente = $('#aplicaCarteraVig').is(':checked');
		var atras = $('#aplicaCarteraAtra').is(':checked');
		var ven = $('#aplicaCarteraVen').is(':checked');
		var noApli = $('#carteraNoAplica').is(':checked');
		if(vigente == false &&  atras == false && ven == false && noApli == false){
			alert("Especifique el Estado de Cartera");
			$('#aplicaCarteraVig').focus();
			return false;
		}
		var aux= 0;
		$('input[name=permiteManual]').each(function () {
			var valor = $(this).is(':checked');
			if (valor == true){
				aux ++;
			}
		});
		if (aux == 0){
			alert("Especifique si permite generación Manual");
			$('#generaManualSI').focus();
			return false;
		}
		var base= 0;
		$('input[name=base]').each(function () {
			var valor = $(this).is(':checked');
			if (valor == true){
				base ++;
			}
		});
		if (base == 0){
			alert("Especifique la Base de Generación");
			$('#porcentaje').focus();
			return 0;
		}
	
		var basePor = $('#porcentaje').is(':checked');
		var basePorcentaje = $('#basePorcentaje').val();
		if (basePor == true && basePorcentaje == ''){
			alert("Especifique el porcentaje de Base de Generación");
			$('#basePorcentaje').focus();
			return false;
		}
		var baseNum = $('#numero').is(':checked');
		var baseNumero = $('#baseNumero').val();
		if(baseNum == true && baseNumero == ''){
			alert("Especifique el Número de Base de Generación");
			$('#baseNumero').focus();
			return false;
		}
		cont = 0;
		$('input[name=alcance]').each(function () {
			var valor = $(this).is(':checked');
			if (valor == true){
				cont ++;
			}
		});	
		if (cont == 0) {
			alert("Seleccione el Alcance del Seguimiento");
			$('#alcGlobal').focus();
			return false;
		}
		if ($("#tableSelec tr").length == 0){
			alert("Especifique al menos un Criterio de Selección");
			$('#agregaSelect').focus();
			return false;
		}	
		
		if ($("#tablePrograma tr").length == 0){
			alert("Especifique al menos un Criterio de Programación");
			$('#agregaProgra').focus();
			return false;
		}
	
		if ($("#tableClasifica tr").length == 0){
			alert("Especifique al menos un Criterio de Clasificación");
			$('#agregaClasifica').focus();
			return false;
		}
	
		var procede;
		var mostrarAlert;
		var id;		
		var selec = 0;
		var chkAlcance;
		$('input[name=alcance]').each(function () {
			if ($(this).is(':checked') == true) {
				 chkAlcance = $(this).val();
			}
		});
		if ( chkAlcance == "G") {
			selec = 1;
		}
		mostrarAlert = 1;
		procede = 1;
		if ( chkAlcance == "P") {
			$('input[name=checkPlaza]').each(function () {
				if ($(this).is(':checked') == true) {
					selec ++;
				}
			});
			if (selec == 0) {
				if (mostrarAlert == 1) {			
					alert("Especifique el Alcance de Plazas");
					$('#selecTodosPlazas').focus();
					mostrarAlert = 0;
					procede = 0;
				}
			}
		}
		
		if ( chkAlcance == "S") {
			selec = 0;
			$('input[name=checkSucur]').each(function () {
				if ($(this).is(':checked') == true) {
					selec ++;
				}
			});
			if (selec == 0) {
				if (mostrarAlert == 1) {			
					alert("Especifique el Alcance de Sucursales");
					$('#selecTodosSucur').focus();
					mostrarAlert = 0;
					procede = 0;
				}
			}
		}
				
		if ( chkAlcance == "E") {
			selec = 0;
			$('input[name=checkEjec]').each(function () {
				if ($(this).is(':checked') == true) {
					selec ++;
				}
			});
			if (selec == 0) {
				if (mostrarAlert == 1) {			
					alert("Especifique el Alcance de Ejecutivos");
					$('#selecTodosEjecu').focus();
					mostrarAlert = 0;
					procede = 0;
				}
			}
		}
		selec = 0;
		$('input[name=checkFondeo]').each(function () {
			if ($(this).is(':checked') == true) {
				selec ++;
			}
		});
		if (selec == 0) {
			if (mostrarAlert == 1) {
				alert("Especifique al Menos un Fondeador");
				 $('#recPropios').focus();
				mostrarAlert = 0;
				procede = 0;
			}
		}
				
		$('select[name=selecCondi1]').each(function () {
			if (this.value == ''){
				if (mostrarAlert == 1){
					alert("Seleccione la Condición de Selección");
					mostrarAlert = 0;
					procede = 0;
				}
			}
		});
		
		$('select[name=selecOperador]').each(function () {
			if (this.value == ''){
				if (mostrarAlert == 1){
					alert("Seleccione el Operador de Selección");
					mostrarAlert = 0;
					procede = 0;
				}
			}
		});

		$('select[name=selecCondi2]').each(function () {
			id = this.id.substring(7);
			if (this.value == ''){
				var valor = $('#condiciOpc'+id).val();
				if(valor == ""){
					if (mostrarAlert == 1){
						alert("Capture la Condición de Selección");
						$('#condiciOpc'+id).focus();
						mostrarAlert = 0;
						procede = 0;
					}	
				}				
			}
		});
				
			
		$('select[name=comboCriterio]').each(function () {			
			id = this.id.substring(8);			
			if (this.value == ""){
				if(mostrarAlert == 1){
					alert("Especificar el Criterio de Programación.");
					$(this).focus();
					mostrarAlert = 0;
					procede = 0;
				}
			}else
			if (this.value == '1'){
				var perio = $('#prograPeriodicidad'+id).val();
				if( perio == ""){
					if (mostrarAlert == 1){
						alert("Seleccione la Periodicidad");
						$('#prograPeriodicidad'+id).focus();
						mostrarAlert = 0;
						procede = 0;
					}
				}
			}else if (this.value == '2') {
				var valor = $('#prograAvanceCredito'+id).val();
				if (valor == ''){
					if(mostrarAlert == 1){
						alert("Especificar el Porcentaje de Avance de Crédito");
						$('#prograAvanceCredito'+id).focus();
						mostrarAlert = 0;
						procede = 0;
					}
				}
			}else if(this.value == '3'){
				var valor = $('#prograDiasOtorga'+id).val();
				if (valor == ''){
					if(mostrarAlert == 1){
						alert("Especificar Dias posteriores al Otorgamiento");
						$('#prograDiasOtorga'+id).focus();
						mostrarAlert = 0;
						procede = 0;
					}
				}
			}else if (this.value == '4') {
				var valor = $('#prograDiasAntLiq'+id).val();
				if (valor == ''){
					if(mostrarAlert == 1){
						alert("Especificar Dias Anteriores a la Liquidación");
						$('#prograDiasAntLiq'+id).focus();
						mostrarAlert = 0;
						procede = 0;
					}
				}
			}else if (this.value == '5') {
				var valor = $('#prograDiasAntCuota'+id).val();
				if (valor == ''){
					if(mostrarAlert == 1){
						alert("Especificar Dias Anteriores al Pago de Cuota");
						$('#prograDiasAntCuota'+id).focus();
						mostrarAlert = 0;
						procede = 0;
					}
				}
			}
		});
		
		$('input[name=prograMaxUltSegto]').each(function () {
			id = this.id.substring(17);
			if(this.value == ''){
				if (mostrarAlert == 1) {
					alert("Especificar los Dias Máximo desde Ultimo Segto.");
					$(this).focus();
					mostrarAlert = 0;
					procede = 0;
				}
			}
		});
		
		$('input[name=prograMinUltSegto]').each(function () {
			id = this.id.substring(17);
			if(this.value == ''){
				if (mostrarAlert == 1) {
					alert("Especificar los Dias Minimo desde Ultimo Segto.");
					$(this).focus();
					mostrarAlert = 0;
					procede = 0;
				}
			}
		});

		$('input[name=prograPlazoMaximo]').each(function () {
			id = this.id.substring(17);
			if(this.value == ''){
				if (mostrarAlert == 1) {
					alert("Especificar Máximo de Eventos.");
					$(this).focus();
					mostrarAlert = 0;
					procede = 0;
				}
			}
		});

		$('select[name=comboDia]').each(function () {
			id = this.id.substring(8);
			if (this.value == '') {
				if (mostrarAlert == 1) {
					alert("Especifique el Día Fijo");
					$('#comboDia'+id).focus();
					mostrarAlert = 0;
					procede = 0;
				}
			}else
			if (this.value == 1) {
				var valor = $('#prograDiaMes'+id).val();
				if (valor == '') {
					if (mostrarAlert == 1) {
						alert("Especifique el Día del Mes");
						$('#prograDiaMes'+id).focus();
						mostrarAlert = 0;
						procede = 0;
					}
				}
			}else if (this.value == 2){
				var valor = $('#prograDiaSemana'+id).val();
				if (valor == '') {
					if (mostrarAlert == 1) {
						alert("Especifique Día de la Semana");
						$('#prograDiaSemana'+id).focus();
						mostrarAlert = 0;
						procede = 0;					
					}
				}
			}
		});

		$('select[name=clasifCondicion]').each(function () {
			id = this.id.substring(15);
			if(this.value == ''){
				if (mostrarAlert == 1) {
					alert("Especificar Condición de Clasificación.");
					$(this).focus();
					mostrarAlert = 0;
					procede = 0;
				}
			}
		});
		$('select[name=clasifOperador]').each(function () {
			id = this.id.substring(14);
			if(this.value == ''){
				if (mostrarAlert == 1) {
					alert("Especificar Operador de Clasificación.");
					$(this).focus();
					mostrarAlert = 0;
					procede = 0;
				}
			}
		});
		if (procede == 0){
			return false;
		}else {
			return true;
		}
	}
});
//  fin de Jquery



function agregaElementoSeleccion(){
		var numeroFila = document.getElementById("numSelect").value;
		var nuevaFila = parseInt(numeroFila) + 1;
		var tds = '<tr id="renglonSeleccion' + nuevaFila + '" name="renglonSeleccion">';
   	if(numeroFila == 0){
			tds += '<td>';
			tds += '	<select id="compuerta'+nuevaFila+'" name="selecCompuerta" path="selecCompuerta" tabindex="">';
			tds += '		<option value="">SELECCIONA</option>';
			tds += '		<option value="OR">O</option>';
			tds += '		<option value="AND">Y</option>';
			tds += '	</select>';
			tds += '</td>';
			tds += '<td>';
			tds += '	<select id="condicion'+nuevaFila+'" name="selecCondi1" path="selecCondi1" tabindex="" onchange="cambioCondicionUno(this.id)">';
			tds += '		<option value="">SELECCIONA</option>';
			tds += '		<option value="1">SALDO TOTAL CRÉDITO</option>';
			tds += '		<option value="2">MONTO ORIGINAL CRÉDITO</option>';
			tds += '		<option value="3">SALDO DE CAPITAL</option>';
			tds += '		<option value="4">CAPITAL ATRASADO</option>';
			tds += '		<option value="5">DÍAS DE ATRASO</option>';
			tds += '		<option value="6">DÍAS DE LIQUIDACIÓN</option>';
			tds += '		<option value="7">DÍAS DESDE EL OTORGAMIENTO</option>';
			tds += '		<option value="8">DÍAS PARA EL PRÓXIMO VENCIMIENTO</option>';
			tds += '	</select>';
			tds += '</td>			';					
			tds += '<td>';
			tds += '		<select id="operador'+nuevaFila+'" name="selecOperador" path="selecOperador" tabindex="">';
			tds += '			<option value="">SELECCIONA</option>';
			tds += '			<option value="1">MAYOR QUE</option>';
			tds += '			<option value="2">MENOR QUE</option>';
			tds += '			<option value="3">IGUAL QUE</option>';
			tds += '			<option value="4">DIFERENTE QUE</option>';
			tds += '		</select>';
			tds += '	</td>';
			tds += '	<td>';
			tds += '		<select id="condici'+nuevaFila+'" name="selecCondi2" path="selecCondi2" tabindex="" onchange="cambioCondicionDos(this.id)">';
			tds += '			<option value="">SELECCIONA</option>';
			tds += '		<option value="1">NÚMERO FIJO</option>';
			tds += '		<option value="2">MONTO FIJO</option>';
			tds += '		<option value="3">SALDO CRÉDITO</option>';
			tds += '			<option value="4">MONTO CRÉDITO</option>';
			tds += '		<option value="5">DÍAS DE ATRASO</option>';
			tds += '			<option value="6">DÍAS DE LIQUIDACIÓN</option>';
			tds += '		<option value="7">DÍAS DESDE EL OTORGAMIENTO</option>';
			tds += '		<option value="8">DÍAS PARA EL PRÓXIMO VENCIMIENTO</option>';
			tds += '	</select>';
			tds += '	<input type="text" id="condiciOpc'+nuevaFila+'" name="condiciOpc" size="8" onkeypress="validaSoloNumeros()" style="display:none" onblur="generaFormato(this.id)"/>';
			tds += '		</td>';
    	}else{
			tds += '<td>';
			tds += '	<select id="compuerta'+nuevaFila+'" name="selecCompuerta" path="selecCompuerta" tabindex="">';
			tds += '		<option value="">SELECCIONA</option>';
			tds += '		<option value="OR">O</option>';
			tds += '		<option value="AND">Y</option>';
			tds += '	</select>';
			tds += '</td>';
			tds += '<td>';
			tds += '	<select id="condicion'+nuevaFila+'" name="selecCondi1" path="selecCondi1" tabindex="" onchange="cambioCondicionUno(this.id)">';
			tds += '		<option value="">SELECCIONA</option>';
			tds += '		<option value="1">SALDO TOTAL CRÉDITO</option>';
			tds += '<option value="2">MONTO ORIGINAL CRÉDITO</option>';
			tds += '<option value="3">SALDO DE CAPITAL</option>';
			tds += '		<option value="4">CAPITAL ATRASADO</option>';
			tds += '		<option value="5">DÍAS DE ATRASO</option>';
			tds += '		<option value="6">DÍAS DE LIQUIDACIÓN</option>';
			tds += '		<option value="7">DÍAS DESDE EL OTORGAMIENTO</option>';
			tds += '		<option value="8">DÍAS PARA EL PRÓXIMO VENCIMIENTO</option>';
			tds += '	</select>';
			tds += '</td>			';					
			tds += '<td>';
			tds += '		<select id="operador'+nuevaFila+'" name="selecOperador" path="selecOperador" tabindex="">';
			tds += '			<option value="">SELECCIONA</option>';
			tds += '			<option value="1">MAYOR QUE</option>';
			tds += '			<option value="2">MENOR QUE</option>';
			tds += '			<option value="3">IGUAL QUE</option>';
			tds += '			<option value="4">DIFERENTE QUE</option>';
			tds += '		</select>';
			tds += '	</td>';
			tds += '	<td>';
			tds += '		<select id="condici'+nuevaFila+'" name="selecCondi2" path="selecCondi2" tabindex="" onchange="cambioCondicionDos(this.id)">';
			tds += '			<option value="">SELECCIONA</option>';
			tds += '		<option value="1">Número Fijo</option>';
			tds += '		<option value="2">MONTO FIJO</option>';
			tds += '		<option value="3">SALDO CRÉDITO</option>';
			tds += '			<option value="4">MONTO CRÉDITO</option>';
			tds += '		<option value="5">DÍAS DE ATRASO</option>';
			tds += '			<option value="6">DÍAS DE LIQUIDACIÓN</option>';
			tds += '		<option value="7">DÍAS DESDE EL OTORGAMIENTO</option>';
			tds += '		<option value="8">DÍAS PARA EL PRÓXIMO VENCIMIENTO</option>';
			tds += '	</select>';
			tds += '	<input type="text" id="condiciOpc'+nuevaFila+'" name="condiciOpc" size="8" onkeypress="validaSoloNumeros()" style="display:none" onblur="generaFormato(this.id)"/>';
			tds += '		</td>';
    	}
    	tds += '<td><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaSeleccion(this)"/>';
    	tds += '<input type="button" name="agregaSeleccion" id="'+nuevaFila+'" class="btnAgrega" onclick="agregaElementoSeleccion()"/></td>';
	   tds += '</tr>';
    	document.getElementById("numSelect").value = nuevaFila;
    	$("#tableSelec").append(tds);
    	return false;
	}

	function eliminaSeleccion(control){
		var numeroID = control.id;
		var jqTr = eval("'#renglonSeleccion"+ numeroID +"'");
		$(jqTr).remove();
		//Reordenamiento de Controles 
		$('#numSelect').val($('#numSelect').val()-1);
	}


	function agregaElementoPrograma(){
		var numeroFila = document.getElementById("numProgram").value;
		var nuevaFila = parseInt(numeroFila) + 1;
		var tds = '<tr id="renglonPrograma'+nuevaFila+'" name="renglonPrograma">';
		if(numeroFila == 0){
			tds += '<td>';
			tds += '		<fieldset class="ui-widget ui-widget-content ui-corner-all">';
			tds += '			<legend class="label">Criterio</legend>';
			tds += '			<table border="0" cellpadding="0" cellspacing="0" width="100%">';
				tds += '<tr>';
			tds += '												<td>';
			tds += '													<select id="criterio'+nuevaFila+'" name="comboCriterio" onchange="comboCambio(this.id)">';
			tds += '														<option value="">SELECCIONA</option>';
			tds += '											<option value="1">PERIODICIDAD</option>';
			tds += '														<option value="2">% DE AVANCE DEL PLAN DE CRÉDITO</option>';
			tds += '														<option value="3">DÍAS POSTERIOR OTORGAMIENTO</option>';
			tds += '														<option value="4">DÍAS ANTERIOR A LA LIQUIDACIÓN</option>';
			tds += '														<option value="5">DIAS ANTERIOR PAGO CUOTA</option>';
			tds += '													</select>';
			tds += '												</td>';
			tds += '												<td id="trPeriodo'+nuevaFila+'" style="display:none">';
			tds += '													<select id="prograPeriodicidad'+nuevaFila+'" name="prograPeriodicidad" path="prograPeriodicidad" tabindex="" onchange="cambioPeriodo(this.id)">';
			tds += '														<option value="">SELECCIONA</option>';
			tds += '														<option value="D">DIARIO</option>';
			tds += '														<option value="S">SEMANAL</option>';
			tds += '														<option value="C">CATORCENAL</option>';
			tds += '														<option value="Q">QUINCENAL</option>';
			tds += '														<option value="M">MENSUAL</option>';
			tds += '														<option value="B">BIMESTRAL</option>';
			tds += '														<option value="T">TRIMESTRAL</option>';
			tds += '														<option value="U">CUATRIMESTRAL</option>';
			tds += '														<option value="I">QUINCOMENSUAL</option>';
			tds += '														<option value="E">SEMESTRAL</option>';
			tds += '														<option value="A">ANUAL</option>';
			tds += '														<option value="N">NO APLICA</option>';
			tds += '													</select>';
			tds += '												</td>';
			tds += '												<td id="tdAvance'+nuevaFila+'" style="display:none">';
			tds += '													<input type="text" id="prograAvanceCredito'+nuevaFila+'" name="prograAvanceCredito" path="prograAvanceCredito" size="5" tabindex="" onkeypress="validaSoloNumeros();"/><label>%</label>';
			tds += '									</td>';
			tds += '												<td id="tdOtorga'+nuevaFila+'" style="display:none">';
			tds += '													<input type="text" id="prograDiasOtorga'+nuevaFila+'" name="prograDiasOtorga" path="prograDiasOtorga" size="5" tabindex="" onkeypress="validaSoloNumeros();"/>';
			tds += '												</td>';
			tds += '												<td id="tdLiquida'+nuevaFila+'" style="display:none">';
			tds += '													<input type="text" id="prograDiasAntLiq'+nuevaFila+'" name="prograDiasAntLiq" path="prograDiasAntLiq" size="5" tabindex="" onkeypress="validaSoloNumeros();"/>';
			tds += '												</td>';
			tds += '												<td id="tdCuota'+nuevaFila+'" style="display:none">';
			tds += '													<input type="text" id="prograDiasAntCuota'+nuevaFila+'" name="prograDiasAntCuota" path="prograDiasAntCuota" size="5" tabindex="" onkeypress="validaSoloNumeros();"/>';
			tds += '												</td>';
			tds += '											</tr>';
			tds += '											<tr>';
			tds += '												<td>';
			tds += '													<label>Días Máximos desde Último Segto.:</label>';
			tds += '												</td>';
			tds += '												<td>';
			tds += '													<input type="text" id="prograMaxUltSegto'+nuevaFila+'" name="prograMaxUltSegto" path="prograMaxUltSegto" size="5" tabindex="" onkeypress="validaSoloNumeros()"/>';
			tds += '												</td>';
			tds += '												<td class="separador"></td>';
			tds += '												<td>';
			tds += '													<label>Días Mínimos desde Último Segto.:</label>';
			tds += '												</td>';
			tds += '												<td>';
			tds += '													<input type="text" id="prograMinUltSegto'+nuevaFila+'" name="prograMinUltSegto" path="prograMinUltSegto" size="5" tabindex="" onkeypress="validaSoloNumeros()"/>';
			tds += '												</td>';
			tds += '											</tr>';
			tds += '											<tr>';
			tds += '												<td>';
			tds += '													<label>Máximo de Eventos:</label>';
			tds += '												</td>';
			tds += '												<td>';
			tds += '													<input type="text" id="prograPlazoMaximo'+nuevaFila+'" name="prograPlazoMaximo" path="prograPlazoMaximo" size="5" tabindex="" onkeypress="validaSoloNumeros()"/>';
			tds += '												</td>';
			tds += '											</tr>';
			tds += '										</table>';
			tds += '									</fieldset>';
			tds += '								</td>';
			tds += '								<td>';
			tds += '									<fieldset class="ui-widget ui-widget-content ui-corner-all">';
			tds += '										<legend class="label">Día Fijo</legend>';
			tds += '										<table border="0" cellpadding="0" cellspacing="0" width="100%">';
			tds += '											<tr>';
			tds += '												<td class="label">';
			tds += '										<select id="comboDia'+nuevaFila+'" name="comboDia" onchange="cambioDia(this.id)">';
			tds += '											<option value="">SELECCIONA</option>';
			tds += '											<option value="1">DÍA DEL MES</option>';
			tds += '											<option value="2">DÍA SEMANA</option>';
			tds += '										</select>';
			tds += '												</td>';
			tds += '												<td id="diaMes'+nuevaFila+'" style="display:none">';
			tds += '													<input type="text" id="prograDiaMes'+nuevaFila+'" name="prograDiaMes" path="prograDiaMes" size="5" tabindex="" onkeypress="validaSoloNumeros();" onblur="validaDias(this.id)"/>';
			tds += '												</td>';
			tds += '									<td id="diaSemana'+nuevaFila+'" style="display:none">';
			tds += '										<select id="prograDiaSemana'+nuevaFila+'" name="prograDiaSemana" path="prograDiaSemana" tabindex="">';
			tds += '											<option value="">SELECCIONA</option>';
			tds += '											<option value="L">LUNES</option>';
			tds += '											<option value="M">MARTES</option>';
			tds += '											<option value="MI">MIÉRCOLES</option>';
			tds += '											<option value="J">JUEVES</option>';
			tds += '											<option value="V">VIERNES</option>';
			tds += '											<option value="I">INDISTINTO</option>';
			tds += '										</select>';			
			tds += '									</td>';
			tds += '								</tr>';
			tds += '					<tr>';
			tds += '						<td class="label">';
			tds += '							<label>Día hábil Sig./Ant.:</label>';
			tds += '						</td>';
			tds += '						<td>';
			tds += '							<select id="prograDiaHabil'+nuevaFila+'" name="prograDiaHabil" path="prograDiaHabil" tabindex="">';
			tds += '							<option value="">SELECCIONA</option>';
			tds += '								<option value="S">SIGUIENTE</option>';
			tds += '								<option value="A">ANTERIOR</option>';
			tds += '							</select>';
			tds += '						</td>';
			tds += '					</tr>';
			tds += '				</table>';
			tds += '			</fieldset>';
			tds += '		</td>';
			}else{
				tds += '<td>';
			tds += '		<fieldset class="ui-widget ui-widget-content ui-corner-all">';
			tds += '			<legend class="label">Criterio</legend>';
			tds += '			<table border="0" cellpadding="0" cellspacing="0" width="100%">';
				tds += '<tr>';
			tds += '		<td>';
			tds += '			<select id="criterio'+nuevaFila+'" name="comboCriterio" onchange="comboCambio(this.id)">';
			tds += '				<option value="">SELECCIONA</option>';
			tds += '				<option value="1">PERIODICIDAD</option>';
			tds += '				<option value="2">% DE AVANCE DEL PLAN DE CRÉDITO</option>';
			tds += '				<option value="3">DÍAS POSTERIOR OTORGAMIENTO</option>';
			tds += '				<option value="4">DÍAS ANTERIOR A LA LIQUIDACIÓN</option>';
			tds += '				<option value="5">DIAS ANTERIOR PAGO CUOTA</option>';
			tds += '			</select>';
			tds += '			</td>';
			tds += '												<td id="trPeriodo'+nuevaFila+'" style="display:none">';
			tds += '													<select  id="prograPeriodicidad'+nuevaFila+'" name="prograPeriodicidad" path="prograPeriodicidad" tabindex="" onchange="cambioPeriodo(this.id)">';
			tds += '														<option value="">SELECCIONA</option>';
			tds += '														<option value="D">DIARIO</option>';
			tds += '														<option value="S">SEMANAL</option>';
			tds += '														<option value="C">CATORCENAL</option>';
			tds += '														<option value="Q">QUINCENAL</option>';
			tds += '														<option value="M">MENSUAL</option>';
			tds += '														<option value="B">BIMESTRAL</option>';
			tds += '														<option value="T">TRIMESTRAL</option>';
			tds += '														<option value="U">CUATRIMESTRAL</option>';
			tds += '														<option value="I">QUINCOMENSUAL</option>';
			tds += '														<option value="E">SEMESTRAL</option>';
			tds += '														<option value="A">ANUAL</option>';
			tds += '														<option value="N">NO APLICA</option>';
			tds += '													</select>';
			tds += '												</td>';
			tds += '												<td id="tdAvance'+nuevaFila+'" style="display:none">';
			tds += '													<input type="text" id="prograAvanceCredito'+nuevaFila+'" name="prograAvanceCredito" path="prograAvanceCredito" size="5" tabindex="" onkeypress="validaSoloNumeros();"/><label>%</label>';
			tds += '									</td>';
			tds += '												<td id="tdOtorga'+nuevaFila+'" style="display:none">';
			tds += '													<input type="text" id="prograDiasOtorga'+nuevaFila+'" name="prograDiasOtorga" path="prograDiasOtorga" size="5" tabindex="" onkeypress="validaSoloNumeros();"/>';
			tds += '												</td>';
			tds += '												<td id="tdLiquida'+nuevaFila+'" style="display:none">';
			tds += '													<input type="text" id="prograDiasAntLiq'+nuevaFila+'" name="prograDiasAntLiq" path="prograDiasAntLiq" size="5" tabindex="" onkeypress="validaSoloNumeros();"/>';
			tds += '												</td>';
			tds += '												<td id="tdCuota'+nuevaFila+'" style="display:none">';
			tds += '													<input type="text" id="prograDiasAntCuota'+nuevaFila+'" name="prograDiasAntCuota" path="prograDiasAntCuota" size="5" tabindex="" onkeypress="validaSoloNumeros();"/>';
			tds += '												</td>';
			tds += '											</tr>';
			tds += '											<tr>';
			tds += '												<td>';
			tds += '													<label>Días Máximos desde Último Segto.:</label>';
			tds += '												</td>';
			tds += '												<td>';
			tds += '													<input type="text" id="prograMaxUltSegto'+nuevaFila+'" name="prograMaxUltSegto" path="prograMaxUltSegto" size="5" tabindex="" onkeypress="validaSoloNumeros()"/>';
			tds += '												</td>';
			tds += '												<td class="separador"></td>';
			tds += '												<td>';
			tds += '													<label>Días Mínimos desde Último Segto.:</label>';
			tds += '												</td>';
			tds += '												<td>';
			tds += '													<input type="text" id="prograMinUltSegto'+nuevaFila+'" name="prograMinUltSegto" path="prograMinUltSegto" size="5" tabindex="" onkeypress="validaSoloNumeros()"/>';
			tds += '												</td>';
			tds += '											</tr>';
			tds += '											<tr>';
			tds += '												<td>';
			tds += '													<label>Máximo de Eventos:</label>';
			tds += '												</td>';
			tds += '												<td>';
			tds += '													<input type="text" id="prograPlazoMaximo'+nuevaFila+'" name="prograPlazoMaximo" path="prograPlazoMaximo" size="5" tabindex="" onkeypress="validaSoloNumeros()"/>';
			tds += '												</td>';
			tds += '											</tr>';
			tds += '										</table>';
			tds += '									</fieldset>';
			tds += '								</td>';
			tds += '								<td>';
			tds += '									<fieldset class="ui-widget ui-widget-content ui-corner-all">';
			tds += '										<legend class="label">Día Fijo</legend>';
			tds += '										<table border="0" cellpadding="0" cellspacing="0" width="100%">';
			tds += '											<tr>';
			tds += '												<td class="label">';
			tds += '											<select id="comboDia'+nuevaFila+'" name="comboDia" onchange="cambioDia(this.id)">';
			tds += '												<option value="">SELECCIONA</option>';
			tds += '												<option value="1">DÍA DEL MES</option>';
			tds += '												<option value="2">DÍA SEMANA</option>';
			tds += '											</select>';			
			tds += '												</td>';
			tds += '												<td id="diaMes'+nuevaFila+'" style="display:none">';
			tds += '													<input type="text" id="prograDiaMes'+nuevaFila+'" name="prograDiaMes" path="prograDiaMes" size="5" tabindex="" onkeypress="validaSoloNumeros();" onblur="validaDias(this.id)"/>';
			tds += '												</td>';
			tds += '								<td id="diaSemana'+nuevaFila+'" style="display:none">';
			tds += '							<select id="prograDiaSemana'+nuevaFila+'" name="prograDiaSemana" path="prograDiaSemana" tabindex="">';
			tds += '								<option value="">SELECCIONA</option>';
			tds += '								<option value="L">LUNES</option>';
			tds += '								<option value="M">MARTES</option>';
			tds += '								<option value="MI">MIÉRCOLES</option>';
			tds += '								<option value="J">JUEVES</option>';
			tds += '								<option value="V">VIERNES</option>';
			tds += '								<option value="I">INDISTINTO</option>';
			tds += '							</select>';
			tds += '							</td>';
			tds += '											</tr>';
			tds += '					<tr>';
			tds += '						<td class="label">';
			tds += '							<label>Día hábil Sig./Ant.:</label>';
			tds += '						</td>';
			tds += '						<td>';
			tds += '							<select id="prograDiaHabil'+nuevaFila+'" name="prograDiaHabil" path="prograDiaHabil" tabindex="">';
			tds += '							<option value="">SELECCIONA</option>';
			tds += '								<option value="S">SIGUIENTE</option>';
			tds += '								<option value="A">ANTERIOR</option>';
			tds += '							</select>';
			tds += '						</td>';
			tds += '					</tr>';
			tds += '				</table>';
			tds += '			</fieldset>';
			tds += '		</td>';   	
			}
			tds += '<td><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaPrograma(this)"/>';
			tds += '<input type="button" name="agrega" id="' + nuevaFila + '" class="btnAgrega" onclick="agregaElementoPrograma()"/></td>';
			tds += '</tr>';
			document.getElementById("numProgram").value = nuevaFila;
			$("#tablePrograma").append(tds);
			return false;
	}


	function eliminaPrograma(control){
		var numeroID = control.id;
		var jqTr = eval("'#renglonPrograma" + numeroID + "'");
		$(jqTr).remove();
		//Reordenamiento de Controles 
		$('#numProgram').val($('#numProgram').val()-1);
	}

	//Agrega Clasificacion
	function agregaElementoClasifica(){
		
		var numeroFila = document.getElementById("numClasifica").value;
		var nuevaFila = parseInt(numeroFila) + 1;
		var tds = '<tr id="renglonClasifica' + nuevaFila + '" name="renglonClasifica">';
   	if(numeroFila == 0){
   		tds += '<td>';
			tds += '	<input type="text" id="consecutivo' + nuevaFila + '" name="consecutivo1" value="1" size="5" disabled="true" />';
			tds += '			</td>';
			tds += '			<td>';
			tds += '		<select id="clasifCondicion' + nuevaFila + '" name="clasifCondicion" path="clasifCondicion" tabindex="">';
			tds += '			<option value="">SELECCIONA</option>';
			tds += '			<option value="1">REGIÓN</option>';
			tds += '			<option value="2">SUCURSAL</option>';
			tds += '			<option value="3">OFICIAL</option>';
			tds += '			<option value="4">MUNICIPIO</option>';
			tds += '			<option value="5">GÉNERO</option>';
			tds += '			<option value="6">MONTO ORIGINAL CRÉDITO</option>';										
			tds += '			<option value="7">SALDO DEL CRÉDITO</option>';
			tds += '			<option value="8">SALDO MORA + CARGOS</option>';
			tds += '			<option value="9">FECHA PRÓXIMO VENCIMIENTO</option>';
			tds += '			<option value="10">FECHA OTORGAMIENTO CRÉDITO</option>';
			tds += '			<option value="11">FECHA LIQUIDACIÓN CRÉDITO</option>';
			tds += '			<option value="12">DÍAS DE ATRASO</option>';
			tds += '		</select>';
			tds += '	</td>';
			tds += '	<td>';
			tds += '		<select id="clasifOperador' + nuevaFila + '" name="clasifOperador" path="clasifOperador" tabindex="">';
			tds += '			<option value="">SELECCIONA</option>';
			tds += '			<option value="ASC">ASCENDENTE</option>';
			tds += '			<option value="DESC">DESCENDENTE</option>';
			tds += '		</select>';
			tds += '	</td>';
    	}else{	
 			tds += '<td>';
			tds += '	<input type="text" id="consecutivo' + nuevaFila + '" name="consecutivo1" value="'+nuevaFila+'" size="5" disabled="true" />';
			tds += '			</td>';
			tds += '			<td>';
			tds += '		<select id="clasifCondicion' + nuevaFila + '" name="clasifCondicion" path="clasifCondicion" tabindex="">';
			tds += '			<option value="">SELECCIONA</option>';
			tds += '			<option value="1">REGIÓN</option>';
			tds += '			<option value="2">SUCURSAL</option>';
			tds += '			<option value="3">OFICIAL</option>';
			tds += '			<option value="4">MUNICIPIO</option>';
			tds += '			<option value="5">GÉNERO</option>';
			tds += '			<option value="6">MONTO ORIGINAL CRÉDITO</option>';										
			tds += '			<option value="7">SALDO DEL CRÉDITO</option>';
			tds += '			<option value="8">SALDO MORA + CARGOS</option>';
			tds += '			<option value="9">FECHA PRÓXIMO VENCIMIENTO</option>';
			tds += '			<option value="10">FECHA OTORGAMIENTO CRÉDITO</option>';
			tds += '			<option value="11">FECHA LIQUIDACIÓN CRÉDITO</option>';
			tds += '			<option value="12">DÍAS DE ATRASO</option>';
			tds += '		</select>';
			tds += '	</td>';
			tds += '	<td>';
			tds += '		<select id="clasifOperador' + nuevaFila + '" name="clasifOperador" path="clasifOperador" tabindex="">';
			tds += '			<option value="">SELECCIONA</option>';
			tds += '			<option value="ASC">ASCENDENTE</option>';
			tds += '			<option value="DESC">DESCENDENTE</option>';
			tds += '		</select>';
			tds += '	</td>';
    	}
    	tds += '<td><input type="button" name="elimina" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaClasifica(this)"/>';
    	tds += '<input type="button" name="agrega" id="'+nuevaFila+'" class="btnAgrega" onclick="agregaElementoClasifica()"/></td>';
	   tds += '</tr>';
    	document.getElementById("numClasifica").value = nuevaFila;
    	$("#tableClasifica").append(tds);
    	return false;
	}

	function eliminaClasifica(control){
		var numeroID = control.id;
		var jqTr = eval("'#renglonClasifica" + numeroID + "'");
		$(jqTr).remove();
		//Reordenamiento de Controles 
		$('#numClasifica').val($('#numClasifica').val()-1);
	}

	function cambioPeriodo(idControl){
		var id = idControl.substring(18);
		$('#prograMaxUltSegto'+id).val('');
		$('#prograMinUltSegto'+id).val('');
		$('#prograPlazoMaximo'+id).val('');
	}

	function comboCambio(idControl) {
		var id = idControl.substring(8);
		var valor = $('#'+idControl).val();
		if (valor == 1){
			$('#trPeriodo'+id).removeAttr('style');
			$('#tdAvance'+id).hide();
			$('#tdOtorga'+id).hide();
			$('#tdLiquida'+id).hide();
			$('#tdCuota'+id).hide();
			$('#prograPeriodicidad'+id).val('');
			$('#prograAvanceCredito'+id).val('');
			$('#prograDiasOtorga'+id).val('');
			$('#prograDiasAntLiq'+id).val('');
			$('#prograDiasAntCuota'+id).val('');
			habilitaControl('prograPlazoMaximo'+id);
			$('#prograPlazoMaximo'+id).val('');
		}else
		if (valor == 2){
			$('#tdAvance'+id).removeAttr('style');
			$('#trPeriodo'+id).hide();
			$('#tdOtorga'+id).hide();
			$('#tdLiquida'+id).hide();
			$('#tdCuota'+id).hide();
			$('#prograPeriodicidad'+id).val('');
			$('#prograAvanceCredito'+id).val('');
			$('#prograDiasOtorga'+id).val('');
			$('#prograDiasAntLiq'+id).val('');
			$('#prograDiasAntCuota'+id).val('');
			deshabilitaControl('prograPlazoMaximo'+id);
			$('#prograPlazoMaximo'+id).val(1);
		}else
		if (valor == 3){
			$('#tdOtorga'+id).removeAttr('style');
			$('#trPeriodo'+id).hide();
			$('#tdAvance'+id).hide();
			$('#tdLiquida'+id).hide();
			$('#tdCuota'+id).hide();
			$('#prograPeriodicidad'+id).val('');
			$('#prograAvanceCredito'+id).val('');
			$('#prograDiasOtorga'+id).val('');
			$('#prograDiasAntLiq'+id).val('');
			$('#prograDiasAntCuota'+id).val('');		
			deshabilitaControl('prograPlazoMaximo'+id);
			$('#prograPlazoMaximo'+id).val(1);	
		}else
		if (valor == 4){
			$('#tdLiquida'+id).removeAttr('style');
			$('#trPeriodo'+id).hide();
			$('#tdAvance'+id).hide();
			$('#tdOtorga'+id).hide();
			$('#tdCuota'+id).hide();
			$('#prograPeriodicidad'+id).val('');
			$('#prograAvanceCredito'+id).val('');
			$('#prograDiasOtorga'+id).val('');
			$('#prograDiasAntLiq'+id).val('');
			$('#prograDiasAntCuota'+id).val('');	
			deshabilitaControl('prograPlazoMaximo'+id);
			$('#prograPlazoMaximo'+id).val(1);		
		}else
		if (valor == 5){
			$('#tdCuota'+id).removeAttr('style');
			$('#trPeriodo'+id).hide();
			$('#tdAvance'+id).hide();
			$('#tdOtorga'+id).hide();
			$('#tdLiquida'+id).hide();
			$('#prograPeriodicidad'+id).val('');
			$('#prograAvanceCredito'+id).val('');
			$('#prograDiasOtorga'+id).val('');
			$('#prograDiasAntLiq'+id).val('');
			$('#prograDiasAntCuota'+id).val('');
			deshabilitaControl('prograPlazoMaximo'+id);
			$('#prograPlazoMaximo'+id).val(1);
		}
	}

	function validaDias(idControl){
		var jqCondi  = eval("'#" + idControl + "'");
		var valor = $(jqCondi).val();
		if (valor > 31) {
			alert("Valor no valido.");
			$(jqCondi).focus();
		}
	}
	function cambioDia(idControl) {
		var id  = idControl.substring(8);
		var jqCombo  = eval("'#" + idControl + "'");
		var valor = $(jqCombo).val();
		if (valor == 1) {
			$('#diaMes'+id).show();
			$('#diaSemana'+id).hide();
			$('#prograDiaMes'+id).val('');
			$('#prograDiaSemana'+id).val('');
		}else if (valor == 2) {
			$('#diaMes'+id).hide();
			$('#diaSemana'+id).show();
			$('#prograDiaMes'+id).val('');
			$('#prograDiaSemana'+id).val('');
		}
	}
	
	function cambioCondicionUno(idControl){
		var id  = idControl.substring(9);
		var jqCombo  = eval("'#" + idControl + "'");
		var valor = $(jqCombo).val();
		var condicion2 = $('#condici'+id).val();
		if (valor == condicion2 && valor > 4) {
			alert("No puede seleccionar la misma condición.");
			$(jqCombo).val("");
			$(jqCombo).focus();
		}
	}

	function cambioCondicionDos(idControl){
		var id  = idControl.substring(7);
		var jqCombo  = eval("'#" + idControl + "'");
		var valor = $(jqCombo).val();
		var condicion2 = $('#condicion'+id).val();
		if (valor == condicion2 && valor >4  ) {
			alert("No puede seleccionar la misma condición.");
			$(jqCombo).val("");
			$(jqCombo).focus();
		}else if (valor == 1 || valor == 2){
			$('#condiciOpc'+id).show();
			$('#condiciOpc'+id).focus();
		}else {
			$('#condiciOpc'+id).hide();
			$('#condiciOpc'+id).val('');
		}
	}

	function selecTodoEjecutivo(idControl){
		var jqSelec  = eval("'#" + idControl + "'");
		
		if ($(jqSelec).is(':checked') == true){
			$('input[name=checkEjec]').each(function () {
				$(this).attr('checked', 'true');
			});
		}else {
			$('input[name=checkEjec]').each(function () {
				$(this).removeAttr('checked');
			});
		}
	}

	function selecTodoPlazas(idControl){
		var jqSelec  = eval("'#" + idControl + "'");
		
		if ($(jqSelec).is(':checked') == true){
			$('input[name=checkPlaza]').each(function () {
				$(this).attr('checked', 'true');
			});
		}else {
			$('input[name=checkPlaza]').each(function () {
				$(this).removeAttr('checked');
			});
		}
	}

	function selecTodoSucursal(idControl){
		var jqSelec  = eval("'#" + idControl + "'");
		
		if ($(jqSelec).is(':checked') == true){
			$('input[name=checkSucur]').each(function () {
				$(this).attr('checked', 'true');
			});
		}else {
			$('input[name=checkSucur]').each(function () {
				$(this).removeAttr('checked');
			});
		}
	}
	
	function selecTodoFondeo(idControl){
		var jqSelec  = eval("'#" + idControl + "'");
		
		if ($(jqSelec).is(':checked') == true){
			$('#recPropios').attr('checked', 'true');
			$('input[name=checkFondeo]').each(function () {
				$(this).attr('checked', 'true');
			});
		}else {
			$('input[name=checkFondeo]').each(function () {
				$(this).removeAttr('checked');
			});
			$('#recPropios').removeAttr('checked');
		}
	}

	function validaSoloNumeros() {
		if ((event.keyCode < 48) || (event.keyCode > 57))
  		event.returnValue = false;
	}

	function generaFormato(idControl){
		var jqCampo  = eval("'#" + idControl + "'");
		var id = idControl.substring(10);
		var combo = $('#condici'+id).val();
		if (combo == 2) {
			$(jqCampo).formatCurrency({
				positiveFormat: '%n',
				negativeFormat: '%n',
				roundToDecimalPlace: 2
			});
		}else {
			var number = $(jqCampo).asNumber();
			$(jqCampo).val(number);
		}
	}
	
	function funcionExitoTransaccion (){
	    $("#tableSelec").hide();
		$("#tablePrograma").hide();
		$("#tableClasifica").hide();
		inicializaForma('formaGenerica', 'seguimientoID');
		$('#estatus').val("").selected = true;
		$("#productosID").val('');
		deshabilitaBoton('grabar', 'submit');
		deshabilitaBoton('modifica', 'submit');
	}


	function funcionFalloTransaccion (){
		agregaFormatoControles('formaGenerica');
	}
	
