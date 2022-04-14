$(document).ready(function() {
}); // fin del Ready
esTab=true;
agFormMone();
agregaFormatoControles('gridCredFonAsig'); 
// js para Funciones de Grid de Creditos de Redescuento

// función para mostrar el grid con las condiciones que corresponden a estados y municipios

function consultaConDesctoEdosMunLinFon(numLineaFondeo){
	var params = {};
	params['tipoLista'] = 1;
	params['creditoID'] = numLineaFondeo;

	$.post("gridCondicionesDesctoEdoLinFon.htm", params, function(data){
		$('#gridEstadosMunLoc').show();
		$('#gridEstadosMunLocGrid').show();
			if(data.length >0) {
				$('#gridEstadosMunLocGrid').html(data);
				$('#gridEstadosMunLocGrid').show();
				$('#grabarEdo').show();
				habilitaBoton('grabar', 'submit');
				
				// si no hay valores capturados se muestra la primera fila para su captura
				if($('#numeroDetalleEdo').asNumber() == 0 ){
					agregarNuevaFilaEdoMun();
					$('#gridEstadosMunLocGrid').show();
					habilitaBoton('grabarEdo', 'submit');
				}else{
					consultaDescripcionesCondEdoGrid();
				}
				$('#lineaFondeoIDEdo').val(numLineaFondeo);
			}else{
				$('#gridEstadosMunLocGrid').html("");
				$('#gridEstadosMunLoc').hide();
				$('#grabarEdo').hide();
				deshabilitaBoton('grabarEdo', 'submit');
				$('#numeroDetalleEdo').val("");
			}
			
	});
}

// función para agregar al grid la primera fila de captura
function agregarNuevaFila(){
    var numeroFila = $('input[name=consecutivoID]').length;
	var nuevaFila = parseInt(numeroFila+1);
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
 	
	tds += '<td><input type="text" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="4"  readOnly="true" value="'+nuevaFila+'" autocomplete="off" '
	            +' onkeypress="" onblur="" /></td>';
	
	tds += '<td><input type="text" id="formaSeleccion'+nuevaFila+'" name="listaSeleccion"  value="MANUAL" size="12"  readOnly="true" '
				+' onkeypress="" onblur="" /></td>';
	
	tds += '<td><input type="text" id="creditoID'+nuevaFila+'" name="listaCreditoID" size="10"  onkeypress="listaCreditosGrid(this.id);"  onblur="validarCreditoGrid(this.id);" /></td>';
	
	tds += '<td><input type="text"  id="nombreCliente'+nuevaFila+'" name="nombreCliente" size="35" autocomplete="off"   readOnly="true"'
				+' onkeypress="" onblur="" /></td>';
	
	tds += '<td><input type="text" id="fechaAsignacion'+nuevaFila+'" name="fechaAsignacion" size="9" readOnly="true"/></td>';
	
	tds += '<td><input type="text" id="fechaVen'+nuevaFila+'" name="fechaVen" size="9"  readOnly="true" autocomplete="off" '
				+' onkeypress="" onblur=""/></td>';
	
	tds += '<td><input type="text" id="montoCredito'+nuevaFila+'"  name="listaMontoCredito"  size="10"  readOnly="true" esMoneda="true" style="text-align: right;"/></td>';

	tds += '<td><input type="text" id="saldoCapCre'+nuevaFila+'" name="listaSaldoCapCre" size="10"    readOnly="true" esMoneda="true" style="text-align: right;" /></td>';
	
	tds += '<td><input type="text" id="prodCred'+nuevaFila+'" name="prodCred" size="30" value=""  readOnly="true"/></td>';
	
	tds += '<td><input type="text" id="tipoPersona'+nuevaFila+'" name="tipoPersona" size="5"    readOnly="true"/></td>';
	
	tds += '<td><input type="text" id="sexo'+nuevaFila+'" name="sexo" size="8"    readOnly="true"/></td>';
	
	tds += '<td><input type="text" id="estadoCivil'+nuevaFila+'" name="estadoCivil" size="25"    readOnly="true"/></td>';
	
	tds += '<td><input type="text" id="destino'+nuevaFila+'" name="destino" size="25"    readOnly="true"/></td>';
	
	tds += '<td><input type="text" id="actDescrip'+nuevaFila+'" name="actDescrip" size="25"    readOnly="true"/></td>';
	
	tds += '<td><textarea type="text" id="direccion'+nuevaFila+'" name="direccion" rows="2" cols="23" readOnly="true"></textarea></td>';
	
	
	tds += '<td><input type="button" name="elimina" id="elimina'+nuevaFila +'"  class="btnElimina" onclick="eliminaFila(this.id);recalTot();"/></td>';
	
	tds += '<td><input type="button" name="agrega"  id="agrega'+nuevaFila +'"  class="btnAgrega" onclick="agregarNuevaFila()"/></td>';
	
	tds += '</tr>';
	document.getElementById("numeroDetalle").value = nuevaFila; 
	$("#miTabla").append(tds);
	var jqCreditoID = eval("'#creditoID" + nuevaFila + "'");
	$(jqCreditoID).focus();
	
   return false;	
}	

