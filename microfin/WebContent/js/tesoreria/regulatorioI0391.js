var opcionMenuRegBean ;
var menuClasCred		= {};
var menuFormaAdqui 		= {};
var menuGrupoRiesg 		= {};
var menuTipoInstru		= {};
var esTab				= true;
var enteroCero          = 0;
var catRegulatorioI0391 = { 
			'Excel'			: 2,		
			'Csv'			: 3,		
		};

var lisMenuRegulatorio = { 
			'Busqueda'		: 1,		
			'Combo'			: 2,		
		};

var catMenuRegulatorio = { 
			'Instituciones'			: 1,		
			'ClasifCredito'			: 2,		
			'FormaAdquisicion'		: 3,		
			'TipoRiesgo'			: 4,		
			'TipoInstrumento'		: 5,		
		};

$(document).ready(function() {
	parametros = consultaParametrosSession();
	esTab = true;


	//------------ Metodos y Manejo de Eventos -----------------------------------------
	agregaFormatoControles('formaGenerica');
	llenaComboAnios(parametroBean.fechaAplicacion);

	//------------ Validaciones de Controles -------------------------------------
	
	$.validator.setDefaults({
	    submitHandler: function(event) {    	  
	  	 grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','anio');
	  	   
	  	   //Si la respuesta es éxitosa se habilita el botón generar
	  	   setTimeout(function(){
		  	   	var resultado = $('#numeroMensaje').val();
				if(resultado == enteroCero){
				 	habilitaBoton('generar');
				}

	  	   },500);	 
	  	   	 

	    }
	 });

	$('#formaGenerica').validate({
		rules: {
			anio: 'required'				
		},		
		messages: {
			anio: 'Especifique el Año del periodo',		
		}		
	});


	cargarMenus(); 
	
	consultaRegistroRegulatorioI0391();

	$(':text').bind('keydown', function(e) {
				if (e.which == 9 && !e.shiftKey) {
					esTab = true;
				}
			});

	$(':text').focus(function() {
		esTab = false;
	});
	

	

});// cerrar




function seleccionaOpcionMenuReg(){	
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);
			var jsClasCred = eval("'sclasfConta" + numero+ "'");	
			var jsFormaAdqui = eval("'sformaAdqui" + numero+ "'");	
			var jsGrupoRiesg = eval("'sgrupoRiesgo" + numero+ "'");	
			var jsTipoInstru = eval("'stipoInstru" + numero+ "'");	


			var valorClasCred= document.getElementById(jsClasCred).value;	
			var valorFormaAdqui= document.getElementById(jsFormaAdqui).value;	
			var valorGrupoRiesg= document.getElementById(jsGrupoRiesg).value;	
			var valorTipoInstru= document.getElementById(jsTipoInstru).value;	


			$('#clasfConta'+numero+' option[value='+ valorClasCred +']').attr('selected','true');	
			$('#formaAdqui'+numero+' option[value='+ valorFormaAdqui +']').attr('selected','true');	
			$('#grupoRiesgo'+numero+' option[value='+ valorGrupoRiesg +']').attr('selected','true');	
			$('#tipoInstru'+numero+' option[value='+ valorTipoInstru +']').attr('selected','true');	

			esTab = true;
			consultaEntidad("entidad"+numero);
		});
		
	}

	function iniciarDatePikers(){	
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);

			$("#fechaContra"+numero).datepicker({
    			showOn: "button",
    			buttonImage: "images/calendar.png",
    			buttonImageOnly: true,
				changeMonth: true, 
				changeYear: true,
				dateFormat: 'yymmdd',
				yearRange: '-100:+10'							
			});

			$("#fechaVencim"+numero).datepicker({
    			showOn: "button",
    			buttonImage: "images/calendar.png",
    			buttonImageOnly: true,
				changeMonth: true, 
				changeYear: true,
				dateFormat: 'yymmdd',
				yearRange: '-100:+10'							
			});
			
		});
		
	}


