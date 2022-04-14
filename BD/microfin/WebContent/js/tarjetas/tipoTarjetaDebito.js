$(document).ready(function() {	
	agregaFormatoControles('formaGenerica');
		esTab = true;	 
		$('#tipoTarjetaDebID').focus();
		ocultar();

	//Definicion de Constantes y Enums  
	var catTipoTransaccionTipoTarjeta = {  
  		'agrega':'1',
  		'modifica':'2',
  		'eliminar':'3'	
  	};


	var catTipoConsultaTipoTarjeta = {
  		'principal'	: 1,
  		'foranea'	: 2,
  		'tipotarjetadebito':3  		
	};
	
	habilitaOpISS();

	//------------ Metodos y Manejo de Eventos -----------------------------------------
    deshabilitaBoton('modifica', 'submit');
    deshabilitaBoton('agrega', 'submit');
    llenarComboColorTarjeta();
    llenarListaPatrocinador();
    $('#identificaSocioS').attr("checked",false);
    $('#identificaSocioN').attr("checked",false);
    $('#opePosLineaSI').attr("checked",false);
    $('#opePosLineaNO').attr("checked",false);
    $('#tipoTarjetaD').attr("checked",false);
    $('#tipoTarjetaC').attr("checked",false);


   $(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});
	$(':text').focus(function() {
	 	esTab = false;
	});

	$.validator.setDefaults({
   	submitHandler: function(event) {
   	 		if($('#tipoTarjetaD').attr("checked") == false && $('#tipoTarjetaC').attr("checked") == false){
				mensajeSis("Seleccione un tipo de tarjeta.");
			}
			else{

				if($('#tipoTarjetaC').attr("checked") == true){
					if($('#tasaFija').val() == ''){
						mensajeSis("Ingrese una Tasa Fija");
						$('#tasaFija').focus();		
					}
					else if($('#montoAnual').val() == ''){
						mensajeSis("Ingrese un monto anualidad");
						$('#montoAnual').focus();			
					}
					else if($('#cobraMora').val() == ''){
						mensajeSis("Seleccione si cobra moratorios");	
						$('#cobraMora').focus();		
					}
					else if($('#cobraMora').val() == 'S' && $('#tipoMora').val() == ''){
						mensajeSis("Ingrese el tipo de moratorios");	
						$('#tipoMora').focus();		
					}
					else if($('#factorMora').val() == '' && $('#cobraMora').val() == 'S'){
						mensajeSis("Ingrese el factor de moratorios");	
						$('#factorMora').focus();		
					}
					else if($('#cobFaltaPago').val() == ''){
						mensajeSis("Seleccione si cobra falta de pago");	
						$('#cobFaltaPago').focus();		
					}
					else if($('#cobFaltaPago').val() == 'S' && $('#tipoFaltaPago').val() == ''){
						mensajeSis("Ingrese el tipo de falta de pago");	
						$('#tipoFaltaPago').focus();		
					}
					else if($('#facFaltaPago').val() == '' && $('#cobFaltaPago').val() == 'S'){
						mensajeSis("Ingrese el factor de falta de pago");	
						$('#facFaltaPago').focus();		
					}
					else if($('#porcPagoMin').val() == ''){
						mensajeSis("Ingrese el porcentaje de pago minimo");	
						$('#porcPagoMin').focus();		
					}
					else if($('#montoCredito').val() == ''){
						mensajeSis("Ingrese el monto de credito");	
						$('#montoCredito').focus();		
					}
					else{					
						grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'false','tipoTarjetaDebID','funcionExitoTipoTarjetaDebito','funcionErrorTipoTarjetaDebito');		
					}
				}
				else{
						grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'false','tipoTarjetaDebID','funcionExitoTipoTarjetaDebito','funcionErrorTipoTarjetaDebito');		
				}
			}


		}
	});

	$('#agrega').click(function() {
		$('#tipoTransaccion').val(catTipoTransaccionTipoTarjeta.agrega);
	});

	$('#modifica').click(function() {
			$('#tipoTransaccion').val(catTipoTransaccionTipoTarjeta.modifica);	
	});
		
	$('#tipoTarjetaDebID').bind('keyup',function(e){
		lista('tipoTarjetaDebID', '1', '1', 'tipoTarjetaDebID', $('#tipoTarjetaDebID').val(), 'tipoTarjetasDevLista.htm');
		
	});

	$('#tipoTarjetaDebID').blur(function() {
		if($('#tipoTarjetaDebID').val() != null && $('#tipoTarjetaDebID').val() != ''){
			insertaTipoTarjetaDebito(this.id);	
		}
		
	});
	// Lista de productos
	$('#productoCredID').bind('keyup',function(e){
		lista('productoCredID', '2', '1', 'descripcion', $('#productoCredID').val(), 'listaProductosCredito.htm');
	});
	$('#productoCredID').blur(function() {
		if(esTab){
			if ($('#productoCredID').val()!='' && $('#productoCredID').val()!='') {
				consultaProducto($('#productoCredID').val());
			}else{
				$('#productoCredID').val('');
				$('#descripcionProd').val('');
			}
		}
	});
	// CONSULTA DEL PRODUCTO
	function consultaProducto(producto) {
		var prodCreditoBeanCon = { 
			'producCreditoID':$('#productoCredID').val()
		};
		setTimeout("$('#cajaLista').hide();", 200);
		if($('#tipoTarjetaC').attr("checked") == true){
			productosCreditoServicio.consulta(1,prodCreditoBeanCon,function(prodCred) {
				if (prodCred !='' && prodCred != null) {
					$('#descripcionProd').val(prodCred.descripcion);
				}else{
					mensajeSis("No Existe el Producto de Crédito");
					$('#productoCredID').val('');
					$('#descripcionProd').val('');
					$('#productoCredID').focus();
				}
			});	
		}				
	}
	
	//LISTA BINS
	$('#tarBinParamsID').bind('keyup',function(e){
		lista('tarBinParamsID', '1', '1', 'tarBinParamsID', $('#tarBinParamsID').val(), 'tarParametrosBINLista.htm');
	});
	$('#tarBinParamsID').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			consultaBINs(this.id);
			consultaSubBINsGrid();
		}
	});
	//FUNCIÓN CONSULTA LOS DATOS DEL BIN
	function consultaBINs(idControl) {
		var jqNumero = eval("'#" + idControl + "'");
		var TarBinParamsID = $(jqNumero).val();
		setTimeout("$('#cajaLista').hide();", 200);
		var numCon=1;
		var BeanCon = {
				'tarBinParamsID':TarBinParamsID
			};

		if(TarBinParamsID != '' && !isNaN(TarBinParamsID) && TarBinParamsID > 0){
			tarjetaBinParamsServicio.consulta(numCon,BeanCon,function(tarBinParamsBean) {

				if(tarBinParamsBean!=null){
					$('#numBIN').val(tarBinParamsBean.numBIN);
					var esSubBin = tarBinParamsBean.esSubBin;
					if(esSubBin == 'S'){
						if(TarBinParamsID = 0){
							$('#numSubBIN').val("");
						}
						habilitaControl("numSubBIN");
					}else if(esSubBin == 'N'){
						deshabilitaControl("numSubBIN");
						$('#numSubBIN').val("00");
					}
				}else{
					$(jqNumero).val('');
					$('#numBIN').val('');
					$(jqNumero).focus();
					mensajeSis('No Existe el Bin');
				}
			});
		}else{
			$(jqNumero).val('');
			$('#numBIN').val('');
			$(jqNumero).focus();
			mensajeSis('No Existe el Bin');
		}
	}
	
	$("#cobraMora").blur(function() {
		if($("#cobraMora").val() == 'N'){
			$("#tipoMora").attr('disabled',true);
			$("#factorMora").attr('disabled',true);
			$('#tipoMora').val('');
			$('#factorMora').val('');
		}else{
			$("#tipoMora").attr('disabled',false);
			$("#factorMora").attr('disabled',false);
		}
	});
	$("#cobFaltaPago").change(function() {
		if($("#cobFaltaPago").val() == 'N'){
			$("#tipoFaltaPago").attr('disabled',true);
			$("#facFaltaPago").attr('disabled',true);
			$('#tipoFaltaPago').val('');
			$('#facFaltaPago').val('0.0');
		}else{
			$("#tipoFaltaPago").attr('disabled',false);
			$("#facFaltaPago").attr('disabled',false);
			$('#tipoFaltaPago').val('');
			$('#facFaltaPago').val('');
			$('#tipoFaltaPago').focus();
		}
	});
	$('#tipoFaltaPago').change(function() {
		$("#facFaltaPago").val('');
		$("#facFaltaPago").focus();
	});

	$('#tipoCore').change(function() {
		if($('#tipoCore').val()=='3'){
			$('#urlCoretd').hide();
			$('#urlCoretd2').hide();
			$('#urlCore').val('');
		}else{
			$('#urlCoretd').show();
			$('#urlCoretd2').show();
		}
	});
	
	$('#cobComisionAper').change(function() {
		if ($('#cobComisionAper').val()!='' && $('#cobComisionAper').val()=='N') {
			$("#tipoCobComAper").attr('disabled',true);
			$("#facComisionAper").attr('disabled',true);
			$("#tipoCobComAper").val('');
			$("#facComisionAper").val('0.0');
		}
		else{
			$("#tipoCobComAper").attr('disabled',false);
			$("#facComisionAper").attr('disabled',false);
			$("#tipoCobComAper").val('');
			$("#facComisionAper").val('');
			$('#tipoCobComAper').focus();
		}
	});

	$('#tipoCobComAper').change(function() {
		$("#facComisionAper").val('');
		$("#facComisionAper").focus();
	});



	$('#tipoTarjetaD').click(function() {
		$('#identificacion').show();
		$('#identificacionSoc').show();
		$('#tipoTarjetaC').attr("checked",false);
		$('#identificaSocioS').attr("checked",false);
		$('#identificaSocioN').attr("checked",false	);
		$('#tasaFija').val('');
		$('#montoAnual').val('');
		$('#cobraMora').val('');
		$('#tipoMora').val('');
		$('#factorMora').val('');
		$('#cobFaltaPago').val('');
		$('#tipoFaltaPago').val('');
		$('#facFaltaPago').val('');
		$('#porcPagoMin').val('');
		$('#montoCredito').val('');
		$('#cobComisionAper').val('');
		$('#tipoComisionAper').val('');
		$('#facComisionAper').val('');
		ocultar();
	});
	$("#tipoTarjetaD").blur(function() {
		$('#tipoTarjetaC').focus();
	});

	$('#tipoTarjetaC').click(function() {
		$('#identificaSocioN').attr("checked",true);
		$('#identificacion').hide();
		$('#identificacionSoc').hide();
		mostrar();
	});

	$("#opePosLineaSI").blur(function() {
		$('#opePosLineaNO').focus();
	});

	$("#identificaSocioS").blur(function() {
		$('#identificaSocioN').focus();
	});

	//------------ Validaciones de la Forma -------------------------------------
	$('#formaGenerica').validate({
		rules: {
			tipoTarjetaDebID: {
				required: true
			},	
			descripcion: {
				required: true
			},
			compraPOSLinea:{
				required: true
			},
			tipoProsaID:{
				required: function(){return $('#habilitadoISS').attr('checked') == true }
			},
			colorTarjeta:{
				required: function(){return $('#habilitadoISS').attr('checked') == true }
			},
			vigenciaMeses:{
				required: true
			},
			estatus: { 
				required: true
			},
			tipoTarjeta:{
				required: true
			},
			identificacionSocio:{
				required: true
			},
			cobComisionAper:{
				required: function() {if($('#tipoTarjetaC').attr("checked") == true) {
										return true;
									}
									else{
										return false
									}
								}
			},
			productoCredito:{
				required: function() {if ($('#tipoTarjeta')=='C') {
										return true;
									}
									else{
										return false
									}
								}
			},
			tipoCobComAper:{
				required: function() {if ($('#cobComisionAper ')=='S') {
										return true;
									}
									else{
										return false;
									}
								}
			},
			facComisionAper:{
				required: function() {if ($('#cobComisionAper ')=='S') {
										return true;
									}
									else{
										return false;
									}
								}
			},
			numSubBIN:{
				required: function(){return $('#habilitadoTGS').attr('checked') == true },
				minlength:2
			},
			tarBinParamsID:{
					required: function() {if($('#tarBinParamsID') == "0") {
						return true;
					}
					else{
						return false;
					}
				}
			},
			tipoMaquilador:{
				required: function() {if ($('#habilitadoISS').attr('checked') == false || $('#habilitadoTGS').attr('checked') == false) {
										return true;
									}
									else{
										return false
									}
								}
			},
			tipoCore:{
				required: function(){return $('#habilitadoTGS').attr('checked') == true }
			},
			urlCore:{
				required: function(){ if ($('#habilitadoTGS').attr('checked') == true && ($('#tipoCore').val() != '3' )){
												return true;
											}else{
												return false;	
											}
									}
			},
			tarBinParamsID:{
				required : function(){return $('#habilitadoTGS').attr('checked') == true }
			},
			patroSubBIN:{
				required: function(){return $('#habilitadoTGS').attr('checked') == true }
			}
			
		},
		messages: {
			tipoTarjetaDebID: {
				required: 'Especifique el Tipo de Tarjeta Débito.'
			},
			descripcion: {
				required: 'Especifique la Descripción'
			},
			compraPOSLinea:{
				required: 'Especificar Operacion POS en Linea'
			},
			tipoProsaID:{
				required: 'Especifique un ID de PROSA'
			},
			colorTarjeta:{
				required: 'Especificar el Color de Tarjeta'
			},
			vigenciaMeses:{
				required: 'Especificar el Número de Meses de Vigencia de la Tarjeta'
			},
			estatus: {
				required: 'Especifique el Estatus'
			},
			tipoTarjeta:{
				required: 'Especificar Tipo de Tarjeta'
			},
			identificacionSocio:{
				required: 'Especificar si requiere identificacion'
			},
			productoCredito:{
				required: 'Especificar el producto de credito'
			},
			tipoCobComAper:{
			    required: 'Especificar el tipo de comisión por apertura'
			},
			facComisionAper:{
				required: 'Especificar el factor de comisión por apertura'
			},
			cobComisionAper:{
				required: 'Especificar la comisión por apertura'
			},
			tipoMaquilador:{
				required: 'Una opción es requerida ISS o TGS'
			},
			numSubBIN:{
				required: 'Especificar el valor del SubBin',
				minlength: 'El valor m&iacute;nimo es de dos caracteres'
			},
			tarBinParamsID:{
				required: 'Especifique un valor de Bin'
			},
			tipoCore:{
				required: 'Especificar un tipo de Core'
			},
			urlCore:{
				required: 'Especificar la URL'
			},
			patroSubBIN:{
				required: 'Especificar el patrocinador'
			}
			
		}		
	});
	
	//------------ Validaciones de Controles -------------------------------------
	
	function insertaTipoTarjetaDebito(control) {
		$('#gridSubBIN').hide();
		var numTarjetaDeb = $('#tipoTarjetaDebID').val();
		setTimeout("$('#cajaLista').hide();", 200);
		if(numTarjetaDeb != '' && !isNaN(numTarjetaDeb) && esTab){
			if(numTarjetaDeb=='0'){
				habilitaBoton('agrega', 'submit');
				deshabilitaBoton('modifica', 'submit');
				limpiar();
				$('#tipoTarjetaD').attr("checked",false);
				$('#tipoTarjetaC').attr("checked",false);
			} else {
				deshabilitaBoton('agrega', 'submit');
				habilitaBoton('modifica', 'submit');
				var tipoTarjetaBeanCon = {
  					'tipoTarjetaDebID' : $('#tipoTarjetaDebID').val()
				};
				tipoTarjetaDebServicio.consulta(catTipoConsultaTipoTarjeta.tipotarjetadebito,tipoTarjetaBeanCon,function(TipoTarDeb) {

					if(TipoTarDeb!=null){
						dwr.util.setValues(TipoTarDeb);
						$('#cobComisionAper').val(TipoTarDeb.cobComisionAper);
						$('#tipoCobComAper').val(TipoTarDeb.tipoCobComAper);
						$('#facComisionAper').val(TipoTarDeb.facComisionAper);
						if (TipoTarDeb.compraPosLinea == 'S') {
							$('#opePosLineaSI').attr("checked",true);
						}else if (TipoTarDeb.compraPosLinea == 'N') {
							$('#opePosLineaNO').attr("checked",true);
						}
						if(TipoTarDeb.tipoTarjeta == 'D'){
							$('#tipoTarjetaD').attr("checked",true);
							$('#identificacion').show();
							$('#identificacionSoc').show();
							ocultar();
						}else if(TipoTarDeb.tipoTarjeta == 'C'){
							$('#tipoTarjetaC').attr("checked",true);
							$('#identificacion').hide();
							$('#identificacionSoc').hide();
							mostrar();
						}
						if(TipoTarDeb.identificacionSocio=="S"){
							$('#identificaSocioS').attr("checked",true);
						}else {
							$('#identificaSocioS').attr("checked",false);
							$('#identificaSocioN').attr("checked",true);
						}
						if($("#cobFaltaPago").val() == 'N'){
							$("#tipoFaltaPago").attr('disabled',true);
							$("#facFaltaPago").attr('disabled',true);
						}else if($("#cobFaltaPago").val() == 'S'){
							$("#tipoFaltaPago").attr('disabled',false);
							$("#facFaltaPago").attr('disabled',false);
						}
						if($("#cobraMora").val() == 'N'){
							$("#tipoMora").attr('disabled',true);
							$("#factorMora").attr('disabled',true);
						}else if($("#cobraMora").val() == 'S'){
							$("#tipoMora").attr('disabled',false);
							$("#factorMora").attr('disabled',false);
						}
						if($("#cobComisionAper").val() == 'N'){
							$("#tipoCobComAper").attr('disabled',true);
							$("#facComisionAper").attr('disabled',true);
						}else if($("#cobComisionAper").val() == 'S'){
							$("#tipoCobComAper").attr('disabled',false);
							$("#facComisionAper").attr('disabled',false);
						}
						if(TipoTarDeb.tipoMaquilador == 1){
							habilitaOpISS();
						}
						if(TipoTarDeb.tipoMaquilador == 2){
							habilitaOpTGS();
							consultaSubBINsGrid();
							$('#numSubBIN').val(TipoTarDeb.numSubBIN);
							$('#patroSubBIN').val(TipoTarDeb.patrocinadorID);
							consultaBINs("tarBinParamsID");
						}
						//OCULTA EL CAMPO URL CORE SI ES CORE INTERNO
						if($('#tipoCore').val()=='3'){
							$('#urlCoretd').hide();
							$('#urlCoretd2').hide();
						}
						
						consultaProducto($('#productoCredID').val());
						deshabilitaBoton('agrega', 'submit');
						habilitaBoton('modifica', 'submit');
						agregaFormatoControles('formaGenerica');
					}else{
						mensajeSis("No Existe el Tipo de Tarjeta de Débito");
						deshabilitaBoton('modifica', 'submit');
   						deshabilitaBoton('agrega', 'submit');
						$('#tipoTarjetaDebID').focus();
						$('#tipoTarjetaDebID').select();
						limpiar();										
					}
				});
			}
		}else{
			$('#tipoTarjetaDebID').focus();
			limpiar();
		}
	}
	
	function habilitaOpTGS(){
		$('#BINtr').show();
		$('#coretr').show();
		$('#lblColorTar').hide();
		$('#selectColorTar').hide();
		$('#idprosa').hide();
		$('#idprosa2').hide();
		$('#Patroctr').show();
	}
	
	$('#habilitadoTGS').click(function() {
		$('#habilitadoISS').attr("checked",false);
		habilitaOpTGS();
	});
	
	function habilitaOpISS(){
		$('#BINtr').hide();
		$('#Patroctr').hide();
		$('#coretr').hide();
		$('#lblColorTar').show();
		$('#selectColorTar').show();
		$('#idprosa').show();
		$('#idprosa2').show();
		$('#tarBinParamsID').val("");
		$('#numBIN').val("");
		$('#numSubBIN').val("");
		$('#tipoCore').val("");
		$('#urlCore').val("");
	}
	
	$('#habilitadoISS').click(function() {	
		$('#habilitadoTGS').attr("checked",false);
		habilitaOpISS();
	});
	

});