// funcion para eliminar una fila  al grid de estados, municipios, localidades
function eliminaFila(control){	
	var contador = 0 ;
	var numeroID=control.substr(7);
	
	var jqRenglon 		 = eval("'#renglon" + numeroID + "'");
	var jqConsecutivo    = eval("'#consecutivoID" + numeroID + "'");
	var jqSeleccion 	 = eval("'#formaSeleccion" + numeroID + "'");
	var jqCreditoID 	 = eval("'#creditoID" + numeroID + "'");
	var jqNombreCliente  = eval("'#nombreCliente" + numeroID + "'");
	var jqFechaInicio 	 = eval("'#fechaAsignacion" + numeroID + "'");
	var jqFechaVencim 	= eval("'#fechaVen" + numeroID + "'");
	var jqMontoCred 	= eval("'#montoCredito" + numeroID + "'");
	var jqSaldoCap      = eval("'#saldoCapCre" + numeroID + "'");
	var jqProdCred      = eval("'#prodCred" + numeroID + "'");
	var jqTipoPersona   = eval("'#tipoPersona" + numeroID + "'");
	var jqSexo          = eval("'#sexo" + numeroID + "'");
	var jqEstadoCivil   = eval("'#estadoCivil" + numeroID + "'");
	var jqDestino       = eval("'#destino" + numeroID + "'");
	var jqActDescrip    = eval("'#actDescrip" + numeroID + "'");
	var jqDireccion     = eval("'#direccion" + numeroID + "'");
	var jqEliminaDetalle= eval("'#elimina" + numeroID + "'");
	var jqAgregaDetalle = eval("'#agrega" + numeroID + "'");
	
	// se elimina la fila seleccionada
	$(jqConsecutivo).remove();
	$(jqSeleccion).remove();
	$(jqCreditoID).remove();
	$(jqNombreCliente).remove();
	$(jqFechaInicio).remove();
	$(jqFechaVencim).remove();
	$(jqMontoCred).remove();
	$(jqSaldoCap).remove();
	$(jqProdCred).remove();
	$(jqTipoPersona).remove();
	$(jqSexo).remove();
	$(jqEstadoCivil).remove();
	$(jqDestino).remove();
	$(jqActDescrip).remove();
	$(jqDireccion).remove();
	$(jqEliminaDetalle).remove();
	$(jqAgregaDetalle).remove();
	$(jqRenglon).remove();
				
	// se asigna el numero de detalle que quedan
	var elementos = document.getElementsByName("renglon");
	$('#numeroDetalle').val(elementos.length);

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	var jqRenglonCiclo       = "" ; 		 
	var jqConsecutivoCiclo   = "" ;   
	var jqSeleccionCiclo     = "" ; 	 
	var jqCreditoIDCiclo     = "" ;	
	var jqNombreClienteCiclo = "" ;
	var jqFechaInicioCiclo 	 = "" ;
	var jqFechaVencimCiclo 	 = "" ;
	var jqMontoCredCiclo 	 = "" ;
	var jqSaldoCapCiclo      = "" ;
	var jqProdCredCiclo      = "" ;
	var jqTipoPersonaCiclo   = "" ;
	var jqSexoCiclo          = "" ;
	var jqEstadoCivilCiclo   = "" ;
	var jqDestinoCiclo       = "" ;
	var jqActDescripCiclo    = "" ;
	var jqDireccionCiclo     = "" ;
	var jqEliminaDetalleCiclo = "";
	var jqAgregaDetalleCiclo = "" ;
	
	$('tr[name=renglonEdo]').each(function() {
		numero= this.id.substr(10,this.id.length);
		jqRenglonCiclo = eval("'renglon" + numero+ "'");	
		
		jqConsecutivoCiclo   = eval("'consecutivoID" + numeroID + "'");   
		jqSeleccionCiclo     = eval("'formaSeleccion" + numeroID + "'"); 	 
		jqCreditoIDCiclo     = eval("'creditoID" + numeroID + "'");	
		jqNombreClienteCiclo = eval("'nombreCliente" + numeroID + "'");
		jqFechaInicioCiclo 	 = eval("'fechaAsignacion" + numeroID + "'");
		jqFechaVencimCiclo 	 = eval("'fechaVen" + numeroID + "'");
		jqMontoCredCiclo 	 = eval("'montoCredito" + numeroID + "'");
		jqSaldoCapCiclo      = eval("'saldoCapCre" + numeroID + "'");
		jqProdCredCiclo      = eval("'prodCred" + numeroID + "'");
		jqTipoPersonaCiclo   = eval("'tipoPersona" + numeroID + "'");
		jqSexoCiclo   = eval("'sexo" + numeroID + "'");
		jqEstadoCivilCiclo   = eval("'estadoCivil" + numeroID + "'");
		jqDestinoCiclo   = eval("'destino" + numeroID + "'");
		jqActDescripCiclo   = eval("'actDescrip" + numeroID + "'");
		jqDireccionCiclo     = eval("'direccion" + numeroID + "'");
		jqEliminaDetalleCiclo = eval("'elimina" + numeroID + "'");
		jqAgregaDetalleCiclo  = eval("'agrega" + numeroID + "'");
		
		document.getElementById(jqRenglonCiclo).setAttribute('id', "renglonEdo" + contador);
		document.getElementById(jqConsecutivoCiclo).setAttribute('id', "consecutivoID" + contador);
		document.getElementById(jqSeleccionCiclo).setAttribute('id', "formaSeleccion" + contador);
		document.getElementById(jqCreditoIDCiclo).setAttribute('id', "creditoID" + contador);
		document.getElementById(jqNombreClienteCiclo).setAttribute('id', "nombreCliente" + contador);
	
		document.getElementById(jqFechaInicioCiclo).setAttribute('id', "fechaAsignacion" + contador);
		document.getElementById(jqFechaVencimCiclo).setAttribute('id', "fechaVen" + contador);
		document.getElementById(jqMontoCredCiclo).setAttribute('id', "montoCredito" + contador);
		document.getElementById(jqSaldoCapCiclo).setAttribute('id', "saldoCapCre" + contador);
		document.getElementById(jqProdCredCiclo).setAttribute('id', "prodCred" + contador);
		document.getElementById(jqTipoPersonaCiclo).setAttribute('id', "tipoPersona" + contador);
		document.getElementById(jqSexoCiclo).setAttribute('id', "sexo" + contador);
		document.getElementById(jqEstadoCivilCiclo).setAttribute('id', "estadoCivil" + contador);
		document.getElementById(jqDestinoCiclo).setAttribute('id', "destino" + contador);
		document.getElementById(jqActDescripCiclo).setAttribute('id', "actDecrip" + contador);
		document.getElementById(jqDireccionCiclo).setAttribute('id', "direccion" + contador);
		
		document.getElementById(jqEliminaDetalleCiclo).setAttribute('id', "elimina" + contador);
		document.getElementById(jqAgregaDetalleCiclo).setAttribute('id', "agrega" + contador);

		contador = parseInt(contador + 1);	
	});
}

