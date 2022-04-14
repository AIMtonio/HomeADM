var opcionMenuRegBean ;
var menuDesCredito		    = {};
var menuPeriodicidad 		= {};
var menuPlazo		 		= {};
var menuTipoCredito			= {};
var menuTipoGaran		    = {};
var menuTipoPres			= {};
var esTab				= true;
var enteroCero          = 0;
var catRegulatorioD0842 = { 
			'Excel'			: 2,		
			'Csv'			: 3,		
		};

var lisMenuRegulatorio = { 
			'Busqueda'		: 1,		
			'Combo'			: 2,		
		};

var catMenuRegulatorio = { 
			'DestinoCredito'		: 10,		
			'Periodicidad'			: 11,		
			'PlazoCortLarg'		    : 12,		
			'TipoCredito'			: 13,		
			'TipoGarantia'		    : 14,
			'TipoPrestamista'		: 15,
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
	    	if(validarRegistro())
    	{
    		grabaFormaTransaccion(event, 'formaGenerica', 'contenedorForma', 'mensaje','false','fecha');
				//Si la respuesta es éxitosa se habilita el botón generar	
    	setTimeout(function(){
	  	   	var resultado = $('#numeroMensaje').val();
	  	   	 
			if(resultado == enteroCero){
			 	habilitaBoton('generar');
			}

  	   },500);		  	    
     
    }
    else
    {
    	return false;   	
     
  	
  	  
    }
  	  
  	   	 

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
	
	consultaRegistroRegulatorioD0842();

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
			var jsDestinoCredito = eval("'sdestino" + numero+ "'");	
			var jsPeriodicidad   = eval("'speriodoPago" + numero+ "'");	
			var jsPlazoCortLarg  = eval("'sclasificaCortLarg" + numero+ "'");	
			var jsTipoCredito    = eval("'stipoCredito" + numero+ "'");	
			var jsTipoGarantia   = eval("'stipoGarantia" + numero+ "'");
			var jsTipoPrestamista= eval("'stipoPrestamista" + numero+ "'");


			var valorDestinoCredito= document.getElementById(jsDestinoCredito).value;	
			var valorPeriodicidad= document.getElementById(jsPeriodicidad).value;	
			var valorPlazoCortLarg= document.getElementById(jsPlazoCortLarg).value;	
			var valorTipoCredito= document.getElementById(jsTipoCredito).value;	
			var valorTipoGarantia= document.getElementById(jsTipoGarantia).value;	
			var valorTipoPrestamista= document.getElementById(jsTipoPrestamista).value;


			$('#destino'+numero+' option[value='+ valorDestinoCredito +']').attr('selected','true');	
			$('#periodoPago'+numero+' option[value='+ valorPeriodicidad +']').attr('selected','true');	
			$('#clasificaCortLarg'+numero+' option[value='+ valorPlazoCortLarg +']').attr('selected','true');	
			$('#tipoCredito'+numero+' option[value='+ valorTipoCredito +']').attr('selected','true');
			$('#tipoGarantia'+numero+' option[value='+ valorTipoGarantia +']').attr('selected','true');
			$('#tipoPrestamista'+numero+' option[value='+ valorTipoPrestamista +']').attr('selected','true');

			esTab = true;
			
		});
		
	}

	function iniciarDatePikers(){	
		$('tr[name=renglon]').each(function() {
			var numero= this.id.substr(7,this.id.length);

			$("#fechaContra"+numero).datepicker({
				 
			    defaultDate: parametroBean.fechaSucursal,
    			showOn: "button",
    			buttonImage: "images/calendar.png",
    			buttonImageOnly: true,
				changeMonth: true, 
				changeYear: true,
				dateFormat: 'yy-mm-dd',
				yearRange: '-100:+10',						
			});

			$("#fechaVencim"+numero).datepicker({
				defaultDate: parametroBean.fechaSucursal,
    			showOn: "button",
    			buttonImage: "images/calendar.png",
    			buttonImageOnly: true,
				changeMonth: true, 
				changeYear: true,
				dateFormat: 'yy-mm-dd',
				yearRange: '-100:+10'							
			});
			
			$("#fechaPago"+numero).datepicker({
				defaultDate: parametroBean.fechaSucursal,
    			showOn: "button",
    			buttonImage: "images/calendar.png",
    			buttonImageOnly: true,
				changeMonth: true, 
				changeYear: true,
				dateFormat: 'yy-mm-dd',
				yearRange: '-100:+10'							
			});
			
		});
		
	}