function cargarMenus(){

	// Combo Clasificación del Crédito
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.ClasifCredito,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean1) {
			 menuClasCred = opcionesMenuRegBean1;
			});

	//Combo Forma de Adquisición
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.FormaAdquisicion,
						'descripcion': ''
						};

	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean2) {
			menuFormaAdqui = opcionesMenuRegBean2;
			});

	//Combo Tipo de Riesgo
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.TipoRiesgo,
						'descripcion': ''
						};

	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean3) {
			menuGrupoRiesg = opcionesMenuRegBean3;
			});

	//Combo Tipo de Instrumento
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.TipoInstrumento,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean4) {
			menuTipoInstru = opcionesMenuRegBean4;
			});

}


function cargarCombos(id){
	$('#formaAdqui'+id).each(function() {  $('#formaAdqui'+id+' option').remove(); });
	$('#tipoInstru'+id).each(function() {  $('#tipoInstru'+id+' option').remove(); });
	$('#clasfConta'+id).each(function() {  $('#clasfConta'+id+' option').remove(); });
	$('#grupoRiesgo'+id).each(function() { $('#grupoRiesgo'+id+' option').remove(); });
	// se agrega la opcion por default
	$('#formaAdqui'+id).append( new Option('SELECCIONAR', '', true, true));
	$('#tipoInstru'+id).append( new Option('SELECCIONAR', '', true, true));
	$('#clasfConta'+id).append( new Option('SELECCIONAR', '', true, true));
	$('#grupoRiesgo'+id).append( new Option('SELECCIONAR', '', true, true));
		
	for ( var j = enteroCero; j < menuFormaAdqui.length; j++) {										
		$('#formaAdqui'+id).append(new Option(menuFormaAdqui[j].descripcion,menuFormaAdqui[j].codigoOpcion,true,true));
		}

	for ( var j = enteroCero; j < menuTipoInstru.length; j++) {										
		$('#tipoInstru'+id).append(new Option(menuTipoInstru[j].descripcion,menuTipoInstru[j].codigoOpcion,true,true));
		}

	for ( var j = enteroCero; j < menuClasCred.length; j++) {										
		$('#clasfConta'+id).append(new Option(menuClasCred[j].descripcion,menuClasCred[j].codigoOpcion,true,true));
		}

	for ( var j = enteroCero; j < menuGrupoRiesg.length; j++) {										
		$('#grupoRiesgo'+id).append(new Option(menuGrupoRiesg[j].descripcion,menuGrupoRiesg[j].codigoOpcion,true,true));
		}

	$('#formaAdqui'+id).val('').selected = true;
	$('#tipoInstru'+id).val('').selected = true;
	$('#clasfConta'+id).val('').selected = true;
	$('#grupoRiesgo'+id).val('').selected = true;
						
}


function buscaEntidad(input){
	var parametros = ['descripcion','menuID'];
	var opcionMenuReg = [$('#'+input).val(),1];
	lista(input, '2', '1',parametros,opcionMenuReg,'opcionesMenuRegLista.htm');
}
						
		
function consultaEntidad(idControl){
			var jqEntidad = eval("'#" + idControl + "'");
			var numEntidad = $(jqEntidad).val();

			var opcionMenuRegBean = {
					'menuID' 		: catMenuRegulatorio.Instituciones,
					'codigoOpcion' 	: numEntidad
			};
			tipoConEntidad = 3;

			if (!isNaN($(jqEntidad).val()) && esTab == true && $(jqEntidad).val() != '') {
				opcionesMenuRegServicio.consulta(tipoConEntidad,opcionMenuRegBean,function(entidad) {
						if (entidad != null) {
							$('#nombre'+idControl).val(entidad.descripcion);
						} else {
								alert("No Existe la Entidad Financiera.");
								$('#nombre'+idControl).val('');
								$(jqEntidad).focus();
						}
					});
			} 
}