// funcion para listar en el grid los CREDITOS
function listaCreditosGrid(idControl){
	var jqControl = eval("'#" + idControl+ "'");
	var camposLista = new Array();
	var parametrosLista = new Array();
	camposLista[0] = "creditoID";
	parametrosLista[0] = $(jqControl).val();
	if($(jqControl).val() != ''){
		lista(idControl, '2', '9', camposLista, parametrosLista, 'ListaCredito.htm');
	}
}	
function recalTot(){
	var saldoCap = 0;
	var subtotal = 0;
	var jqsal    = 0;
	$('input[name=listaSaldoCapCre]').each(function() {
	var jqMonto = eval("'#" + this.id + "'");
	jqsal = $(jqMonto).asNumber();
	
	saldoCap = parseFloat(jqsal); 
	subtotal = subtotal + saldoCap;
	/*saldoCap = $(jqSaldoCap).asNumber();
	subtotal = document.getElementById("sumaSaldoCapital").value;
	x = parseFloat(subtotal);
	total = parseFloat(saldoCap) + x;*/
	});	
	$('#sumaSaldoCapital').val("");
	$('#sumaSaldoCapital').val(subtotal);
	$('#sumaSaldoCapital').formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
}

function agFormMone(){
	$('input[name=listaSaldoCapCre]').each(function() {
		agregaFormatoMoneda(this.id);
		});	
}
function quitaFormMone(){
	$('input[name=listaSaldoCapCre]').each(function() {
		quitaFormatoMoneda(this.id);
		});	
}