function cargarMenus(){

	// Combo Destino del Crédito
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.DestinoCredito,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean10) {
		    menuDesCredito = opcionesMenuRegBean10;
			});

	//Combo la Periodicidad del Crédito
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.Periodicidad,
						'descripcion': ''
						};

	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean11) {
	    	menuPeriodicidad = opcionesMenuRegBean11;
			});

	//Combo Tipo de Plazo
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.PlazoCortLarg,
						'descripcion': ''
						};

	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean12) {
		      menuPlazo = opcionesMenuRegBean12;
			});

	//Combo Tipo de Crédito
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.TipoCredito,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean13) {
		       menuTipoCredito = opcionesMenuRegBean13;
			});
	//Combo Tipo de Garantía
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.TipoGarantia,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean14) {
		     menuTipoGaran = opcionesMenuRegBean14;
			});
	//Combo Tipo de Prestamista
	opcionMenuRegBean = {
						'menuID' : catMenuRegulatorio.TipoPrestamista,
						'descripcion': ''
						};
	opcionesMenuRegServicio.listaCombo(lisMenuRegulatorio.Combo,opcionMenuRegBean,function(opcionesMenuRegBean15) {
		     menuTipoPres = opcionesMenuRegBean15;
			});

}


function cargarCombos(id){
	$('#destino'+id).each(function() {  $('#destino'+id+' option').remove(); });
	$('#periodoPago'+id).each(function() {  $('#periodoPago'+id+' option').remove(); });
	$('#clasificaCortLarg'+id).each(function() {  $('#clasificaCortLarg'+id+' option').remove(); });
	$('#tipoCredito'+id).each(function() { $('#tipoCredito'+id+' option').remove(); });
	$('#tipoGarantia'+id).each(function() {  $('#tipoGarantia'+id+' option').remove(); });
	$('#tipoPrestamista'+id).each(function() { $('#tipoPrestamista'+id+' option').remove(); });
	// se agrega la opcion por default
	$('#destino'+id).append( new Option('SELECCIONAR', '', true, true));
	$('#periodoPago'+id).append( new Option('SELECCIONAR', '', true, true));
	$('#clasificaCortLarg'+id).append( new Option('SELECCIONAR', '', true, true));
	$('#tipoCredito'+id).append( new Option('SELECCIONAR', '', true, true));
	$('#tipoGarantia'+id).append( new Option('SELECCIONAR', '', true, true));
	$('#tipoPrestamista'+id).append( new Option('SELECCIONAR', '', true, true));
		
	for ( var j = enteroCero; j < menuDesCredito.length; j++) {										
		$('#destino'+id).append(new Option(menuDesCredito[j].descripcion,menuDesCredito[j].codigoOpcion,true,true));
		}

	for ( var j = enteroCero; j < menuPeriodicidad.length; j++) {										
		$('#periodoPago'+id).append(new Option(menuPeriodicidad[j].descripcion,menuPeriodicidad[j].codigoOpcion,true,true));
		}

	for ( var j = enteroCero; j < menuPlazo.length; j++) {										
		$('#clasificaCortLarg'+id).append(new Option(menuPlazo[j].descripcion,menuPlazo[j].codigoOpcion,true,true));
		}

	for ( var j = enteroCero; j <menuTipoCredito.length; j++) {										
		$('#tipoCredito'+id).append(new Option(menuTipoCredito[j].descripcion,menuTipoCredito[j].codigoOpcion,true,true));
		}
	for ( var j = enteroCero; j <menuTipoGaran.length; j++) {										
		$('#tipoGarantia'+id).append(new Option(menuTipoGaran[j].descripcion,menuTipoGaran[j].codigoOpcion,true,true));
		}
	for ( var j = enteroCero; j <menuTipoPres.length; j++) {										
		$('#tipoPrestamista'+id).append(new Option(menuTipoPres[j].descripcion,menuTipoPres[j].codigoOpcion,true,true));
		}

	$('#destino'+id).val('').selected = true;
	$('#periodoPago'+id).val('').selected = true;
	$('#clasificaCortLarg'+id).val('').selected = true;
	$('#tipoCredito'+id).val('').selected = true;
	$('#tipoGarantia'+id).val('').selected = true;
	$('#tipoPrestamista'+id).val('').selected = true;
						
}