function agregarRegistro(){	
	var numeroFila=consultaFilas();
	
	var nuevaFila = parseInt(numeroFila) + 1;					
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	 	 	  
		if(numeroFila == 0){
			tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID"  size="6"  value="1" autocomplete="off"  type="hidden" />';
			tds += '<input type="text" id="entidad'+nuevaFila+'"  name="lEntidad" size="8" onkeyup="buscaEntidad(this.id)" onblur="consultaEntidad(this.id)" value="" class="display: inline-block" />';	
			tds += '<input type="text" id="nombreentidad'+nuevaFila+'" readonly="" disabled=""  name="nombreentidad" size="30" value="" class="display: inline-block" />	</td>';
			tds += '<td><input type="text" id="emisora'+nuevaFila+'" maxlength="7" onblur=" ponerMayusculas(this);" name="lEmisora" size="10" value=""/></td>';
			tds += '<td><input type="text" id="serie'+nuevaFila+'" maxlength="10" onblur=" ponerMayusculas(this);" name="lSerie" size="10" value=""/></td>';
			tds += '<td><input type="hidden" id="sformaAdqui'+nuevaFila+'"  name="sformaAdqui" size="20" value=""/><select name="lFormaAdqui" id="formaAdqui'+nuevaFila+'" ></select></td>';
			tds += '<td><input type="hidden" id="stipoInstru'+nuevaFila+'"  name="stipoInstru" size="20" value=""/><select name="lTipoInstru" id="tipoInstru'+nuevaFila+'" ></select></td>';
			tds += '<td><input type="hidden" id="sclasfConta'+nuevaFila+'"  name="sclasfConta" size="20" value=""/><select name="lClasfConta" id="clasfConta'+nuevaFila+'" ></select></td>';
			tds += '<td><input type="text" id="fechaContra'+nuevaFila+'" maxlength="8" name="lFechaContra" onblur="esFechaValida(this.value,this.id)" size="12" value="" /></td>';
			tds += '<td><input type="text" id="fechaVencim'+nuevaFila+'" maxlength="8" name="lFechaVencim" onblur="esFechaValida(this.value,this.id)" size="12" value="" /></td>';
			tds += '<td><input type="text" id="numeroTitu'+nuevaFila+'"  maxlength="21" name="lNumeroTitu"  onkeyPress="return validaSoloNumeros(event);" style="text-align:right;" size="20" value=""/></td>';
			tds += '<td><input type="text" id="costoAdqui'+nuevaFila+'"  maxlength="21" name="lCostoAdqui" onkeyPress="return validaSoloNumeros(event);" style="text-align:right;" size="20" value=""/></td>';
			tds += '<td><input type="text" id="tasaInteres'+nuevaFila+'" maxlength="6" name="lTasaInteres" esMoneda="true" style="text-align:right;" onBlur="validarPorcentaje(this.id,this.value)" size="12" value=""/><label class="label">%</label></td>';
			tds += '<td><input type="hidden" id="sgrupoRiesgo'+nuevaFila+'"  name="sgrupoRiesgo" size="10" value=""/><select name="lGrupoRiesgo" id="grupoRiesgo'+nuevaFila+'" ></select></td>';
			tds += '<td><input type="text" id="valuacion'+nuevaFila+'" maxlength="21"  name="lValuacion"  onkeyPress="return validaSoloNumeros(event);" style="text-align:right;" size="21" value=""/></td>';
			tds += '<td><input type="text" id="resValuacion'+nuevaFila+'" maxlength="21"  name="lResValuacion" onkeyPress="return validaSoloNumeros(event);" style="text-align:right;" size="21" value=""/></td>';

		} else{    		
			var valor = numeroFila+ 1;
			tds += '<td><input  id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="'+valor+'" autocomplete="off"  type="hidden"/>';
			tds += '<input type="text" id="entidad'+nuevaFila+'"  name="lEntidad" size="8" onkeyup="buscaEntidad(this.id)" onblur="consultaEntidad(this.id)" value="" class="display: inline-block" />';	
			tds += '<input type="text" id="nombreentidad'+nuevaFila+'" readonly="" disabled=""  name="nombreentidad" size="30" value="" class="display: inline-block" />	</td>';
			tds += '<td><input type="text" id="emisora'+nuevaFila+'" maxlength="7" onblur=" ponerMayusculas(this);" name="lEmisora" size="10" value=""/></td>';
			tds += '<td><input type="text" id="serie'+nuevaFila+'" maxlength="10" onblur=" ponerMayusculas(this);" name="lSerie" size="10" value=""/></td>';
			tds += '<td><input type="hidden" id="sformaAdqui'+nuevaFila+'"  name="sformaAdqui" size="20" value=""/><select name="lFormaAdqui" id="formaAdqui'+nuevaFila+'" ></select></td>';
			tds += '<td><input type="hidden" id="stipoInstru'+nuevaFila+'"  name="stipoInstru" size="20" value=""/><select name="lTipoInstru" id="tipoInstru'+nuevaFila+'" ></select></td>';
			tds += '<td><input type="hidden" id="sclasfConta'+nuevaFila+'"  name="sclasfConta" size="20" value=""/><select name="lClasfConta" id="clasfConta'+nuevaFila+'" ></select></td>';
			tds += '<td><input type="text" id="fechaContra'+nuevaFila+'" maxlength="8" name="lFechaContra" onblur="esFechaValida(this.value,this.id)" size="12" value="" /></td>';
			tds += '<td><input type="text" id="fechaVencim'+nuevaFila+'" maxlength="8" name="lFechaVencim" onblur="esFechaValida(this.value,this.id)" size="12" value="" /></td>';
			tds += '<td><input type="text" id="numeroTitu'+nuevaFila+'"  maxlength="21" name="lNumeroTitu" onkeyPress="return validaSoloNumeros(event);" style="text-align:right;" size="20" value=""/></td>';
			tds += '<td><input type="text" id="costoAdqui'+nuevaFila+'"  maxlength="21" name="lCostoAdqui" onkeyPress="return validaSoloNumeros(event);" style="text-align:right;" size="20" value=""/></td>';
			tds += '<td><input type="text" id="tasaInteres'+nuevaFila+'" maxlength="6" name="lTasaInteres" esMoneda="true" style="text-align:right;" onBlur="validarPorcentaje(this.id,this.value)" size="12" value=""/><label class="label">%</label></td>';
			tds += '<td><input type="hidden" id="sgrupoRiesgo'+nuevaFila+'"  name="sgrupoRiesgo" size="10" value=""/><select name="lGrupoRiesgo" id="grupoRiesgo'+nuevaFila+'" ></select></td>';
			tds += '<td><input type="text" id="valuacion'+nuevaFila+'" maxlength="21"  name="lValuacion"  onkeyPress="return validaSoloNumeros(event);" style="text-align:right;" size="21" value=""/></td>';
			tds += '<td><input type="text" id="resValuacion'+nuevaFila+'" maxlength="21"  name="lResValuacion" onkeyPress="return validaSoloNumeros(event);" style="text-align:right;" size="21" value=""/></td>';

		}
		tds += '<td ><input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarRegistro(this.id)"/>';
		tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregarRegistro()"/></td>';
		tds += '</tr>';	   	   
		
		$("#miTabla").append(tds);
		cargarCombos(nuevaFila);
		iniciarDatePikers();
		
		// Asignamos el foco al campo entidad
		$('#entidad'+nuevaFila).focus();
		
		habilitaBoton('grabar');
		deshabilitaBoton('generar');
		
		agregaFormatoControles('formaGenerica');
		

		return false;		
	}


	