// funcion para consultar la descripcion del estado  
function consultaCreditosGrid(idControl) {
	var jqCredito      = eval("'#" + idControl + "'");
	var numCredito     = $(jqCredito).val();
	var numDetalle     = $('input[name=consecutivoID]').length;
	var jqCreditoID 	 = eval("'#creditoID" + numDetalle + "'");
	var jqNombreCliente  = eval("'#nombreCliente" + numDetalle + "'");
	var jqFechaInicio 	 = eval("'#fechaAsignacion" + numDetalle + "'");
	var jqFechaVencim 	= eval("'#fechaVen" + numDetalle + "'");
	var jqMontoCred 	= eval("'#montoCredito" + numDetalle + "'");
	var jqSaldoCap      = eval("'#saldoCapCre" + numDetalle + "'");
	var jqProdCred      = eval("'#prodCred" + numDetalle + "'");
	var jqTipoPersona   = eval("'#tipoPersona" + numDetalle + "'");
	var jqSexo = eval("'#sexo" + numDetalle + "'");
	var jqEstadoCivil   = eval("'#estadoCivil" + numDetalle + "'");
	var jqDestino   = eval("'#destino" + numDetalle + "'");
	var jqActDescrip   = eval("'#actDescrip" + numDetalle + "'");
	var jqDireccion     = eval("'#direccion" + numDetalle + "'");
	var jqFecha         = $('#fecha').val();
	var tipConPrincipal = 1;
	
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	var creditoBeanCon = { 
			'creditoID': numCredito
	};
	if (numCredito != '' && !isNaN(numCredito) && esTab) {
		redesCueServicio.consulta(tipConPrincipal,creditoBeanCon,function(credito) {
			if(credito!=null){
				$(jqCreditoID).val(credito.creditoID);
				$(jqNombreCliente).val(credito.nombreCompleto);
				$(jqFechaInicio).val(credito.fechaInicio);
				$(jqFechaVencim).val(credito.fechaVencimien);
				$(jqMontoCred).val(credito.montoCredito);
				$(jqSaldoCap).val(credito.saldoCapital);
				recalTot();
				$(jqProdCred).val(credito.descripcion);
				$(jqTipoPersona).val(credito.tipoPersona);
				$(jqSexo).val(credito.sexo);
				$(jqEstadoCivil).val(credito.estadoCivil);
				$(jqDestino).val(credito.destino);
				$(jqActDescrip).val(credito.actDescrip);
				$(jqDireccion).val(credito.direccionCompleta);
				//agregaFormatoMoneda("'montoCredito" + numDetalle + "'");
				$(jqMontoCred).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});	
				$(jqSaldoCap).formatCurrency({positiveFormat: '%n', roundToDecimalPlace: 2});
			} else {
				alert("No Existe el Crédito");
				$(jqCredito).val("");
				$(jqCredito).focus();
				$(jqCreditoID).val("");
				$(jqNombreCliente).val("");
				$(jqFechaInicio).val("");
				$(jqFechaVencim).val("");
				$(jqMontoCred).val("");
				$(jqSaldoCap).val("");
				$(jqProdCred).val("");
				$(jqTipoPersona).val("");
				$(jqSexo).val("");
				$(jqEstadoCivil).val("");
				$(jqDestino).val("");
				$(jqActDescrip).val("");
				$(jqDireccion).val("");
				
			}
		});
	}
}