function llenarComboColorTarjeta(){
		var tarDebBean = {
				'colorTarjeta' : ''
		};
		dwr.util.removeAllOptions('colorTarjeta');
		dwr.util.addOptions('colorTarjeta', {'':'SELECCIONAR'});

		tipoTarjetaDebServicio.listaCombo( 7 , tarDebBean, function(tipoTarjetaDebIDs){
			dwr.util.addOptions('colorTarjeta', tipoTarjetaDebIDs, 'colorTarjeta', 'descripcion');
		});
	}
function llenarListaPatrocinador(){
	var patrocsubbin = {
			'patrocinadorID' : 0
	};
	dwr.util.removeAllOptions('patroSubBIN');
	dwr.util.addOptions('patroSubBIN', {'':'SELECCIONAR'});
	tipoTarjetaDebServicio.listaCombo(10,patrocsubbin , function(patrocSubBin){
		dwr.util.addOptions('patroSubBIN', patrocSubBin, 'patrocinadorID', 'nombrePatroc');
	});
}


function limpiar(){
		$('#estatus').val('');
		$('#descripcion').val('');
		$('#tipoProsaID').val('');
		$('#colorTarjeta').val('');
		$('#vigenciaMeses').val('');
		$('#opePosLineaSI').attr("checked",false);
		$('#opePosLineaNO').attr("checked",false);
		$('#identificaSocioS').attr("checked",false);
		$('#identificaSocioN').attr("checked",false);
		$('#productoCredID').val('');
		$('#descripcionProd').val('');
		$('#tasaFija').val('');
		$('#montoAnual').val('');
		$('#cobraMora').val('');
		$('#tipoMora').val('');
		$('#factorMora').val('');
		$('#cobFaltaPago').val('');
		$('#tipoFaltaPago').val('');
		$('#facFaltaPago').val('');
		$('#porcPagoMin').val('');
		$('#montoCredito').val('');
		$('#cobComisionAper').val('');
		$('#tipoCobComAper').val('');
		$('#facComisionAper').val('');
		$('#tipoCore').val('');
		$('#tarBinParamsID').val('');
		$('#numBIN').val('');
		$('#numSubBIN').val('');
		$('#urlCore').val('');
		$('#gridSubBIN').hide();
		$('#patroSubBIN').val('');
	}	