//consulta cuantas filas tiene el grid de documentos
function consultaFilas(){
	var totales=enteroCero;
	$('tr[name=renglon]').each(function() {
		totales++;		
	});
	return totales;
}

function verificaSeleccionado(idCampo){
	var nuevaFrecuencia=$('#'+idCampo).val();
	
	$('tr[name=renglon]').each(function() {
		var numero= this.id.substr(7,this.id.length);
		var jqIdFrecuencias = eval("'frecuencia" + numero+ "'");
		var valorFrecuencias=$('#'+jqIdFrecuencias).val();
		if(jqIdFrecuencias != idCampo){
			if(valorFrecuencias == nuevaFrecuencia){
				alert("La Frecuencia se repite para el Producto de Crédito indicado ");
				$('#'+idCampo).focus();
			}
		}
	});
	
}
	
function eliminarRegistro(control){	
	var contador = enteroCero ;
	var numeroID = control;
	
	var jqRenglon 		= eval("'#renglon" + numeroID + "'");
	var jqNumero 		= eval("'#consecutivoID" + numeroID + "'");
	var jqFrecuencias 	= eval("'#frecuencias" + numeroID + "'");		
	var jqFrecuencia 	= eval("'#frecuencia" + numeroID + "'");
	var jqDiasPaso 		= eval("'#diasPasoVencido" + numeroID + "'");
	var jqAgrega 		= eval("'#agrega" + numeroID + "'");
	var jqElimina 		= eval("'#" + numeroID + "'");

	// se elimina la fila seleccionada
	$(jqNumero).remove();
	$(jqFrecuencias).remove();
	$(jqFrecuencia).remove();
	$(jqElimina).remove();
	$(jqDiasPaso).remove();
	$(jqAgrega).remove();
	$(jqRenglon).remove();
	//$(jqAgrega).remove();

	//Reordenamiento de Controles
	contador = 1;
	var numero= enteroCero;
	$('tr[name=renglon]').each(function() {		
		numero= this.id.substr(7,this.id.length);
		var jqRenglon1 		= eval("'#renglon"+numero+"'");
		var jqNumero1 		= eval("'#consecutivoID"+numero+"'");
		var jqFrecuencias1  = eval("'#frecuencias"+numero+"'");		
		var jqFrecuencia1 	= eval("'#frecuencia"+numero+"'");
		var jqDiasPaso1		=eval("'#diasPasoVencido"+ numero+"'");
		var jqAgrega1 		=eval("'#agrega"+ numero+"'");
		var jqElimina1 		= eval("'#"+numero+ "'");
	
		$(jqNumero1).attr('id','consecutivoID'+contador);
		$(jqFrecuencias1).attr('id','frecuencias'+contador);
		$(jqFrecuencia1).attr('id','frecuencia'+contador);
		$(jqDiasPaso1).attr('id','diasPasoVencido'+contador);
		$(jqAgrega1).attr('id','agrega'+contador);
		$(jqElimina1).attr('id',contador);
		$(jqRenglon1).attr('id','renglon'+ contador);
		contador = parseInt(contador + 1);	
		
	});

	deshabilitaBoton('generar');
	
}