function validarCreditoGrid(idControl){
	var jqCredito      = eval("'#" + idControl + "'");
	var numCredito     = $(jqCredito).val();
	var numDetalle     = $('input[name=consecutivoID]').length;
	var jqCreditoID 	 = eval("'#creditoID" + numDetalle + "'");
	var jqNombreCliente  = eval("'#nombreCliente" + numDetalle + "'");
	var jqFechaInicio 	 = eval("'#fechaAsignacion" + numDetalle + "'");
	var jqFechaVencim 	= eval("'#fechaVen" + numDetalle + "'");
	var jqMontoCred 	= eval("'#montoCredito" + numDetalle + "'");
	var jqSaldoCap      = eval("'#saldoCapCre" + numDetalle + "'");
	var jqProdCred      = eval("'#prodCred" + numDetalle + "'");
	var jqTipoPersona   = eval("'#tipoPersona" + numDetalle + "'");
	var jqSexo          = eval("'#sexo" + numDetalle + "'");
	var jqEstadoCivil   = eval("'#estadoCivil" + numDetalle + "'");
	var jqDestino       = eval("'#destino" + numDetalle + "'");
	var jqActDescrip    = eval("'#ActDescrip" + numDetalle + "'");
	var jqDireccion     = eval("'#direccion" + numDetalle + "'");
	var jqFecha         = $('#fecha').val();
	var tipConForanea = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	var creditoBeanCon = { 
			'creditoID': numCredito,
			'fechaAsignacion':jqFecha
	};
	if (numCredito != '' && !isNaN(numCredito) && esTab) {
		redesCueServicio.consulta(tipConForanea,creditoBeanCon,function(credito) {
			if(credito!=null){ 
					var confirmar=confirm("El Credito Activo, ya se encuentra asignado \nAl Credito Pasivo: "+credito.creditoFondeoID+" \n¿Desea continuar?");
					if (confirmar == true) {
						consultaCreditosGrid(idControl);
					}				
					else {
						$(jqCreditoID).focus();
						$(jqCreditoID).val("");
						$(jqNombreCliente).val("");
						$(jqFechaInicio).val("");
						$(jqFechaVencim).val("");
						$(jqMontoCred).val("");
						$(jqSaldoCap).val("");
						$(jqProdCred).val("");
						$(jqTipoPersona).val("");
						$(jqSexo).val("");
						$(jqEstadoCivil).val("");
						$(jqDestino).val("");
						$(jqActDescrip).val("");
						$(jqDireccion).val("");
					} 
			} else {
				consultaCreditosGrid(idControl);
			}
		});
	}
}
//funcion para listar en el grid los municipios
function listaMunicipiosGrid(idControl){
	var jqControl = eval("'#" + idControl+ "'");
	var jqEstadoID = eval("'#estadoID" + idControl.substr(11) + "'");
	var camposLista = new Array();
	var parametrosLista = new Array();
	camposLista[0] = "estadoID";
	camposLista[1] = "nombre";
	parametrosLista[0] = $(jqEstadoID).val();
	parametrosLista[1] = $(jqControl).val();
	if($(jqControl).val() != ''){
		listaAlfanumerica(idControl, '2', '1', camposLista, parametrosLista,'listaMunicipios.htm');
	}
}	