function agregarRegistro(){	
	var numeroFila=consultaFilas();
	
	var nuevaFila = parseInt(numeroFila) + 1;					
	var tds = '<tr id="renglon' + nuevaFila + '" name="renglon">';
	 	 	  
		if(numeroFila == 0){
			tds += '<td><input type="hidden" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="'+valor+'" autocomplete="off" type="hidden"/>';	
			tds += '<input type="text" id="numeroIden'+nuevaFila+'" maxlength="12"  name="lnumeroIden"   size="12" value="" onkeyPress="soloLetrasYNum(this,this.id)"   onblur="ponerMayusculas(this);"/></td>';
			tds += '<td><input type="hidden" id="stipoPrestamista'+nuevaFila+'"  name="stipoPrestamista" size="20" value="" /><select name="ltipoPrestamista" id="tipoPrestamista'+nuevaFila+'" onblur="validaCampoSelect(this,this.id)" ></select></td>';
			tds += '<td><input type="text" id="clavePrestamista'+nuevaFila+'" maxlength="25"  name="lclavePrestamista"  size="15" onkeyup="buscaEntidad(this.id)"  value=""/></td>';
			tds += '<td><input type="text" id="numeroContrato'+nuevaFila+'" maxlength="12"  name="lnumeroContrato"   onkeyPress="soloLetrasYNum(this,this.id)" onblur="ponerMayusculas(this);" size="15" value=""/></td>';
			tds += '<td><input type="text" id="numeroCuenta'+nuevaFila+'" maxlength="12"  name="lnumeroCuenta"   onkeyPress="soloLetrasYNum(this,this.id)" onblur="ponerMayusculas(this);" size="15" value=""/></td>';
			tds += '<td><input type="text" id="fechaContra'+nuevaFila+'" maxlength="10" name="lfechaContra" onblur="esFechaValida(this.value,this.id)" size="12" value="" /></td>';
			tds += '<td><input type="text" id="fechaVencim'+nuevaFila+'" maxlength="10" name="lfechaVencim" onblur="esFechaValida(this.value,this.id)" size="12" value="" /></td>';
			tds += '<td><input type="text" id="tasaAnual'+nuevaFila+'" maxlength="7" path="ltasaAnual" name="ltasaAnual" style="text-align:right;" onblur="validarTasa(this.id,this.value),soloCantidad(this,this.id)" size="12" value=""/><label class="label">%</label></td>';
			tds += '<td><input type="text" id="plazo'+nuevaFila+'" maxlength="4" name="lplazo" onkeyPress="soloNum(this,this.id)" size="10" style="text-align:right;" value=""/></td>';
			tds += '<td><input type="hidden" id="speriodoPago'+nuevaFila+'"  name="speriodoPago" size="20" value=""/><select name="lperiodoPago" id="periodoPago'+nuevaFila+'" onblur="validaCampoSelect1(this,this.id)"></select></td>';
			tds += '<td><label class="label">$</label><input type="text" id="montoRecibido'+nuevaFila+'" maxlength="28" onblur="soloCantidad(this,this.id)" name="lmontoRecibido"  size="20" esMoneda="true" style="text-align:right;" value=""/></td>';
			tds += '<td><input type="hidden" id="stipoCredito'+nuevaFila+'"  name="stipoCredito" size="20" value=""/><select name="ltipoCredito" id="tipoCredito'+nuevaFila+'" onblur="validaCampoSelect2(this,this.id)"></select></td>';
			tds += '<td><input type="hidden" id="sdestino'+nuevaFila+'"  name="sdestino" size="20" value=""/><select name="ldestino" id="destino'+nuevaFila+'" onblur="validaCampoSelect3(this,this.id)"></select></td>';
			tds += '<td><input type="hidden" id="stipoGarantia'+nuevaFila+'"  name="stipoGarantia" size="20" value=""/><select name="ltipoGarantia" id="tipoGarantia'+nuevaFila+'"onblur="validaCampoSelect4(this,this.id)" ></select></td>';
			tds += '<td><label class="label">$</label><input type="text" id="montoGarantia'+nuevaFila+'" maxlength="28" name="lmontoGarantia" size="20" onblur="soloCantidad(this,this.id)" esMoneda="true" style="text-align:right;" value=""/></td>';
			tds += '<td><input type="text" id="fechaPago'+nuevaFila+'"  maxlength="10" name="lfechaPago" size="12" onblur="esFechaValida(this.value,this.id)" value="" /></td>';
			tds += '<td><label class="label">$</label><input type="text" id="montoPago'+nuevaFila+'" maxlength="28" name="lmontoPago" onblur="soloCantidad(this,this.id)" esMoneda="true" size="20" style="text-align:right;" value=""/></td>';
			tds += '<td><input type="hidden" id="sclasificaCortLarg'+nuevaFila+'"  name="sclasificaCortLarg" size="20" value=""/><select name="lclasificaCortLarg" id="clasificaCortLarg'+nuevaFila+'" onblur="validaCampoSelect5(this,this.id)"></select></td>';
			tds += '<td><input type="text" id="salInsoluto'+nuevaFila+'" maxlength="28" name="lsalInsoluto" size="20" onblur="soloCantidad(this,this.id)" esMoneda="true" style="text-align:right;" value=""/></td>';
			
		} else{    		
			var valor = numeroFila+ 1;
			tds += '<td><input type="hidden" id="consecutivoID'+nuevaFila+'" name="consecutivoID" size="6" value="'+valor+'" autocomplete="off" type="hidden"/>';	
			tds += '<input type="text" id="numeroIden'+nuevaFila+'" maxlength="12"  name="lnumeroIden"   size="12" value="" onkeyPress="soloLetrasYNum(this,this.id)"   onblur="ponerMayusculas(this);"/></td>';
			tds += '<td><input type="hidden" id="stipoPrestamista'+nuevaFila+'"  name="stipoPrestamista" size="20" value="" /><select name="ltipoPrestamista" id="tipoPrestamista'+nuevaFila+'" onblur="validaCampoSelect(this,this.id)" ></select></td>';
			tds += '<td><input type="text" id="clavePrestamista'+nuevaFila+'" maxlength="25"  name="lclavePrestamista"  size="15" onkeyup="buscaEntidad(this.id)"  value=""/></td>';
			tds += '<td><input type="text" id="numeroContrato'+nuevaFila+'" maxlength="12"  name="lnumeroContrato"   onkeyPress="soloLetrasYNum(this,this.id)" onblur="ponerMayusculas(this);" size="15" value=""/></td>';
			tds += '<td><input type="text" id="numeroCuenta'+nuevaFila+'" maxlength="12"  name="lnumeroCuenta"   onkeyPress="soloLetrasYNum(this,this.id)" onblur="ponerMayusculas(this);" size="15" value=""/></td>';
			tds += '<td><input type="text" id="fechaContra'+nuevaFila+'" maxlength="10" name="lfechaContra" onblur="esFechaValida(this.value,this.id)" size="12" value="" /></td>';
			tds += '<td><input type="text" id="fechaVencim'+nuevaFila+'" maxlength="10" name="lfechaVencim" onblur="esFechaValida(this.value,this.id)" size="12" value="" /></td>';
			tds += '<td><input type="text" id="tasaAnual'+nuevaFila+'" maxlength="7" path="ltasaAnual" name="ltasaAnual" style="text-align:right;" onblur="validarTasa(this.id,this.value),soloCantidad(this,this.id)" size="12" value=""/><label class="label">%</label></td>';
			tds += '<td><input type="text" id="plazo'+nuevaFila+'" maxlength="4" name="lplazo" onkeyPress="soloNum(this,this.id)" size="10" style="text-align:right;" value=""/></td>';
			tds += '<td><input type="hidden" id="speriodoPago'+nuevaFila+'"  name="speriodoPago" size="20" value=""/><select name="lperiodoPago" id="periodoPago'+nuevaFila+'" onblur="validaCampoSelect1(this,this.id)"></select></td>';
			tds += '<td><label class="label">$</label><input type="text" id="montoRecibido'+nuevaFila+'" maxlength="28" onblur="soloCantidad(this,this.id)" name="lmontoRecibido"  size="20" esMoneda="true" style="text-align:right;" value=""/></td>';
			tds += '<td><input type="hidden" id="stipoCredito'+nuevaFila+'"  name="stipoCredito" size="20" value=""/><select name="ltipoCredito" id="tipoCredito'+nuevaFila+'" onblur="validaCampoSelect2(this,this.id)"></select></td>';
			tds += '<td><input type="hidden" id="sdestino'+nuevaFila+'"  name="sdestino" size="20" value=""/><select name="ldestino" id="destino'+nuevaFila+'" onblur="validaCampoSelect3(this,this.id)"></select></td>';
			tds += '<td><input type="hidden" id="stipoGarantia'+nuevaFila+'"  name="stipoGarantia" size="20" value=""/><select name="ltipoGarantia" id="tipoGarantia'+nuevaFila+'"onblur="validaCampoSelect4(this,this.id)" ></select></td>';
			tds += '<td><label class="label">$</label><input type="text" id="montoGarantia'+nuevaFila+'" maxlength="28" name="lmontoGarantia" size="20" onblur="soloCantidad(this,this.id)" esMoneda="true" style="text-align:right;" value=""/></td>';
			tds += '<td><input type="text" id="fechaPago'+nuevaFila+'"  maxlength="10" name="lfechaPago" size="12" onblur="esFechaValida(this.value,this.id)" value="" /></td>';
			tds += '<td><label class="label">$</label><input type="text" id="montoPago'+nuevaFila+'" maxlength="28" name="lmontoPago" onblur="soloCantidad(this,this.id)" esMoneda="true" size="20" style="text-align:right;" value=""/></td>';
			tds += '<td><input type="hidden" id="sclasificaCortLarg'+nuevaFila+'"  name="sclasificaCortLarg" size="20" value=""/><select name="lclasificaCortLarg" id="clasificaCortLarg'+nuevaFila+'" onblur="validaCampoSelect5(this,this.id)"></select></td>';
			tds += '<td><input type="text" id="salInsoluto'+nuevaFila+'" maxlength="28" name="lsalInsoluto" size="20" onblur="soloCantidad(this,this.id)" esMoneda="true" style="text-align:right;" value=""/></td>';
		}
		   tds += '<td ><input type="button" name="eliminar" id="'+nuevaFila +'" value="" class="btnElimina" onclick="eliminarRegistro(this.id)"/>';
		   tds += '<input type="button" name="agrega" id="agrega'+nuevaFila +'" value="" class="btnAgrega" onclick="agregarRegistro()"/></td>';
		   tds += '</tr>';	   	   
		
		$("#miTabla").append(tds);
		cargarCombos(nuevaFila);
		iniciarDatePikers();
		
		// Asignamos el foco al campo entidad
		$('#numeroIden'+nuevaFila).focus();

		$('#fechaContra'+nuevaFila).change(function(){
		this.focus();
		});
		
		$("#fechaVencim"+nuevaFila).change(function(){
			this.focus();
		});
		$("#fechaPago"+nuevaFila).change(function(){
				this.focus();
			});
		
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
		   mensajeSis("El Mes Indicado es Mayor al Mes Actual del Sistema.");
		   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
		   consultaRegistroRegulatorioD0842();
		   this.focus();
	   }else{
		   consultaRegistroRegulatorioD0842();
	   }
});