function Validador(e) {
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46) {

		if (key==8|| key == 46)	{ 
			return true;
		}
		else
			alert("sólo números");
		return false;
	}
}


// -- FUNCIONES ---------------------- 

function llenaComboAnios(fechaActual){
	   var anioActual 	= fechaActual.substring(0, 4);
	   var mesActual 	= parseInt(fechaActual.substring(5, 7));
	   var numOption 	= 4;
	  
	   for(var i=0; i<numOption; i++){
		   $("#anio").append('<option value="'+anioActual+'">' + anioActual + '</option>');
		   anioActual = parseInt(anioActual) - 1;
	   }
	   
	   $("#mes option[value="+ mesActual +"]").attr("selected",true);
}


$('#mes').change(function (){
	   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
	   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
	   var anioSeleccionado = $('#anio').val();
	   
	   if((parseInt(this.value) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
		   alert("El Mes Indicado es Mayor al Mes Actual del Sistema.");
		   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
		   consultaRegistroRegulatorioI0391();
		   this.focus();
	   }else{
		   consultaRegistroRegulatorioI0391();
	   }
});

$('#anio').change(function (){
	   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
	   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
	   var anioSeleccionado = $('#anio').val();
	   var mesSeleccionado 	= $('#mes').val();
	   
	   if((parseInt(mesSeleccionado) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
		   alert("El Año Indicado es Incorrecto.");
		   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
		   consultaRegistroRegulatorioI0391();
		   this.focus();
	   }else{
		   consultaRegistroRegulatorioI0391();
	   }
});


function consultaRegistroRegulatorioI0391(){	
	var anio 	= $('#anio').val();
	var mes  	= $('#mes').val();
	var params 	= {};
	params['tipoLista'] = 1;
	params['anio'] 		= anio;
	params['mes']		= mes;
	
	$.post("regulatorioI0391GridVista.htm", params, function(data){
		if(data.length >enteroCero) {
			$('#divRegulatorioI0391').html(data);
			$('#fieldsetDiasPasoVencido').show();
			$('#divRegulatorioI0391').show();
			
			if(consultaFilas() > enteroCero){
				habilitaBoton('grabar');
				habilitaBoton('generar');
			}else{
				deshabilitaBoton('grabar');
				deshabilitaBoton('generar');
			}

			iniciarDatePikers();

			// Intervalo que valida los objetos que contienen las opciones para los combos
			var cargando = setInterval(function(){
				if(menuClasCred.length > enteroCero & menuFormaAdqui.length > enteroCero 
				    & menuGrupoRiesg.length > enteroCero & menuTipoInstru.length > enteroCero ){

						for (var i = 1; i <= consultaFilas(); i++) {
							cargarCombos(i);
							seleccionaOpcionMenuReg();
						}
					
				 clearInterval(cargando);

				}

			},100);
	
			agregaFormatoControles('formaGenerica');			
			
			$('#generar').click(function(){

					  	 		if($('#excel').is(':checked')){
									if(consultaFilas()>enteroCero ){
										generaReporte(catRegulatorioI0391.Excel);
									}
								}
								if($('#csv').is(':checked')){
									if(consultaFilas()>enteroCero){
										generaReporte(catRegulatorioI0391.Csv);
									}
								}		

				});

		}else{				
			$('#divRegulatorioI0391').html("");
			$('#fieldsetDiasPasoVencido').hide();
			$('#divRegulatorioI0391').hide(); 
		}
	});


}


function validarPorcentaje(controlID, valor){
	var numero= controlID.substr(10,controlID.length);

	if(isNaN(parseFloat(valor))){
		$("#"+controlID).focus();
		$("#"+controlID).val('0.00');
	}else{
		if(valor.length > 6){
			alert("Máximo 3 dígitos y 2 decimales");
			$("#"+controlID).focus();
			$("#"+controlID).val('0.00');
		}		
	}
}

function generaReporte(tipoReporte){
		   var anio = $('#anio').val();
		   var mes = $('#mes').val();
		   var url='';

		   url = 'reporteRegulatorioI0391.htm?tipoReporte=' + tipoReporte + '&anio='+anio+ '&mes=' + mes;
		   window.open(url);
		   
	   };


function validaSoloNumeros(e) {
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57 || key == 46) {

		if (key==8|| key == 46)	{ 
			return true;
		}
		else
			alert("sólo números");
		return false;
	}
}


// --------------- funcion para validar la fecha --------------------------
function esFechaValida(fecha,idfecha) {
	if (fecha != undefined && fecha != "") {
		
		var mes = fecha.substring(4, 6) * 1;
		var dia = fecha.substring(6, 8) * 1;
		var anio = fecha.substring(0, 4) * 1;

		switch (mes) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			numDias = 31;
			break;
		case 4:
		case 6:
		case 9:
		case 11:
			numDias = 30;
			break;
		case 2:
			if (comprobarSiBisisesto(anio)) {
				numDias = 29;
			} else {
				numDias = 28;
			}
			;
			break;
		default:
			alert("Fecha Introducida es Errónea.");
			$('#'+idfecha).val('');
			$('#'+idfecha).focus();
		return false;
		}
		if (dia > numDias || dia == 0) {
			alert("Fecha Introducida es Errónea.");
			$('#'+idfecha).val('');
			$('#'+idfecha).focus();
			return false;
		}
		return true;
	}
}

function comprobarSiBisisesto(anio) {
	if ((anio % 100 != enteroCero) && ((anio % 4 == enteroCero) || (anio % 400 == enteroCero))) {
		return true;
	} else {
		return false;
	}
}