//funcion para consultar la descripcion del municipio  
function consultaMunicipioDescripcionGrid(idControl) {
	var jqMunicipio = eval("'#" + idControl + "'");
	var jqMunicipioDes = eval("'#municipioDescripcion" + idControl.substr(11) + "'");
	var jqestadoID =  eval("'#estadoID" + idControl.substr(11) + "'");		
	var numMunicipio = $(jqMunicipio).val();	
	var numEstado = $(jqestadoID).val();
	var tipConForanea = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	if (numMunicipio != '' && !isNaN(numMunicipio) && esTab) {
		if(numMunicipio==0){
			$(jqMunicipioDes).val("TODOS");
		}else{
		municipiosServicio.consulta(tipConForanea,numEstado,numMunicipio,function(municipio) {
			if (municipio != null) {
				$(jqMunicipioDes).val(municipio.nombre);
			} else {
				alert("No Existe el Municipio");
				$(jqMunicipio).val("");
				$(jqMunicipio).focus();
			}
		});
		}
		
	}
}	

//funcion para listar en el grid las localidades de la republica
function listaLocalidadesGrid(idControl){
	var jqControl = eval("'#" + idControl+ "'");
	var jqEstadoID = eval("'#estadoID" + idControl.substr(11) + "'");
	var jqMunicipioID = eval("'#municipioID" + idControl.substr(11) + "'");
	var camposLista = new Array();
	var parametrosLista = new Array();
	camposLista[0] = "estadoID";
	camposLista[1] = 'municipioID';
	camposLista[2] = "nombreLocalidad";
	parametrosLista[0] = $(jqEstadoID).val();
	parametrosLista[1] = $(jqMunicipioID).val();
	parametrosLista[2] = $(jqControl).val();
	if($(jqControl).val() != ''){
		listaAlfanumerica(idControl, '2', '1', camposLista, parametrosLista,'listaLocalidades.htm');
	}
}	
function validaEstado(idCtrl){
	var cont=0;
	var jqEstado = eval("'#" + idCtrl + "'");
	var jqEstadoDes = eval("'#estadoDescripcion" + idCtrl.substr(8) + "'");
	var jqEstadoID = eval("'#estadoID" + idCtrl.substr(8) + "'");
	var act = $(jqEstado).val();
	//var act = $('#'+idCtrl).val();
	if(act!=0){
		$('input[name=listaEstadoID]').each(function() {
			if(this.value == 0){
				cont++;
			}
		});		
		if(cont==1){
			alert("Ya Elegiste Todos los Estados");
			$(jqEstadoID).focus();
			$(jqEstadoID).val('');
			$(jqEstadoDes).val('');
		} 		
	}else if(act!='' && act == 0){
		var cont1=0;
		$('input[name=listaEstadoID]').each(function() {
			if(this.value != 0){
				cont1++;
			}
		});		
		if(cont1>0){
			alert("Si Eliges Todos los Estados Elimina los Insertados");
			$(jqEstadoID).focus();
			$(jqEstado).val('');
			$(jqEstadoID).val('');
			$(jqEstadoDes).val('');
		}
	}	
}
function validaMunicipio(idCtrl){
	var jqMunicipio = eval("'#" + idCtrl + "'");
	var jqMunicipioDes = eval("'#municipioDescripcion" + idCtrl.substr(11) + "'");
	var jqMunicipioID = eval("'#municipioID" + idCtrl.substr(11) + "'");
	var numDetalle = $('input[name=listaEstadoID]').length;
	var jqEstadoID = eval("'#estadoID" + numDetalle + "'");
	var jqEstadoDes = eval("'#estadoDescripcion" + numDetalle + "'");
	var act = $(jqMunicipio).val();
    var edo = $(jqEstadoID).val();
	
	if(act!=0){
		for(var i = 1; i <= numDetalle - 1; i++){
			var edoi = eval("'#estadoID" + i + "'");
			var edoo = $(edoi).val();
			if(edoo == edo){
				var muni = eval("'#municipioID" + i + "'");
				var munii = $(muni).val();
				if(munii==0){
					alert("Ya Elegiste Todos los Municipios del Estado");
					$(jqEstadoID).focus();
					$(jqEstadoID).val('');
					$(jqEstadoDes).val('');
					$(jqMunicipioID).val('');
					$(jqMunicipioDes).val('');
					i=1000;
				}
			}
		}		
	}
	else if(act!='' && act == 0){
		for(var i = 1; i <= numDetalle - 1; i++){
			var edoi = eval("'#estadoID" + i + "'");
			var edoo = $(edoi).val();
			if(edoo == edo){
				var muni = eval("'#municipioID" + i + "'");
				var munii = $(muni).val();
				if(munii!=0){
					alert("Si Eliges Todos los Municipios del Estado Elimina las Anteriores");
					$(jqEstadoID).focus();
					$(jqEstadoID).val('');
					$(jqEstadoDes).val('');
					$(jqMunicipioID).val('');
					$(jqMunicipioDes).val('');
					i=1000;
				}
			}
		}
	}	
}

