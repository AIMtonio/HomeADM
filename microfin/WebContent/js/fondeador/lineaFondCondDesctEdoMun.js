$(document).ready(function() {
	//Definicion de Constantes y Enums  
	var catTipoTransaccionDesctoEdo = {   
  		'agrega':1,
  		'modifica':2
	};
	
	$.validator.setDefaults({
		submitHandler: function(event) {
			var vacio=validaVacios();
			if(vacio==1){
			
			}else{
				grabaFormaTransaccionRetrollamada(event, 'formaGenerica2', 'contenedorForma', 'mensaje','true','lineaFondeoID','funcionExitoCondEdo','funcionFalloCondEdo');	
			}
		}
    });
	
	// seccion de eventos para condiciones de estados, municipios, localidades de credito
	$('#grabarEdo').click(function() {
		
		$('#tipoTransaccionEstado').val(catTipoTransaccionDesctoEdo.agrega);
	});
	
	// formulario de grid de estados y municipios
	$('#formaGenerica2').validate({
		rules: {
			lineaFondeoIDEdo: {required: true},			
			
		},
		messages: {	
			lineaFondeoIDEdo: {required: 'Especificar Linea de Fondeo '	}			
		}		
	});
	function validaVacios(){
		var conta = 0;
		var numDetalle = $('input[name=listaEstadoID]').length;
		var jqEstadoID = eval("'#estadoID" + numDetalle + "'");
		var jqMunicipioID = eval("'#municipioID" + numDetalle + "'");
		var jqLocalidadID = eval("'#localidadID" + numDetalle + "'");
		
		if($(jqEstadoID).val()==''){
			$(jqEstadoID).focus();
		    conta = 1;
		    return conta;
		}
		if($(jqMunicipioID).val()==''){
			$(jqMunicipioID).focus();			
		    conta = 1;
		    return conta;
		}
		if($(jqLocalidadID).val()==''){
			$(jqLocalidadID).focus();
		    conta = 1;
		    return conta;
		}
	}
}); // fin del Ready

// js para Funciones de Grid de Condiciones de Descuento de Estados, Municipios y 
// Localidades de la pantalla Linea de Fondeo