$('#anio').change(function (){
	   var mesSistema = parseInt(parametroBean.fechaAplicacion.substring(5, 7));
	   var anioActual = parametroBean.fechaAplicacion.substring(0, 4);	
	   var anioSeleccionado = $('#anio').val();
	   var mesSeleccionado 	= $('#mes').val();
	   
	   if((parseInt(mesSeleccionado) > parseInt(mesSistema)) && parseInt(anioSeleccionado) >= parseInt(anioActual)){
		   mensajeSis("El Año Indicado es Incorrecto.");
		   $("#mes option[value="+ mesSistema +"]").attr("selected",true);
		   consultaRegistroRegulatorioD0842();
		   this.focus();
	   }else{
		   consultaRegistroRegulatorioD0842();
	   }
});


function consultaRegistroRegulatorioD0842(){	
	var anio 	= $('#anio').val();
	var mes  	= $('#mes').val();
	var params 	= {};
	params['tipoLista'] = 1;
	params['anio'] 		= anio;
	params['mes']		= mes;
	
	$.post("regulatorioD0842GridVista.htm", params, function(data){
		if(data.length >enteroCero) {
			$('#divRegulatorioD0842').html(data);
			$('#fieldsetDiasPasoVencido').show();
			$('#divRegulatorioD0842').show();
			
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
				if(menuDesCredito.length > enteroCero & menuPeriodicidad.length > enteroCero 
				    & menuPlazo.length > enteroCero & menuTipoCredito.length > 
				    enteroCero  & menuTipoGaran.length > enteroCero & menuTipoPres.length > enteroCero){

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
										generaReporte(catRegulatorioD0842.Excel);
									}
								}
								if($('#csv').is(':checked')){
									if(consultaFilas()>enteroCero){
										generaReporte(catRegulatorioD0842.Csv);
									}
								}		
				});

		}else{				
			$('#divRegulatorioD0842').html("");
			$('#fieldsetDiasPasoVencido').hide();
			$('#divRegulatorioD0842').hide(); 
		}
	});
}