function ocultar(){
	$('#condiciones').hide();
	$('#comisiones').hide();
	$('#productoCred').hide();
	$('#producCredito').hide();
}
function mostrar(){
	$('#condiciones').show();
	$('#comisiones').show();
	$('#productoCred').show();
	$('#producCredito').show();
	
}
//funcion que se ejecuta cuando el resultado fue exito

function funcionExitoTipoTarjetaDebito(){
	deshabilitaBoton('agrega', 'submit');
	habilitaBoton('modifica', 'submit');
	limpiar();
	$('#tipoTarjetaD').attr("checked",false);
	$('#tipoTarjetaC').attr("checked",false);
	$('#tipoTarjetaDebID').focus();
}

function soloNum(campo,idcampo){
	
	if (!/^([0-9])*$/.test(campo.value)){
    	mensajeSis("Ingrese solo números");
   	    $('#'+idcampo).focus();
  	    $('#'+idcampo).val('');
    }  
    else{
	    	$('#agrega').focus();  	
	    }  
}

// funcion que se ejecuta cuando el resultado fue error
// diferente de cero

function funcionErrorTipoTarjetaDebito(){

}

function validador(e){
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57){
		if (key==8 || key == 0 || key == 46){
			return true;
		}
		else 
  		return false;
	}
} 
function validadorNum(e){
	key=(document.all) ? e.keyCode : e.which;
	if (key < 48 || key > 57){
		if (key==8 || key == 0){
			return true;
		}
		else 
  		return false;
	}
}
//CONSULTA LISTA DE SudBINS REGISTRADOS
function consultaSubBINsGrid() {
	
	var tipoTarjetaDebBean = {};
	tipoTarjetaDebBean['tipoLista'] = 11;
	tipoTarjetaDebBean['numBIN'] = $('#tarBinParamsID').val();
	
	bloquearPantalla();
	$.post("tarjetaSubBinGrid.htm", tipoTarjetaDebBean, function(data) {
		if (data.length > 0 ) {
			$('#gridSubBIN').html(data);
			$('#gridSubBIN').show();
			desbloquearPantalla();
		} else {
			$('#gridSubBIN').html("");
			$('#gridSubBIN').hide();
			desbloquearPantalla();
		}
	});
}
function  eliminaSubBin(numSubBIN) {
	mensajeSisRetro({
		mensajeAlert : '¿Confirma Eliminar el SubBin Actual?',
		muestraBtnAceptar: true,
		muestraBtnCancela: true,
		txtAceptar : 'Eliminar',
		txtCancelar : 'Cancelar',
		funcionAceptar : function(){
			eliminar(Number(numSubBIN));
		},
		funcionCancelar : function(){// si no se pulsa en aceptar
			return false;
		}
	});
}

	function eliminar(numSubBIN){
		console.log("llego"+numSubBIN)

		$('#numSubBINs').val(numSubBIN);
		$('#numBINs').val() == $('#tarBinParamsID').val();

		$('#tipoTransaccion').val(3);	
		grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'false','tipoTarjetaDebID','funcionExitoTipoTarjetaDebito','funcionErrorTipoTarjetaDebito');
		
	}
		