// funcion para consultar la descripcion del estado  
function consultaLocalidadDescripcionGrid(idControl) {
	var jqLocalidad = eval("'#" + idControl + "'");
	var jqLocalidadDes = eval("'#localidadDescripcion" + idControl.substr(11) + "'");
	var jqMunicipioID = eval("'#municipioID" + idControl.substr(11) + "'");
	var jqEstadoID = eval("'#estadoID" + idControl.substr(11) + "'");
	var numLocalidad = $(jqLocalidad).val();
	var numMunicipio =	$(jqMunicipioID).val();
	var numEstado =  $(jqEstadoID).val();				
	var tipConPrincipal = 1;		
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	if(numLocalidad != '' && !isNaN(numLocalidad) && esTab){
		if(numLocalidad==0){
			$(jqLocalidadDes).val("TODOS");
		}else{
		localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,function(localidad) {
			if (localidad != null) {
				$(jqLocalidadDes).val(localidad.nombreLocalidad);
			} else {
				alert("No Existe la Localidad");
				$(jqLocalidad).val("");
				$(jqLocalidad).focus();
			}
		});
		}
	}
}

function consultaDescripcionesCondEdoGrid(){
	$('tr[name=renglonEdo]').each(function() {
		var numero= this.id.substring(10,this.id.length);	
		var jqEstadoIDCiclo = "estadoID" + numero;
		var jqMunicipioIDCiclo = "municipioID" + numero;
		var jqLocalidadIDCiclo= "localidadID" + numero;
		consultaLocalidadDescripcionGrid(jqLocalidadIDCiclo);
		consultaMunicipioDescripcionGrid(jqMunicipioIDCiclo);
		consultaEstadoDescripcionGrid(jqEstadoIDCiclo);
	});
}

function funcionExitoCondEdo(){
	esTab=true;
	//validaLineaFondeo('lineaFondeoID');
	consultaConDesctoEdosMunLinFon($('#lineaFondeoIDEdo').asNumber());
}

function funcionFalloCondEdo(){
	
}