function buscaEntidad(input){
	var parametros = ['descripcion','menuID'];
	var opcionMenuReg = [$('#'+input).val(),1];
	lista(input, '2', '1',parametros,opcionMenuReg,'opcionesMenuRegLista.htm');
}

function validarTasa(controlID, valor){
	
	if(isNaN(parseFloat(valor))){
		mensajeSis("Solo Números");
		$("#"+controlID).focus();
		$("#"+controlID).val('0.00');
	}else{
   			var tasa = valor.indexOf('.');
			for (var i=0; i<tasa; i++) {
				 var entero= i;   
   			 }for (var x=tasa; x<valor.length; x++) {
				var decimal= x;   
   			 	} 	                                                   
			if (tasa < 0) { 
				var tasaEntero=valor.length;
				}             
			if(i>4 && x>2 || tasaEntero >4){
			mensajeSis("Máximo 4 enteros y 2 decimales");
			$("#"+controlID).focus();
			$("#"+controlID).val('0.00');
			}				
	}
}

function generaReporte(tipoReporte){
		   var anio = $('#anio').val();
		   var mes = $('#mes').val();
		   var url='';

		   url = 'reporteRegulatorioD0842.htm?tipoReporte=' + tipoReporte + '&anio='+anio+ '&mes=' + mes;
		   window.open(url);
		   
	   };