// función para mostrar el grid con las condiciones que corresponden a estados y municipios
function consultaConDesctoEdosMunLinFon(numLineaFondeo){
	var params = {};
	params['tipoLista'] = 1;
	params['lineaFondeoIDEdo'] = numLineaFondeo;

	$.post("gridCondicionesDesctoEdoLinFon.htm", params, function(data){
		$('#gridEstadosMunLoc').show();
		$('#gridEstadosMunLocGrid').show();
			if(data.length >0) {
				$('#gridEstadosMunLocGrid').html(data);
				$('#gridEstadosMunLocGrid').show();
				$('#grabarEdo').show();
				habilitaBoton('grabarEdo', 'submit');
				
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
function agregarNuevaFilaEdoMun(){
	var numeroFila = $("#numeroDetalleEdo").asNumber() +1;
	var nuevaFila = parseInt(numeroFila);
	var tds = '<tr id="renglonEdo' + nuevaFila + '" name="renglonEdo">';
 	
	tds += '<td nowrap="nowrap"><input type="text" id="estadoID'+nuevaFila+'" name="listaEstadoID" size="10" value="" autocomplete="off" '
				+' onkeypress="listaEstadosGrid(this.id);" onblur="validaEstado(this.id);consultaEstadoDescripcionGrid(this.id);" />';
	tds += '<input type="text" id="estadoDescripcion'+nuevaFila+'" name="estadoDescripcion" size="35" value="" disabled="disabled" readonly="readonly"/></td>';
	tds += '<td class="separador"></td>';
	tds += '<td nowrap="nowrap"><input type="text"  id="municipioID'+nuevaFila+'" name="listaMunicipioID" size="10" value="" autocomplete="off" '
				+' onkeypress="listaMunicipiosGrid(this.id);" onblur="validaMunicipio(this.id);consultaMunicipioDescripcionGrid(this.id);" />';
	tds += '<input type="text" id="municipioDescripcion'+nuevaFila+'" name="municipioDescripcion" size="35" value="" disabled="disabled" readonly="readonly"/></td>';
	tds += '<td class="separador"></td>';
	tds += '<td nowrap="nowrap"><input type="text" id="localidadID'+nuevaFila+'" name="listaLocalidadID" size="10" value="" autocomplete="off" '
				+' onkeypress="listaLocalidadesGrid(this.id);" onblur="validaLocalidad(this.id);consultaLocalidadDescripcionGrid(this.id);"/>';
	tds += '<input type="text" id="localidadDescripcion'+nuevaFila+'" name="localidadDescripcion" size="40" value="" disabled="disabled" readonly="readonly" /></td>';

	tds += '<td><input type="button" name="eliminaEdo" id="eliminaEdo'+nuevaFila +'" value="" class="btnElimina" onclick="eliminaFilaEdo(this.id)"/></td>';
	tds += '<td><input type="button" name="agregaEdo"  id="agregaEdo'+nuevaFila +'" value="" class="btnAgrega" onclick="agregarNuevaFilaEdoMun()"/></td>';
	tds += '</tr>';
	
	

	document.getElementById("numeroDetalleEdo").value = nuevaFila;    	
	$("#tablaEstadosMun").append(tds);
   return false;	
}	

// funcion para eliminar una fila  al grid de estados, municipios, localidades
function eliminaFilaEdo(control){	
	var contador = 0 ;
	var numeroID=control.substr(10);
	
	var jqRenglon 		= eval("'#renglonEdo" + numeroID + "'");
	var jqEstadoID 		= eval("'#estadoID" + numeroID + "'");
	var jqEstadoDes 	= eval("'#estadoDescripcion" + numeroID + "'");
	var jqMunicipioID 	= eval("'#municipioID" + numeroID + "'");
	var jqMunicipioDes 	= eval("'#municipioDescripcion" + numeroID + "'");
	
	var jqLocalidadID 	= eval("'#localidadID" + numeroID + "'");
	var jqLocalidadDes 	= eval("'#localidadDescripcion" + numeroID + "'");
	var jqEliminaDetalle= eval("'#eliminaEdo" + numeroID + "'");
	var jqAgregaDetalle = eval("'#agregaEdo" + numeroID + "'");
	
	// se elimina la fila seleccionada
	$(jqEstadoID).remove();
	$(jqEstadoDes).remove();
	$(jqMunicipioID).remove();
	$(jqMunicipioDes).remove();
	$(jqLocalidadID).remove();

	$(jqLocalidadDes).remove();
	$(jqEliminaDetalle).remove();
	$(jqAgregaDetalle).remove();
	$(jqRenglon).remove();
				
	// se asigna el numero de detalle que quedan
	var elementos = document.getElementsByName("renglonEdo");
	$('#numeroDetalleEdo').val(elementos.length);	

	//Reordenamiento de Controles
	contador = 1;
	var numero= 0;
	var jqRenglonCiclo = "" ;
	var jqEstadoIDCiclo = "" ;
	var jqEstadoDesCiclo = "" ;
	var jqMunicipioIDCiclo = "";
	var jqMunicipioDesCiclo = "";
	
	var jqLocalidadIDCiclo = "" ;
	var jqLocalidadDesCiclo = "" ;
	var jqEliminaDetalleCiclo = "";
	var jqAgregaDetalleCiclo = "" ;
	
	$('tr[name=renglonEdo]').each(function() {
		numero= this.id.substr(10,this.id.length);
		jqRenglonCiclo = eval("'renglonEdo" + numero+ "'");	
		jqEstadoIDCiclo = eval("'estadoID" + numero + "'");
		jqEstadoDesCiclo = eval("'estadoDescripcion" + numero + "'");
		jqMunicipioIDCiclo = eval("'municipioID" + numero + "'");
		jqMunicipioDesCiclo = eval("'municipioDescripcion" + numero + "'");
		
		jqLocalidadIDCiclo= eval("'localidadID" + numero + "'");
		jqLocalidadDesCiclo = eval("'localidadDescripcion" + numero + "'");
		jqEliminaDetalleCiclo = eval("'eliminaEdo" + numero + "'");
		jqAgregaDetalleCiclo = eval("'agregaEdo" + numero + "'");

		document.getElementById(jqRenglonCiclo).setAttribute('id', "renglonEdo" + contador);
		document.getElementById(jqEstadoIDCiclo).setAttribute('id', "estadoID" + contador);
		document.getElementById(jqEstadoDesCiclo).setAttribute('id', "estadoDescripcion" + contador);
		document.getElementById(jqMunicipioIDCiclo).setAttribute('id', "municipioID" + contador);
		document.getElementById(jqMunicipioDesCiclo).setAttribute('id', "municipioDescripcion" + contador);
	
		document.getElementById(jqLocalidadIDCiclo).setAttribute('id', "localidadID" + contador);
		document.getElementById(jqLocalidadDesCiclo).setAttribute('id', "localidadDescripcion" + contador);
		document.getElementById(jqEliminaDetalleCiclo).setAttribute('id', "eliminaEdo" + contador);
		document.getElementById(jqAgregaDetalleCiclo).setAttribute('id', "agregaEdo" + contador);

		contador = parseInt(contador + 1);	
	});
}

// funcion para listar en el grid los estados de la republica
function listaEstadosGrid(idControl){
	var jqControl = eval("'#" + idControl+ "'");
	var camposLista = new Array();
	var parametrosLista = new Array();
	camposLista[0] = "nombre";
	parametrosLista[0] = $(jqControl).val();
	if($(jqControl).val() != ''){
		listaAlfanumerica(idControl, '2', '1', camposLista,parametrosLista,'listaEstados.htm');
	}
}	

// funcion para consultar la descripcion del estado  
function consultaEstadoDescripcionGrid(idControl) {
	var jqEstado = eval("'#" + idControl + "'");
	var jqEstadoDes = eval("'#estadoDescripcion" + idControl.substr(8) + "'");
	var numEstado = $(jqEstado).val();
	var tipConForanea = 2;
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	if (numEstado != '' && !isNaN(numEstado) && esTab) {
		estadosServicio.consulta(tipConForanea,numEstado,function(estado) {
			if (estado != null) {
				if(estado.estadoID == 0){
					$(jqEstadoDes).val("TODOS");
				}else{
				$(jqEstadoDes).val(estado.nombre);
				}
			} else {
				alert("No Existe el Estado");
				$(jqEstado).val("");
				$(jqEstado).focus();
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
function validaLocalidad(idCtrl){
	var jqLocalidad = eval("'#" + idCtrl + "'");
	var numDetalle = $('input[name=listaEstadoID]').length;
	var jqLocalidadDes = eval("'#localidadDescripcion" + numDetalle + "'");
	var jqMunicipioID = eval("'#municipioID" + numDetalle + "'");
	var jqMunicipioDes = eval("'#municipioDescripcion" + numDetalle + "'");
	var jqEstadoID = eval("'#estadoID" + numDetalle + "'");
	var jqEstadoDes = eval("'#estadoDescripcion" + numDetalle + "'");
	var act = $(jqLocalidad).val();
	var mu = $(jqMunicipioID).val();
    var edo = $(jqEstadoID).val();
	
	if(act!=0){
		for(var i = 1; i <= numDetalle - 1; i++){
			var edoi = eval("'#estadoID" + i + "'");
			var edoo = $(edoi).val();
			if(edoo == edo){
				var muni = eval("'#municipioID" + i + "'");
				var munii = $(muni).val();
				if(munii==mu){
					var loc = eval("'#localidadID" + i + "'");
					var loci = $(loc).val();
					if(loci==0){
						alert("Ya Elegiste Todas las Localidades del Estado");
						$(jqEstadoID).focus();
						$(jqEstadoID).val('');
						$(jqEstadoDes).val('');
						$(jqMunicipioID).val('');
						$(jqMunicipioDes).val('');
						$(jqLocalidad).val('');
						$(jqLocalidadDes).val('');						
						i=1000;
					}else if(loci==act){
						alert("La Localidad ya Existe");
						$(jqLocalidad).focus();
						$(jqLocalidad).val('');
						$(jqLocalidadDes).val('');						
						i=1000;
					}
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
				if(munii==mu){
					var loc = eval("'#localidadID" + i + "'");
					var loci = $(loc).val();
					if(loci!=0){
						alert("Si Eliges Todos las Localidades del Estado Elimina las Anteriores");
						$(jqEstadoID).focus();
						$(jqEstadoID).val('');
						$(jqEstadoDes).val('');
						$(jqMunicipioID).val('');
						$(jqMunicipioDes).val('');
						$(jqLocalidad).val('');
						$(jqLocalidadDes).val('');						
						i=1000;
					}
				}
			}
		}
	}	
}
function consultaHabitantes(){
	var numDetalle = $('input[name=listaEstadoID]').length;
	var jqNumHab = eval("'#auxHabitantes" + numDetalle + "'");
	var jqNumHab1 = eval("'#auxHabitantes1" + numDetalle + "'");
	var numHabita = $(jqNumHab).val();
	var numHabita1 = $(jqNumHab1).val();
	$('#numHabitantesInf').val(numHabita);
	$('#numHabitantesSup').val(numHabita1);
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
	var numHabitaInf = $('#numHabitantesInf').asNumber();
	var numHabitaSup = $('#numHabitantesSup').asNumber();
	var tipConPrincipal = 1;		
	setTimeout("$('#cajaLista').hide();", 200);
	esTab = true;
	if(numLocalidad != '' && !isNaN(numLocalidad) && esTab){
		if(numLocalidad==0){
			$(jqLocalidadDes).val("TODOS");
		}else{
		localidadRepubServicio.consulta(tipConPrincipal,numEstado,numMunicipio,numLocalidad,function(localidad) {
			if (localidad != null) {
				if(localidad.numHabitantes >= numHabitaInf && localidad.numHabitantes <= numHabitaSup){
					$(jqLocalidadDes).val(localidad.nombreLocalidad);
				}else if(numHabitaInf==0 && numHabitaSup==0){
					$(jqLocalidadDes).val(localidad.nombreLocalidad);
				}else {
					alert("La Localidad no Cumple con el Límite de Habitantes");
					$(jqLocalidad).val("");
					$(jqLocalidad).focus();
					$(jqLocalidadDes).val("");
				}
				
			} else {
				alert("No Existe la Localidad");
				$(jqLocalidad).val("");
				$(jqLocalidad).focus();
				$(jqLocalidadDes).val("");
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
		consultaHabitantes();
	});
}

function validaLimiteInferior(){
	var numHabitaInf = $('#numHabitantesInf').val();
	var numHabitaSup = $('#numHabitantesSup').val();
	//alert("estan mal las validaciones"+numHabitaInf+"-"+numHabitaSup);
	if(numHabitaSup == 0 || numHabitaSup == ''){
		
	}else if(numHabitaSup > 0) {
		if(numHabitaInf>numHabitaSup){
			alert("El Límite Inferior no debe ser Mayor al Superior");
			$('#numHabitantesInf').val('');
			$('#numHabitantesInf').focus();
		}else{
		}
	}
}

function validaLimiteSuperior(){
	var numHabitaInf = $('#numHabitantesInf').val();
	var numHabitaSup = $('#numHabitantesSup').val();
	//alert("estan mal las validaciones"+numHabitaInf+"-"+numHabitaSup);
	if(numHabitaInf == 0 || numHabitaInf == ''){
		
	}else if(numHabitaInf > 0) {
		if(numHabitaSup < numHabitaInf){
			alert("El Límite Superior no debe ser Menor al Inferior");
			$('#numHabitantesSup').val('');
			$('#numHabitantesSup').focus();
		}else{
			
		}
	}
}

var nav4 = window.Event ? true : false;
function IsNumber(evt){
	var key = nav4 ? evt.which : evt.keyCode;
	return (key <= 13 || (key >= 48 && key <= 57) );
}

function funcionExitoCondEdo(){
	esTab=true;
	//validaLineaFondeo('lineaFondeoID');
	consultaConDesctoEdosMunLinFon($('#lineaFondeoIDEdo').asNumber());
}

function funcionFalloCondEdo(){
	
}