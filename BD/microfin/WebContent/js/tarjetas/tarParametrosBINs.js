$(document).ready(function() {

	/******* DEFINICION DE CONSTANTES Y NUMEROS DE CONSULTAS *******/
	esTab = false;
	$('#esmultibase').hide();

	var catTipoTransaccion = {  
				'agrega':'1',
				'modifica':'2'
	};

	/******* FUNCIONES CARGA AL INICIAR PANTALLA *******/
	funcionCargaComboMarca();
	consultaBINsGrid();
	deshabilitaPantalla();
	$("#tarBinParamsID").focus();
	


	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$(':text').focus(function() {
	 	esTab = false;
	});

	/******* VALIDACIONES DE LA FORMA *******/	
	$.validator.setDefaults({
		submitHandler: function(event) {
			grabaFormaTransaccionRetrollamada(event, 'formaGenerica','contenedorForma', 'mensaje', 'true','tarBinParamsID','funcionExito','funcionError');
	      }
	});

	$('#formaGenerica').validate({
		rules: {
			numBIN : {
				required : true,
				minlength:6
			},
			catMarcaTarjetaID : {
				required : true
			}
		},	
		messages: {
			numBIN: {
				required : "El número Bin es requerido",
				minlength: "El valor mínimo de caractes es de seis"
			},
			catMarcaTarjetaID : {
				required : "La marca es requerido" 
			}
		}		
	});

	/******* MANEJO DE EVENTOS *******/	
	$(':text').focus(function() {	
	 	esTab = false;
	});
	    
	$(':text').bind('keydown',function(e){
		if (e.which == 9 && !e.shiftKey){
			esTab= true;
		}
	});

	$('#agrega').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccion.agrega);
	});
	
	$('#modifica').click(function() {		
		$('#tipoTransaccion').val(catTipoTransaccion.modifica);
	});

	$('#tarBinParamsID').bind('keyup',function(e){
		lista('tarBinParamsID', '1', '1', 'tarBinParamsID', $('#tarBinParamsID').val(), 'tarParametrosBINLista.htm');
	});

	$('#tarBinParamsID').blur(function(){
		setTimeout("$('#cajaLista').hide();", 200);
		if(esTab){
			consultaBINs(this.id);
		}
	});

	/*******  FUNCIONES PARA CARGAR INFORMACIÓN A LOS CONTROLES *******/
	function consultaBINs(idControl) {
		var jqNumero = eval("'#" + idControl + "'");
		var TarBinParamsID = $(jqNumero).val();
		setTimeout("$('#cajaLista').hide();", 200);
			
		var numCon=1;
		var BeanCon = {
				'tarBinParamsID':TarBinParamsID
			};

		if(TarBinParamsID != '' && TarBinParamsID == 0){
			inicializaPantalla();
			$('#esSubBinN').attr("checked",true);
			habilitaBoton('agrega','submit');
			deshabilitaBoton('modifica','submit');
			$('#numBIN').focus();

		}else if(TarBinParamsID != '' && !isNaN(TarBinParamsID) && TarBinParamsID > 0){
			tarjetaBinParamsServicio.consulta(numCon,BeanCon,function(tarBinParamsBean) {

				if(tarBinParamsBean!=null){
					inicializaPantalla();
					$('#numBIN').val(tarBinParamsBean.numBIN);
					$('#catMarcaTarjetaID').val(tarBinParamsBean.catMarcaTarjetaID);
					var esSubBin = tarBinParamsBean.esSubBin;
					if(esSubBin == 'S'){
						$('#esSubBinS').attr("checked",true);
						$('#esSubBinN').attr("checked",false);
					}else if(esSubBin == 'N'){
						$('#esSubBinS').attr("checked",false);
						$('#esSubBinN').attr("checked",true);
					}
					var varEsBinMulEmp = tarBinParamsBean.esBinMulEmp;
					if(varEsBinMulEmp == 'S'){
						$('#esBinMulEmpS').cheked = true;
						deshabilitaControl("esBinMulEmpS");
					}else if(varEsBinMulEmp == 'N'){
						$('#esBinMulEmpS').cheked = false;
					}
					deshabilitaBoton('agrega','submit');
					habilitaBoton('modifica','submit');
					agregaFormatoControles('formaGenerica');
				}else{
					$(jqNumero).val('');
					$(jqNumero).focus();
					mensajeSis('No Existe el Bin');
					$('#tarBinParamsID').focus();
				}
			});
		}else{
			$(jqNumero).val('');
			$(jqNumero).focus();
			mensajeSis('No Existe el Bin');
			$('#tarBinParamsID').focus();
		}
	}

}); // FIN $(DOCUMENT).READY()

//FUNCION INICIALIZA PANTALLA
function inicializaPantalla(){
	$('#numBIN').val('');
	$('#catMarcaTarjetaID').val('');
	habilitaControl("numBIN");
	habilitaControl("catMarcaTarjetaID");
	habilitaControl("esBinMulEmpS");
	habilitaControl("esSubBinS");
	habilitaControl("esSubBinN");
	habilitaBoton('agrega','submit');
	deshabilitaBoton('modifica','submit');
}
//DESHABILITA PANTALLA
function deshabilitaPantalla(){
	$('#numBIN').val('');
	$('#catMarcaTarjetaID').val('');
	$('#esSubBinN').attr("checked",false);
	$('#esSubBinS').attr("checked",false);
	deshabilitaControl("numBIN");
	deshabilitaControl("catMarcaTarjetaID");
	deshabilitaControl("esBinMulEmpS");
	deshabilitaControl("esSubBinS");
	deshabilitaControl("esSubBinN");
	deshabilitaBoton('agrega','submit');
	deshabilitaBoton('modifica','submit');
};

function funcionCargaComboMarca(){
	dwr.util.removeAllOptions('catMarcaTarjetaID');
	tarjetaBinParamsServicio.lista(3, function(beanLista){
		dwr.util.addOptions('catMarcaTarjetaID', {'':'SELECCIONAR'});
		dwr.util.addOptions('catMarcaTarjetaID', beanLista, 'catMarcaTarjetaID', 'descMarcaTar');
	});
}

//FUNCIÓN SOLO ENTEROS SIN PUNTOS NI CARACTERES ESPECIALES 
function validaSoloNumero(e,elemento){//Recibe al evento 
	var key = "";
	if(window.event){//Internet Explorer ,Chromium,Chrome
		key = e.keyCode; 
	}else if(e.which){//Firefox , Opera Netscape
			key = e.which;
	}
	
	if (key > 31 && (key < 48 || key > 57)) //se valida, si son números los deja 
	   return false;
	return true;
}

//CONSULTA LISTA DE BINS REGISTRADOS
function consultaBINsGrid(){
	var tarBinParamsBean = {
			'tipoLista'		: 2
	};
	$('#gridBINs').html("");
	$.post("gridParamsBINs.htm", tarBinParamsBean, function(data) {
		if (data.length > 0 ) {
			$('#gridBINs').html(data);
			$('#gridBINs').show();
		} else {
			$('#gridBINs').hide();
		}
	});
}

//FUNCIÓN DE ÉXITO DE LA TRANSACCIÓN
function funcionExito() {
	deshabilitaPantalla();
	//carga de nuevo la información del grid
	consultaBINs();
}

//FUNCIÓN DE ERROR DE LA TRANSACCIÓN
function funcionError() {
	agregaFormatoControles('formaGenerica');
}