function soloNum(campo,idcampo){
	
	if (!/^([0-9])*$/.test(campo.value)){
    	mensajeSis("Solo Números");
   	    $('#'+idcampo).focus();
  	    $('#'+idcampo).val('');
    }   
  }

function soloLetrasYNum(campo,idcampo){
	
	 if (!/^([a-zA-Z0-9])*$/.test(campo.value)){
    	mensajeSis("Solo caracteres alfanuméricos");
   	    $('#'+idcampo).focus();
  	    $('#'+idcampo).val('');
    }
   
      
  }
  function soloCantidad(campo,idcampo){
  	var re = /,/g;
  	var cantidad= campo.value;
  	var nuevacantidad = cantidad.replace(re, '');
  	
  	if (!/^[0-9]*(\.[0-9]+)?$/.test(nuevacantidad)){
    	mensajeSis("Solo  Números");
   	    $('#'+idcampo).focus();
  	    $('#'+idcampo).val('0.0');
    }  
  }

   function validaCampoSelect(campo,idcampo){
	 if(campo.value=='')
	    {
	    	mensajeSis("Seleccione un Tipo de Prestamista");
	   	    $('#'+idcampo).focus();
	  	    $('#'+idcampo).val('');
	    }
    }
    function validaCampoSelect1(campo,idcampo){
 
	 if(campo.value=='')
	    {
	    	mensajeSis("Seleccione una Periodicidad del Plan de Pagos Acordado");
	   	    $('#'+idcampo).focus();
	  	    $('#'+idcampo).val('');
	    }
    }
   function validaCampoSelect2(campo,idcampo){
	 if(campo.value=='')
	    {
	    	mensajeSis("Seleccione un Tipo de Crédito");
	   	    $('#'+idcampo).focus();
	  	    $('#'+idcampo).val('');
	    }
    }
    function validaCampoSelect3(campo,idcampo){
	 if(campo.value=='')
	    {
	    	mensajeSis("Seleccione un Destino de Crédito");
	   	    $('#'+idcampo).focus();
	  	    $('#'+idcampo).val('');
	    }
    }
     function validaCampoSelect4(campo,idcampo){
	 if(campo.value=='')
	    {
	    	mensajeSis("Seleccione un Tipo de Garantía");
	   	    $('#'+idcampo).focus();
	  	    $('#'+idcampo).val('');
	    }
    }
     function validaCampoSelect5(campo,idcampo){
	 if(campo.value=='')
	    {
	    	mensajeSis("Seleccione una Clasificación de Plazo");
	   	    $('#'+idcampo).focus();
	  	    $('#'+idcampo).val('');
	    }
    }
// --------------- funcion para validar la fecha --------------------------
function esFechaValida(fecha,idfecha) {
	if (fecha != undefined && fecha != "") {
		
		var mes = fecha.substring(5, 7) * 1;
		var dia = fecha.substring(8, 10) * 1;
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
			mensajeSis("Formato de Fecha no Valido (aaaa-mm-dd)");
			$('#'+idfecha).val('');
			$('#'+idfecha).focus();
		return false;
		}
		if (dia > numDias || dia == 0) {
			mensajeSis("Formato de Fecha no Valido (aaaa-mm-dd)");
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
 
function validarRegistro(){		
	
    var respuesta = true;
	$('tr[name=renglon]').each(function() {	
		var idCampo = 'numeroIden';
		var mensaje = "El Número de Identificación está vacío";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}	
		var idCampo = 'tipoPrestamista';
		var mensaje = "El Tipo de Prestamista está vacío";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}

		numero= this.id.substr(7,this.id.length);		
		var idCampo = 'clavePrestamista';
		var mensaje = "La Clave del Prestamista debe tener datos Númericos, Máximo 12 Dígitos ";
		
		if(validaCam(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
		var idCampo = 'numeroContrato';
		var mensaje = "El Número de Contrato está vacío";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
		var idCampo = 'numeroCuenta';
		var mensaje = "El Número de Cuenta está vacío";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
		var idCampo = 'fechaContra';
		var mensaje = "La Fecha de Contratación está vacía";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
		var idCampo = 'fechaVencim';
		var mensaje = "La Fecha de Vencimiento está vacía";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
		var idCampo = 'tasaAnual';
		var mensaje = "El Valor del la Tasa Anual está vacía";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
		var idCampo = 'plazo';
		var mensaje = "El Plazo está vacío";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
		var idCampo = 'periodoPago';
		var mensaje = "El Periodo de Pago está vacío";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
		var idCampo = 'montoRecibido';
		var mensaje = "El Valor del Monto Original Recibido está vacío";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
		var idCampo = 'tipoCredito';
		var mensaje = "El Tipo de Crédito está vacío";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
		var idCampo = 'destino';
		var mensaje = "El Destino del Crédito está vacío";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
		var idCampo = 'tipoGarantia';
		var mensaje = "El Tipo de Garantía está vacío";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
		var idCampo = 'montoGarantia';
		var mensaje = "El Monto de la Garantía está vacío";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
		var idCampo = 'fechaPago';
		var mensaje = "La fecha del Pago Inmediato Siguiente está vacía";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
		var idCampo = 'montoPago';
		var mensaje = "El Monto  del Pago Inmediato Siguiente está vacío";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
		var idCampo = 'clasificaCortLarg';
		var mensaje = "La Clasificación del Plazo está vacía";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
		var idCampo = 'salInsoluto';
		var mensaje = "El Saldo Insoluto  está vacío";
		
		if(validaCampo1(idCampo, numero, mensaje)==false){
			
			respuesta = false;
			return false;
			
		}
				
	});
	return respuesta;	
}

function validaCampo1(idCampo, fila, mensaje)
{
	if($("#"+idCampo+fila).val()=='')
		{
		   mensajeSis(mensaje);	
		   $("#"+idCampo+fila).focus();
		   return false;
		
		}
	else
		{
			return true;
		}	
}
function validaCam(idCampo, fila, mensaje)
{
	var tam = $("#"+idCampo+fila).val();
	if (!/^([0-9])*$/.test($("#"+idCampo+fila).val()) || $("#"+idCampo+fila).val()=='' || tam.length>12)
		{
		   mensajeSis(mensaje);	
		   $("#"+idCampo+fila).focus();
		   return false;
		
		}
	else
		{
			return true;
		}	
}




